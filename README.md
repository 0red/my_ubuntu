# my_ubuntu

```bash
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
```bash
sudo umount /mnt/c
sudo mount -t drvfs C: /mnt/c -o metadata
```
# fstab
```bash
/dev/sdb1 /pg ext4 defaults 0 0
```

## tileserver
https://medium.com/@mojodna/tapalcatl-cloud-optimized-tile-archives-1db8d4577d92
https://switch2osm.org/


## others
File transfer calculator https://techinternets.com/copy_calc

## grup show on start

For permanent change you'll need to edit your /etc/default/grub file -- place a "#" symbol at the start of line GRUB_HIDDEN_TIMEOUT=0.

sudo update-grub

## missing eth0

```bash 
lshw -c network
``` 

```bash 
$ sudo nano /etc/netplan/01-network-manager-all.yaml
``` 
Then add the following lines by replacing the interface name with your system’s network interface.

``` 
network:
 version: 2
 renderer: NetworkManager
 ethernets:
  ens33:
   dhcp4: yes
   addresses: []
```    
```
# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    version: 2
    ethernets:
        eth0:
            dhcp4: true
            match:
                macaddress: b8:27:eb:da:e5:ea
            set-name: eth0
```   
```bash
network:
    version: 2
    ethernets:
        ens32:
            dhcp4: true
```   
   
   
Once done, save and close the file.

Now test the new configuration using the following command:

```bash 
$ sudo netplan try
``` 
If it validates the configuration, you will receive the configuration accepted message, otherwise, it rolls back to the previous configuration.

Next, run the following command to apply the new configurations.

```bash 
$ sudo netplan apply
``` 
