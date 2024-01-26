#!/bin/bash

function logo() {
    bash <(curl -s https://raw.githubusercontent.com/CPITMschool/Scripts/main/logo.sh)
}

logo

sudo apt update
sudo apt install -y cron

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

export EDITOR=nano

if [ -z "$(sudo crontab -l)" ]; then
    echo "0 */2 * * * sleep 5 && bash /root/AUTODELEGATE/DelegLava.sh" | sudo crontab -
    echo "0 */2 * * * sleep 20 && bash /root/AUTODELEGATE/DelegZeta.sh" | sudo crontab -
    echo "0 */2 * * * sleep 40 && bash /root/AUTODELEGATE/DelegDymension.sh" | sudo crontab -
else
    { sudo crontab -l; echo "0 */2 * * * sleep 5 && bash /root/AUTODELEGATE/DelegLava.sh"; echo "0 */2 * * * sleep 20 && bash /root/AUTODELEGATE/DelegZeta.sh"; echo "0 */2 * * * sleep 40 && bash /root/AUTODELEGATE/DelegDymension.sh"; } | sudo crontab -
fi
