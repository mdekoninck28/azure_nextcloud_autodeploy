# Deploiement automatisé de Nextcloud sur Azure

Dans le cadre de ma formation "Manager des Systèmes d'Informations option Cloud et Virtualisation", j'ai appris à manipuler des outils d'infrastructure as code afin d'automatiser le déploiement de services au sein d'un fournisseur cloud.

Dans ce cas précis, j'ai utilisé Packer, Ansible, et Terraform pour déployer une instance de Nextcloud dans une VM sur la plateforme Microsoft Azure. Les fichiers de ce projet sont parfaitement réutilisables pour monter son propre serveur de fichiers Nextcloud.

## Fonctionnement

Packer, Ansible, et Terraform permettent de générer une image de Debian pré-configurée et générer une VM sur Azure à partir de cette image.

![Déploiement d'une VM pré-configurée sur Azure avec Packer, Ansible, et Terraform](https://i.ibb.co/68mRsmL/packer-ansible-terraform.png%22)

Packer récupère d'abord l'image de Debian 10 sur le dépôt d'images Azure. Ensuite il la provisionne, d'abord à l'aide d'un script bash pour y installer Ansible, puis avec Ansible lui-même afin de configurer Nextcloud.

Ansible installe les paquets nécessaires, configure le serveur web Apache2, le SGBD MySQL, et effectue le paramétrage de Nextcloud. Une fois le provisionnement de l'image terminé, Packer stocke l'image sur Azure et exécute un script qui va indiquer le nom de l'image à Terraform.

Pour terminer, Terraform créée la machine virtuelle, ainsi que les ressources requises (adresse IP, adaptateur réseau...) sur Azure, en appliquant l'image précédemment générée par Packer. A la fin, la VM est démarrée et son adresse IP Publique s'affiche à l'écran.

## Instructions d'utilisation

Pour déployer Nextcloud avec cette configuration : 

 1. Commencer par installer `Azure CLI` sur un PC (https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli)
 2. Se connecter à son compte Azure grâce à la commande `az login` et suivre les instructions à l'écran. Une fois connecté, noter les différents identifiants qui s'affichent.
 3. Créer un groupe de ressources dans lequel seront stockés les données (via le CLI ou l'interface web Azure), qui doit impérativement être situé sur le datacenter `eastus` (cette valeur est modifiable à la ligne 29 de `packer/main.pkr.hcl`si besoin).
 4. Installer Packer (https://learn.hashicorp.com/tutorials/packer/getting-started-install).
 5. Installer Terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli).
 6. Copier le répertoire du projet sur la machine. 
 7. Ajouter les identifiants Azure obtenus à l'étape 2 dans le fichier `packer/main.auto.pkrvars.hcl`. Il s'agit des variables "client_id", "client_secret", "subscription_id", et "tenant_id". Elles vont permettre à Packer de se connecter au compte Azure.
 8. Modifier aussi les variables `dept` et `resourcegroup` pour les adapter à la situation.
 9. Editer le fichier `ansible/roles/nextcloud/vars/main.yml`pour définir les réglages et les identifiants admin de Nextcloud
 10. Editer le fichier `terraform/terraform.tfvars`pour renseigner les paramètres de la VM (groupe de ressources, emplacement, nom...).
 11. Lancer la commande `make all` à la racine du projet pour démarrer le processus et patientez jusqu'à la fin. Noter l'adresse IP en sortie. 
 12. Votre serveur Nextcloud est prêt à l'emploi !

Remarque : Pour de meilleures performances, il est possible de modifier le type de machine déployée dans Azure depuis le fichier `terraform/main.tf`. De plus, il est conseillé d'activer le cache en mémoire avec Redis (https://www.it-connect.fr/nextcloud-activer-et-configurer-le-cache-redis/).
