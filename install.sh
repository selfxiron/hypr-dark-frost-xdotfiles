#!/usr/bin/env bash
# Install hypr-dark-frost-xdotfiles to $HOME.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin="${HOME}/.local/bin"
share="${HOME}/.local/share/hypr-dark-frost-xdotfiles"
desktop="${HOME}/.local/share/applications"
shell_cfg="${HOME}/.config/hypr-dark-frost-xdotfiles"
bashrc="${HOME}/.bashrc"
marker_start="# >>> hypr-dark-frost-xdotfiles shell >>>"
marker_end="# <<< hypr-dark-frost-xdotfiles shell <<<"

write_desktop_entries() {
    cat >"${desktop}/code.desktop" <<EOF
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editor
GenericName=Text Editor
Exec=${bin}/code --unity-launch %F
Icon=visual-studio-code
Type=Application
StartupNotify=false
StartupWMClass=code-oss
Categories=TextEditor;Development;IDE;
MimeType=application/x-code-workspace;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=${bin}/code --new-window %F
Icon=visual-studio-code
EOF

    cat >"${desktop}/code-oss.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Code - OSS
Hidden=true
NoDisplay=true
EOF

    cat >"${desktop}/firefox.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Firefox
Comment=Browse the Web
GenericName=Web Browser
Exec=${bin}/firefox %u
Icon=firefox
StartupWMClass=firefox
Terminal=false
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
EOF

    cat >"${desktop}/discord.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Discord
Comment=Voice and text chat
Exec=${bin}/discord
Icon=discord
StartupWMClass=discord
Terminal=false
Categories=Network;InstantMessaging;
EOF
}

mkdir -p "$bin" "$share" "$desktop" "$shell_cfg" \
  "${HOME}/.config/hypr" \
  "${HOME}/.config/kitty" \
  "${HOME}/.config/rofi" \
  "${HOME}/.config/electron" \
  "${HOME}/.config/fastfetch"

cp -f "${repo}/share/font-stack.sh" "$share/"
chmod +x "${repo}/bin/"*
for script in "${repo}/bin/"*; do
  cp -f "$script" "${bin}/$(basename "$script")"
done

ln -sf code-hypr-dark-frost-xdotfiles "${bin}/code"
ln -sf firefox-hypr-dark-frost-xdotfiles "${bin}/firefox"
ln -sf discord-hypr-dark-frost-xdotfiles "${bin}/discord"

cp -f "${repo}/config/hypr/hyprland.lua" "${HOME}/.config/hypr/"
cp -f "${repo}/config/kitty/kitty.conf" "${HOME}/.config/kitty/"
cp -f "${repo}/config/rofi/config.rasi" "${HOME}/.config/rofi/"
cp -f "${repo}/config/shell/hypr-dark-frost-xdotfiles.bash" "${shell_cfg}/shell.bash"
if [[ -f "${repo}/config/electron/electron42-flags.conf" ]]; then
  cp -f "${repo}/config/electron/electron42-flags.conf" "${HOME}/.config/"
fi

write_desktop_entries

# Retire old ambxst-branded helper names.
for old in \
  sync-gtk-ambxst sync-rofi-ambxst sync-kitty-ambxst sync-vscode-ambxst \
  sync-firefox-ambxst sync-discord-ambxst sync-fonts-ambxst \
  install-ambxst-fonts install-vscode-ambxst fix-gtk-ambxst-perms; do
  rm -f "${bin}/${old}"
done
rm -f "${HOME}/.local/share/ambxst/font-stack.sh"

if [[ -f "$bashrc" ]]; then
  if grep -qF "$marker_start" "$bashrc"; then
    awk -v start="$marker_start" -v end="$marker_end" '
      $0 == start { skip=1; next }
      $0 == end { skip=0; next }
      !skip { print }
    ' "$bashrc" >"${bashrc}.tmp"
    mv "${bashrc}.tmp" "$bashrc"
  fi
  cat >>"$bashrc" <<EOF

${marker_start}
[[ -f "\${HOME}/.config/hypr-dark-frost-xdotfiles/shell.bash" ]] && source "\${HOME}/.config/hypr-dark-frost-xdotfiles/shell.bash"
${marker_end}
EOF
fi

"${bin}/sync-fonts-hypr-dark-frost-xdotfiles"

echo "Installed hypr-dark-frost-xdotfiles."
echo "Install shell tools: ~/.local/bin/install-shell-hypr-dark-frost-xdotfiles"
echo "Run: hyprctl reload   then open a new Kitty window."
