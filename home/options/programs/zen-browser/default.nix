{ npins, pkgs, lib, ... }:
{
  programs.zen-browser.enable = true;
  programs.zen-browser.profiles.default = {
    preConfig = lib.readFile "${npins.betterfox}/user.js";

    extraConfig = ''
      /** SmoothFox **/

      user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
      user_pref("general.smoothScroll", true); // DEFAULT
      user_pref("mousewheel.default.delta_multiplier_y", 275); // 250-400; adjust this number to your liking
      // Firefox Nightly only:
      // [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1846935
      user_pref("general.smoothScroll.msdPhysics.enabled", false); // [FF122+ Nightly]
    '';

    extensions = {
      force = true;
      
      packages = with pkgs.nur.repos.rycee.firefox-addons; [
        refined-github
        ublock-origin
        violentmonkey
      ];

      settings = {
        "uBlock0@raymondhill.net".settings = {
          selectedFilterLists = [
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"

            "ublock-cookies-easylist"
            "fanboy-cookiemonster"
            
            "easylist"
            "adguard-spyware-url"
            "urlhaus-1"
            "plowe-0"
            "fanboy-social"
            "easylist-annoyances"
            "ublock-annoyances"     
          ];
        };
      };
    };
  };
}
