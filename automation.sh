sudo apt update -y

echo "Check if apache2 is installed"
pkg="apache2"
if dpkg -s  $pkg
then
    echo "$pkg installed"
else
    echo "$pkg NOT installed"
    sudo apt install $pkg
fi
#dpkg -s apache2
echo "Check if apache2 is enabled"
if systemctl status $pkg
then
    echo "$pkg is running"
else
    systemctl start $pkg
    systemctl enable $pkg
fi

echo "create tar file for logs"

timestamp=$(date '+%d%m%Y-%H%M%S')
name="Aishwarya"
file="$name-httpd-logs-$timestamp"


    tar -cvf $file.tar /var/log/apache2/*.log
    mv $file.tar /tmp/


s3_bucket="upgrad-aishwarya"
aws s3 \
cp /tmp/$name-httpd-logs-$timestamp.tar \
s3://$s3_bucket/$name-httpd-logs-$timestamp.tar
