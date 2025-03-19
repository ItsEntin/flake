let
	nixlab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8f3q9DW0LGqYOrmOOr2/k0OHGaYXzk7EfUDZ2XJs/x root@nixlab";
	laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZGp7WOC3gv2M0KvIxWjEsIAN13xann0jJtp17irnQg root@nixos";

	systems = [ nixlab laptop ];

	evren_nixlab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILx52OIAM9RcL5GEnula/WGOl907ZQAxcvYZ2DrXAMiw evren@nixlab";
in
{
	"cf-credentials.age".publicKeys = [ nixlab ];
	"torrent-wg-conf.age".publicKeys = [ nixlab ];
	"torrent-wg-key.age".publicKeys = [ nixlab ];
	"torrent-env.age".publicKeys = [ nixlab evren_nixlab ];
	"gluetun-conf.age".publicKeys = [ nixlab ];
	"radarr-api-key.age".publicKeys = [ nixlab ];
	"radarr-api-key-env.age".publicKeys = [ nixlab ];
	"immich-api-key-env.age".publicKeys = [ nixlab ];
	"jellyfin-api-key-env.age".publicKeys = [ nixlab ];
}
