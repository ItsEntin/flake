{ config, lib, pkgs, inputs, ... }: {

	programs.spicetify = let
		spkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
	in {
		enable = true;
		wayland = true;
		theme = spkgs.themes.catppuccin;
		colorScheme = "mocha";
		alwaysEnableDevTools = true;
		enabledExtensions = with spkgs.extensions; [
			simpleBeautifulLyrics
			betterGenres
			history
			songStats
			# coverAmbience
		];
		enabledCustomApps = [
			# spkgs.apps.lyricsPlus
		];
		enabledSnippets = with spkgs.snippets; [
			thickerBars
			fixDjIcon
			# dynamicSearchbar
			removeTopSpacing
		];
	};

}
