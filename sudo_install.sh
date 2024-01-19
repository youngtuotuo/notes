#!/usr/bin/env /usr/bin/bash

# Ask Y/n
function ask() {
	read -p "$1 (Y/n): " resp
	if [ -z "$resp" ]; then
		response_lc="y" # empty is Yes
	else
		response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
	fi

	[ "$response_lc" = "y" ]
}

if ask "============ Do you want to apt update and upgrade? ============"; then
	sudo apt-get update
	sudo apt-get upgrade -y
fi

# dependencies
if ask "============ Do you want to install all dependencies? ============"; then
	sudo apt-get install python3.8-venv zstd ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen build-essential clang libevent-dev libncurses-dev bison git fd-find ripgrep -y
fi

# nodejs
if ask "============ Do you want to install nodejs? ============"; then
	curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
	sudo apt-get install -y nodejs
fi

# yarn
if ask "============ Do you want to install yarn? ============"; then
	curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
	echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt-get update && sudo apt-get install yarn
fi

# cuda
if ask "============ Do you want to install cuda? ============"; then
	echo "Please go to this website and give corresponding url based on your system:"
	echo "  https://developer.nvidia.com/cuda-downloads"
        echo -e "  \033[91mNote\033[0m: It is important to not install the cuda-drivers packages within the WSL environment."
        echo "      - cuda (cuda-toolkit + driver)"
        echo "      - cuda-toolkit (no driver)"
	read -p "Please give the cuda-keyring deb url: " resp
	if [ -z "$resp" ]; then
		echo "Empty url, skip."
	else
		wget $resp -O $HOME/cuda.deb
		sudo dpkg -i $HOME/cuda.deb
		sudo apt-get update
		echo "Please choose what you want to install"
                echo -e "  \033[91mNote\033[0m: It is important to not install the cuda-drivers packages within the WSL environment."
                echo "      - cuda (cuda-toolkit + driver)"
                echo "      - cuda-toolkit (no driver)"
		read -p "Type cuda/cuda-toolkit: " resp
		if [ "$resp" = "cuda" ] || [ "$resp" = "cuda-toolkit" ]; then
			sudo apt install $resp -y
		fi
                rm $HOME/cuda.deb
	fi
fi

# latex
if ask "============ Do you want to install latex? ============"; then
        sudo apt install texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra texlive-xetex latexmk -y
fi

# tiger vnc
if ask "============ Do you want to install tigerVNC? ============"; then
        sudo apt install tigervnc-standalone-server xfce4 xfce4-goodies
        mkdir $HOME/.vnc
        cp $HOME/github/dotfiles/xstartup $HOME/.vnc/xstartup
        sudo chmod +x ~/.vnc/xstartup
fi
