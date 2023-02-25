source common.sh

print_header "Installing Redis Repo files"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_header "Enable 6.2 redis repo"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_header "Install Redis"
yum install redis -y  &>>${log_file}
status_check $?

print_header "Update Redis Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?

print_header "Enable Redis"
systemctl enable redis &>>${log_file}
status_check $?

print_header "Start Redis"
systemctl restart redis &>>${log_file}
status_check $?