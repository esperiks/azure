#/bin/bash

aro_name=$(az network lb list  -g aro-dev --query [0].name  -o tsv)
echo $aro_name
