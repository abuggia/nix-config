{
  pkgs,
  adam-neovim,
  codex-cli-nix,
  claude-code,
  ...
}:
let
  agent-waiting-notify = import ./agent-waiting-notify.nix { inherit pkgs; };
  docseq = import ./docseq.nix { inherit pkgs; };
in {

  home.stateVersion = "23.05";
  home.homeDirectory = "/Users/adam";

  home.packages = with pkgs; [
    adam-neovim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
    gws
    agent-waiting-notify
    docseq
    tree
    jq
    jujutsu
    ripgrep
    fd
    awscli2
    watch
    nurl
    treemd
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
    syntaxHighlighting.enable = true;
    initContent = pkgs.lib.readFile ./.zshrc;
    autosuggestion.enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gh = {
    enable = true;

    extensions = [ pkgs.gh-stack ];

    settings = {
      git_protocol = "https";
      aliases.co = "pr checkout";
    };

    gitCredentialHelper.enable = false;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "Adam Buggia";
        email = "abuggia@gmail.com";
      };

      color.ui = true;
      github.user = "abuggia";
      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      pull.autoSetupRemote = true;
      init.defaultBranch = "main";
      extraConfig = {
        "remote \"origin\"" = {
          fetch = "+refs/heads/*:refs/remotes/origin/*";
        };
      };
    };
  };

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
