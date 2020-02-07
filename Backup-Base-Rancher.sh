#!/bin/bash

#Credenciais MYSQL
HOST="HOST"
USER="USUARIO"
PASSWORD="SENHA"

#Variaveis de S.O
DATA=`/bin/date +%d.%m.%Y`
HORA=`/bin/date | cut -d ' ' -f 4`
DIRLOG="/var/log/logsbkp-rancher"
LOGSERVER="$DIRLOG/backup-mysql.log"
ENVIAEMAIL="$DIRLOG/bkp-email.log"

#Bases de dados
DBPROD="rancherprod"
DBHOMOL="rancherhomol"
DBDEV="rancherdev"

#Armazenamento backup das bases
DIRBKP="/rancherbkp-bases"

#Lista de E-mails 
EMAILS="m.christian279@gmail.com"

#Cria Arquivo Para Gravar as Saidas de Execução de Comandos
Prepara_Ambiente(){
    sudo touch $ENVIAEMAIL
}

##Deleta Arquivo Para Gravar as Saidas de Execução de Comandos
Limpa_Ambiente(){
    rm -rf $ENVIAEMAIL
}

Envia_Email(){
   #cat $ENVIAEMAIL | /bin/mutt -s 'Equipe IDP - Backup dos Bancos de Dados Rancher' "$EMAILS" 
   echo "Sucesso!" 
}

#Funcao Execução Rotina Backup
Executa_Bkp(){
echo " " >> $LOGSERVER;
echo "======================== *** Inicio dia $DATA *** ========================" >> $LOGSERVER;
echo "$HORA - Iniciado Backup dos Bancos de Dados Rancher" >> $LOGSERVER; 
echo " " >> $LOGSERVER;
echo "$HORA - Iniciado Backup dos Bancos de Dados Rancher" >> $ENVIAEMAIL;
echo " " >> $ENVIAEMAIL;
    for BKP in $DBPROD $DBHOMOL $DBDEV ; 
        do 
        mysqldump -h $HOST -u $USER -pSENHA $BKP > $DIRBKP/$BKP-$DATA-$HORA.sql
            if [ $? == 0 ]; then
                echo "Backup da Base $BKP Realizado com Sucesso! - $DATA" >> $LOGSERVER;
                echo "Backup da Base $BKP Realizado com Sucesso! - $DATA" >> $ENVIAEMAIL;
            else
                echo "Erro ao Realizar Backup  da Base $BKP - $DATA" >> $LOGSERVER;
                echo "Erro ao Realizar Backup  da Base $BKP - $DATA" >> $ENVIAEMAIL;                
    fi ; done ;
echo " " >> $LOGSERVER;
echo "$HORA - Finalizado Backup Diario dos Bancos de Dados Rancher" >> $LOGSERVER;
echo "========================== ** Fim dia $DATA ** ==========================" >> $LOGSERVER;
echo " " >> $ENVIAEMAIL;
echo "$HORA - Finalizado Backup Diario dos Bancos de Dados Rancher" >> $ENVIAEMAIL;
echo "========================== ** Fim dia $DATA ** ==========================" >> $ENVIAEMAIL
}
 
 #Executa Funcao Preparação do Ambiente
 Prepara_Ambiente;

 #Executa Funcao Rotina Backup
 Executa_Bkp

#Condicao Caso a Funcao Executa_Bkp seja Bem Sucedida
if [ $? == 0 ]; then
    Envia_Email ; sleep 5; Limpa_Ambiente
else
    echo "$HORA - Erro ao Executar Script Rotina de Backup - $DATA" >> $LOGSERVER; 
    echo "$HORA - Erro ao Executar Script Rotina de Backup - $DATA" >> $ENVIAEMAIL
    Envia_Email ; sleep 5; Limpa_Ambiente
fi