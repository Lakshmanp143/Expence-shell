#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGS_FOLDER="/var/log/expenseshell-logs"
LOGS_FILE=$(echo $0 | cut -d "." -f1 )
LOGS_FILE_NAME="$LOGS_FOLDER/$LOGS_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ..... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ..... $G SUCCESS $N"
    fi    
}

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo " You need be root user to execute this script"
        exit 1
    fi
}
echo "Script started executing at: $TIMESTAMP " &>>$LOGS_FILE_NAME
CHECK_ROOT  

dnf install mysql-server -y  &>>$LOGS_FILE_NAME
VALIDATE @? "istalling mysql-server"

systemctl enable mysqld  &>>$LOGS_FILE_NAME
VALIDATE $? "Enabling mysqld serveice"

systemctl start mysqld  &>>$LOGS_FILE_NAME
VALIDATE $? "Starting mysqld service"

#mysql -h mysql.lakshman.site -u root -pExpense@App1 -e 'show databases;' &>>$LOGS_FILE_NAME
#if [ $? -ne o ]; then
#   echo "mysql root password not setup" &>>$LOGS_FILE_NAME

mysql_secure_installation --set -root -pass Expense@App1  &>>$LOGS_FILE_NAME
VALIDATE $? "Setting root password"