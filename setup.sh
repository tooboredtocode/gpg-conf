#!/bin/bash

# empty line for readbility
echo

# Install packages
OSKERNEL=$(uname)

case "$OSKERNEL" in
    Linux )
        if [ -f /etc/os-release ]; then
            . /etc/os-release
        fi

        case "$ID" in
            debian )
                echo "Do you want to install the following packages with apt:"
                echo "If you installed them already please press C"
                echo
                echo "wget gnupg2 gnupg-agent dirmngr cryptsetup scdaemon pcscd secure-delete hopenpgp-tools yubikey-personalization"
                echo

                read -p "(Y/N/C): " yn
                case $yn in
                    [Yy]* )
                        sudo apt update
                        sudo apt install wget gnupg2 gnupg-agent dirmngr cryptsetup scdaemon pcscd secure-delete hopenpgp-tools yubikey-personalization
                        ;;
                    [Cc]* )
                        ;;
                    * )
                        echo "Script closed, please install the the packages manually"
                        exit 1
                        ;;
                esac
                ;;
            
            * )
                echo "Unknown Linux distro, the packages needed could not be determined"
                echo "Press C if you have installed the neccesary packages and want to continue the script"

                read -p "(C/*): " yn
                case $yn in
                    [Cc]* )
                        ;;
                     * )
                        exit 1
                        ;;
                esac
                ;;
        esac
        ;;
    
    Darwin )
        echo "Do you want to install the following packages with brew:"
        echo "If you installed them already please press C"
        echo
        echo "gnupg2 gnupg-agent gnupg-curl scdaemon pcscd"
        echo

        read -p "(Y/N/C): " yn
        case $yn in
            [Yy]* )
                brew update
                brew install gnupg yubikey-personalization hopenpgp-tools ykman pinentry-mac
                ;;
            [Cc]* )
                ;;
            * )
                echo "Script closed, please install the the packages manually"
                exit 1
                ;;
        esac
        ;;
    
    * )
        echo "Unknown OS, the packages needed could not be determined"
        echo "Press C if you have installed the neccesary packages and want to continue the script"
        
        read -p "(C/*): " yn
        case $yn in
            [Cc]* )
                ;;
            * )
                exit 1
                ;;
        esac
        ;;
esac

echo


# Create neccesary files
if [ -f ~/.gnupg/gpg.conf ]; then
    echo "GPG config file already exists, do you want to overwrite it?"

    read -p "(Y/N): " yn
    case $yn in
        [Yy]* )
            curl -s https://raw.githubusercontent.com/tooboredtocode/gpg-conf/master/gpg.conf > ~/.gnupg/gpg.conf
            ;;
        * )
            ;;
    esac
    echo
else
    curl -s https://raw.githubusercontent.com/tooboredtocode/gpg-conf/master/gpg.conf > ~/.gnupg/gpg.conf
fi

function setupgpgagent() {
    curl -s https://raw.githubusercontent.com/tooboredtocode/gpg-conf/master/gpg-agent.conf > ~/.gnupg/gpg-agent.conf

    case "$OSKERNEL" in
        Linux )
            case "$ID" in
                debian )
                    sed -i -e 's/#pinentry-program \/usr\/bin\/pinentry-curses/pinentry-program \/usr\/bin\/pinentry-curses/g' ~/.gnupg/gpg-agent.conf
            esac
            ;;
        Darwin )
            sed -i -e 's/#pinentry-program \/usr\/local\/bin\/pinentry-mac/pinentry-program \/usr\/local\/bin\/pinentry-mac/g' ~/.gnupg/gpg-agent.conf
            ;;
    esac
}

if [ -f ~/.gnupg/gpg-agent.conf ]; then
    echo "GPG agent config file already exists, do you want to overwrite it?"

    read -p "(Y/N): " yn
    case $yn in
        [Yy]* )
            setupgpgagent
            ;;
        * )
            ;;
    esac
    echo
else
    setupgpgagent
fi

# Setup optional ssh agent
echo "Do you want to set up ssh to use gpg?"

read -p "(Y/N): " yn
case $yn in
    [Yy]* )
        case $SHELL in
            /bin/zsh )
                FILE="~/.zshrc"
                ;;
            /bin/bash )
                FILE="~/.bashrc"  
                ;;
            * )
                FILE="~/.profile"
                ;;
        esac

        curl -s https://raw.githubusercontent.com/tooboredtocode/gpg-conf/master/ssh-gpg >> $FILE
        ;;
    * )
        ;;
esac

echo

echo "To finish please import your gpg key and assigin it ultimate trust"

echo