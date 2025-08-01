{
  inputs = {
    # === Essentials ===

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # === Essentials ===


    # === Utilities ===

    # Secret management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # === Utilities ===


    # === Niche ===

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # === Niche ===
  };



  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let

    # Extend lib with lib.custom
    lib = nixpkgs.lib.extend (self: super: {
      custom = import ./lib { inherit (nixpkgs) lib; };
    });

    baseSpecialArgs = { inherit
      inputs
      lib;
    };

  in {
    nixosConfigurations = {
      # === FM-PC-NIXOS ===
      
      "FM-PC-NIXOS" = let
        hostname = "FM-PC-NIXOS";
        
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        
	      specialArgs = baseSpecialArgs // { inherit
          hostname;
        };

      in nixpkgs.lib.nixosSystem {
        inherit system pkgs specialArgs;

        modules = [
          ./hosts/FM-PC-NIXOS/configuration.nix
        ];
      };
      
      # === FM-PC-NIXOS ===
      
      # === WSNix ===

      WSNix = let
        hostname = "WSNix";

        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};

        specialArgs = baseSpecialArgs // { inherit
          hostname;
        };

      in nixpkgs.lib.nixosSystem {
        inherit system pkgs specialArgs;

        modules = [
          ./hosts/WSNix/configuration.nix
        ];
      };

      # === WSNix ===
    };
  };
}