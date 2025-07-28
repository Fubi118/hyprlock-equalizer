# 🎵 Hyprlock Audio Visualizer with CAVA

This project adds a clean, performant audio visualizer to your [Hyprlock](https://github.com/hyprwm/hyprlock) lockscreen using [CAVA](https://github.com/karlstav/cava) and a custom `eq.sh` script.  
It is designed to be subtle, fast, and entirely written in bash — with no heavy dependencies.

## ✨ Features

- Live audio visualization with 8 levels of Unicode blocks
- Single or Dual-direction display (top & bottom bars)
- RAM-based output
- Auto-start via systemd user service
- Player detection via `playerctl`

---

## 📦 Dependencies

You will need the following tools:

- [`cava`](https://github.com/karlstav/cava) (audio visualizer backend)
- [`playerctl`](https://github.com/altdesktop/playerctl) (media player detection)

---

## 🛠️ Setup Instructions

### 1. Start Music (youtube or something)
It makes testing easier

### 2. Run playerctl
Make sure your playerctl is running and working
playerctl status --format "{{ uc(status) }}"
playerctl metadata artist
playerctl metadata title

### 3. Configure `cava`

Make sure your `~/.config/cava/config` contains these **exact settings**:

method = raw
data_format = ascii
ascii_max_range = 8
framerate = 30

These settings are required to ensure the visualizer generates the expected output for the script to parse.
you can find an example config under "examples"

### 4. Enable the background service
Create a systemd user service at:
~/.config/systemd/user/cava-to-file.service

Paste the following content (adjust paths):
[Unit]
Description=CAVA to RAM file for Hyprlock visualizer
After=default.target

[Service]
ExecStart=/home/YOUR_USERNAME/.config/hypr/scripts/cava_to_file.sh
Restart=always

[Install]
WantedBy=default.target

RUN
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now cava-to-file.service
systemctl --user start --now cava-to-file.service

Check if service is running
systemctl --user status --now cava-to-file.service
journalctl --user -u cava-to-file -f

check if outputfile is getting data
tail -f  /dev/shm/cava_output.txt

### 5. Add the Hyprlock config snippet
In your hyprlock.conf, add the two label blocks for top and bottom visualization from equalizer_snippet.conf. Adjust the positions as needed.
If you only need one you can do so.

## 🧠 How It Works
- cava_to_file.sh: continuously pipes the CAVA visual data into a file stored in RAM (/dev/shm/cava_output.txt)
- eq.sh and eq_inverted.sh: parse this file and map amplitude to Unicode characters (Braille elements)
- playerctl: checks if something is playing and hides the visualizer otherwise
- Hyprlock: regularly calls the script via cmd[update:1]

## 🎨 Customization
### Changing the Visualizer Bars

The visualizer bars are defined in the scripts (`eq.sh` and `eq_inverted.sh`) by mapping numeric amplitude values to Unicode characters.

- To **change the appearance** of the bars, edit the character arrays inside these scripts.  
  see examples/eq_variations.txt for some ideas. be creative and replace these characters with others (e.g., different block elements, Braille patterns, or custom Unicode symbols).

### Adjusting the Number of Bars
The number of bars are set like this "bars = 20"
you can easily change the amount without breaking anything.