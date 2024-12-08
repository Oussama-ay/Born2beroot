#!/bin/bash

wall "
    #Architecture: $(uname -a)
    #CPU physical: $(cat /proc/cpuinfo | grep "physical id" | sort -u | wc -l)
    #vCPU: $(nproc)
    #Memory Usage: $(free -m | awk '/Mem/ {printf("%d/%dMB (%.2f%%)", $3, $2, ($3*100/$2))}')
    #Disk Usage: $(df -h --total | grep total | awk '{printf("%.1f/%dGb (%s)", $3, $2, $5)}')
    #CPU load: $(top -bn1 | grep "Cpu(s)" | awk '{printf "%.2f%%\n", $2 + $4}')
    #Last boot: $(uptime -s | head -c 16)
    #LVM use: $(lsblk | grep lvm | wc -l | awk '{if ($1 != 0) {printf("yes");} else printf("no");}')
    #Connections TCP: $(ss -t | grep ESTAB | wc -l) ESTABLISHED
    #User log: $(who | wc -l)
    #Network: IP: $(hostname -I) $(ip a | grep link/ether | awk '{printf("(%s)", $2);}')
    #Sudo: $(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l | awk '{printf("%d cmd\n", $1);}')
"
