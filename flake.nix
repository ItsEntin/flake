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
		spicetify-nix = {
			url = "github:Gerg-L/spicetify-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-minecraft.url = "github:Infinidoge/nix-minecraft";
		nixvim = {
			url = "github:nix-community/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};
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
					./themes
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
					catppuccin.homeModules.catppuccin
					inputs.spicetify-nix.homeManagerModules.default
					common/home.nix
					hosts/laptop/home.nix
					./themes
				];
			};
			nixlab = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { system = "x86_64-linux"; };
				modules = [
					catppuccin.homeModules.catppuccin
					common/home.nix
					hosts/nixlab/home.nix
				];
			};
		};

	};
}
