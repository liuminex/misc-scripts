rmapkg () {
  sudo dpkg --remove --force-remove-reinstreq $1
  sudo dpkg --purge $1
  sudo dpkg -P --force-all $1
  sudo service mysqld start
  sudo dpkg -r --force-all $1
}
rmpckges () {
  sudo systemctl stop ${1}.service
  sudo kill $(pgrep ${1})
  sudo service $1 stop
  sudo systemctl stop $1
  sudo apt-get remove --purge ${1}-\*
  sudo rm -rf ./$1-*
  sudo apt purge ${1}-server ${1}-client ${1}-common ${1}-server-core-* ${1}-client-core-*
  sudo rm -rf /etc/$1 /var/lib/$1 /var/log/$1
  sudo killall -KILL ${1} ${1}d_safe mysqld
  sudo apt-get --yes purge ${1}-server ${1}-client
  sudo apt-get --yes autoremove --purge
  sudo apt-get autoclean
  sudo deluser --remove-home ${1}
  sudo delgroup ${1}
  sudo rm -rf /etc/apparmor.d/abstractions/${1} /etc/apparmor.d/cache/usr.sbin.${1}d /etc/${1} /var/lib/${1} /var/log/${1}* /var/log/upstart/${1}.log* /var/run/${1}d
  sudo apt remove --purge --autoremove ${1}-server
  dpkg -l | awk  '{print $2}' | grep -i $1 | grep -v lib
  sudo dpkg -P  --force-all $(dpkg -l | awk  '{print $2}' | grep -i $1 | grep -v lib)
}

rmpckges mysql
rmpckges mariadb

sudo updatedb
sudo apt autoremove
sudo apt autoclean

#manually type the packages you see from the command dpkg -l | grep -i [mysql or mariadb]
rmapkg mysql-server-core-8.0
rmapkg mysql-server-8.0
rmapkg mysql-client-8.0
rmapkg mysql-client-core-8.0
rmapkg mysql-common
rmapkg mariadb-common
rmapkg mariadb-client-10.3
rmapkg mariadb-server-10.3

echo "finished, confirm:"
dpkg -l | grep -i mysql
dpkg -l | grep -i mariadb
