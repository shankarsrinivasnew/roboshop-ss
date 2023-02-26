source common.sh

rabbitmq_password=$1

if [ -z "${rabbitmq_password}" ]; then
echo -e "\e[31mMisiing rabbit password\e[0m"
exit 1
fi

print_header "downloading repo code"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>{log_file}
status_check $?

print_header "installing erlang"
yum install erlang -y &>>{log_file}
status_check $?

print_header "downloading app code"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>{log_file}
status_check $?

print_header "installing rabbitmq"
yum install rabbitmq-server -y &>>{log_file}
status_check $?

print_header "starting rabbitmq server"
systemctl enable rabbitmq-server &>>{log_file}
systemctl start rabbitmq-server  &>>{log_file}
status_check $?

print_header "adding user and setting permissions"
rabbitmqctl list_users |grep roboshop & >>{log_file}
if [ $? -ne 0 ]; then
rabbitmqctl add_user roboshop ${rabbitmq_password} &>>{log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>{log_file}
fi
status_check $?


