{ compiler ? "ghc883" ,
  pkgs ? import ./nix/nixpkgs.nix {},
}:
let
  hpkgs = pkgs.haskell.packages."${compiler}";
  lorri-repro = hpkgs.developPackage {
    root = pkgs.nix-gitignore.gitignoreSource [] ./.;
    name = "lorri-repro";
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
   then lorri-repro
   else
     pkgs.haskell.lib.dontCoverage (
       pkgs.haskell.lib.dontCheck
         (pkgs.haskell.lib.disableLibraryProfiling
           (pkgs.haskell.lib.disableExecutableProfiling
             (pkgs.haskell.lib.disableOptimization lorri-repro))))
