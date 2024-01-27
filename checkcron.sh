#!/bin/bash

function printGreen {
  echo -e "\e[1m\e[32m${1}\e[0m"
}

echo ""
printGreen "Останні 15 записів файлу Lava.txt"
tail -n 10 $HOME/AUTODELEGATE/Lava.txt
echo ""
printGreen "Останні 15 записів файлу Zeta.txt"
tail -n 10 $HOME/AUTODELEGATE/Zeta.txt
echo ""
printGreen "Останні 15 записів файлу Dymension.txt"
tail -n 10 $HOME/AUTODELEGATE/Dymension.txt
echo ""
