#!/bin/sh
rclone copy "/media/guto/Enterprise/Music" "mega:/Music" --ignore-existing -P
notify-send "Backup" "O backup das músicas foi efetuado com sucesso" --expire-time 5000
