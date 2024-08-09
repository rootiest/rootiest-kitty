#!/bin/bash

# Default values
type="tab"
title=""
cwd=""
active_bg=""
active_fg=""
inactive_bg=""
inactive_fg=""
cmd=""
cmd_flag=""
icon=""

# Icon dictionary for NerdFont glyphs
declare -A icons=(
  ["code"]="󱃖 "       # Code icon
  ["git"]="󰊢 "        # Git icon
  ["docs"]=" "       # Docs icon
  ["web"]="󰖟 "        # Web icon
  ["music"]=" "      # Music icon
  ["bug"]=" "        # Bug icon
  ["info"]=" "       # Info icon
  ["question"]=" "   # Question icon
  ["warning"]=" "    # Warning icon
  ["error"]=" "      # Error icon
  ["folder"]=" "     # Folder icon
  ["file"]=" "       # File icon
  ["lock"]=" "       # Lock icon
  ["unlock"]=" "     # Unlock icon
  ["key"]=" "        # Key icon
  ["search"]=" "     # Search icon
  ["clock"]=" "      # Clock icon
  ["calendar"]=" "   # Calendar icon
  ["download"]=" "   # Download icon
  ["vim"]=" "        # Vim icon
  ["nvim"]=" "       # Neovim icon
  ["neovim"]=" "     # Neovim icon
  ["python"]=" "     # Python icon
  ["shell"]=" "      # Shell icon
  ["rust"]=" "       # Rust icon
  ["go"]=" "         # Go icon
  ["java"]=" "       # Java icon
  ["lua"]=" "        # Lua icon
  ["cat"]="󰄛 "        # Cat icon
  ["dog"]="󰩄 "        # Dog icon
  ["fish"]="󰈺 "       # Fish icon
  ["cow"]="󰆚 "        # Cow icon
  ["bird"]="󱗆 "       # Bird icon
  ["config"]=" "     # Config icon
  ["home"]=" "       # Home icon
  ["game"]=" "       # Game icon
  ["image"]=" "      # Image icon
  ["video"]=" "      # Video icon
  ["pdf"]=" "        # PDF icon
  ["music2"]=" "     # Music2 icon
  ["archive"]=" "    # Archive icon
  ["heart"]=" "      # Heart icon
  ["md"]="󰍔 "         # MarkDown icon
  ["apple"]=" "      # Apple icon
  ["mac"]=" "        # Apple icon
  ["google"]=" "     # Google icon
  ["microsoft"]=" "  # Microsoft icon
  ["ms"]=" "         # Microsoft icon
  ["windows"]=" "    # Windows icon
  ["slack"]=" "      # Slack icon
  ["linux"]=" "      # Linux icon
  ["ubuntu"]="󰕈 "     # Linux icon
  ["archlinux"]=" "  # ArchLinux icon
  ["arch"]=" "       # ArchLinux icon
  ["debian"]=" "     # Debian icon
  ["fedora"]=" "     # Fedora icon
  ["freebsd"]=" "    # FreeBSD icon
  ["gentoo"]=" "     # Gentoo icon
  ["manjaro"]=" "    # Manjaro icon
  ["nixos"]=" "      # NixOS icon
  ["opensuse"]=" "   # OpenSUSE icon
  ["suse"]=" "       # OpenSUSE icon
  ["redhat"]="󱄛 "     # RedHat icon
  ["centos"]="󱄛 "     # RedHat icon
  ["endeavoros"]=" " # EndeavorOS icon
  ["endeavor"]=" "   # EndeavorOS icon
  ["eos"]=" "        # EndeavorOS icon
  ["github"]=" "     # GitHub icon
  ["gh"]=" "         # GitHub icon
  ["youtube"]=" "    # YouTube icon
  ["yt"]=" "         # YouTube icon
  ["poop"]="󰇷 "       # Poop icon
  ["sun"]="󰖙 "        # Sun icon
  ["moon"]=" "       # Moon icon
  ["rain"]=" "       # Rain icon
  ["cloud"]=" "      # Cloud icon
  ["alien"]="󰢚 "      # Alien icon
  ["lightbulb"]=" "  # Lightbulb icon
  ["lightning"]=" "  # Lightning icon
  ["night"]=" "      # Night icon
  ["day"]=" "        # Day icon
  ["chat"]="󰭹 "       # Chat icon
  ["mail"]=" "       # Mail icon
  ["terminal"]=" "   # Terminal icon
  ["sleep"]=" "      # Sleep icon
  ["bed"]=" "        # Sleep icon
  ["note"]=" "       # Note icon
  ["notes"]=" "      # Note icon
  ["fire"]=" "       # Fire icon
  ["trash"]=" "      # Trash icon
  ["garbage"]=" "    # Trash icon
  ["trashcan"]=" "   # Trash icon
  ["recycle"]=" "    # Trash icon
  ["water"]="󰖌 "      # Water icon
  ["beer"]=" "       # Beer icon
  ["coffee"]=" "     # Coffee icon
  ["cake"]="󰃩 "       # Cake icon
  ["package"]=" "    # Package icon
  ["inbox"]=" "      # Inbox icon
  ["outbox"]=" "     # Outbox icon
  ["scissors"]=" "   # Scissors icon
  ["stats"]=" "      # Stats icon
  ["database"]=" "   # Database icon
  ["link"]=" "       # Link icon
  ["flag"]=" "       # Flag icon
  ["pizza"]=" "      # Pizza icon
  ["burger"]="󰚅 "     # Burger icon
  ["success"]=" "    # Success icon
  ["fail"]=" "       # Fail icon
  ["warn"]=" "       # Warn icon
  ["alert"]=" "      # Warn icon
  ["car"]=" "        # Car icon
  ["bicycle"]="󰂣 "    # Bicycle icon
  ["bike"]="󰂣 "       # Bicycle icon
  ["airplane"]=" "   # Airplane icon
  ["plane"]=" "      # Airplane icon
  ["boat"]="󰻈 "       # Boat icon
  ["sailboat"]="󰻈 "   # Boat icon
  ["ship"]=" "       # Ship icon
  ["shipit"]=" "     # Ship icon
  ["train"]=" "      # Train icon
  ["subway"]=" "     # Subway icon
  ["bus"]=" "        # Bus icon
  ["motorbike"]=" "  # Motorcycle icon
  ["motorcycle"]=" " # Motorcycle icon
  ["truck"]=" "      # Truck icon
)

