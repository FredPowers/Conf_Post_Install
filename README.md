NAME		Conf_Post_Install.sh

VERSION		1.0  15/01/2023

AUTHOR		Frédéric Puren


Script bash to configure Debian 11 after fresh installation

Script testé sur Debian 11

Script pour configurer Debian 11 après l'installation,
	-changer le nom
	- COnfigurer l'IP
	- Déclarer les bons dépots
	- En faire un serveur DHCP, un serveur DNS, un serveur Web ou un routeur.


pour le partage de dossier dans VmWare
si le partage de dossier n'apparait pas dans /mnt/hgfs
lancer la commande suivante : vmhgfs-fuse .host:/ /mnt/hgfs/ -o allow_other -o uid=1000
Si vous etes dans le dossier hgfs, le quitter puis y revenir, le dossier partagé devrait maintenant y apparaitre



Menu

<img width="264" alt="1" src="https://user-images.githubusercontent.com/105367565/212493127-68d01b87-8386-49f7-b59f-bb529b92d84b.png">


Nom d'hôte

<img width="125" alt="2023-01-14 19_58_23-DebServer - VMware Workstation 16 Player (Non-commercial use only)" src="https://user-images.githubusercontent.com/105367565/212493162-79cc8398-12f1-4768-809d-5885a1d3403c.png">


Configuration IP

<img width="214" alt="2023-01-14 19_58_44-DebServer - VMware Workstation 16 Player (Non-commercial use only)" src="https://user-images.githubusercontent.com/105367565/212493173-e49069d6-fcb9-48c9-a9b7-3655c491bc15.png">


Vérifier proxy

<img width="176" alt="2023-01-14 19_59_17-DebServer - VMware Workstation 16 Player (Non-commercial use only)" src="https://user-images.githubusercontent.com/105367565/212493185-278feeb0-d620-4958-9007-88d85fae96cc.png">


Configurer un serveur DHCP

<img width="283" alt="2023-01-14 19_59_45-DebServer - VMware Workstation 16 Player (Non-commercial use only)" src="https://user-images.githubusercontent.com/105367565/212493196-1939ec6f-2752-44c2-a0fa-af8291137695.png">


Configurer un serveur DNS

<img width="241" alt="2023-01-14 20_00_24-DebServer - VMware Workstation 16 Player (Non-commercial use only)" src="https://user-images.githubusercontent.com/105367565/212493199-259afaeb-4051-48c3-92f0-344d9fffd93a.png">


Configurer un serveur LAMP

<img width="133" alt="2023-01-14 20_00_49-DebServer - VMware Workstation 16 Player (Non-commercial use only)" src="https://user-images.githubusercontent.com/105367565/212493209-9fffb8f7-0efb-439e-9dc6-59a92ee31e7a.png">


Ajouter un repertoire au $PATH

<img width="139" alt="2023-01-14 20_03_41-DebServer - VMware Workstation 16 Player (Non-commercial use only)" src="https://user-images.githubusercontent.com/105367565/212493214-0e638218-451b-4bef-b401-38947ec14ac8.png">

