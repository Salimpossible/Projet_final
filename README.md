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
•	Un master Jenkins
•	Un slave Jenkins
•	Un serveur web Nginx qui servira de proxy/reverse
    
 Les outils:
•	Ansible : différent roles et playbooks ansible pour approvisionner les ressources : GIT, MAVEN, JAVA12, MONGODB,JENKINS, DOCKER,
     PYMONGO, NGINX, TERRAFORM, SSHCONFIG, JAVA8,AZCLI
•	Terraform : pour la création des ressources (la plateforme) sur Azure Cloud. Cette dernière comprend deux ressources groups. L'un contenant 
     le Vnet,Subnet, les IPs, les NIC, les NSG qui accueilleront les machines Jenkins, Slave et le serveur Nginx et l'autre contient 
     le Vnet, les deux Subnet (un pour environnement Test, un pour l'environnement Prod), les IPs, les NIC, les NSG.
•	GitHub : Dépôt distant (https://github.com/Salimpossible/Projet_final.git)
•	DockerHub : Contient les images docker (aaugrain/ansible-git)
•	Maven : Build, package
•	Ansible : les rôles ansible pour provisionner la machine cliente et la BDD MongoDB

Description du code pour la livraison de pile complète : contenu dans un fichier Jenkinsfile qui contient un pipeline :
•	Récupération du code terraform
•	Exécution du code terraform
•	Récupération du code ansible
•	Provisioning des serveurs et BDD
•	Récupération du code de l’application
•	Lancement des tests maven
•	Livraison de l’image docker sur dockerhub
Si la branche est develop, le déploiement sera dans l’environnement Test.
Si la branche est master, le déploiement sera dans l’environnement Prod

     
Auteurs:
     - Salim --> @salimpossible
     - Allexandre --> @aagrain
     - Lynda --> @lynda-cheheb

