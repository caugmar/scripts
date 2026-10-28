#!/bin/sh
rclone copy --progress -v -L /home/guto/Documentos/ mega:backups/notebook-guto/Documentos/
rclone copy --progress -v -L /home/guto/Imagens/ mega:backups/notebook-guto/Imagens/
rclone copy --progress -v -L /home/guto/ProgramasRFB/ mega:backups/notebook-guto/ProgramasRFB/
rclone copy --progress -v -L /home/guto/backups/ mega:backups/notebook-guto/backups/
rclone copy --progress -v -L /home/guto/clientes/ mega:backups/notebook-guto/clientes/
rclone copy --progress -v -L /home/guto/src/ mega:backups/notebook-guto/src/
rclone copy --progress -v -L /home/guto/bin/ mega:backups/notebook-guto/bin/
notify-send "Backup" "O backup do notebook foi efetuado com sucesso" --expire-time 5000

