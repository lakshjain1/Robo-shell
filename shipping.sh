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

yum install maven -y &>>$LOGFILE

VALIDATE $? "installed maven"

useradd roboshop &>>$LOGFILE

VALIDATE $? "created user"

mkdir /app &>>$LOGFILE

VALIDATE $? "make dir"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "downloaded shipping"

cd /app &>>$LOGFILE

VALIDATE $? "changed dir"

unzip /tmp/shipping.zip &>>$LOGFILE

VALIDATE $? "unzip shipping"

cd /app &>>$LOGFILE

VALIDATE $? "move to dir"

mvn clean package &>>$LOGFILE

VALIDATE $? "run maven"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE

VALIDATE $? "Moving jar file"

cp /home/centos/Robo-shell/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

VALIDATE $? "Copied Shipping"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "System reloaded"

systemctl enable shipping &>>$LOGFILE

VALIDATE $? "enabled shipping"

systemctl start shipping &>>$LOGFILE

VALIDATE $? "Started shipping"

yum install mysql -y &>>$LOGFILE

VALIDATE $? "Installed SQL"

mysql -h mysql.laksh.site -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE

VALIDATE $? "Updated SQL"

systemctl restart shipping &>>$LOGFILE

VALIDATE $? "Restart Shipping"