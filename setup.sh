#!/usr/bin/bash

# source https://raw.githubusercontent.com/learn-co-curriculum/flatiron-manual-setup-validator/master/wsl-phase-0-manual-setup-validator-with-py.sh

# Define colors
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

# Function to install a package using apt-get
install_package() {
  sudo apt-get install -y "$1"
}

# Function to check if a command is available
is_command_available() {
  command -v "$1" >/dev/null 2>&1
}

# Function to evaluate a test
evaluate_test () {
  eval "$1" && printf "${GREEN}pass${NC}\n" || printf "${RED}fail${NC}\n"
}

# Function to evaluate a command
evaluate () {
  eval "$1"
}

# Function to print test results in a table format
print_table_results () {
  local result=$(evaluate_test "$2")
  printf "%-30s => [ %-6s ]\n" "$1" "$result"
}

# Function to print data row
print_data_row () {
  local result=$(evaluate "$2")
  printf "%-12s => [ %-6s ]\n" "$1" "$result"
}

# Function to print delimiter
delimiter () {
  printf "${BLUE}******************************************${NC}\n"
}

# Function to print validation header
validation_header () {
  printf "\n${CYAN}************ VALIDATING SETUP ************${NC}\n\n"
}

# Function to print configuration header
configuration_header () {
  printf "\n${CYAN}************* CONFIGURATION **************${NC}\n\n"
}

# Validation
validation_header
delimiter

# Check and install VS Code
if ! is_command_available "code"; then
  install_package "code"
fi
print_table_results "Installed VSCode" "command -v code >/dev/null 2>&1 && code -v | grep -q '1.'"

# Check and install NVM
if ! is_command_available "nvm"; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  . ~/.nvm/nvm.sh
fi
print_table_results "Installed NVM" "command -v nvm >/dev/null 2>&1 && nvm --version | grep -q '[0-9]*\.[0-9]*\.[0-9]*'"

# Check and install Node
if ! is_command_available "node"; then
  nvm install node
fi
print_table_results "Installed Node" "command -v node >/dev/null 2>&1 && node -v | grep -q 'v'"
print_table_results "Default Node (>11.x)" 'command -v nvm >/dev/null 2>&1 && nvm version default | grep -q "v11\|v12\|v13\|v14\|v15\|v16\|v17\|v18\|v19\|v20"'

# Check and install Python
if ! is_command_available "python3"; then
  install_package "python3"
fi
print_table_results "Installed Python3" "command -v python3 | grep -q 'python3'"
print_table_results "Default Python (>=3)" "command -v python3 >/dev/null 2>&1 && python3 -V | grep -Fq 'Python 3.'"

# Check and install git
if ! is_command_available "git"; then
  install_package "git"
fi
if ! git config --list | grep -q 'user.name='; then
  echo "Git global configuration not found. Please enter your name:"
  read user_name
  git config --global user.name "$user_name"
fi
if ! git config --list | grep -q 'user.email='; then
  echo "Git global configuration not found. Please enter your email:"
  read user_email
  git config --global user.email "$user_email"
fi
print_table_results "Github user config" "command -v git >/dev/null 2>&1 && git config --list | grep -q 'user.name='"
print_table_results "Github email config" "command -v git >/dev/null 2>&1 && git config --list | grep -q 'user.email='"
echo "Github User Configuration:"
print_data_row "Name" "command -v git >/dev/null 2>&1 && git config user.name"
print_data_row "Email" "command -v git >/dev/null 2>&1 && git config user.email"

delimiter
