{ config, lib, pkgs, ... }: {

	compose.stacks.immich = 
	let envFile = builtins.toFile "immich.env" /*sh*/ ''
		UPLOAD_LOCATION=/mnt/hdd/immich/media
		DB_DATA_LOCATION=/mnt/hdd/immich/db
		IMMICH_VERSION=release
		DB_USERNAME=postgres
		DB_DATABASE_NAME=immich
		DB_PASSWORD=postgres
		TZ=America/Toronto
	'';
	in {
		enable = true;
		requireNetwork = true;
		extraArgs = "--env-file ${envFile}";
		stack = {
			name = "immich";
			services = {

				immich-server = {
					container_name = "immich_server";
					image = "ghcr.io/immich-app/immich-server:release";
					volumes = [
						"\${UPLOAD_LOCATION}:/usr/src/app/upload"
						"/etc/localtime:/etc/localtime:ro"
					];
					env_file = envFile;
					ports = [
						"2283:2283"
					];
					depends_on = [
						"redis"
						"database"
					];
					restart = "always";
					healthcheck = {
						disable = false;
					};
				};

				immich-machine-learning = {
					container_name = "immich_machine_learning";
					image = "ghcr.io/immich-app/immich-machine-learning:release";
					volumes = [
						"model-cache:/cache"
					];
					env_file = envFile;
					restart = "always";
					healthcheck = {
						disable = false;
					};
				};

				redis = {
					container_name = "immich-redis";
					image = "docker.io/valkey/valkey:8-bookworm@sha256:42cba146593a5ea9a622002c1b7cba5da7be248650cbb64ecb9c6c33d29794b1";
					healthcheck = {
						test = "redis-cli ping || exit 1";
					};
					restart = "always";
				};

				database = {
					container_name = "immich_postgres";
					image = "docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:739cdd626151ff1f796dc95a6591b55a714f341c737e27f045019ceabf8e8c52";
					environment = {
						POSTGRES_USER = "\${DB_USERNAME}";
						POSTGRES_PASSWORD = "\${DB_PASSWORD}";
						POSTGRES_DB = "\${DB_DATABASE_NAME}";
						POSTGRES_INITDB_ARGS = "--data-checksums";
					};
					volumes = [
						"\${DB_DATA_LOCATION}:/var/lib/postgresql/data"
					];
					healthcheck = {
						test = ''pg_isready --dbname="$${POSTGRES_DB}" --username="$${POSTGRES_USER}" || exit 1; Chksum="$$(psql --dbname="$${POSTGRES_DB}" --username="$${POSTGRES_USER}" --tuples-only --no-align --command='SELECT COALESCE(SUM(checksum_failures), 0) FROM pg_stat_database')"; echo "checksum failure count is $$Chksum"; [ "$$Chksum" = '0' ] || exit 1'';
						interval = "5m";
						start_interval = "30m";
						start_period = "5m";
					};
					command = ''postgres -c shared_preload_libraries=vectors.so -c 'search_path="$$user", public, vectors' -c logging_collector=on -c max_wal_size=2GB -c shared_buffers=512MB -c wal_compression=on'';
					restart = "always";
				};
			};
			volumes = {
				model-cache = {};
			};
		};
	};

	# Immich module refuses to work for some reason
	# services.immich = {
	# 	enable = true;
	# 	openFirewall = true;
	# 	mediaLocation = "/mnt/hdd/immich";
	# 	environment = {
	# 	};
	# 	port = 2283;
	# 	host = "0.0.0.0";
	# };

}
