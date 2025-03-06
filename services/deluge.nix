{ config, lib, pkgs, inputs, ... }: {

	# networking.nat = {
	# 	enable = true;
	# 	externalInterface = "wlp2s0";
	# 	internalInterfaces = [ "ve-deluge" ];
	# };

	containers.deluge = {
		autoStart = true;
		bindMounts = {
			"/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;
		};
		enableTun = true;
		privateNetwork = true;
		config = { config, lib, pkgs, ... }: {

			imports = [ inputs.agenix.nixosModules.default ];
			age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
			age.secrets = {
				"deluge-creds" = {
					file = ../secrets/deluge-creds.age;
					owner = "deluge";
					group = "deluge";
				};
				"torrent-wg-key" = {
					file = ../secrets/torrent-wg-key.age;
				};
			};

			networking.firewall.enable = false;

			users.users.deluge = {
				isSystemUser = true;
				group = "deluge";
			};

			services.deluge = {
				enable = true;
				web.enable = true;
				declarative = true;
				authFile = config.age.secrets.deluge-creds.path;
				config = {
					outgoing-interface = "wg0";
				};
			};

			networking.wireguard = {
				enable = true;
				interfaces.wg0 = {
					ips = [ "10.2.0.2/32" ];
					privateKeyFile = config.age.secrets.torrent-wg-key.path;
					peers = [
						{
							publicKey = "b5Wy36VwywSceq7wfLAe/QxcQ/UQC11txwkGes/CEWc=";
							allowedIPs = [ "0.0.0.0/0" ];
							endpoint = "146.70.198.50:51820";
							persistentKeepalive = 25;
						}
					];
				};
			};

		};
	};

#
# 	services.deluge = {
# 		enable = true;
# 		web.enable = true;
# 		declarative = true;
# 		authFile = config.age.secrets.deluge-creds.path;
# 		config = {
# 			outgoing-interface = "wg0";
# 		};
# 	};
#
# 	# From https://wiki.nixos.org/w/index.php?title=Deluge&oldid=19174
#
# 	# creating network namespace
# 	systemd.services."netns@" = {
# 		description = "%I network namespace";
# 		before = [ "network.target" ];
# 		serviceConfig = {
# 			Type = "oneshot";
# 			RemainAfterExit = true;
# 			ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
# 			ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
# 		};
# 	};
#
# 	# setting up wireguard interface within network namespace
# 	systemd.services.wg = {
# 		description = "wg network interface";
# 		bindsTo = [ "netns@wg.service" ];
# 		requires = [ "network-online.target" ];
# 		after = [ "netns@wg.service" ];
# 		serviceConfig = {
# 			Type = "oneshot";
# 			RemainAfterExit = true;
# 			ExecStart = with pkgs; writers.writeBash "wg-up" ''
# 				see -e
# 				${iproute2}/bin/ip link add wg0 type wireguard
# 				${iproute2}/bin/ip link set wg0 netns wg
# 				${iproute2}/bin/ip -n wg address add 10.2.0.2 dev wg0
# 				${iproute2}/bin/ip netns exec wg \
# 				 ${wireguard-tools}/bin/wg setconf wg0 ${config.age.secrets.torrent-wg-conf.path}
# 				${iproute2}/bin/ip -n wg link set wg0 up
# 				# need to set lo up as network namespace is started with lo down
# 				${iproute2}/bin/ip -n wg link set lo up
# 				${iproute2}/bin/ip -n wg route add default dev wg0
# 			'';
# 			ExecStop = with pkgs; writers.writeBash "wg-down" ''
# 				${iproute2}/bin/ip -n wg route del default dev wg0
# 				${iproute2}/bin/ip -n wg link del wg0
# 			'';
# 		};
# 	};
#
}
