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

yum install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "install python"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "downloaded payment"

cd /app &>>$LOGFILE

VALIDATE $? "change dir"

unzip /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "unzip payment"

cd /app  &>>$LOGFILE

VALIDATE $? "switch dir"

pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "Installed requiredments"

cp /home/centos/Robo-shell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE

VALIDATE $? "copied payment"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "system reload"

systemctl enable payment &>>$LOGFILE

VALIDATE $? "enabled service"

systemctl start payment &>>$LOGFILE

VALIDATE $? "start service"