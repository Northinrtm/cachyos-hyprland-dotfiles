#!/usr/bin/env bash

set -euo pipefail

readonly REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly BACKUP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/cachyos-hyprland-dotfiles/backup-$(date +%Y%m%d-%H%M%S)"

install_packages=true
if [[ "${1:-}" == "--configs-only" ]]; then
    install_packages=false
elif [[ $# -gt 0 ]]; then
    echo "Usage: $0 [--configs-only]" >&2
    exit 2
fi

if [[ ! -r /etc/os-release ]]; then
    echo "Cannot identify the operating system." >&2
    exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release
if [[ "${ID_LIKE:-}" != *arch* && "${ID:-}" != "cachyos" && "${ID:-}" != "arch" ]]; then
    echo "This installer supports CachyOS and Arch Linux." >&2
    exit 1
fi

if $install_packages; then
    mapfile -t packages < <(sed -E '/^[[:space:]]*(#|$)/d' "$REPO_DIR/packages/desktop.txt")
    sudo pacman -S --needed "${packages[@]}"
fi

mkdir -p "$BACKUP_DIR" "$HOME/.config" "$HOME/.local/bin" "$HOME/.themes"

backup_path() {
    local source_path="$1"
    local relative_path="${source_path#"$HOME"/}"

    if [[ -e "$source_path" || -L "$source_path" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname -- "$relative_path")"
        cp -a -- "$source_path" "$BACKUP_DIR/$relative_path"
    fi
}

for source_dir in "$REPO_DIR"/config/*; do
    name="$(basename -- "$source_dir")"
    backup_path "$HOME/.config/$name"
    mkdir -p "$HOME/.config/$name"
    rsync -a -- "$source_dir/" "$HOME/.config/$name/"
done

backup_path "$HOME/.local/bin/xiaomi-pad-studio"
backup_path "$HOME/.local/bin/frozen-region-screenshot"
install -Dm755 "$REPO_DIR/scripts/xiaomi-pad-studio" "$HOME/.local/bin/xiaomi-pad-studio"
install -Dm755 "$REPO_DIR/scripts/frozen-region-screenshot" "$HOME/.local/bin/frozen-region-screenshot"

backup_path "$HOME/.themes/gsimplecal-dark"
mkdir -p "$HOME/.themes/gsimplecal-dark"
rsync -a -- "$REPO_DIR/themes/gsimplecal-dark/" "$HOME/.themes/gsimplecal-dark/"

mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Pictures/wallpapers"

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi
fc-cache -f

echo
echo "Configuration installed."
echo "Previous files were backed up to:"
echo "  $BACKUP_DIR"
echo
echo "Before starting Hyprland, review:"
echo "  $HOME/.config/hypr/hyprland.lua"
echo "  $HOME/.config/hypr/hyprpaper.conf"
echo "Monitor names and wallpaper files are machine-specific."
