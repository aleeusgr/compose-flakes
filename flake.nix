#https://github.com/tweag/monad-bayes/blob/master/flake.nix
{
  description = "A very basic flake";
  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs"; 
      flake-utils.url = "github:numtide/flake-utils";
      # local directories (for absolute paths you can omit 'path:')
      #a-flake.url = "/home/alex/workshop/nix/compose-flakes/a-flake"; 
      # git urls
      #github:edolstra/nix-warez?dir=blender: A flake in a subdirectory of a GitHub repository.
      #a-flake.url = "github:edolstra/nix-warez?dir=blender";
      a-flake.url = "github:aleeusgr/compose-flakes?dir=a-flake";
      b-flake.url = "/home/alex/workshop/nix/compose-flakes/b-flake";
      pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
      #what's follows?
      pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
      pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
    };
    outputs = { 
      self, 
      flake-utils,
      nixpkgs, 
      pre-commit-hooks,
      a-flake, 
      b-flake 
    } @ inputs:  # from Nobbz.
  flake-utils.lib.eachSystem
    [
      # Tier 1 - Tested in CI
      flake-utils.lib.system.x86_64-linux
      flake-utils.lib.system.x86_64-darwin
      # Tier 2 - Not tested in CI (at least for now)
      flake-utils.lib.system.aarch64-linux
      flake-utils.lib.system.aarch64-darwin
    ]
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

        b-shell = inputs.b-flake.devShell.${system};
        a-shell = inputs.a-flake.devShell.x86_64-linux;
        mainShell = pkgs.mkShell {
          inputsFrom = [a-shell b-shell];
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
              echo "this is a nix shell ${system}"
            '';
        };
        pre-commit = pre-commit-hooks.lib.${system}.run { 
          src = " " ; #won't run without this line
          hooks = {
        #    alejandra.enable = true;
        #    cabal-fmt.enable = true;
        #    hlint.enable = false;
        #    ormolu.enable = true;
          };
        };
      in rec { #rec for record?, this lists stuff needed for nix [run shell develop]
        packages = {inherit pre-commit;}; # line 69?
        #packages.default = packages.monad-bayes; #need a generic default package
        #checks = {inherit monad-bayes pre-commit;};
        devShells.default = mainShell;
        # Needed for backwards compatibility with Nix versions <2.8
        defaultPackage = warnToUpdateNix packages.default; #maybe I can remove packages.default??
        devShell = warnToUpdateNix devShells.default;
      }
    );
}
