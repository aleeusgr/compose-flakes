# compose-flakes

A Nix flake is a directory that contains a flake.nix file. That file must contain an attribute set with one required attribute – outputs – and optionally description and inputs.

need to output two devShells and then compose them into one.
https://github.com/aleeusgr/compose-flakes/issues/1

a-flake -> haskell, devshell should respond to ghc --version
b-flake -> python, python --version
. -> both python and haskell


