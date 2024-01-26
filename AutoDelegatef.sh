#!/bin/bash

# Функція для виводу логотипу
function logo() {
    bash <(curl -s https://raw.githubusercontent.com/CPITMschool/Scripts/main/logo.sh)
}

# Викликаємо функцію для виводу логотипу
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

# Перевіряємо, чи скрипт вже був запущений
if [ ! -f /root/AUTODELEGATE/first_run_completed ]; then
    # Якщо не був, запускаємо всі три скрипти та записуємо дані при першому запуску
    bash /root/AUTODELEGATE/DelegLava.sh && sleep 300 && lavad q staking validator $(lavad keys show wallet --bech val -a) | grep -E "tokens" > /root/AUTODELEGATE/Lava.txt
    bash /root/AUTODELEGATE/DelegZeta.sh && sleep 300 && zetacored q staking validator $(zetacored keys show wallet --bech val -a) | grep -E "tokens" > /root/AUTODELEGATE/Zeta.txt
    bash /root/AUTODELEGATE/DelegDymension.sh && sleep 300 && dymd q staking validator $(dymd keys show wallet --bech val -a) | grep -E "tokens" > /root/AUTODELEGATE/Dymension.txt

    # Встановлюємо флаг, що перший запуск відбувся
    touch /root/AUTODELEGATE/first_run_completed
fi

# Розклад для подальших запусків та збереження результатів відразу після кожного запуску
{ echo "0 */2 * * * bash /root/AUTODELEGATE/DelegLava.sh"; \
  echo "0 */2 * * * bash /root/AUTODELEGATE/DelegZeta.sh"; \
  echo "0 */2 * * * bash /root/AUTODELEGATE/DelegDymension.sh"; \
  echo "0 0 * * * sleep 300 && grep -E \"tokens\" /root/AUTODELEGATE/Lava.txt > /root/AUTODELEGATE/Lava_daily.txt"; \
  echo "0 0 * * * sleep 300 && grep -E \"tokens\" /root/AUTODELEGATE/Zeta.txt > /root/AUTODELEGATE/Zeta_daily.txt"; \
  echo "0 0 * * * sleep 300 && grep -E \"tokens\" /root/AUTODELEGATE/Dymension.txt > /root/AUTODELEGATE/Dymension_daily.txt"; } | sudo crontab -
