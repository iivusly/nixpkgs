{
  nix-update-script,
  stdenvNoCC,
  fetchurl,
  undmg,
  lib,
}:

stdenvNoCC.mkDerivation(finalAttrs: {
  pname = "obs-studio";
  version = "30.1.2";
  src = {
    aarch64-darwin = fetchurl {
      url = "https://github.com/obsproject/obs-studio/releases/download/${finalAttrs.version}/OBS-Studio-${finalAttrs.version}-macOS-Apple.dmg";
      hash = "sha256-ZPapOpj/ifct5yGq4tAgkkg8ForSwWIw9X5UnRC/ESA=";
    };

    x86_64-darwin = fetchurl {
      url = "https://github.com/obsproject/obs-studio/releases/download/${finalAttrs.version}/OBS-Studio-${finalAttrs.version}-macOS-Intel.dmg";
      hash = "sha256-1TuFphQt40C/sMSLxWO2vg2ZrmsJHaQ6e6JQILrGkC4=";
    };
  }.${stdenvNoCC.hostPlatform.system};

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "OBS.app";

  installPhase = ''
  runHook preInstall

  mkdir -p $out/Applications/OBS.app
  cp -R . $out/Applications/OBS.app

  runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    maintainers = with maintainers; [ iivusly ];
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.darwin;
  };
})
