#!/bin/bash

function logo() {
    bash <(curl -s https://raw.githubusercontent.com/CPITMschool/Scripts/main/logo.sh)
}

function printGreen {
    echo -e "\e[1m\e[32m${1}\e[0m"
}

function printDelimiter {
    echo "==========================================="
}

clear
logo
printGreen "Встановлення автоматичного делегування токенів нод: Lava, Zetachain, Dymension"
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

# Видалення поточного розкладу
sudo crontab -r

# Додавання розкладу в sudo crontab
sudo sh -c "(echo '
0 */2 * * * sleep 5 && bash /root/AUTODELEGATE/DelegLava.sh
0 */2 * * * sleep 20 && bash /root/AUTODELEGATE/DelegZeta.sh
0 */2 * * * sleep 40 && bash /root/AUTODELEGATE/DelegDymension.sh
0 */1 * * * sleep 10 && /root/go/bin/lavad q staking validator $(/root/go/bin/lavad keys show wallet --bech val -a) | grep -E 'tokens' >> /root/AUTODELEGATE/Lava.txt
0 */1 * * * sleep 30 && /root/go/bin/zetacored q staking validator $(/root/go/bin/zetacored keys show wallet --bech val -a) | grep -E 'tokens' >> /root/AUTODELEGATE/Zeta.txt
0 */1 * * * sleep 50 && /root/go/bin/dymd q staking validator $(/root/go/bin/dymd keys show wallet --bech val -a) | grep -E 'tokens' >> /root/AUTODELEGATE/Dymension.txt
') | crontab -u root -"
 
echo ""
printDelimiter
printGreen "Cron розклад успішно створений."
printGreen "Щоб перевірити роботу скрипта та фактичну кількість токенів заделегованих в вашого валідатора в данний момент - скористайтесь командою:"
printGreen "checkcron"
printGreen "Вивід команди: tokens: значення - дата та час останньго занесення інформації"
printDelimiter
printGreen "Через 10 секунд виконається тестове виконання скрипта:"
sleep 1 && /root/go/bin/lavad q staking validator $(/root/go/bin/lavad keys show wallet --bech val -a) | grep -E "tokens" >> /root/AUTODELEGATE/Lava.txt
sleep 2 && /root/go/bin/zetacored q staking validator $(/root/go/bin/zetacored keys show wallet --bech val -a) | grep -E "tokens" >> /root/AUTODELEGATE/Zeta.txt
sleep 2 && /root/go/bin/dymd q staking validator $(/root/go/bin/dymd keys show wallet --bech val -a) | grep -E "tokens" >> /root/AUTODELEGATE/Dymension.txt
bash <(curl -s https://raw.githubusercontent.com/CheckTest1231/CheckNodes-Delegate/main/checkcron.sh)
exec bash
