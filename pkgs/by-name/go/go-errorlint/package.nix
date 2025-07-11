{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "go-errorlint";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "polyfloyd";
    repo = "go-errorlint";
    rev = "v${version}";
    hash = "sha256-xO9AC1z3JNTRVEpM/FF8x+AMfmspU64kUywvpMb2yxM=";
  };

  vendorHash = "sha256-pSajd2wyefHgxMvhDKs+qwre4BMRBv97v/tZOjiT3LE=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };
  meta = with lib; {
    description = "Source code linter that can be used to find code that will cause problems with Go's error wrapping scheme";
    homepage = "https://github.com/polyfloyd/go-errorlint";
    changelog = "https://github.com/polyfloyd/go-errorlint/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      meain
      polyfloyd
    ];
    mainProgram = "go-errorlint";
  };
}
