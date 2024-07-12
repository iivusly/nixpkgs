{ lib
, fetchFromGitHub
, wrapGAppsHook4
, gdk-pixbuf
, gettext
, gobject-introspection
, gtk4
, python3Packages
, stdenvNoCC
, makeWrapper
}:

python3Packages.buildPythonApplication rec {
  pname = "nicotine-plus";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "nicotine-plus";
    repo = "nicotine-plus";
    rev = "refs/tags/${version}";
    hash = "sha256-3OMcCMHx+uRid9MF2LMaqUOVQEDlvJiLIVDpCunhxw8=";
  };

  nativeBuildInputs = [ gettext wrapGAppsHook4 gobject-introspection makeWrapper ];

  propagatedBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    gtk4
    python3Packages.pygobject3
  ];

  postInstall = ''
    ln -s $out/bin/nicotine $out/bin/nicotine-plus
  '' + lib.optionalString stdenvNoCC.isDarwin ''
    APP_PATH="$out/Applications/Nicotine+.app/Contents"
    mkdir -p $APP_PATH/MacOS $APP_PATH/Resources

    cat << EOF | tee $APP_PATH/Info.plist
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleDevelopmentRegion</key>
      <string>English</string>
      <key>CFBundleExecutable</key>
      <string>nicotine</string>
      <key>CFBundleIconFile</key>
      <string>icon.icns</string>
      <key>CFBundleIdentifier</key>
      <string>org.nicotine_plus.Nicotine</string>
      <key>CFBundleInfoDictionaryVersion</key>
      <string>6.0</string>
      <key>CFBundleName</key>
      <string>Nicotine+</string>
      <key>CFBundlePackageType</key>
      <string>APPL</string>
      <key>CFBundleShortVersionString</key>
      <string>${version}</string>
      <key>CFBundleVersion</key>
      <string>${version}</string>
      <key>NSHighResolutionCapable</key>
      <string>True</string>
    </dict>
    </plist>
    EOF

    cp -r packaging/macos/icon.icns $APP_PATH/Resources
    makeWrapper $out/bin/nicotine $APP_PATH/MacOS/nicotine
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk4}/share/gsettings-schemas/${gtk4.name}"
    )
  '';

  doCheck = false;

  meta = with lib; {
    description = "Graphical client for the SoulSeek peer-to-peer system";
    longDescription = ''
      Nicotine+ aims to be a pleasant, free and open source (FOSS) alternative
      to the official Soulseek client, providing additional functionality while
      keeping current with the Soulseek protocol.
    '';
    homepage = "https://www.nicotine-plus.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ klntsky ];
  };
}
