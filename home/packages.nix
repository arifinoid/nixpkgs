{ pkgs, ... }:
{
  home.packages = with pkgs; [
    asciiquarium
    openssh
    curl
    wget
    ack
    neofetch
    ripgrep
    trash-cli
    xclip
    xsel
    openvpn
    openvpn3
    alacritty
    nodejs_20
    yarn
    go
    gcc9
    libstdcxx5
    python39
    nerdfonts
    rustc
    cargo
    zig
    fishPlugins.bass
    speedtest-cli
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;


  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;
}