#!/bin/sh
rclone copy --progress -v -L /media/guto/VAULT/backup-minister/ mega:backups/backup-minister/
notify-send "Backup" "O backup do HD Externo foi efetuado com sucesso" --expire-time 5000

