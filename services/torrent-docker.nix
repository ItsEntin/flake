{ config, lib, pkgs, ... }: 

let

	composeFile = builtins.toFile "docker-compose.yml" ( builtins.replaceStrings ["	"] ["   "] /*sh*/ ''
		secrets:
			wg-key:
				file: ${config.age.secrets.torrent-wg-key.path}
		services:
			gluetun:
				image: qmcgaw/gluetun
				container_name: gluetun
				cap_add:
					- NET_ADMIN
				devices:
					- /dev/net/tun:/dev/net/tun
				secrets:
					- wg-key
				volumes:
					- ${config.age.secrets.torrent-wg-conf.path}:/gluetun/wireguard/wg0.conf
				environment:
					VPN_SERVICE_PROVIDER: custom
					VPN_TYPE: wireguard
					# WIREGUARD_PRIVATE_KEY: wg-key
					# WIREGUARD_PUBLIC_KEY: b5Wy36VwywSceq7wfLAe/QxcQ/UQC11txwkGes/CEWc=
					# WIREGUARD_ADDRESSES: 10.2.0.2/32
					# VPN_ENDPOINT_IP: 146.70.198.50
					# VPN_ENDPOINT_PORT: 51820
				ports:
					- 6011:6011 # qBittorrent
					- 6081:6081 # qBittorrent API
					- 6081:6081/udp #qBittorrent API
					- 8010:8000/tcp # Probably qBittorrent
				restart: unless-stopped
					
					
			qbittorrent:
				image: lscr.io/linuxserver/qbittorrent:latest
				container_name: qbittorrent
				environment:
					- PUID=1000
					- PGID=988
					- TZ=America/Toronto
					- WEBUI_PORT=6011
					- DOCKER_MODS=ghcr.io/vuetorrent/vuetorrent-lsio-mod:latest
					- TP_COMMUNITY_THEME=true
					- TP_THEME=catppuccin-mocha
				volumes:
					- /mnt/hdd/downloads:/downloads
					- /home/evren/docker/qbittorrent/:/config
				network_mode: "service:gluetun"
				depends_on:
					"gluetun":
						condition: service_healthy
				restart: unless-stopped
			flaresolverr:
				image: ghcr.io/flaresolverr/flaresolverr:latest
				container_name: flaresolverr
				environment:
					- TZ=America/Toronto
				ports:
					- 8191:8191
				restart: unless-stopped
	'');

in {

	virtualisation.docker.enable = true;

	systemd.services.torrent-stack= {
		enable = true;
		description = "Docker compose torrent stack";
		after = [ "network.target" ];
		wantedBy = [ "multi-user.target" ];
		serviceConfig = {
			Group = "torrent";
			Type = "simple";
			ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ${composeFile} up";
			ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ${composeFile} down";
		};
	};

}
