#!/bin/bash

# Autor: Michael Christian
# Versao: 1.0
# GitHub: mchristian279

# Variaveis Externas do Jenkins
#${ImagemBase}
#${Tag}
#${Stack}
#${Service}

# Variaveis de Ambiente Globais
GitRepoBalanceador="PROJETOGIT"
GitRepoDirBalanceador=`echo "$GitRepoBalanceador" | cut -d '/' -f 5 | cut -d '.' -f 1`
RancherServer="http://RANCHERSERVER:8080"
AccessKey="ACCESSKEY"
SecretKey="SECRETKEY"
RancherBalanceadorStack="Balanceador"

# Get_ConfigBalanceador - Faz o pull das configurações do repositório de balanceamento
Get_ConfigBalanceador () {
    git config --global http.sslverify false ;
    git clone "$GitRepoBalanceador"
}

# Deploy_Balanceador - Realiza o Deploy das configuração de balanceamento Rancher
Deploy_Balanceador () {
rancher-compose --url "$RancherServer" --access-key "$AccessKey" --secret-key "$SecretKey" -p "$RancherBalanceadorStack" -f "$GitRepoDirBalanceador"/docker-compose.yml -r "$GitRepoDirBalanceador"/rancher-compose.yml up --force-upgrade --confirm-upgrade -d ;
sleep 3
}

# Executa a Função Get_ConfigBalanceador
Get_ConfigBalanceador 

# Espera dois segundos para executar a próxima Função
sleep 2;

# Executa a Função Deploy_Balanceador
Deploy_Balanceador

# Valida a execução da chamada da Função Deploy_Balanceador
if [ $? == 0 ]; then
    echo "Deploy das configurações de Balanceador Rancher Realizado com sucesso! - "${Stack}"/"${Service}""
elif [ $? != 0 ]; then
    echo "Não foi possível realizar o Deploy das configurações de Balanceador Rancher" ;
fi
