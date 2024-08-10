{
  stdenvNoCC,
  fetchurl,
  undmg,
  lib,
}:

let
  version = "3.12.1";

  sources = system: {
    aarch64-darwin = {
      url = "https://desktop-release.notion-static.com/Notion-${version}-arm64.dmg";
      hash = "sha256-l3QaNLy8GkcJErGbm7o1bcUs2NeOh2v4bHoIpIsBzZU=";
    };

    x86_64-darwin = {
      url = "https://desktop-release.notion-static.com/Notion-${version}.dmg";
      hash = "sha256-Z3NbDQEYy9HPmqD69oUVu1aUQlCYrI+IVnum2J8cLcA=";
    };
  }.${system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "notion-app";
  version = "3.12.1";

  src = fetchurl (sources stdenvNoCC.hostPlatform.system);
  sourceRoot = "Notion.app";

  nativeBuildInputs = [ undmg ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications/${finalAttrs.sourceRoot}
    cp -R . $out/Applications/${finalAttrs.sourceRoot}
    runHook postInstall
  '';

  meta = {
    description = "App to write, plan, collaborate, and get organised";
    homepage = "https://www.notion.so/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
