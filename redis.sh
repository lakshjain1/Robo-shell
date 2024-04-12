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


yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> &>>$LOGFILE 

VALIDATE $? "Install Repo"

yum module enable redis:remi-6.2 -y &>>$LOGFILE 

VALIDATE $? "installed Redis"

yum install redis -y &>>$LOGFILE 

VALIDATE $? "installed Redis"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE

VALIDATE $? "change security"

systemctl enable redis &>>$LOGFILE

VALIDATE $? "enabled redis"

systemctl start redis &>>$LOGFILE

VALIDATE $? "started redis"