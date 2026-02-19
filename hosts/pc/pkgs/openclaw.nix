{
	pkgs,
	lib
}: pkgs.stdenv.mkDerivation (finalAttrs: rec {
	pname = "openclaw";
	version = "2026.2.12";

	src = pkgs.fetchFromGitHub {
		owner = "openclaw";
		repo = "openclaw";
		rev = "d8d69ccbf464788a3ac0406b917d422ddf0dd84e";
		hash = "sha256-/R8rQYgSqA+f8tlhfcbFAV495g9NDJDQNd9K2wSwZ0w=";
	};

	nativeBuildInputs = with pkgs; [
		nodejs_22
		pnpm_10
		pnpm_10.configHook
		cmake
		glibc
		gcc
		gpp
		python3
		pkg-config
		makeWrapper
		git
		curl
		wget
		gum
		coreutils
	];

	buildInputs = nativeBuildInputs;

	dontUseCmakeConfigure = true;

	pnpmDeps = pkgs.fetchPnpmDeps {
		inherit (finalAttrs) pname version src;
		fetcherVersion = 3;
		pnpm = pkgs.pnpm_10;
		hash = "sha256-fyQOPolsaBtPlvbZRCJCgq1jm2mrGt4qSbqni4ebLVQ=";
	};

	buildPhase = ''
		cd $out
		pnpm install # --frozen-lockfile --offline
		pnpm ui:build || echo "UI build failed; continuing..."
		pnpm build
	'';

	installPhase = ''
		# mkdir -p $out/lib/openclaw
		# cp -r dist node_modules package.json $out/lib/openclaw/

		# makeWrapper ${pkgs.nodejs_22}/bin/node $out/bin/openclaw \
		#   --add-flags "$out/lib/openclaw/dist/entry.js" \
		#   --prefix PATH : ${lib.makeBinPath [ pkgs.git ]} \
		#   --set SHARP_IGNORE_GLOBAL_LIBVIPS "1"
	'';

})


# }: pkgs.buildNpmPackage {
# 	pname = "openclaw";
# 	version = "1.0.0";
#
# 	src = pkgs.fetchFromGitHub {
# 		owner = "openclaw";
# 		repo = "openclaw";
# 		rev = "d8d69ccbf464788a3ac0406b917d422ddf0dd84e";
# 		hash = "sha256-/R8rQYgSqA+f8tlhfcbFAV495g9NDJDQNd9K2wSwZ0w=";
# 	};
#
# 	npmDepsHash = "sha256-QETRG8Pv2p/fqhUmM76CGP6K1X2WyF6/9PmUY+WjD+4=";
# }
#
