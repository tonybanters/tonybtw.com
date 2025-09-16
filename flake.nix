{
  description = "Dev shell for this tonybtw.com";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      foreach = f: builtins.listToAttrs (map (system: { name = system; value = f system; }) systems);
    in
    {
      devShells = foreach (system:
        let
          pkgs = import nixpkgs { inherit system; };
          common_pkgs = [ pkgs.hugo ];
        in
        {
          default = pkgs.mkShell {
            packages = common_pkgs;
            shellHook = ''
              echo "Hugo dev shell ready."
              hugo version
            '';
          };
          serve = pkgs.mkShell {
            packages = common_pkgs;
            shellHook = ''
              echo "Hugo dev shell ready."
              hugo serve
            '';
          };
        }
      );
    };
}

