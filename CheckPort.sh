User
#!/bin/bash


printGreen() {
  echo -e "\e[32m$1\e[0m"
}

function printDelimiter {
  echo "==========================================="
}

printGreen "sudo lsof -i:26657"
sudo lsof -i:26657

printGreen "sudo lsof -i:27657"
sudo lsof -i:27657

printGreen "sudo lsof -i:28657"
sudo lsof -i:28657

printGreen "sudo lsof -i:29657"
sudo lsof -i:29657

printGreen "sudo lsof -i:30657"
sudo lsof -i:30657

printGreen "sudo lsof -i:31657"
sudo lsof -i:31657

printGreen "sudo lsof -i:32657"
sudo lsof -i:32657

printGreen "sudo lsof -i:33657"
sudo lsof -i:33657

printGreen "sudo lsof -i:34657"
sudo lsof -i:34657

printGreen "sudo lsof -i:35657"
sudo lsof -i:35657

printGreen "sudo lsof -i:36657"
sudo lsof -i:36657

printGreen "sudo lsof -i:36657"
sudo lsof -i:36657

