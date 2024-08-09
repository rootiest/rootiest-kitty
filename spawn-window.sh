#!/bin/bash

# Determine the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the icons dictionary
source "$SCRIPT_DIR/icons-dict.sh"

# Source the colors dictionary
source "$SCRIPT_DIR/colors-dict.sh"

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

# Function to convert color names to hex codes
convert_color() {
  local color_name="$1"
  echo "${colors[$color_name]:-$color_name}"
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
  title_with_icon="$icon$title"
  title_without_icon="$title"
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
