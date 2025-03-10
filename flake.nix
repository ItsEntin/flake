{
	description = "evrens nixos configurations :3";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		catppuccin.url = "github:catppuccin/nix";
		agenix.url = "github:ryantm/agenix";
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
					hosts/laptop/configuration.nix
				];
			};
			nixlab = lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs; };
				modules = [
					catppuccin.nixosModules.catppuccin
					inputs.agenix.nixosModules.default

					common/configuration.nix
					hosts/nixlab/configuration.nix
					services/default.nix
					secrets/default.nix
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
