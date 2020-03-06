Projet : 
Ce projet propose une plateforme d'intégration continue avec des ressources sur le Cloud Azure, capable d'effectuer une livraison de pile
de production complète sur les environnements techniques: Test et Prod de l'entreprise.

Les environnement Test et Prod se situent sur un même réseau virtuel (Vnet) lié à une ressource group
Environnement de Test:
Installé sur une ressource Cloud (un Subnet). Contient un serveur de base de données MongoDB et un serveur test pour déployer l'application 
https://github.com/girldevops/Restful-Webservice qui repose sur un Framework SpringBoot.

Environnement de Prod:
Installé sur une autre ressource Cloud (un autre subnet). Contient un serveur de base de données MongoDB et un serveur prod pour déployer l'application..

Description de la plateforme d'intégration continue (PIC): 
Installée une une ressource group dans un Vnet,elle comprend:
   - Un master Jenkins
   - Un slave Jenkins
   - Un serveur web Nginx qui servira de proxy/reverse
 
 Les outils:
   - Ansible : différent roles et playbooks ansible pour approvisionner les ressources : GIT, MAVEN, JAVA12, MONGODB,JENKINS, DOCKER, PYMONGO, NGINX, TERRAFORM, SSHCONFIG, JAVA8,AZCLI
   - Terraform : pour la création des ressources (la plateforme) sur Azure Cloud. Cette dernière comprend deux ressources groups. 
      L'un contenant  le Vnet,Subnet, les IPs, les NIC, les NSG qui accueilleront les machines Jenkins, Slave et le serveur  Nginx et l'autre contient 
     le Vnet, les deux Subnet (un pour environnement Test, un pour l'environnement Prod), les IPs, les NIC, les NSG.
   - GitHub : Dépôt distant (https://github.com/Salimpossible/Projet_final.git)
   - DockerHub : Contient les images docker (aaugrain/ansible-git)
   - Maven : Build, package
   - Ansible : les rôles ansible pour provisionner la machine cliente et la BDD MongoDB

Dépendances requises:
- vagrant (ou une VM avec ansible et terraform installés)

Description des tâches à suivre :
- Cloner le répertoire GITHUB suivant https://github.com/Salimpossible/Projet_final.git afin de récupérer un l'ensemble des scipts.
- Une fois le répertoire présent sur votre environment local,via un terminal, utiliser le vagrantfile pour créer une machine virtuelle à l'aide de Vagrant (vagrant up) et connectez-y vous (vagrant ssh)
- Une fois connecté à la VM, créer une paire de clé SSH grâce à la commande ssh-keygen, et laisser l'ensemble des champs vides.
- Installation de la plateforme d'intégration continue: 
Créer un fichier backend.tfvars dans le dossier terraform_pic qui aura la forme suivante :
   subscription_id =  id de souscription
   client_id       =  id de client
   client_secret   =  mot de passe
   tenant_id       =  id de tenant
   pub_key      =  clé SSH publique

NB: Il s'agit de la clé publique générée à l'étape précédente et qui se trouve donc dans /home/stage/.ssh/id_rsa.pub

Dans le terminal, se placer dans le dossier terraform_pic et lancer les commandes suivantes:
   terraform init
   terraform plan -var-file="variables.tfvars" -var-file="backend.tfvars"
   terraform apply -var-file="variables.tfvars" -var-file="backend.tfvars"


Une fois la plateforme installée, se placer via un terminal dans le dossier ansible et lancer la commande suivante:
- ansible-playbook install_pic.yml -i inventory

Sur votre navigateur internet entrer ensuite l'adresse suivante:
- http://proxypic.francecentral.cloudapp.azure.com

Suivre les instructions afficher pour paramétrer la première connexion à Jenkins.

Une fois connecter à jenkins suivres les étapes suivantes:
- Aller dans "administrer jenkins" puis "Gestion des plugins" et installer les plugins maven, ansible, docker, git.
- Aller ensuite dans "identifiants",  "global",  "ajouter des identifiants" dans "type" selectionner "SSH Username with private key" dans "username" , cocher la case "Enter directly" et coller la clé publique générer précédemment (/home/stage/.ssh/id_rsa) et sauvegarder.
- Répéter la procédure pour créer de nouveaux identifiants,  ans "type" selectionner "secret file" et importer un fichier de type backend.tfvars comme celui créer précédemment.
- Replacer dans le menu principal de jenkins et créer un nouveau pipeline (nouvel item, pipeline). dans la partie "Pipeline" "Définition" sélectionner "pipeline from SCM" puis "GiT". Dans "Repository URL" entrer "https://github.com/Salimpossible/Projet_final.git" et "sauver".
- "lancer un build"


Auteurs:
     - Salim --> @salimpossible
     - Alexandre --> @aaugrain
     - Lynda --> @lynda-cheheb

