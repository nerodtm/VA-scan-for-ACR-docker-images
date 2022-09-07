#! /usr/bin/bash

echo "Vulnerability Scanning for azure repository docker images"

echo -n $'\E[31m'
echo $''
echo $'      _,.'
echo $'    ,` -.)'
echo $'   \'( _/\'-\\\\-.'
echo $'  /,|`--._,-^|          ,'
echo $'  \\_| |`-._/||          ,\'|'
echo $'    |  `-, / |         /  /'
echo $'    |     || |        /  /'
echo $'     `r-._||/   __   /  /'
echo $' __,-<_     )`-/  `./  /'
echo $'\'  \\   `---\'   \\   /  /'
echo $'    |           |./  /'
echo $'    /           //  /'
echo $'\\_/\' \\         |/  /'
echo $' |    |   _,^-\'/  /'
echo $' |    , ``  (\\/  /_'
echo $'  \\,.->._    \\X-=/^'
echo $'  (  /   `-._//^`'
echo $'   `Y-.____(__}'
echo $'    |     {__)'
echo $'          ()`'

#Update linux distro
#sudo apt update

#Log in to azure portal
#az login

#Log in to azure container registries
echo "Enter the Azure container registry name"
read name
acr_name=$name
az acr login --name $name

#Enter Azure Container Registry's Repository name
echo "Enter ACR repository name"
read repo
repo_name=$repo


#Pull docker images from azure repository
filename='versions.txt'
echo Start
while read p; do 
    echo "$p"


docker pull $name.azurecr.io/$repo:$p

#Scan docker images using trivy
trivy image $name.azurecr.io/$repo:$p > /home/nero/Desktop/test/$p.txt

timestamp=$(date +%Y%m%d_%H%M%S)
log_path="`pwd`"
filename=docker_cleanup_$timestamp.log
log=$log_path/$filename


docker_space_before(){
CURRENTSPACE=`docker system df`
echo "Current Docker Space:" >> $log
echo $CURRENTSPACE >>$log
}
docker_find (){
echo "#####################################################################" >> $log
echo "Finding images" >> $log
echo "#####################################################################" >> $log
REMOVEIMAGES=`docker images | grep " [days|months|weeks]* ago" | awk '{print $3}'`

echo "Listing images that needs to be cleaned up" >> $log
echo $REMOVEIMAGES >>$log

}

docker_cleanup(){
echo "#####################################################################" >> $log
echo "Cleaning images" >> $log
echo "#####################################################################" >> $log
docker rmi ${REMOVEIMAGES}
}

docker_space_after(){
CURRENTSPACE=`docker system df`
echo "Current Docker Space, after clean up:" >> $log
echo $CURRENTSPACE >>$log
}
docker_space_before
docker_find
docker_cleanup
docker_space_after

done < "$filename"
