{ config, lib, pkgs, ... }: {

	services.radicale = {
		enable = true;
		settings = {
			server = {
				hosts = [ "0.0.0.0:5232" ];
			};
			auth = {
				type = "htpasswd";
				htpasswd_encryption = "plain";
				htpasswd_filename = "${config.age.secrets.radicale-users.path}";
			};
		};
	};

}
