# Remotely reboot multiple servers

For the reboot function in this solution, the user should be prompt for password of each server that they tend to reboot. 
If you want to login without password, consider using `ssh-keygen` and `ssh-copy-id`

## How to use

Call `rebootserver.sh reboot *` to reboot all servers in list_of_servers.txt.

Call `rebootserver.sh reboot 1 2` to reboot server in line 1 and 2 in list_of_servers.txt.

Call `rebootserver.sh status` to show all server's status.