{
  description = "Home Manager configuration of arifinoid";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";

    # neovim
    vimPlugins_git = { url = "github:dinhhuy258/git.nvim"; flake = false; };
    vimPlugins_git-conflict-nvim = { url = "github:akinsho/git-conflict.nvim"; flake = false; };
    vimPlugins_mason-null-ls = { url = "github:jay-babu/mason-null-ls.nvim"; flake = false; };
    vimPlugins_codeium = { url = "github:Exafunction/codeium.nvim"; flake = false; };
  };

  outputs = { self, nixpkgs, home-manager, utils, ... } @inputs:
    utils.lib.eachDefaultSystem (system:
      let
        config = { allowUnfree = true; };
        pkgs = import nixpkgs {
          inherit system;
          config = config;
        };

        defaultNixpkgs = {
          inherit config;
        };
      in
      {
        homeConfigurations = {
          arifinoid = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ({ pkgs, ... }:
                let
                  nixConfigDirectory = "~/.config/nixpkgs";
                  username = "arifinoid";
                  homeDirectory = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${username}";
                in
                {

                  home.stateVersion = "23.05";
                  home.username = username;
                  home.homeDirectory = homeDirectory;
                  home.shellAliases = {
                    nxb = "nix build ${nixConfigDirectory}/#homeConfigurations.${system}.${username}.activationPackage -o ${nixConfigDirectory}/result ";
                    nxa = "${nixConfigDirectory}/result/activate switch --flake ${nixConfigDirectory}/#homeConfigurations.${system}.${username}";
                  };

                  nixpkgs = {
                    overlays = [
                      (final: prev: {
                        vimPlugins = prev.vimPlugins // {
                          mason-null-ls = prev.vimUtils.buildVimPlugin {
                            name = "mason-null-ls";
                            src = inputs.vimPlugins_mason-null-ls;
                          };
                          git = prev.vimUtils.buildVimPlugin {
                            name = "git";
                            src = inputs.vimPlugins_git;
                          };
                          codeium = prev.vimUtils.buildVimPlugin {
                            name = "codeium";
                            src = inputs.vimPlugins_codeium;
                          };
                        };
                      })
                    ];
                  };
                })

              ./home/git.nix
              ./home/nvim.nix
              ./home/packages.nix
              ./home/shells.nix
              ./home/tmux.nix
            ];
          };
        };

        legacyPackages = import inputs.nixpkgs (defaultNixpkgs // { inherit system; });

        devShells = import ./devShells.nix {
          pkgs = self.legacyPackages.${system};
        };
      });
}
