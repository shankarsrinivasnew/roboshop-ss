source common.sh src

print_header "downloading nodejs"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>{log_file}
status_check $?

print_header "Installing nodejs"
yum install nodejs -y &>>{log_file}
status_check $?

print_header "adding user"
id roboshop &>>{log_file}
if [ $? -ne 0 ]; then
useradd roboshop &>>{log_file}
fi
status_check $?

print_header "adding new directory"
if [ ! -d /app ]; then
mkdir /app &>>{log_file}
fi
status_check $?

print_header "downlading new code and unzip files"
rm -rvf /app/* &>>{log_file}
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>{log_file}
cd /app &>>{log_file}
unzip /tmp/user.zip &>>{log_file}
status_check $?

print_header "downloading dependencies"
cd /app &>>{log_file}
npm install  &>>{log_file}
status_check $?

print_header "copyig systemd files"
copy ${code_dir}/configs/user.service /etc/systemd/system/user.service  &>>{log_file}
status_check $?

print_header "starting user service"
systemctl daemon-reload  &>>{log_file}
systemctl enable user   &>>{log_file}
systemctl start user  &>>{log_file}
status_check $?

print_header "loading yum repositories"
copy ${code_dir}/mongodb.repo /etc/yum.repos.d/mongo.repo &>>{log_file}
status_check $?

print_header "installing mongodb"
yum install mongodb-org-shell -y &>>{log_file}
status_check $?

print_header "installing schema"
mongo --host mongodb.sstech.store </app/schema/user.js &>>{log_file}
status_check $?







