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

	outputs = { self, nixpkgs }: {

		nixosConfigurations = {
			nixos = nixpkgs.lib.nixosSystem {

			};
			nixlab = nixpkgs.lib.nixosSystem {

			};
		};

		homeConfigurations = {
			nixos = inputs.home-manager.lib.homeManagerConfiguration {

			};
			nixlab = inputs.home-manager.lib.homeManagerConfiguration {

			};
		};

	};
}