# Catppuccin Macchiato color palette with additional common colors
convert_color() {
  case "$1" in
  rosewater) echo "#f4dbd6" ;;
  flamingo) echo "#f0c6c6" ;;
  pink) echo "#f5bde6" ;;
  mauve) echo "#c6a0f6" ;;
  red) echo "#ed8796" ;;
  maroon) echo "#ee99a0" ;;
  peach) echo "#f5a97f" ;;
  yellow) echo "#eed49f" ;;
  green) echo "#a6da95" ;;
  teal) echo "#8bd5ca" ;;
  sky) echo "#91d7e3" ;;
  sapphire) echo "#7dc4e4" ;;
  blue) echo "#8aadf4" ;;
  lavender) echo "#b7bdf8" ;;
  text) echo "#cad3f5" ;;
  subtext1) echo "#b8c0e0" ;;
  subtext0) echo "#a5adcb" ;;
  overlay2) echo "#939ab7" ;;
  overlay1) echo "#8087a2" ;;
  overlay0) echo "#6e738d" ;;
  surface2) echo "#5b6078" ;;
  surface1) echo "#494d64" ;;
  surface0) echo "#363a4f" ;;
  base) echo "#24273a" ;;
  mantle) echo "#1e2030" ;;
  crust) echo "#181926" ;;
  black) echo "#181926" ;;   # Crust
  white) echo "#cad3f5" ;;   # Text
  gray) echo "#6e738d" ;;    # Overlay0
  grey) echo "#6e738d" ;;    # Overlay0
  silver) echo "#a5adcb" ;;  # Subtext0
  orange) echo "#f5a97f" ;;  # Peach
  brown) echo "#24273a" ;;   # Base
  purple) echo "#b7bdf8" ;;  # Lavender
  cyan) echo "#91d7e3" ;;    # Sky
  magenta) echo "#f5bde6" ;; # Pink
  gold) echo "#eed49f" ;;    # Yellow
  *) echo "$1" ;;            # If not a recognized color, assume it's already a hex code
  esac
}

# Function to show usage
usage() {
  echo "Usage: $0 [options] [command]"
  echo "Options:"
  echo "  -t, --title <title>        Set the tab/window title"
  echo "  -i, --icon <icon>          Icon to prefix the title or set the title to (use icon name from the dictionary)"
  echo "  -c, --cmd <command>        Command to run in the new tab/window"
  echo "  -d, --cwd <path>           Set the working directory"
  echo "  -a, --active-bg <color>    Active tab background color (tab only)"
  echo "  -f, --active-fg <color>    Active tab foreground color (tab only)"
  echo "  -n, --inactive-bg <color>  Inactive tab background color (tab only)"
  echo "  -g, --inactive-fg <color>  Inactive tab foreground color (tab only)"
  echo "  -y, --type <type>          Type of split or tab:"
  echo "                               t, tab (tab)"
  echo "                               v, vertical, vert (vertical split)"
  echo "                               h, horizontal, horiz (horizontal split)"
  echo "                               b, background, bg (background)"
  echo "                               w, window, win (window)"
  echo "                               o, overlay, over (overlay)"
  echo "  -h, --help                 Show this help message"
  echo "Command:"
  echo "  Command to run in the new tab/window (e.g., 'nvim' or 'make')"
  exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
  -t | --title)
    title="$2"
    shift
    ;;
  -i | --icon)
    icon_name="$2"
    if [[ -n "${icons[$icon_name]}" ]]; then
      icon="${icons[$icon_name]}"
    else
      echo "Warning: Unrecognized icon name '$icon_name'."
      icon=""
    fi
    shift
    ;;
  -c | --cmd)
    cmd_flag="$2"
    shift
    ;;
  -d | --cwd)
    cwd="$2"
    shift
    ;;
  -a | --active-bg)
    active_bg="$2"
    shift
    ;;
  -f | --active-fg)
    active_fg="$2"
    shift
    ;;
  -n | --inactive-bg)
    inactive_bg="$2"
    shift
    ;;
  -g | --inactive-fg)
    inactive_fg="$2"
    shift
    ;;
  -y | --type)
    type="$2"
    shift
    ;;
  -h | --help)
    usage
    ;;
  *)
    # Any remaining argument is considered the command
    if [[ -n "$cmd_flag" ]]; then
      echo "Warning: Both '-c/--cmd' and positional command provided. Using positional command."
      cmd="$*"
      break
    else
      cmd="$*"
      break
    fi
    ;;
  esac
  shift
