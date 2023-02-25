source common.sh

print_header "downloading code"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_header "installing package"
yum install nodejs -y &>>${log_file}
status_check $?

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
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${log_file}
status_check $?

print_header "creating new directory"
cd /app
status_check $?

print_header "unzipping new code"
unzip /tmp/catalogue.zip &>>${log_file}
cd /app
status_check $?

print_header "installing new code"
npm install &>>${log_file}
status_check $?

print_header "copying old code"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_header "restarting service"
systemctl daemon-reload &>>${log_file}
systemctl enable catalogue &>>${log_file}
systemctl restart catalogue &>>${log_file}
status_check $?

print_header "loading mogo repositories"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_header "loading schema"
mongo --host mongodb.sstech.store </app/schema/catalogue.js &>>${log_file}
status_check $?