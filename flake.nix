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

	outputs = inputs@{ nixpkgs, home-manager, catppuccin, ... }: let
		lib = nixpkgs.lib;
		system = "x86_64-linux";
	in {

		nixosConfigurations = {
			nixos = lib.nixosSystem {
				inherit system;
				modules = [
					catppuccin.nixosModules.catppuccin
					common/configuration.nix
				];
			};
			nixlab = lib.nixosSystem {
				inherit system;
				modules = [
					catppuccin.nixosModules.catppuccin
					common/configuration.nix
					hosts/nixlab/configuration.nix
				];
			};
		};

		homeConfigurations = {
			nixos = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { system = "x86_64-linux"; };
				modules = [
					catppuccin.homeManagerModules.catppuccin
					common/home.nix
					hosts/laptop/home.nix
				];
			};
			nixlab = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { system = "x86_64-linux"; };
				modules = [
					catppuccin.homeManagerModules.catppuccin
					common/home.nix
					hosts/nixlab/home.nix
				];
			};
		};

	};
}
