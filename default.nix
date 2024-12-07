{ pkgs ? import <nixpkgs> { } }:
pkgs.buildNpmPackage rec {
  version = "v0.0.0.test";
  pname = "portfolio";
  src = ./.;
  npmDepsHash = "sha256-Cl7bgcZ3Xp762jvRvFsCvKvLsgX6dAeVhecza8Ebs8E=";
  postInstall = ''
    mkdir -p $out/bin
    exe="$out/bin/${pname}"
    lib="$out/lib/node_modules/${pname}"
    cp -r ./.next $lib
    touch $exe
    chmod +x $exe
    echo "
        #!/usr/bin/env bash
        cd $lib
        ${pkgs.nodePackages_latest.pnpm}/bin/pnpm run start" > $exe
  '';
}
