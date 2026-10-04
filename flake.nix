{
  description = "Pinned development and acceptance tools for the Logto provider";
  inputs.nixpkgs.url = "tarball+https://codeload.github.com/NixOS/nixpkgs/tar.gz/c59305bab2065cfecc4944690d9eedbb56f3a9fa";
  outputs = { self, nixpkgs }: {
    devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [ pkgs.go pkgs.gotools pkgs.go-tools pkgs.govulncheck pkgs.gnumake pkgs.opentofu pkgs.python3 pkgs.postgresql_17 pkgs.nodejs_22 pkgs.actionlint ];
      };
    });
  };
}
