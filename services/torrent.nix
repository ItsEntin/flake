{ config, lib, pkgs, ... }: {

	containers.torrent = {
		bindMounts."${config.age.secrets.torrent-wg-key.path}".isReadOnly = true;
		config = { config, lib, pkgs, ... }: {

			networking.wireguard = {
				enable = true;
				interfaces.wg0 = {
					ips = [ "10.2.0.2/32" ];
					privateKeyFile = "/run/agenix/torrent-wg-key";
					peers = [{
						name = "CA-96";
						publicKey = "b5Wy36VwywSceq7wfLAe/QxcQ/UQC11txwkGes/CEWc=";
						allowedIPs = [ "0.0.0.0/0" ];
						endpoint = "146.70.198.50:51820";
						persistentKeepalive = 25;
					}];
				};
			};
			services.transmission = {
				enable = true;
				settings = {
					rpc-bind-address = "0.0.0.0";
				};
			};
		};
	};

}
