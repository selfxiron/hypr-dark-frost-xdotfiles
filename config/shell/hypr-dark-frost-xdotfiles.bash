# hypr-dark-frost-xdotfiles — bash interactive setup (Fastfetch + Starship).
# Installed to ~/.config/hypr-dark-frost-xdotfiles/shell.bash

if [[ -z "${HDF_X_FASTFETCH_DONE:-}" ]]; then
    if command -v fastfetch >/dev/null 2>&1; then
        fastfetch
    fi
    export HDF_X_FASTFETCH_DONE=1
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
