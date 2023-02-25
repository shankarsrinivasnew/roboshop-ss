source common.sh

print_header "Installing nginx"
yum install nginx -y &>>${log_file}
status_check $?

print_header "enabling service"
systemctl enable nginx &>>${log_file}
systemctl start nginx &>>${log_file}
status_check $?

print_header "Removing old code"
rm -rvf /usr/share/nginx/html/* &>>${log_file}
status_check $?

print_header "downloading new code"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>${log_file}
status_check $?

print_header "copying new code"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip  &>>${log_file}
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status_check $?

print_header "restarting nginx"
systemctl restart nginx &>>${log_file}
status_check $?