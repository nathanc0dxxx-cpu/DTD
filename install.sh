printf "\e[93mcreating file: DOT.lua\n"
printf "installing dependencies...\e[0m\n"
pkg install -y lua54

if ! grep -q 'alias dtdos=' ~/.bashrc; then
    echo 'alias dtdos="lua $HOME/DOT.lua"' >> ~/.bashrc
fi

curl -fsSL https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDBTL.lua > ~/DOT.lua
source ~/.bashrc
stty -echo -icanon
printf "\e[32m[PROCCESS COMPLETED]:\e[0m\n"
read
stty sane
printf "\e[0m"