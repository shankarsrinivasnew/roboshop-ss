code_dir=$(pwd)

log_file=/tmp/roboshop.log

print_header () {
    echo -e "\e[35m$1\e[0m "
}

status_check () {
if [ $1 -eq 0 ]; then
    echo "success"
else
    echo "failed"
    exit 1
fi
}

app_user_setup () {
print_header "adding user"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
useradd roboshop &>>${log_file}
fi
status_check $?

print_header "adding new directory"
if [ ! -d /app ]; then
mkdir /app &>>${log_file}
fi
status_check $?

print_header "removing old content"
rm -rvf /app/* &>>${log_file}
status_check $?

print_header "downloading new code"
curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip  &>>${log_file}
status_check $?

print_header "unzipping new code"
unzip /tmp/$component.zip &>>${log_file}
cd /app
status_check $?
}

schema_setup () {

if [ "${schema_type}" == "mongo" ]; then

print_header "loading mogo repositories"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_header "loading schema"
mongo --host mongodb.sstech.store </app/schema/$component.js &>>${log_file}
status_check $?

elif [ "${schema_type}" == "mysql" ]; then

print_header "installing mysql"
yum install mysql -y &>>${log_file}
status_check $?

print_header "loading mysql schema"
mysql -h mysql.sstech.store -uroot -p${mysql_root_password} < /app/schema/$component.sql &>>${log_file}
status_check $?
fi
}



systemd_setup () {
print_header "adding systemd file"
cp {code_dir}/configs/$component.service /etc/systemd/system/$component.service  &>>${log_file}
status_check $?

print_header "starting systemd service of app"
systemctl daemon-reload  &>>${log_file}
systemctl enable $component  &>>${log_file}
systemctl restart $component  &>>${log_file}
status_check $?

}

nodejs () {

print_header "downloading code"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_header "installing package"
yum install nodejs -y &>>${log_file}
status_check $?

app_user_setup

print_header "installing new code"
npm install &>>${log_file}
status_check $?

print_header "copying old code"
cp ${code_dir}/configs/$component.service /etc/systemd/system/$component.service &>>${log_file}
status_check $?

schema_setup

systemd_setup

}

java (){
print_header "Installing maven "
yum install maven -y  &>>${log_file}
status_check $?

app_user_setup

print_header "installing dependencies"
mvn clean package   &>>${log_file}
mv target/$component-1.0.jar $component.jar  &>>${log_file}
status_check $?

schema_setup
systemd_setup

}

