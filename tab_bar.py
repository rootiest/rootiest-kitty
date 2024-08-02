# pyright: reportMissingImports=false
# pyright: reportUnknownVariableType=false
# pyright: reportUnknownParameterType=false
# pyright: reportUnknownArgumentType=false
# pyright: reportUnknownMemberType=false

import datetime
import time
import subprocess
import psutil
import os

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_tab_with_powerline,
)

timer_id = None

UNPLUGGED_ICONS = {
    10: "",
    20: "",
    30: "",
    40: "",
    50: "",
    60: "",
    70: "",
    80: "",
    90: "",
    100: "",
}
PLUGGED_ICONS = {
    1: "",
}


class WakaTime:
    def __init__(self):
        self.cache = None
        self.cache_time = 0
        self.cache_duration = 60  # Cache duration in seconds (1 minute)
        self.cli_path = os.path.expanduser("~/.wakatime/wakatime-cli")

    def get_today_time(self):
        current_time = time.time()
        if self.cache is None or (current_time - self.cache_time) > self.cache_duration:
            # Run the command
            result = subprocess.run(
                [self.cli_path, "--today"], stdout=subprocess.PIPE, text=True
            )
            self.cache = result.stdout.strip()
            self.cache_time = current_time
        return self.cache


waka_time = WakaTime()


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id

    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, 2.0, True)
    draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    if is_last:
        draw_right_status(draw_data, screen)
    return screen.cursor.x


def draw_right_status(draw_data: DrawData, screen: Screen) -> None:
    # The tabs may have left some formats enabled. Disable them now.
    draw_attributed_string(Formatter.reset, screen)
    cells = create_cells()
    # Drop cells that wont fit
    while True:
        if not cells:
            return
        padding = screen.columns - screen.cursor.x - sum(len(c) + 3 for c in cells)
        if padding >= 0:
            break
        cells = cells[1:]

    if padding:
        screen.draw(" " * padding)

    tab_bg = as_rgb(int(draw_data.inactive_bg))
    tab_fg = as_rgb(int(draw_data.inactive_fg))
    default_bg = as_rgb(int(draw_data.default_bg))
    for cell in cells:
        # Draw the separator
        if cell == cells[0]:
            screen.cursor.fg = tab_bg
            screen.draw("")
        else:
            screen.cursor.fg = default_bg
            screen.cursor.bg = tab_bg
            screen.draw("")
        screen.cursor.fg = tab_fg
        screen.cursor.bg = tab_bg
        screen.draw(f" {cell} ")


def create_cells() -> list[str]:
    return [
        get_current_artist_title(),
        format_cell(get_wakatime_today()),
        format_cell(get_date()),
        format_cell(get_time()),
        get_battery_level()["icon"],
    ]


def format_cell(data: dict[str, str]) -> str:
    return f"{data['icon']} {data['text']}"


def _redraw_tab_bar(timer_id: int):
    for tm in get_boss().all_tab_managers:
        tm.mark_tab_bar_dirty()


def get_time():
    now = datetime.datetime.now().strftime("%H:%M")
    return {"icon": " ", "color": "#669bbc", "text": now}


def get_date():
    today = datetime.date.today()
    if today.weekday() < 5:
        return {"icon": "󰃵 ", "color": "#2a9d8f", "text": today.strftime("%e %b")}
    else:
        return {"icon": "󰧓 ", "color": "#f2e8cf", "text": today.strftime("%e %b")}


def get_battery_level():
    battery = psutil.sensors_battery()
    if battery is None:
        return {"icon": "", "text": "Battery info not available"}

    battery_percentage = round(battery.percent)
    charging = battery.power_plugged
    icon: str = ""

    if charging:
        icon = PLUGGED_ICONS[1]
    else:
        for level in sorted(UNPLUGGED_ICONS.keys(), reverse=True):
            if battery_percentage >= level:
                icon = UNPLUGGED_ICONS[level]
                break

    return {"icon": icon, "text": f"{battery_percentage}%"}


def get_current_artist_title():
    try:
        # Run playerctl to get the artist, ignoring Firefox and KDE Connect
        artist = (
            subprocess.check_output(
                [
                    "playerctl",
                    "-i",
                    "firefox,kdeconnect,plasma-browser-integration",
                    "metadata",
                    "artist",
                ]
            )
            .decode("utf-8")
            .strip()
        )
        # Run playerctl to get the title, ignoring Firefox and KDE Connect
        title = (
            subprocess.check_output(
                [
                    "playerctl",
                    "-i",
                    "firefox,kdeconnect,plasma-browser-integration",
                    "metadata",
                    "title",
                ]
            )
            .decode("utf-8")
            .strip()
        )
        if title == "":
            return "󰟎 "
        if artist != "":
            return f"󰋋  {artist} - {title}"
        else:
            return f"󰋋  {title}"
    except subprocess.CalledProcessError:
        return "󰟎 "
    except FileNotFoundError:
        return "playerctl is not installed"


def get_wakatime_today():
    time_spent = waka_time.get_today_time()
    return {"icon": "󱦺 ", "text": time_spent}
