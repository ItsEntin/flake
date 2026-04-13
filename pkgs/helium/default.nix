{
	lib,
	appimageTools,
	fetchurl,
}: let

	pname = "helium";
	version = "0.10.9.1";

	src = fetchurl {
		url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
		hash = "sha256-FMO4gB2zOjhgmjfE/T0XdDb0NMDKsQFuzy/Org1iD48=";
	};

	contents = appimageTools.extract { inherit pname version src;};

	extraInstallCommands = ''
		install -m 555 -D ${contents}/helium.desktop -t $out/share/applications
		cp -r ${contents}/usr/share/icons $out/share
	'';

	meta = {
		name = "Helium Browser";
		description = "Private, fast, and honest web browser";
		homepage = "https://helium.computer";
		downloadPage = "https://github.com/imputnet/helium-linux/releases/tag/${version}";
		changelog = "https://github.com/imputnet/helium-linux/releases/tag/${version}";
		license = lib.licenses.gpl3;
		mainProgram = "helium";
		platform = [ lib.platforms.linux ];
	};

in appimageTools.wrapType2 {
	inherit pname version src extraInstallCommands meta;
}
