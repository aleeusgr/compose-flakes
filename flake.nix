{
  description = "A very basic flake";
  inputs = {
      #nixpkgs.url = "github:nixos/nixpkgs"; 
      # flake-utils.url = "github:numtide/flake-utils";
      # local directories (for absolute paths you can omit 'path:')
      a-flake.url = "path:./a-flake";
      b-flake.url = "path:./b-flake";
    };
  outputs = { self, nixpkgs }: 
    {
    devShell = nixpkgs.mkShell {
          buildInputs = with nixpkgs; [
          ];
          inputsFrom = [self.devShell.a-flake self.devShell.b-flake];
    };
  };
}
