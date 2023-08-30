{
  inputs,
  pkgs,
  adam-neovim,
  ...
}: {

  home.stateVersion = "23.05";
  home.homeDirectory = "/Users/adam";

  home.packages = [
    adam-neovim.packages.${pkgs.system}.nvim
  ];

  programs.bat = {
    enable = true;
    # config.theme = "TwoDark";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    initExtra = pkgs.lib.readFile ./.zshrc;
  };
  
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git.enable = true;

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 10000;
    extraConfig = pkgs.lib.readFile ./tmux.conf;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  }

}
