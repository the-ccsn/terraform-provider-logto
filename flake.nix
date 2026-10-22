{
  description = "Pinned development and acceptance tools for the Logto provider";
  inputs.nixpkgs.url = "tarball+https://codeload.github.com/NixOS/nixpkgs/tar.gz/c59305bab2065cfecc4944690d9eedbb56f3a9fa";
  outputs = { self, nixpkgs }: {
    devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      go = pkgs.go.overrideAttrs (_: {
        version = "1.26.10";
        src = pkgs.fetchurl {
          url = "https://go.dev/dl/go1.26.10.src.tar.gz";
          hash = "sha256-/WPog7ovK/ypPBZGsx6+9j4rHk0rMXyXidl2po2B828=";
        };
      });
    in {
      default = pkgs.mkShell {
        packages = [ go pkgs.gotools pkgs.go-tools pkgs.govulncheck pkgs.gnumake pkgs.opentofu pkgs.python3 pkgs.postgresql_17 pkgs.nodejs_22 pkgs.actionlint ];
      };
    });
  };
}
