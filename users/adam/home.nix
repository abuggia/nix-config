{
  inputs,
  pkgs,
  adam-neovim,
  ...
}: {

  home.stateVersion = "23.05";
  home.homeDirectory = "/Users/adam";

  home.packages = with pkgs; [
    adam-neovim.packages.${pkgs.system}.nvim
    tree
    jq
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

  programs.git = {
    enable = true;
    userName = "Adam Buggia";
    userEmail = "abuggia@gmail.com";

    extraConfig = {
      color.ui = true;
      github.user = "abuggia";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  }

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 10000;
    extraConfig = pkgs.lib.readFile ./tmux.conf;
  };

  programs.alacritty.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

}