done

# Handle backward compatibility for the -c/--cmd flag
if [[ -n "$cmd_flag" ]]; then
  if [[ -n "$cmd" ]]; then
    echo "Warning: Both '-c/--cmd' and positional command provided. Using '-c/--cmd' value."
  fi
  cmd="$cmd_flag"
fi

# Normalize type values
case "$type" in
v | vertical | vert) type="v" ;;
h | horizontal | horiz) type="h" ;;
t) type="tab" ;;
b | background | bg) type="background" ;;
w | window | win) type="window" ;;
o | overlay | over) type="overlay" ;;
*)
  if [[ "$type" != "tab" && "$type" != "v" && "$type" != "h" && "$type" != "background" && "$type" != "window" && "$type" != "overlay" ]]; then
    echo "Invalid type. Must be 'tab', 'v', 'h', 'vert', 'vertical', 'horiz', 'horizontal', 'b', 'bg', 'background', 'w', 'win', 'window', 'o', 'over', 'overlay'."
    exit 1
  fi
  ;;
esac

# Convert color names to hex codes
active_bg=$(convert_color "$active_bg")
active_fg=$(convert_color "$active_fg")
inactive_bg=$(convert_color "$inactive_bg")
inactive_fg=$(convert_color "$inactive_fg")

# Adjust the type for kitty command
kitty_type="window"
case "$type" in
tab) kitty_type="tab" ;;
background) kitty_type="background" ;;
window) kitty_type="os-window" ;;
overlay) kitty_type="overlay-main" ;;
v) kitty_type="window" ;;
h) kitty_type="window" ;;
esac

# Set the title with the icon if provided
if [[ -n "$icon" ]]; then
  if [[ "$type" == "tab" ]]; then
    title_with_icon="$icon $title"
    title_without_icon="$title"
  else
    title_with_icon="$icon $title"
    title_without_icon="$title"
  fi
else
  title_with_icon="$title"
  title_without_icon="$title"
fi

# Construct the launch command
launch_cmd="kitty @ launch --type=$kitty_type"

if [[ -n "$cwd" ]]; then
  launch_cmd="$launch_cmd --cwd $cwd"
fi

if [[ "$type" == "tab" || "$type" == "window" ]]; then
  launch_cmd="$launch_cmd --tab-title \"$title_with_icon\""
  launch_cmd="$launch_cmd --title \"$title_without_icon\""
elif [[ "$type" == "background" || "$type" == "overlay" ]]; then
  launch_cmd="$launch_cmd --window-title \"$title_without_icon\""
else
  launch_cmd="$launch_cmd --window-title \"$title_with_icon\""
fi

# Add location for splits
if [[ "$type" == "v" ]]; then
  launch_cmd="$launch_cmd --location=vsplit"
elif [[ "$type" == "h" ]]; then
  launch_cmd="$launch_cmd --location=hsplit"
fi

# Append the command to the launch command
if [[ -n "$cmd" ]]; then
  launch_cmd="$launch_cmd -- $cmd"
fi

# Run the launch command and check for errors
if ! eval "$launch_cmd" >/dev/null 2>&1; then
  echo "Error: Failed to execute launch command."
  exit 1
fi

# Set tab colors if type is 'tab' or 'window'
if [[ "$type" == "tab" || "$type" == "window" ]]; then
  if [[ -n "$active_bg" || -n "$active_fg" || -n "$inactive_bg" || -n "$inactive_fg" ]]; then
    color_cmd="kitty @ set-tab-color"
    [[ -n "$active_bg" ]] && color_cmd="$color_cmd active_bg=$active_bg"
    [[ -n "$active_fg" ]] && color_cmd="$color_cmd active_fg=$active_fg"
    [[ -n "$inactive_bg" ]] && color_cmd="$color_cmd inactive_bg=$inactive_bg"
    [[ -n "$inactive_fg" ]] && color_cmd="$color_cmd inactive_fg=$inactive_fg"

    if ! eval "$color_cmd" >/dev/null 2>&1; then
      echo "Error: Failed to set tab colors."
      exit 1
    fi
  fi
fi
