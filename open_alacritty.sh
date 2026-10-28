#!/bin/bash
# Guarda o workspace atual antes de abrir o Alacritty.
CURRENT_DESKTOP=$(wmctrl -d | awk '$2 == "*" {print $1}')

# Abre uma nova instância do Alacritty em segundo plano.
alacritty &
ALACRITTY_PID=$!

# Aguarda a janela associada ao processo novo aparecer.
WINDOW_ID=""
for _ in {1..20}; do
    WINDOW_ID=$(wmctrl -lpx | awk -v desktop="$CURRENT_DESKTOP" -v pid="$ALACRITTY_PID" \
        '$2 == desktop && $3 == pid && /Alacritty\.Alacritty/ {print $1; exit}')

    if [ -n "$WINDOW_ID" ]; then
        break
    fi

    sleep 0.1
done

if [ -n "$WINDOW_ID" ]; then
    wmctrl -i -a "$WINDOW_ID"
fi
