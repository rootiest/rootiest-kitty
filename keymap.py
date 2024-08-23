#!/usr/bin/env python3
"""Kitten to print the current list of keyboard shortcuts (consists of BOTH single keys and key
sequences).
"""

import string
import re
from collections import defaultdict
from typing import Union, Final, Dict, List

from kittens.tui.handler import result_handler
from kitty import fast_data_types
from kitty.boss import Boss
from kitty.options.utils import KeyMap
from kitty.tab_bar import Formatter as fmt
from kitty.types import Shortcut, mod_to_names

# List of categories and regular expressions to match actions on
categories: Final = {
    "Scrolling": r"(^scroll_|show_scrollback|show_last_command_output)",
    "Tab Management": r"(^|_)tab(_|$)",
    "Window Management": r"(^|_)windows?(_|$)",
    "Layout Management": r"(^|_)layout(_|\b)",
    "Other Shortcuts": r".",
}

ShortcutRepr = str
ActionMap = dict[str, list[ShortcutRepr]]


def main(args: list[str]) -> Union[str, None]:
    pass


@result_handler(no_ui=True)
def handle_result(args: list[str], answer: str, target_window_id: int, boss: Boss):
    opts = fast_data_types.get_options()
    modes_categorized: Dict[str, Dict[str, ActionMap]] = {}
    for mode_name, mode_data in opts.keyboard_modes.items():
        # set up keymaps (single keystrokes)
        # keymap: KeyMap = (
        # boss.keymap
        #    mode_data.keymap
        # )  # same as `opts.keymap`, except with global keymaps removed
        # keymap: dict[Shortcut, str] = {
        #    Shortcut((key,)): action for key, action in keymap.items()
        # }
        # set up key sequences (combinations of keystrokes, separated by '>')
        # seq_keymap: dict[Shortcut, str] = {
        #     Shortcut((inner_key.trigger, *(inner_key.rest or []))): inner_key.definition
        #     for key, subseq in keymap.items()
        #     for inner_key in subseq
        # for subseq_keys, action in subseq.items()
        # }

        seq_keymap = {}

        for key, subseq in mode_data.keymap.items():
            # debug_file.write(f"{key}, {subseq}\n")
            # debug_file.write(f"{type(key)}, {type(subseq)}\n")

            for inner_key in subseq:
                trigger = inner_key.trigger
                rest = inner_key.rest or []
                shortcut = Shortcut((trigger, *rest))
                definition = inner_key.definition
                seq_keymap[shortcut] = definition
                # keymap.update(seq_keymap)

        # categorize shortcuts
        # because each action can have multiple shortcuts associated with it, we also attempt to
        # group shortcuts with the same actions together.
        output_categorized: dict[str, ActionMap] = defaultdict(
            lambda: defaultdict(list)
        )
        for key, action in seq_keymap.items():
            key_repr: ShortcutRepr = key.human_repr(kitty_mod=opts.kitty_mod)
            key_repr = f"{key_repr:<15} {fmt.fg.red}→{fmt.fg.default} {action}"

            for subheader, re_pat in categories.items():
                if re.search(re_pat, action):
                    action_map: ActionMap = output_categorized[subheader]
                    action_map[action].append(key_repr)
                    break
            else:
                output_categorized["Other Shortcuts"][action].append(key_repr)
                # emsg = f"No valid subheader found for keymap {key_repr!r}."
                # raise ValueError(emsg)
        modes_categorized[mode_name] = output_categorized
        # print out shortcuts
    output = [
        "Kitty keyboard mappings",
        "=======================",
        "",
        "My kitty_mod is {}.".format("+".join(mod_to_names(opts.kitty_mod))),
        "",
    ]
    for mode_name, output_categorized in modes_categorized.items():
        hr_output_name = mode_name or "Standard"
        output.append("=" * 40)
        output.append(f"{hr_output_name} Mode")
        output.append("=" * 40)
        for category in categories:
            if category not in output_categorized:
                continue
            output.extend([category, "=" * len(category), ""])
            output.extend(sum(output_categorized[category].values(), []))
            output.append("")

        boss.display_scrollback(
            boss.active_window,
            "\n".join(output),
            title="Kitty keyboard mappings",
            report_cursor=False,
        )
