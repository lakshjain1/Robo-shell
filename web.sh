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

yum install nginx -y &>>$LOGFILE

VALIDATE $?

systemctl enable nginx &>>$LOGFILE

VALIDATE $?

systemctl start nginx &>>$LOGFILE

VALIDATE $?

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $?

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE

VALIDATE $?

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $?

unzip /tmp/web.zip &>>$LOGFILE

VALIDATE $?

cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE

VALIDATE $?