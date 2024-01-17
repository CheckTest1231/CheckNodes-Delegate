User
#!/bin/bash

# Функция для вывода зеленого текста
printGreen() {
  echo -e "\e[32m$1\e[0m"
}

function printDelimiter {
  echo "==========================================="
}

# Функция для проверки ноды и вывода журнала логов
checkNode() {
  node_name=$1
  node_command=$2
  echo ""
  printDelimiter
  printGreen "Журнал логів ноди: $node_name"
  printDelimiter
  echo ""

  # Запускаем команду для проверки ноды и ждем 5 секунд
  timeout 5 sudo journalctl -u $node_command -f -o cat
}

# Проверка ноды Lava
checkNode "Lava" "lava"

# Проверка ноды Zetachain
checkNode "Zetachain" "zetacored"

# Проверка ноды Babylond
checkNode "Babylond" "babylond"

# Проверка ноды Dymension
checkNode "Dymension" "dymd"
