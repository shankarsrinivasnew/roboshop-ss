source common.sh

print_header "disabling exiting  mysql"
dnf module disable mysql -y  &>>${log_file}
status_check $?

print_header "loading mysql repositories"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo  &>>${log_file}
status_check $?

print_header "installing mysql"
yum install mysql-community-server -y  &>>${log_file}
status_check $?

print_header "starting mysql server"
systemctl enable mysqld  &>>${log_file}
systemctl start mysqld  &>>${log_file}
status_check $?

mysql_root_password=$1

print_header "setting root password mysql"
echo show databases | mysql -uroot -p${mysql_root_password}  &>>${log_file}
if [ $? -ne 0 ]; then
mysql_secure_installation --set-root-pass ${mysql_root_password}  &>>${log_file}
fi
status_check $?




