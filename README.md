# my_ubuntu

sudo apt-get install language-pack-PL 
sudo a2enmod rewrite
sudo a2enmod userdir
sudo a2enmod headers
systemctl restart apache2

# WSL problem with CHOWN
sudo umount /mnt/c
sudo mount -t drvfs C: /mnt/c -o metadata
