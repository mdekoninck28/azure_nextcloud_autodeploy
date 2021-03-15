#variables

MANIFEST_FILE=manifest.json
TF_TFVARS_FILE=../terraform/terraform.tfvars

#recuperer et afficher le nom de l'image depuis le manifest.json
IMAGE_NAME=$(jq -r '.builds[-1].artifact_id' $MANIFEST_FILE | cut -d ':' -f2 | cut -d '/' -f9)
echo "Nom de l'image :" $IMAGE_NAME

#déclarer la variable dans le fichier terraform.tfvars

sed -i "/^image/s/=.*/=\""$IMAGE_NAME"\"/" $TF_TFVARS_FILE
cat $TF_TFVARS_FILE