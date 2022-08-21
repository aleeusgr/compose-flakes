{
  description = "A very basic flake";
  inputs = {
      # flake-utils.url = "github:numtide/flake-utils";
      # local directories (for absolute paths you can omit 'path:')
      a-flake.url = "path:./a-flake";
      b-flake.url = "path:./b-flake";
    };
  outputs = { self, nixpkgs, }: 
    {
    devShell = nixpkgs.mkShell {
          buildInputs = with nixpkgs; [
          ];
          #inputsFrom = builtins.attrValues self.packages.${system};
        }; 
    };
}
