# gpg-conf

These are my default gpg config files.  
They are stored here for ease of setting up new machines.

## How to use:
### Install necessary packages

Use your choice of package manager

```
$ sudo apt update && sudo apt install gnupg2 gnupg-agent gnupg-curl scdaemon pcscd
```
```
$ sudo pacman -Syu && sudo pacman -S gnupg2 gnupg-agent gnupg-curl scdaemon pcscd
```
```
$ brew update && brew install gnupg2 gnupg-agent gnupg-curl scdaemon pcscd
```

### Store the files
```
$ curl https://raw.githubusercontent.com/tooboredtocode/gpg-conf/master/gpg.conf > ~/.gnupg/gpg.conf

$ curl https://raw.githubusercontent.com/tooboredtocode/gpg-conf/master/gpg-agent.conf > ~/.gnupg/gpg-agent.conf
```

#### Optional:

If you want to use gpg for ssh authentication add the following lines to your rc file (.bashrc/.zshrc/...):
```
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
```
