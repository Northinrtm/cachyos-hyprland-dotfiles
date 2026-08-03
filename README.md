# CachyOS Hyprland dotfiles

Public, privacy-safe configuration for a two-monitor CachyOS/Hyprland desktop.

## Included

- Hyprland Lua configuration, window rules and key bindings
- Hyprpaper, Hyprlock and Hypridle
- Waybar with custom workspace buttons and power menu
- Xiaomi Pad 6 USB menu:
  - microphone + webcam
  - microphone + tablet audio
- Mako, Alacritty and GTK configuration
- a small GTK theme for `gsimplecal`
- curated package list
- installer with automatic backup

The repository does **not** contain passwords, tokens, network profiles, browser
profiles, chat sessions, SSH/GPG keys, logs or device addresses.

## Target system

- CachyOS or Arch Linux
- Hyprland with Lua configuration support
- two-monitor layout:
  - `DP-2`: 2560×1440 at 120 Hz
  - `DVI-D-1`: 1920×1080 at 60 Hz
- NVIDIA environment variables are enabled in `config/hypr/hyprland.lua`

Review these hardware-specific settings before logging into Hyprland on another
computer.

## Installation

```bash
git clone https://github.com/Northinrtm/cachyos-hyprland-dotfiles.git
cd cachyos-hyprland-dotfiles
./install.sh
```

Install only configuration files when dependencies are already installed:

```bash
./install.sh --configs-only
```

Existing configuration is copied to:

```text
~/.local/state/cachyos-hyprland-dotfiles/backup-YYYYMMDD-HHMMSS
```

## Wallpapers

Wallpaper binaries are not published until their redistribution license is
known. See [wallpapers/README.md](wallpapers/README.md).

## Privacy check

Run before every public push:

```bash
./privacy-check.sh
```

The check rejects absolute home paths, email addresses, MAC addresses, private
keys, likely secrets and credentials embedded in URLs.

## Xiaomi Pad 6

Enable Android developer options and USB debugging, then authorize the computer.
The Waybar tablet icon opens a mode menu. The script discovers the connected ADB
device dynamically; no serial number is stored in this repository.

The webcam mode creates `/dev/video10` through `v4l2loopback`. The audio mode
routes tablet playback to the current default PipeWire output. Both modes expose
the tablet microphone as `Xiaomi_Pad_Microphone`.

## License

Configuration and original scripts in this repository are available under the
MIT License. Third-party software remains under its own license.
