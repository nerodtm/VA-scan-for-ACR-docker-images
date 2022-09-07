#! /usr/bin/bash

echo -e "              0000_____________0000________0000000000000000__000000000000000000+\n            00000000_________00000000______000000000000000__0000000000000000000+\n           000____000_______000____000_____000_______0000__00______0+\n          000______000_____000______000_____________0000___00______0+\n         0000______0000___0000______0000___________0000_____0_____0+\n         0000______0000___0000______0000__________0000___________0+\n         0000______0000___0000______0000_________000___0000000000+\n         0000______0000___0000______0000________0000+\n          000______000_____000______000________0000+\n           000____000_______000____000_______00000+\n            00000000_________00000000_______0000000+\n              0000_____________0000________000000007;"

echo "Filter Kuernets cluster's Docker images"

#Filter with ACR name
echo "Enter the Azure container registry name"
read name
acr_name=$name

#Filtered ACR repository list
grep $name report.txt > acr.txt

#Filter with repository name
echo "Enter Azure Container Registry's Repository name"
read repo
repo_name=$repo

#Filtered repository's docker images
grep $repo acr.txt > repo.txt

#Filter version numbers only from repository
cut -b 34-43 repo.txt > version.txt
