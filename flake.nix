{
	description = "evrens nixos configurations :3";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		};
		catppuccin.url = "github:catppuccin/nix";
	};

	outputs = inputs@{ nixpkgs, home-manager, ... }: let
		lib = nixpkgs.lib;
	in {

		nixosConfigurations = {
			nixos = lib.nixosSystem {

			};
			nixlab = lib.nixosSystem {

			};
		};

		homeConfigurations = {
			nixos = home-manager.lib.homeManagerConfiguration {

			};
			nixlab = home-manager.lib.homeManagerConfiguration {

			};
		};

	};
}
