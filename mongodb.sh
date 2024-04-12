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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copied"

yum install mongodb-org -y &>>$LOGFILE

VALIDATE $? "Installed mongo"

systemctl enable mongod | systemctl start mongod &>>$LOGFILE

VALIDATE $? "Enabled and Started"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>>$LOGFILE

VALIDATE $? "Mongo Config"

systemctl restart mongod &>>$LOGFILE

VALIDATE $? "restarted Mongo"