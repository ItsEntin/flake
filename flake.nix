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

	outputs = inputs@{ self, nixpkgs, home-manager, ... }: let
		lib = nixpkgs.lib;
		system = "x86_64-linux";
	in {

		nixosConfigurations = let

			common = {
				inherit system;
				specialArgs = { inherit inputs; };
			};
			modules = [
				inputs.catppuccin.nixosModules.catppuccin
				inputs.nixvim.nixosModules.nixvim
				inputs.agenix.nixosModules.default
				
				common/configuration.nix
			];

		in{

			thinkpad = lib.nixosSystem ( common // {
				modules = modules ++ [
					./hosts/thinkpad/configuration.nix
					./themes
				];
			});

			msi = lib.nixosSystem ( common // {
				modules = modules ++ [
					./hosts/msi
					./themes
				];
			});

			nixlab = lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs; };
				modules = [
					inputs.catppuccin.nixosModules.catppuccin
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
					inputs.catppuccin.homeModules.catppuccin
					inputs.spicetify-nix.homeManagerModules.default
					common/home.nix
					hosts/laptop/home.nix
					./themes
				];
			};
			nixlab = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { system = "x86_64-linux"; };
				modules = [
					inputs.catppuccin.homeModules.catppuccin
					common/home.nix
					hosts/nixlab/home.nix
				];
			};
		};

	};
}
