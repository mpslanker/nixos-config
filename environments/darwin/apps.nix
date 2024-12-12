{ pkgs, ... }:
{
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  #
  ##########################################################################

  environment.variables.EDITOR = "nvim";

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    taps = [
      "common-fate/granted"
      "homebrew/bundle"
      "homebrew/services"
    ];

    # `brew install`
    brews = [
      "awscli"
      "azure-cli"
      "granted"
      "pipenv"
    ];

    # `brew install --cask`
    casks = [
      "1password"
      # "nikitabobko/tap/aerospace"
      "alfred"
      "bettertouchtool"
      "chatgpt"
      "docker"
      "finicky"
      "firefox@developer-edition"
      "google-chrome"
      "hammerspoon"
      "iterm2"
      "jordanbaird-ice"
      "karabiner-elements"
      "keybase"
      "microsoft-teams"
      "obsidian"
      "sf-symbols"
      "the-unarchiver"
    ];

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      "1pSafari" = 1569813296;
      # "magnet" = 441258766;
      "harvest" = 506189836;
      "outlook" = 985367838;
      "wireguard" = 1451685025;
      "xcode" = 497799835;
    };
  };
}
