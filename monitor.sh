#!/bin/bash

liftServices() {
    echo "Executing Ansible playbook to lift services..."
    ansible-playbook apache.yml -i hosts
    ansible-playbook dns.yml -i hosts
}

restartDNSService() {
    echo "Executing Ansible playbook to restart DNS server at 192.168.1.4..."
    ansible-playbook dns-backup.yml -i hosts
}

restartApacheService() {
    echo "Executing Ansible playbook to restart Apache server at 192.168.1.4..."
    ansible-playbook apache-backup.yml -i hosts
}

verifyServerA() {
    echo "verifying DNS server"
    ssh_command=" systemctl is-active named"
    response=$(ssh "192.168.1.2" "$ssh_command")
    echo "Resposta do comando SSH: $response"
    if [ "$response" != "active" ]; then
       	echo "deu ruim no dns!!" 
	serverAUp=false
        restartDNSService 
    else
        echo "DNS server is fine"              
    fi
}

verifyServerB() {
    echo "verifying Apache server"
    ssh_command=" systemctl is-active apache2"
    response=$(ssh "192.168.1.3" "$ssh_command")
    echo "Resposta do comando SSH: $response"
    if [ "$response" != "active" ]; then
        serverBUp=false
        restartApacheService  
    else
        echo "Apache server is fine"              
    fi
}

monitoring() {
    serverAUp=true
    serverBUp=true

    echo "starting monitoring"
    while true; do
        echo "loop"
        if $serverAUp; then
            verifyServerA
        fi
        if $serverBUp; then
            verifyServerB
        fi
        if ! $serverAUp && ! $serverBUp ; then
            break
        fi
        sleep 1
    done
}

main() {
    echo "starting execution"
    liftServices
    monitoring
}

main
