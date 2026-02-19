{ lib
, stdenv
, fetchFromGitHub
, nodejs_24
, pnpm_10
, makeWrapper
, git
, docker
, fetchPnpmDeps
, pnpmConfigHook
}:

stdenv.mkDerivation rec {
  pname = "openclaw";
  version = "2026.2.6";

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "openclaw";
	rev = "d8d69ccbf464788a3ac0406b917d422ddf0dd84e";
	hash = "sha256-/R8rQYgSqA+f8tlhfcbFAV495g9NDJDQNd9K2wSwZ0w=";

  };

  # Handle pnpm dependencies
  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
	fetcherVersion = 3;
	hash = "sha256-fyQOPolsaBtPlvbZRCJCgq1jm2mrGt4qSbqni4ebLVQ=";
  };

  nativeBuildInputs = [ 
	pnpm_10
    nodejs_24 
	pnpmConfigHook
    makeWrapper 
  ];

  # OpenClaw specific build steps
  buildPhase = ''
    runHook preBuild
    
    # Building the TUI/Gateway and UI components
    pnpm ui:build
    pnpm build
    
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/node_modules/openclaw
    cp -r . $out/lib/node_modules/openclaw

    # Create the executable shim
    makeWrapper ${nodejs_24}/bin/node $out/bin/openclaw \
      --add-flags "$out/lib/node_modules/openclaw/dist/cli.js" \
      --prefix PATH : ${lib.makeBinPath [ git docker nodejs_24 ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Your own personal AI assistant. The lobster way. 🦞";
    homepage = "https://openclaw.ai";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
