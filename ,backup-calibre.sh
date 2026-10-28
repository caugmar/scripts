#!/bin/sh
rclone copy --progress -v -L "/home/guto/Biblioteca do calibre/" mega:biblioteca-guto/
notify-send "Backup" "O backup do Calibre foi efetuado com sucesso" --expire-time 5000

