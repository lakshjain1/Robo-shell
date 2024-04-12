#!/bin/bash

DATE=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$0
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"


if [ $USERID -ne 0 ] 
then
    echo -e "$R ERROR:Please run this script with root user $N"
    exit 1
#else
#    echo " you are root user"
fi


VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R Error $2 $N"
        exit 1
    else
        echo -e "$G Success $2 $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "NODEJS"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "installed Nodejs" 

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "downloaded Catalogue"

cd /app &>>$LOGFILE

unzip /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "unzip Catalogue"

cd /app &>>$LOGFILE

npm install &>>$LOGFILE

VALIDATE $? "installed npm Catalogue"

cp /home/centos/Robo-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "copied Catalogue" 

systemctl daemon-reload &>>$LOGFILE

systemctl enable catalogue &>>$LOGFILE

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "enabled and started"

cp /home/centos/Robo-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "copied mongo.repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Installed mongo-shell"

mongo --host mongodb.laksh.site </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "mongo Ip registered"