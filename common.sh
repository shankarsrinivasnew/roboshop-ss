code_dir=$(pwd)

tmp_dir=/tmp/roboshop.log

print_header () {
    echo -e "\e[35m$1\e[0m "
}

status_check () {
if [ $1 -eq 0 ]; then
    echo "success"
else
    echo "failed"
    exit
fi
}