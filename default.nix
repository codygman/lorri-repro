{ compiler ? "ghc883" ,
  pkgs ? import ./nix/nixpkgs.nix {},
}:
let
  inherit (import (builtins.fetchTarball "https://github.com/hercules-ci/gitignore/archive/7415c4f.tar.gz") { }) gitignoreSource;
  hpkgs = pkgs.haskell.packages."${compiler}";
  smurf = hpkgs.developPackage {
    root = pkgs.lib.cleanSourceWith
      { filter = (path: type:
          ! (builtins.any
            (r: (builtins.match r (builtins.baseNameOf path)) != null)
            [
              "README.md"
              "notes"
              "dist-newstyle"
              "ops"
              "tf"
              ".ghcid"
              ".dir-locals.el"
              ".semaphore"
            ])
        );
        src = gitignoreSource ./.;
      } ;
    name = "smurf";
    modifier = drv:
      with pkgs.haskellPackages;
      pkgs.haskell.lib.disableOptimization (pkgs.haskell.lib.overrideCabal drv (attrs: {
        doCoverage = false;
        doCheck = true; # whether to run tests
        enableLibraryProfiling = false;
        enableExecutableProfiling = false;
        doHaddock = false;
        buildTools = [ brittany
                       cabal-install
                       ghcid
                       ghcide
                       hlint
                       hpack
                     ];
      }));
  };
in if pkgs.lib.inNixShell
   then smurf
   else
     pkgs.haskell.lib.dontCoverage (
       pkgs.haskell.lib.dontCheck
         (pkgs.haskell.lib.disableLibraryProfiling
           (pkgs.haskell.lib.disableExecutableProfiling
             (pkgs.haskell.lib.disableOptimization smurf))))
