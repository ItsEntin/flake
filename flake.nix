{
	description = "evrens nixos configurations :3";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		catppuccin.url = "github:catppuccin/nix";
	};

	outputs = inputs@{ self, nixpkgs, home-manager, catppuccin, ... }: let
		lib = nixpkgs.lib;
		system = "x86_64-linux";
	in {

		nixosConfigurations = {
			nixos = lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs; };
				modules = [
					catppuccin.nixosModules.catppuccin
					common/configuration.nix
				];
			};
			nixlab = lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs; };
				modules = [
					catppuccin.nixosModules.catppuccin
					common/configuration.nix
					hosts/nixlab/configuration.nix

					# home-manager.nixosModules.home-manager
					# {
					# 	home-manager.useGlobalPkgs = true;
					# 	home-manager.useUserPackages = true;
					# 	home-manager.users.evren = import ./hosts/nixlab/home.nix;
					# }
				];
			};
		};

		homeConfigurations = {
			nixos = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { system = "x86_64-linux"; };
				inherit system;
				modules = [
					catppuccin.homeManagerModules.catppuccin
					common/home.nix
					hosts/laptop/home.nix
				];
			};
			nixlab = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { system = "x86_64-linux"; };
				inherit system;
				modules = [
					catppuccin.homeManagerModules.catppuccin
					common/home.nix
					hosts/nixlab/home.nix
				];
			};
		};

	};
}
