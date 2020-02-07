#!/bin/bash

#Autor: Michael Reis

# Variaveis Externas do Jenkins
#${ImagemBase}
#${Tag}
#${Stack}
#${Service}

# Variaveis de Ambiente Globais
RancherServer="http://RANCHERSERVER:8080"
AccessKey="ACCESSKEY"
SecretKey="SECRETKEY"

# Deploy_Container - Valida a existencia do Service e realiza o Deploy do Container
Deploy_Container () {

IDservice=`rancher --url "$RancherServer" --access-key "$AccessKey" --secret-key "$SecretKey" stop "${Stack}"/"${Service}" | tee 2> /dev/null ; sleep 5` ;
    
if [ $? == 0 ]; then
    echo "Deploy Contanainer Rancher";
    rancher --url "$RancherServer" --access-key "$AccessKey" --secret-key "$SecretKey" rm "$IDservice";
    sleep 1;
    rancher --url "$RancherServer" --access-key "$AccessKey" --secret-key "$SecretKey" run --name "${Stack}"/"${Service}" "${ImagemBase}":"${Tag}" ;
    sleep 1;
    echo "Deploy "${ImagemBase}":"${Tag}" Realizado com sucesso!" 
elif [["$IDservice" = "error "${Stack}"/"${Service}": Not found: "${Stack}"/"${Service}"" ]] && [[ $? != 0 ]]; then
    echo 'Update do Service em andamento';
    rancher --url "$RancherServer" --access-key "$AccessKey" --secret-key "$SecretKey" run --name "${Stack}"/"${Service}" "${ImagemBase}":"${Tag}" ;
    sleep 3 ;
    echo "Deploy "${ImagemBase}":"${Tag}" Realizado com sucesso!"
fi    
}

# Executa a Função Deploy_Container
Deploy_Container