source common.sh

print_header "Installing ngindd"
yum install nginx -y &>>/tmp/roboshop.log
status_check $?

print_header "enabling service"
systemctl enable nginx &>>/tmp/roboshop.log
systemctl start nginx &>>/tmp/roboshop.log
status_check $?

print_header "Removing old code"
rm -rvf /usr/share/nginx/html/* &>>/tmp/roboshop.log
status_check $?

print_header "downloading new code"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>/tmp/roboshop.log
status_check $?

print_header "copying new code"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip  &>>/tmp/roboshop.log
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/roboshop.log
status_check $?

print_header "restarting nginx"
systemctl restart nginx &>>/tmp/roboshop.log
status_check $?