printf "\e[93mcreating file: DOT.lua\n"
touch DOT.lua
printf "installing dependencies...\e[0m\n"
pkg install lua54
alias dtdos="lua54 DOT.lua"
curl -fsSL https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDBTL.lua > DOT.lua
stty -echo -icanon
printf "\e[32m[PROCCESS COMPLETED]:\e[0m\n"
read
stty sane
printf "\e[0m"