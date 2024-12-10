{
  description = "Portfolio website";

  inputs = { nixpkgs.url = "nixpkgs/nixos-24.11"; };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      packages = forAllSystems (system: {
        default = import ./default.nix { pkgs = nixpkgsFor.${system}; };
      });

      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = nixpkgsFor.${system}; };
      });

      nixosModules.default = { config, lib, pkgs, ... }: {
        options.programs = {
          portfolio-website = {
            enable = lib.mkEnableOption "enables portfolio site";
            port = lib.mkOption {
              type = lib.types.int;
              description = "Port to run the site on";
              default = 3001;
            };
          };
        };

        config = lib.mkIf config.programs.portfolio-website.enable {
          systemd.services.portfolio-website = 
          let 
            pkg = pkgs.callPackage ./default.nix { inherit pkgs; };
            name = (builtins.fromJSON ( builtins.readFile ./package.json )).name;
          in
          {
            enable = true;
            path = [ pkgs.nodePackages_latest.pnpm ];

            serviceConfig = {
              ExecStart = 
                "${pkgs.bash}/bin/bash  ${pkg}/bin/${name} -p ${builtins.toString config.programs.portfolio-website.port}";
              Restart = "on-failure";
              TimeoutStartSec = 5;
              RestartSec = 2;
            };

            wantedBy = [ "multi-user.target" ];

          };
        };
      };

    in {
      inherit packages;
      inherit devShells;
      inherit nixosModules;
    };

}
