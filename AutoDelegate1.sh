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


chmod +x /root/AUTODELEGATE/DelegLava.sh
chmod +x /root/AUTODELEGATE/DelegZeta.sh
chmod +x /root/AUTODELEGATE/DelegDymension.sh

export EDITOR=nano


if [ ! -f /root/AUTODELEGATE/first_run_completed ]; then
    
    bash /root/AUTODELEGATE/DelegLava.sh
    bash /root/AUTODELEGATE/DelegZeta.sh
    bash /root/AUTODELEGATE/DelegDymension.sh

    
    touch /root/AUTODELEGATE/first_run_completed
fi

{ echo "0 */2 * * * bash /root/AUTODELEGATE/DelegLava.sh"; echo "0 */2 * * * sleep 15 && bash /root/AUTODELEGATE/DelegZeta.sh"; echo "0 */2 * * * sleep 30 && bash /root/AUTODELEGATE/DelegDymension.sh"; } | sudo crontab -
