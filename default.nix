{ pkgs ? import <nixpkgs> { } }:
with builtins;
let 
  packageConfig = fromJSON ( readFile ./package.json );

  srcDir = with pkgs.lib.fileset; toSource {
    root = ./.;
    fileset =
    let
      # IIRC cleanSource removes .git
      cleaned = fromSource (pkgs.lib.cleanSource ./.);

      nixFiles = fileFilter (f: f.hasExt "nix") ./.;

      gitignores = fileFilter (f: f.name == ".gitignore") ./.;

      other = unions ( map maybeMissing [ 
        ./result 
        ./.direnv
        ./.github 
        ./.idea
        ./.envrc
        
        ./flake.lock

        ./node_modules
        ./.next 
        
        ./README.md
      ] );

      fileset = difference cleaned ( unions [ 
        nixFiles 
        gitignores 
        other 
      ] ); 
    in trace fileset fileset;
  };
in

pkgs.buildNpmPackage rec {
  version = packageConfig.version;
  pname = packageConfig.name;
  src = srcDir;
  
  npmDepsHash = "sha256-pQXPbZsR4uJvArAafShoNuzm+qhKWtsmgoHTUxyNUfY=";

  npmInstallFlags = ["--force"];

  makeCacheWritable = true;

  npmFlags = [ "--legacy-peer-deps" ];

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
        ${pkgs.nodePackages_latest.pnpm}/bin/pnpm run start \$@" > $exe
  '';
}