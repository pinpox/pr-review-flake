{
  description = "Flake to test PR's in CI";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-21.11";
  inputs = {

    dsluijk.url = "github:dsluijk/nixpkgs";

  };

  outputs =
    { nixpkgs, ... }@inputs:
    let

      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsForFork = forAllSystems (system: nixpkgsFork: import nixpkgsFork { inherit system; });

    in
    {

      packages = forAllSystems (
        system: with inputs; {

          # Packages from specific forks/PR's
          orca-slicer = (nixpkgsForFork.${system} dsluijk).orca-slicer;
          bambu-studio = (nixpkgsForFork.${system} dsluijk).bambu-studio;
        }
      );

    };
}
