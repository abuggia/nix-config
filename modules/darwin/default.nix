{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
  environment.loginShell = pkgs.zsh;
  system.stateVersion = 4;
}
