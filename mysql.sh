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

yum module disable mysql -y &>> $LOGFILE

VALIDATE $? "Disabling the default version"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE

VALIDATE $? "Copying MySQL repo" 

yum install mysql-community-server -y &>> $LOGFILE

VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>> $LOGFILE

VALIDATE $? "Enabling MySQL"

systemctl start mysqld &>> $LOGFILE

VALIDATE $? "Staring MySQL"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VALIDATE $? "setting up root password"