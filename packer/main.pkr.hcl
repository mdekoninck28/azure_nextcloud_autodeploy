#récuperer le timestamp actuel
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

#définir le fournisseur cloud + les ID de connexion à l'API
source "azure-arm" "basic-example" {
  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
  
  #ajouter le timestamp au nom de l'image à générer  
  managed_image_name                = "${var.image_name}_${local.timestamp}"
 
  #définir le groupe de ressources à créer pour stocker l'image
  managed_image_resource_group_name = var.resourcegroup

  #définir l'OS à installer
  os_type = var.os_type
  image_publisher = var.image_publisher
  image_offer = var.image_offer
  image_sku = var.image_sku

  #renseigner les métadonnées de l'image à générer
  azure_tags = {
    dept = var.dept
  }

  #définir l'emplacement du groupe de ressources et le type de serveur à utiliser pour créer l'image
  location = "East US"
  vm_size = "Standard_B1s"
}

#création de l'image
build {
  sources = ["source.azure-arm.basic-example"]
 
  #executer un script shell pour provisionner l'image
  provisioner "shell" {
  execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
  script = "bootstrap.sh"
  }

  #executer un playbook Ansible pour installer Nextcloud
  provisioner "ansible" {
    collections_path = "/home/packer/.ansible/collections/ansible_collections/community/postgresql"
    playbook_file = "../ansible/deploy.yml"
    roles_path = "../ansible/roles"
    user = "ansible"
  }
  
  #générer un récap de l'image créée à la fin
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
    }
  
  #récuperer l'ID de l'image créée pour la déployer avec terraform
  post-processor "shell-local" {
    script = "get_imageid.sh"
}

}
