#!/usr/bin/env sh

# Dump the current kitty session:
kitty @ ls >~/.config/kitty/save_session/kitty-dump.json
# Convert this JSON file into a kitty session file:
cat kitty-dump.json | python3 ~/.config/kitty/save_session/kitty-convert-dump.py >~/.config/kitty/sessions/saved-session.conf
# Close the generator window:
