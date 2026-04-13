# todo:
#
# ssh-keygen
# clone flake repo
# optionally create host dir
# optionally rebuild

$host = bootstrap
read -p "Enter host name (leave empty for bootstrap config): " hostnameInput


switch () {
	sudo nixos-rebuild switch --flake ~/flake#$host
}
