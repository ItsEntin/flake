{ config, pkgs, lib, ... }: {

	networking.wg-quick = {
		interfaces = {
			wg0 = {
				configFile = config.age.secrets.torrent-wg-conf.path;
			};
		};
	};

# 	networking.firewall.allowedUDPPorts = [ 51820 ];
#
# 	networking.wireguard = {
# 		enable = true;
# 		interfaces.wg0 = {
# 			ips = [ "10.2.0.2/32" ];
# 			privateKeyFile = config.age.secrets.torrent-wg-key.path;
# 			listenPort = 51820;
# 			peers = [{
# 				name = "CA-96";
# 				publicKey = "b5Wy36VwywSceq7wfLAe/QxcQ/UQC11txwkGes/CEWc=";
# 				allowedIPs = [ "0.0.0.0/0" ];
# 				endpoint = "146.70.198.50:51820";
# 				persistentKeepalive = 25;
# 			}];
# 		};
# 	};
#
}
