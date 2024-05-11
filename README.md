# projeto-sysadmin
O projeto consiste de 4 servidores: O primeiro servidor (master) é responsável por subir os serviços nas máquinas originais, monitorar e, em caso de problema, levantar o serviço no backup.
O segundo servidor (ServerA) é um servidor DNS.
O terceiro servidor (ServerB) é um servidor apache. O quarto servidor (BackupServer) é o que vai hostear os serviços em caso de problema.

Existem 3 rules e 4 playbooks, além do inventário (hosts) e o script de monitoramento em bash - considere que todo este diretório está presente no servidor master
A execução é realizada por
```sh monitor.sh```
