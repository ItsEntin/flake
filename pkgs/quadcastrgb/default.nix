{
	lib,
	stdenv,
	libusb1,
	glibc,
	gcc
}: stdenv.mkDerivation (finalAttrs: rec {
	pname = "quadcastrgb";
	version = "1.0.5";

	src = fetchGit {
		url = "https://github.com/Ors1mer/QuadcastRGB.git";
		rev = "9ef8db59239be3a6740be6c2f317a6c40bc169a3";
	};

	nativeBuildInputs = [
		libusb1
		gcc
		glibc
	];
	
	# buildPhase = ''
	# 	
	# '';

	installPhase = ''
		mkdir -p $out/bin
		cp quadcastrgb $out/bin

		mkdir -p $out/share/man/man1
		cp -r man/* $out/share/man/man1
	'';

	meta = {
		description = "";
		homepage = "https://ors1mer.xyz/quadcastrgb.html";
		license = lib.licenses.gpl2;
	};
})
