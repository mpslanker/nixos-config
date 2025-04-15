{ pkgs, ... }:
{
  targets.darwin.defaults."com.apple.Safari".IncludeDevelopMenu = true;
  targets.darwin.defaults."com.apple.Safari".ShowFavoritesBar-v2 = 1;
  targets.darwin.defaults."com.apple.Safari".ShowOverlayStatusBar = true;
  targets.darwin.defaults."com.apple.Safari".AutoFillPasswords = false;
  targets.darwin.defaults."com.apple.Safari".AutoOpenSafeDownloads = false;
}
