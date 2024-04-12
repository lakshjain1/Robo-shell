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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

yum install rabbitmq-server -y &>>$LOGFILE

VALIDATE $? "installed rabbitmq"

systemctl enable rabbitmq-server &>>$LOGFILE

VALIDATE $? "enabled mq"

systemctl start rabbitmq-server &>>$LOGFILE

VALIDATE $? "started MQ"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE

VALIDATE $? "User added"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE

VALIDATE $? "permission given"
