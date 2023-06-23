NAME		Conf_Post_Install.sh

VERSION		1.0  15/01/2023

AUTHOR		Frédéric Puren


Script bash to configure Debian 11 after fresh installation

Script testé sur Debian 11

Script pour configurer Debian 11 après l'installation,
	-changer le nom
	- COnfigurer l'IP
	- Déclarer les bons dépots
	- En faire un serveur DHCP, un serveur DNS, un serveur Web, un serveur centreon, un serveur glpi ou en faire un routeur.


pour le partage de dossier dans VmWare
si le partage de dossier n'apparait pas dans /mnt/hgfs
lancer la commande suivante : vmhgfs-fuse .host:/ /mnt/hgfs/ -o allow_other -o uid=1000
Si vous etes dans le dossier hgfs, le quitter puis y revenir, le dossier partagé devrait maintenant y apparaitre



Menu

![2023-06-22 16_12_49-Deb11 - VMware Workstation 16 Player (Non-commercial use only)](https://github.com/FredPowers/Conf_Post_Install/assets/105367565/37adbdab-dca1-4884-9c97-736e3175d51b)


