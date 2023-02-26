source common.sh
component=mongodb

print_header "installing mongodb"
yum install mongodb-org -y &>>${log_file}

print_header "making to listen all ports"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}

systemd_setup
