# my_ubuntu

```
sudo apt-get install language-pack-PL 
sudo apt-get install ubuntu-restricted-extras
sudo a2enmod rewrite
sudo a2enmod userdir
sudo a2enmod headers
sudo vi /etc/apache2/mods-enabled/userdir.conf
systemctl restart apache2
```

# WSL problem with CHOWN
https://devblogs.microsoft.com/commandline/automatically-configuring-wsl/
```
sudo umount /mnt/c
sudo mount -t drvfs C: /mnt/c -o metadata
```
# fstab
```
/dev/sdb1 /pg ext4 defaults 0 0
```

## tileserver
https://medium.com/@mojodna/tapalcatl-cloud-optimized-tile-archives-1db8d4577d92
https://switch2osm.org/


## others
File transfer calculator https://techinternets.com/copy_calc
