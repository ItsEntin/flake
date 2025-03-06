{ config, lib, pkgs, ... }: {

	containers.torrent = {
		autoStart = true;
		bindMounts = {
			"${config.age.secrets.torrent-wg-key.path}".isReadOnly = true;

			"/var/lib/transmission/Downloads" = {
				hostPath = "/mnt/hdd/downloads";
				isReadOnly = false;
			};
		};
		config = { config, lib, pkgs, ... }: {
			environment.systemPackages = [ pkgs.transmission_4 ];
# 			networking.wireguard = {
# 				enable = true;
# 				interfaces.wg0 = {
# 					ips = [ "10.2.0.2/32" ];
# 					privateKeyFile = "/run/agenix/torrent-wg-key";
# 					peers = [{
# 						name = "CA-96";
# 						publicKey = "b5Wy36VwywSceq7wfLAe/QxcQ/UQC11txwkGes/CEWc=";
# 						allowedIPs = [ "0.0.0.0/0" ];
# 						endpoint = "146.70.198.50:51820";
# 						persistentKeepalive = 25;
# 					}];
# 				};
# 			};
			# services.transmission = {
			# 	enable = true;
			# 	webHome = pkgs.flood-for-transmission;
			# 	settings = {
			# 		rpc-bind-address = "0.0.0.0";
			# 		rpc-authentication-required = false;
			# 		rpc-whitelist = "*";
			# 		rpc-whitelist-enabled = false;
			# 		rpc-host-whitelist = "*";
			# 		rpc-host-whitelist-enabled = false;
			# 	};
			# };
		};
	};

}
