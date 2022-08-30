{
  description = "A very basic flake";
  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs"; 
      flake-utils.url = "github:numtide/flake-utils";
      # local directories (for absolute paths you can omit 'path:')
      a-flake.url = "/home/alex/workshop/nix/compose-flakes/a-flake";
      b-flake.url = "/home/alex/workshop/nix/compose-flakes/b-flake";
      pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
      pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
      pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
    };
    outputs = { 
      self, 
      nixpkgs, 
      a-flake, 
      pre-commit-hooks,
      b-flake }: # @ inputs:  #@ inputs; from Nobbz.
  #{
    (
      system: let
        inherit (nixpkgs) lib; # lib = nixpkgs.lib
        pkgs = nixpkgs.legacyPackages.${system};
        warnToUpdateNix = pkgs.lib.warn "Consider updating to Nix > 2.7 to remove this warning!";
        #src = lib.sourceByRegex self [
        #  "^benchmark.*$"
        #  "^models.*$"
        #  "^monad-bayes\.cabal$"
        #  "^src.*$"
        #  "^test.*$"
        #  "^.*\.md"
        #];
        #monad-bayes = pkgs.haskell.packages.ghc902.callCabal2nixWithOptions "monad-bayes" src "--benchmark" {};
        #cabal-docspec = let
        #  ce =
        #    haskell-nix-utils.packages.${system}.pkgs.callPackage
        #    (import "${haskell-nix-utils}/project/cabal-extras.nix") {
        #      self = haskell-nix-utils;
        #      inherit (haskell-nix-utils.packages.${system}) compiler-nix-name index-state;
        #    };
        ##this was misleading initially wit `let` above
        #in
        #  ce.cabal-docspec.components.exes.cabal-docspec;
        monad-bayes-dev = pkgs.mkShell {
          #inputsFrom = [monad-bayes.env];
          packages = with pre-commit-hooks.packages.${system}; [
            #alejandra
            #cabal-fmt
            #hlint
            #ormolu
            #cabal-docspec
          ];
          shellHook =
            pre-commit.shellHook
            + ''
              echo "=== monad-bayes development shell ==="
            '';
        };
        pre-commit = pre-commit-hooks.lib.${system}.run {
        #  inherit src;
          hooks = {
        #    alejandra.enable = true;
        #    cabal-fmt.enable = true;
        #    hlint.enable = false;
        #    ormolu.enable = true;
          };
        };
      in rec { #rec for record?
        packages = {inherit pre-commit;};
        #packages.default = packages.monad-bayes;
        #checks = {inherit monad-bayes pre-commit;};
        devShells.default = monad-bayes-dev;
        # Needed for backwards compatibility with Nix versions <2.8
        defaultPackage = warnToUpdateNix packages.default;
        devShell = warnToUpdateNix devShells.default;
      }
    );
  #};
}
