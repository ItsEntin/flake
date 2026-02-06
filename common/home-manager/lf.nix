{ config, pkgs, lib, ... }: {

programs.lf = {
	enable = true;
	settings = {
		ratios = [ 1 2 2 ]; # Pane sizes
		mouse = true; # Enable mouse support
		incsearch = true; # Search whenever a character is entered
		dircounts = true; # idk
		scrolloff = 8; # Space left at top/bottom when scrolling
		wrapscroll = true; # Scrolling off bottom moves to top
		icons = true; # Enable icons next to files
	};
	extraConfig = 
		let previewer = let
					icat = ''${pkgs.kitty}/bin/kitty +kitten icat --silent --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}"'';
		in pkgs.writeShellScriptBin "pv.sh" /*bash*/ ''
			file=$1
			w=$2
			h=$3
			x=$4
			y=$5

			mimetype=$(${pkgs.file}/bin/file -Lb --mime-type "$1")

			case $mimetype in
				image/* ) 
					${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
					exit 1
				;;
				text/* )
					${pkgs.bat}/bin/bat --color always --style snip $1
					exit 1
				;;
				application/zip )
					echo "ZIP encoding"
					echo
					zipinfo -1 $1
				;;
				application/pdf )
					echo "PDF Document - lf"
					# ${pkgs.imagemagick}/bin/magick \'$1\'[0] - | ${pkgs.kitty}/bin/kitten icat --silent --place "''${w}x''${h}@''${x}x''${y}" --stdin yes < /dev/null > /dev/tty
					${pkgs.imagemagick}/bin/magick "$1"[0] - |${pkgs.kitty}/bin/kitten icat
				;;
			esac

			${pkgs.pistol}/bin/pistol "$file"
		'';
		cleaner = pkgs.writeShellScriptBin "clean.sh" ''
			${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
		'';
		in
		''
		  set cleaner ${cleaner}/bin/clean.sh
		  set previewer ${previewer}/bin/pv.sh
    '';
	keybindings = {
		J = "push 10j";
		K = "push 10k";

		"<backspace2>" = "set hidden!"; # Toggle hidden files
		"<tab>" = "set number!"; # Toggle numberline

		gh = "cd ~"; # Go home
		gf = "cd ~/flake"; # Go to flake

		S = "$$SHELL"; # Open shell
		s = "push :shell<enter>"; # Inline shell

		oa = ":{{set sortby atime; set info atime;}}"; # Order by access time
		oc = ":{{set sortby ctime; set info ctime;}}"; # Order by creation time
		oe = ":{{set sortby ext; set info ;}}"; # Order by extension
		on = ":{{set sortby natural; set info ;}}"; # Order natural
		os = ":{{set sortby size; set info size;}}"; # Order by size
		ot = ":{{set sortby time; set info time;}}"; # Order by time
	};
	commands = {
		trash = /*sh*/ "%trash-put -- $fx";

		open = /*sh*/ ''&{{
			case $( ${pkgs.file}/bin/file --mime-type -Lb "$f" ) in
				image/*)	${pkgs.imv}/bin/imv "$f";;
				text/*)		lf -remote "send $id \$$EDITOR $f";;
				video/*)	${pkgs.mpv}/bin/mpv "$f";;
				audio/*)	${pkgs.vlc}/bin/vlc "$f";;
				*/pdf)		${pkgs.zathura}/bin/zathura "$f";;
				*/zip)		lf -remote "send $id \$ ${pkgs.atool} -l '$f' | less";;
				*/gzip)		lf -remote "send $id \$ ${pkgs.atool} -l '$f' | less";;
		esac }}'';
	};
};

xdg.configFile."lf/icons".source = builtins.fetchurl { 
	url = "https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example";
	sha256 = "734a2b0d03b885e761fb168dae8bc2d207a1e62ab62be7be3d920be5a6f19c89";
};

}
