{ config, lib, pkgs, ... }: 

let

	composeFile = builtins.toFile "docker-compose.yml" ( builtins.replaceStrings ["	"] ["   "] /*sh*/ ''
		services:
			gluetun:
				image: qmcgaw/gluetun
				container_name: gluetun
				cap_add:
					- NET_ADMIN
				devices:
					- /dev/net/tun:/dev/net/tun
				volumes:
					# - $#{config.age.secrets.torrent-wg-conf.path}:/gluetun/wireguard/wg0.conf
					- ${config.age.secrets.gluetun-conf.path}:/gluetun/auth/config.toml
				env_file: ${config.age.secrets.torrent-env.path}
				environment:
					VPN_SERVICE_PROVIDER: protonvpn
					VPN_TYPE: wireguard
					VPN_PORT_FORWARDING: on
					GLUETUN_HTTP_CONTROL_SERVER_ENABLE: on

					WIREGUARD_ADRESSES: "10.2.0.2/32"
					VPN_CITIES: Toronto
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

			qsticky:
				image: ghcr.io/monstermuffin/qsticky:latest
				container_name: qsticky
				env_file: 
					- "${config.age.secrets.torrent-env.path}"
				environment:
					QBITTORRENT_HOST: gluetun
					QBITTORRENT_PORT: 6011

					GLUETUN_HOST: gluetun
					GLUETUN_PORT: 8000
					GLUETUN_AUTH_TYPE: apikey

					CHECK_INTERVAL: 30
					LOG_LEVEL: INFO
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
