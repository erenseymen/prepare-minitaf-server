# prepare-minitaf-server

## Requirements:
* Ubuntu Latest LTS Server Edition (Tested on 22.04)
* Internet connection to Ubuntu apt repositories and Github

## Run:

As root user under /root/ directory run below commands

```console
git clone https://github.com/erenseymen/prepare-minitaf-server
cd prepare-minitaf-server
./main.sh
```

Run below command:
```console
visudo
```
Add below lines to the end of the file
```console
mtaf ALL = NOPASSWD: /usr/sbin/adduser
mtaf ALL = NOPASSWD: /usr/sbin/deluser
```

Add primary local IP (with hostname) to /etc/hosts

And reboot.