let
	nixlab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8f3q9DW0LGqYOrmOOr2/k0OHGaYXzk7EfUDZ2XJs/x root@nixlab";
	laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZGp7WOC3gv2M0KvIxWjEsIAN13xann0jJtp17irnQg root@nixos";

	systems = [ nixlab laptop ];
in
{
	"cf-credentials.age".publicKeys = [ nixlab ];
	"torrent-wg-key.age".publicKeys = [ nixlab ];
}
