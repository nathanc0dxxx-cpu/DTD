printf "\e[93mINSTALLING NOW: DOT APP (DOT.lua)\n"
printf "installing dependencies...\e[0m\n"
if ! command -v lua >/dev/null 2>&1; then
    pkg install -y lua54
fi

maind="${PREFIX:-/usr}/bin"
mkdir -p "$maind"
if [ ! -x "$maind/lua" ]; then
    printf "\e[91mERROR: \e[0mlua package installation failed!\n"
    exit 1
fi

printf "\e[93minstalling program...\n"

curl -fsSL https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/DTDBTL.lua -o "$maind/DOT.lua" || {
    printf "\e[91mERROR: \e[0mfailed while installing app\n"
    exit 1
}
echo "lua $maind/DOT.lua" > "$maind/dtdos"
chmod +x "$maind/dtdos"

stty -echo -icanon
printf "\e[32m[PROCCESS COMPLETED | Press Enter]:\e[0m"
read
stty sane
printf "\e[0m"
clear