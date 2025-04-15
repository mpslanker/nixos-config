{
  pkgs,
  homeDirectory,
  ...
}:
###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#  Incomplete list of macOS `defaults` commands :
#    https://github.com/yannbertrand/macos-defaults
#
###################################################################################
{
  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      # menuExtraClock.Show24Hour = true; # show 24 hour clock
      controlcenter.BatteryShowPercentage = true;

      # customize dock
      dock = {
        autohide = true;
        mru-spaces = false;
        show-recents = false;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/System/Applications/Utilities/Activity Monitor.app"
          "/Applications/ghostty.app"
          # "/Applications/iTerm.app"
          # "/System/Applications/Utilities/Terminal.app"
          # "/Applications/Safari.app"
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "/System/Applications/System Settings.app"
        ];
        persistent-others = [
          "${homeDirectory.content}/Downloads"
        ];
      };

      # customize finder
      finder = {
        _FXShowPosixPathInTitle = false; # show full path in finder title
        _FXSortFoldersFirst = true;
        _FXSortFoldersFirstOnDesktop = true;
        AppleShowAllExtensions = false; # show all file extensions
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };

      # customize settings not supported by nix-darwin directly
      # Incomplete list of macOS `defaults` commands :
      #   https://github.com/yannbertrand/macos-defaults
      NSGlobalDomain = {
        # `defaults read NSGlobalDomain "xxx"`
        "com.apple.swipescrolldirection" = false; # enable natural scrolling(default to true)
        "com.apple.sound.beep.feedback" = 0; # disable beep sound when pressing volume up/down key
        AppleInterfaceStyle = "Dark"; # dark mode
        # AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.
        # ApplePressAndHoldEnabled = true; # enable press and hold

        # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
        # This is very useful for vim users, they use `hjkl` to move cursor.
        # sets how long it takes before it starts repeating.
        InitialKeyRepeat = 15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        # sets how fast it repeats once it starts.
        KeyRepeat = 2; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)

        # NSAutomaticCapitalizationEnabled = false; # disable auto capitalization
        # NSAutomaticDashSubstitutionEnabled = false; # disable auto dash substitution
        # NSAutomaticPeriodSubstitutionEnabled = false; # disable auto period substitution
        # NSAutomaticQuoteSubstitutionEnabled = false; # disable auto quote substitution
        # NSAutomaticSpellingCorrectionEnabled = false; # disable auto spelling correction
        NSNavPanelExpandedStateForSaveMode = true; # expand save panel by default
        NSNavPanelExpandedStateForSaveMode2 = true;
      };

      # Customize settings that not supported by nix-darwin directly
      # see the source code of this project to get more undocumented options:
      #    https://github.com/rgcr/m-cli
      #
      # All custom entries can be found by running `defaults read` command.
      # or `defaults read xxx` to read a specific domain.
      CustomUserPreferences = {
        ".GlobalPreferences" = {
          # automatically switch to a new space when switching to the application
          AppleSpacesSwitchOnActivate = true;
        };
        NSGlobalDomain = {
          # Add a context menu item for showing the Web Inspector in web views
          WebKitDeveloperExtras = true;
          NSWindowShouldDragOnGesture = true; # Allow window drag anywhere with ctrl+cmd
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.screensaver" = {
          # Require password immediately after sleep or screen saver begins
          askForPassword = 1;
          askForPasswordDelay = 10;
        };
        "com.apple.screencapture" = {
          # location = "~/Desktop";
          type = "png";
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        # Prevent Photos from opening automatically when devices are plugged in
        "com.apple.ImageCapture".disableHotPlug = true;
        # Change activity monitor dock icon to cpu usage
        "com.apple.ActivityMonitor" = {
          IconType = 5;
        };
      };

      loginwindow = {
        GuestEnabled = false; # disable guest user
        SHOWFULLNAME = true; # show full name in login window
      };
    };

    # keyboard settings is not very useful on macOS
    # the most important thing is to remap option key to alt key globally,
    # but it's not supported by macOS yet.
    # keyboard = {
    #   enableKeyMapping = true; # enable key mapping so that we can use `option` as `control`

    #   remapCapsLockToControl = true; # remap caps lock to control, useful for emac users

    #   # swap left command and left alt
    #   # so it matches common keyboard layout: `ctrl | command | alt`
    #   #
    #   # disabled, caused only problems!
    #   swapLeftCommandAndLeftAlt = false;
    # };
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  environment.etc."pam.d/sudo_local".text = ''
    # Managed by Nix Darwin
    auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
    auth       sufficient     pam_tid.so
  '';

  # Set your time zone.
  # comment this due to the issue:
  #   https://github.com/LnL7/nix-darwin/issues/359
  # time.timeZone = "America/Los_Angeles";
}
