code_dir=$(pwd)

echo -e "\e[36m Installing nginx \e[0m"
yum install nginx -y
echo -e " \e[36m enabling systemd service \e[0m "
systemctl enable nginx
systemctl start nginx
echo -e " \e[36m removing old code \e[0m "
rm -rvf /usr/share/nginx/html/*
echo -e " \e[36m Downloading new code \e[0m "
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 
echo -e " \e[36m copying code \e[0m "
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e " \e[36m restarting service service \e[0m "
systemctl restart nginx 