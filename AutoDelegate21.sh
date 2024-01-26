#!/bin/bash

# Функція для виводу логотипу
function logo() {
    bash <(curl -s https://raw.githubusercontent.com/CPITMschool/Scripts/main/logo.sh)
}

# Викликаємо функцію для виводу логотипу
logo

function autodelegate() {
    sudo apt update
    sudo apt install -y cron

    echo "export PATH=\$PATH:/root/AUTODELEGATE/" >> ~/.profile
    echo "export PATH=\$PATH:/root/AUTODELEGATE/" >> ~/.bash_profile

    sudo systemctl enable cron.service
    sudo systemctl start cron.service

    mkdir -p /root/AUTODELEGATE/

    # Завантажуємо скрипти з GitHub
    curl -o /root/AUTODELEGATE/DelegLava.sh -fsSL \
        https://github.com/CryptoManUA/auto-delegate-cosmos/raw/main/DelegLava.sh
    curl -o /root/AUTODELEGATE/DelegZeta.sh -fsSL \
        https://github.com/CryptoManUA/auto-delegate-cosmos/raw/main/DelegZeta.sh
    curl -o /root/AUTODELEGATE/DelegDymension.sh -fsSL \
        https://github.com/CryptoManUA/auto-delegate-cosmos/raw/main/DelegDymension.sh

    chmod +x /root/AUTODELEGATE/DelegLava.sh
    chmod +x /root/AUTODELEGATE/DelegZeta.sh
    chmod +x /root/AUTODELEGATE/DelegDymension.sh

    export EDITOR=nano

    bash /root/AUTODELEGATE/DelegLava.sh && sleep 300 && lavad q staking validator $(lavad keys show wallet --bech val -a) | grep -E "tokens" > $HOME/AUTODELEGATE/Lava.txt
    bash /root/AUTODELEGATE/DelegZeta.sh && sleep 300 && zetacored q staking validator $(zetacored keys show wallet --bech val -a) | grep -E "tokens" > $HOME/AUTODELEGATE/Zeta.txt
    bash /root/AUTODELEGATE/DelegDymension.sh && sleep 300 && dymd q staking validator $(dymd keys show wallet --bech val -a) | grep -E "tokens" > $HOME/AUTODELEGATE/Dymension.txt

    # Розклад для подальших запусків та збереження результатів відразу після кожного запуску
    {
        echo "0 */2 * * * bash /root/AUTODELEGATE/DelegLava.sh";
        echo "0 */2 * * * bash /root/AUTODELEGATE/DelegZeta.sh";
        echo "0 */2 * * * bash /root/AUTODELEGATE/DelegDymension.sh";
        echo "0 0 */2 * * lavad q staking validator \$(lavad keys show wallet --bech val -a) | grep -E \"tokens\" > $HOME/AUTODELEGATE/Lava.txt";
        echo "0 0 */2 * * zetacored q staking validator \$(zetacored keys show wallet --bech val -a) | grep -E \"tokens\" > $HOME/AUTODELEGATE/Zeta.txt";
        echo "0 0 */2 * * dymd q staking validator \$(dymd keys show wallet --bech val -a) | grep -E \"tokens\" > $HOME/AUTODELEGATE/Dymension.txt";
    } | crontab -

}

autodelegate
