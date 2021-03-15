#!/usr/bin/env bash

#mise à jour de la liste des paquets
#sudo apt-get update

#installation des outils apt
#sudo apt install software-properties-common

#ajout du repo ansible et mise à jour de la liste des paquets
echo deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
sudo apt update
#sudo apt-add-repository --yes --update ppa:ansible/ansible

#installation d'Ansible et Python3
sudo apt-get install -y ansible python3 

#installation du module Ansible PostgreSQL
sudo ansible-galaxy collection install community.mysql

#définition de l'executable python3 dans la conf Ansible
sudo sed -i '13i\interpreter_python = /usr/bin/python3\' /etc/ansible/ansible.cfg

#création d'un utilisateur temp pour Ansible
sudo useradd -G sudo ansible

