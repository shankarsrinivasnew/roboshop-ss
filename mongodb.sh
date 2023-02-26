source common.sh
component=mongodb

print_header "Setup MongoDB repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_header "installing mongodb"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_header "Update MongoDB Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
status_check $?

print_header "Enable MongoDB"
systemctl enable mongod &>>${log_file}
status_check $?

print_header "Start MongoDB Service"
systemctl restart mongod &>>${log_file}
status_check $?
