{
	description = "evrens nix config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixos-hardware.url = "github:nixos/nixos-hardware/master";
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
		nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
		zen-browser = {
			url = "github:youwen5/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, ... }: let
		lib = nixpkgs.lib;
		system = "x86_64-linux";
	in {

		nixosConfigurations = let

			common = {
				inherit system;
				specialArgs = { inherit inputs; };
			};
			commonModules = [
				inputs.catppuccin.nixosModules.catppuccin
				inputs.nixvim.nixosModules.nixvim
				inputs.agenix.nixosModules.default
				
				./common/configuration.nix
			];
			mkSystem = mods: lib.nixosSystem (common // {
				modules = commonModules ++ mods;
			});
			hmModule = host: ( home-manager.nixosModules.home-manager {
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
				home-manager.users.evren = ./hosts/${host}/home-manager/home.nix;
			});

		in{

			bootstrap = mkSystem [
				./hosts/bootstrap/configuration.nix
			];

			thinkpad = mkSystem [
				nixos-hardware.nixosModules.lenovo-thinkpad-t480s
				./hosts/thinkpad/configuration.nix
				./themes
				./secrets
			];

			pc = mkSystem [
				./hosts/pc/configuration.nix
			];

			nixlab = mkSystem [
				./hosts/nixlab/configuration.nix
				./services
				./secrets
			];

			printer = mkSystem [
				./hosts/printer/configuration.nix
				(hmModule "printer")
				./common/home.nix
			];

			wsl = lib.nixosSystem {
				inherit system;
				modules = [
					./hosts/wsl/configuration.nix
					
					inputs.nixos-wsl.nixosModules.default {
						system.stateVersion = "25.05";
						wsl.enable = true;
					}
				];
			};
		};

		homeConfigurations = let
			mkHome = mods: home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { inherit system; };
				modules = hmCommonModules ++ mods;
			};
			hmCommonModules = [
				inputs.catppuccin.homeModules.catppuccin
				inputs.nixvim.homeManagerModules.nixvim
				common/home.nix
			];
		in {
			thinkpad = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { system = "x86_64-linux"; };
				modules = [
					inputs.catppuccin.homeModules.catppuccin
					inputs.spicetify-nix.homeManagerModules.default
					inputs.nixvim.homeModules.nixvim
					common/home.nix
					hosts/thinkpad/home.nix
					./themes
					common/home-manager/nvim.nix
				];
			};

			pc = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { system = "x86_64-linux"; };
				modules = [
					inputs.catppuccin.homeModules.catppuccin
					inputs.nixvim.homeModules.nixvim
					common/home.nix
					hosts/pc/homemanger
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
			printer = mkHome [
				
			];
			wsl = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { system = "x86_64-linux"; };
				modules = [
					inputs.catppuccin.homeModules.catppuccin
					inputs.nixvim.homeManagerModules.nixvim
					common/home.nix
				];
			};
		};

	};
}
