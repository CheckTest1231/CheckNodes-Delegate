#!/bin/bash

function logo() {
    bash <(curl -s https://raw.githubusercontent.com/CPITMschool/Scripts/main/logo.sh)
}

logo

sudo apt update

sudo apt install cron

echo "export PATH=\$PATH:/root/AUTODELEGATE/" >> ~/.profile
echo "export PATH=\$PATH:/root/AUTODELEGATE/" >> ~/.bash_profile

sudo systemctl enable cron.service
sudo systemctl start cron.service

mkdir -p /root/AUTODELEGATE/

wget -P /root/AUTODELEGATE/ -N \
	https://github.com/CryptoManUA/auto-delegate-cosmos/raw/main/DelegLava.sh
wget -P /root/AUTODELEGATE/ -N \
 	https://github.com/CryptoManUA/auto-delegate-cosmos/raw/main/DelegZeta.sh
wget -P /root/AUTODELEGATE/ -N \
 	https://github.com/CryptoManUA/auto-delegate-cosmos/raw/main/DelegDymension.sh

sudo crontab -e

echo "0 */2 * * * sleep 5 && bash /root/AUTODELEGATE/DelegLava.sh" | sudo tee -a /etc/crontab
echo "0 */2 * * * sleep 20 && bash /root/AUTODELEGATE/DelegZeta.sh" | sudo tee -a /etc/crontab
echo "0 */2 * * * sleep 40 && bash /root/AUTODELEGATE/DelegDymension.sh" | sudo tee -a /etc/crontab
