source common.sh

print_header "downloading code"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log
status_check $?

print_header "installing package"
yum install nodejs -y &>>/tmp/roboshop.log
status_check $?

print_header "adding user"
id roboshop
if [$? -ne 0]; then
useradd roboshop &>>/tmp/roboshop.log
fi
status_check $?

print_header "adding new directory"
mkdir /app &>>/tmp/roboshop.log
status_check $?

print_header "removing old content"
rm -rvf /app/* &>>/tmp/roboshop.log
status_check $?

print_header "downloading new code"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>/tmp/roboshop.log
status_check $?

print_header "creating new directory"
cd /app
status_check $?

print_header "unzipping new code"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app
status_check $?

print_header "installing new code"
npm install &>>/tmp/roboshop.log
status_check $?

print_header "copying old code"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log
status_check $?

print_header "restarting service"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log
status_check $?

print_header "loading mogo repositories"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log
yum install mongodb-org-shell -y &>>/tmp/roboshop.log
status_check $?

print_header "loading schema"
mongo --host mongodb.sstech.store </app/schema/catalogue.js &>>/tmp/roboshop.log
status_check $?