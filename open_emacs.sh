#!/bin/bash
# Guarda o workspace atual e as janelas existentes antes de abrir o Emacs.
CURRENT_DESKTOP=$(wmctrl -d | awk '$2 == "*" {print $1}')
BEFORE_WINDOWS=$(wmctrl -lpx | awk '{print $1}')

# Abre um novo frame no servidor do Emacs gerenciado pelo systemd.
emacsclient -n -c &

# Aguarda o novo frame aparecer e identifica-o pela classe da janela.
WINDOW_ID=""
for _ in {1..20}; do
    WINDOW_ID=$(wmctrl -lpx | awk -v desktop="$CURRENT_DESKTOP" -v before="$BEFORE_WINDOWS" \
        '$2 == desktop && /[Ee]macs/ && index("\n" before "\n", "\n" $1 "\n") == 0 {print $1; exit}')

    if [ -n "$WINDOW_ID" ]; then
        break
    fi

    sleep 0.1
done

if [ -n "$WINDOW_ID" ]; then
    wmctrl -i -a "$WINDOW_ID"
fi
