#!/bin/bash

function logo() {
    bash <(curl -s https://raw.githubusercontent.com/CPITMschool/Scripts/main/logo.sh)
}

logo

sudo apt update
sudo apt install -y cron
sudo apt install -y language-pack-uk

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

{
  echo "LC_TIME=uk_UA.UTF-8"
  echo "0 */2 * * * sleep 5 && bash /root/AUTODELEGATE/DelegLava.sh"
  echo "0 */2 * * * sleep 20 && bash /root/AUTODELEGATE/DelegZeta.sh"
  echo "0 */2 * * * sleep 40 && bash /root/AUTODELEGATE/DelegDymension.sh"
  echo "0 */2 * * * LC_TIME=uk_UA.UTF-8 /root/go/bin/lavad q staking validator \$(/root/go/bin/lavad keys show wallet --bech val -a) | grep -E \"tokens\" | while IFS= read -r line; do echo \"tokens: \$line - \$(LC_TIME=uk_UA.UTF-8 date '+%Y-%m-%d %H:%M:%S')\"; done >> /root/AUTODELEGATE/Lava.txt"
  echo "0 */2 * * * LC_TIME=uk_UA.UTF-8 /root/go/bin/zetacored q staking validator \$(/root/go/bin/zetacored keys show wallet --bech val -a) | grep -E \"tokens\" | while IFS= read -r line; do echo \"tokens: \$line - \$(LC_TIME=uk_UA.UTF-8 date '+%Y-%m-%d %H:%M:%S')\"; done >> /root/AUTODELEGATE/Zeta.txt"
  echo "0 */2 * * * LC_TIME=uk_UA.UTF-8 /root/go/bin/dymd q staking validator \$(/root/go/bin/dymd keys show wallet --bech val -a) | grep -E \"tokens\" | while IFS= read -r line; do echo \"tokens: \$line - \$(LC_TIME=uk_UA.UTF-8 date '+%Y-%m-%d %H:%M:%S')\"; done >> /root/AUTODELEGATE/Dymension.txt"
} | crontab -

echo 'alias checkcron="bash <(curl -s https://raw.githubusercontent.com/CheckTest1231/CheckNodes-Delegate/main/checkcron.sh)"' >> ~/.bashrc
source ~/.bashrc
echo ""
printGreen "Cron розклад успішно створений."
