sudo apt update -y

echo "Check if apache2 is installed"

############# Check if apache2 is installed#####################
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

########### Check if apache2 is enabled #################################
if systemctl status $pkg
then
    echo "$pkg is running"
else
    systemctl start $pkg
    systemctl enable $pkg
fi

echo "create tar file for logs"
###############Create tar ###################

timestamp=$(date '+%d%m%Y-%H%M%S')
name="Aishwarya"
file="$name-httpd-logs-$timestamp"


    tar -cvf $file.tar /var/log/apache2/*.log
    mv $file.tar /tmp/

############### Upload to S3 ####################################
s3_bucket="upgrad-aishwarya"
aws s3 \
cp /tmp/$name-httpd-logs-$timestamp.tar \
s3://$s3_bucket/$name-httpd-logs-$timestamp.tar


#################### Here Task 2 Ends_Automation-v0.1 ############################################

#################### Task 3 ####################################################

# 4 - Updating the Inventory file with the latest log backup.


if [ -f "/var/www/html/inventory.html" ]; 
then
	
	printf "<p>" >> /var/www/html/inventory.html
	printf "\n\t$(ls -lrth /tmp | grep httpd | cut -d ' ' -f 10 | cut -d '-' -f 2,3 | tail -1)" >> /var/www/html/inventory.html
	printf "\t\t$(ls -lrth /tmp | grep httpd | cut -d ' ' -f 10 | cut -d '-' -f 4,5 | cut -d '.' -f 1 | tail -1)" >> /var/www/html/inventory.html
	printf "\t\t\t $(ls -lrth /tmp | grep httpd | cut -d ' ' -f 10 | cut -d '-' -f 4,5 | cut -d '.' -f 2 | tail -1 )" >> /var/www/html/inventory.html
	printf "\t\t\t\t$(ls -lrth /tmp/ | grep httpd | cut -d ' ' -f 6 | tail -1)" >> /var/www/html/inventory.html
	printf "</p>" >> /var/www/html/inventory.html
	
else 
	touch /var/www/html/inventory.html
	printf "<p>" >> /var/www/html/inventory.html
	printf "\tLog-Type\tDate-Created\tType\tSize" >> /var/www/html/inventory.html
	printf "</p>" >> /var/www/html/inventory.html
	printf "<p>" >> /var/www/html/inventory.html
	printf "\n\t$(ls -lrth /tmp | grep httpd | cut -d ' ' -f 10 | cut -d '-' -f 2,3 | tail -1)" >> /var/www/html/inventory.html
	printf "\t\t$(ls -lrth /tmp | grep httpd | cut -d ' ' -f 10 | cut -d '-' -f 4,5 | cut -d '.' -f 1 | tail -1)" >> /var/www/html/inventory.html
	printf "\t\t\t $(ls -lrth /tmp | grep httpd | cut -d ' ' -f 10 | cut -d '-' -f 4,5 | cut -d '.' -f 2 | tail -1)" >> /var/www/html/inventory.html
	printf "\t\t\t\t$(ls -lrth /tmp/ | grep httpd | cut -d ' ' -f 6 |tail -1)" >> /var/www/html/inventory.html
	printf "</p>" >> /var/www/html/inventory.html
	
fi


# 5 - Scheduling cronjob for Daily running of automation script

if [ -f "/etc/cron.d/automation" ];
then
	echo "Automation script in place for Daily 00:00 hrs"
else
	touch /etc/cron.d/automation
	printf "0 0 * * * root /root/Automation_Project/auotmation.sh" > /etc/cron.d/automation
fi

####################### Here Task 3 Ends_Automation-v0.2 ###################################################