#!/usr/bin/env bash
# hypr-dark-frost-xdotfiles — unified font stack for sync scripts.
# Reads shell theme from ~/.config/ambxst/config/theme.json when present.

hdf_x_font_stack() {
    local theme_cfg="${HDF_X_THEME_CFG:-${HOME}/.config/ambxst/config/theme.json}"

    HDF_X_UI_FONT="SF Pro Text"
    HDF_X_UI_SIZE="14"
    HDF_X_MONO_FONT="SF Mono"
    HDF_X_MONO_SIZE="14"

    if [[ -f "$theme_cfg" ]]; then
        HDF_X_UI_FONT="$(jq -r '.font // "SF Pro Text"' "$theme_cfg")"
        HDF_X_UI_SIZE="$(jq -r '.fontSize // 14' "$theme_cfg")"
        HDF_X_MONO_FONT="$(jq -r '.monoFont // "SF Mono"' "$theme_cfg")"
        HDF_X_MONO_SIZE="$(jq -r '.monoFontSize // 14' "$theme_cfg")"
    fi

    HDF_X_GTK_FONT="${HDF_X_UI_FONT} ${HDF_X_UI_SIZE}"
    HDF_X_ROFI_FONT="${HDF_X_UI_FONT} ${HDF_X_UI_SIZE}"
    HDF_X_CHROME_SIZE="${HDF_X_UI_SIZE}"

    _hdf_x_font_available() {
        [[ -n "$(fc-list "$1" -f '%{family}\n' 2>/dev/null | head -1)" ]]
    }

    if ! _hdf_x_font_available "${HDF_X_UI_FONT}"; then
        if _hdf_x_font_available "SF Pro Text"; then
            HDF_X_UI_FONT="SF Pro Text"
        elif _hdf_x_font_available "SF Pro Display"; then
            HDF_X_UI_FONT="SF Pro Display"
        elif _hdf_x_font_available "SF Pro"; then
            HDF_X_UI_FONT="SF Pro"
        elif _hdf_x_font_available "Inter"; then
            HDF_X_UI_FONT="Inter"
        elif _hdf_x_font_available "Adwaita Sans"; then
            HDF_X_UI_FONT="Adwaita Sans"
        elif _hdf_x_font_available "Roboto"; then
            HDF_X_UI_FONT="Roboto"
        fi
        HDF_X_GTK_FONT="${HDF_X_UI_FONT} ${HDF_X_UI_SIZE}"
        HDF_X_ROFI_FONT="${HDF_X_UI_FONT} ${HDF_X_UI_SIZE}"
    fi

    if ! _hdf_x_font_available "${HDF_X_MONO_FONT}"; then
        if _hdf_x_font_available "SF Mono"; then
            HDF_X_MONO_FONT="SF Mono"
        elif _hdf_x_font_available "GeistMono Nerd Font Mono"; then
            HDF_X_MONO_FONT="GeistMono Nerd Font Mono"
        elif _hdf_x_font_available "JetBrainsMono Nerd Font Mono"; then
            HDF_X_MONO_FONT="JetBrainsMono Nerd Font Mono"
        elif _hdf_x_font_available "Iosevka Nerd Font Mono"; then
            HDF_X_MONO_FONT="Iosevka Nerd Font Mono"
        else
            HDF_X_MONO_FONT="monospace"
        fi
    fi
}
