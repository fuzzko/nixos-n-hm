{ config, ... }:
{
  autoUpdate = true;
  autoUpdateNotification = true;
  useQuickCSS = true;
  eagerPatches = true;

  plugins = {
    "WebRichPresence (arRPC)" = {
      enabled = config.services.arrpc.enable;
    };
    ClearURLs = {
      enabled = true;
    };
    BlurNSFW = {
      enabled = true;
    };
    NoTypingAnimation = {
      enabled = true;
    };
    NoProfileThemes = {
      enabled = true;
    };
    ForceOwnerCrown = {
      enabled = true;
    };
    QuickReply = {
      enabled = true;
    };
    Dearrow = {
      enabled = true;
    };
    BetterSettings = {
      enabled = true;

      disableFade = true;
      eagerLoad = true;
    };
    NoUnblockToJump = {
      enabled = true;
    };
    WebScreenShareFixes = {
      enabled = true;
    };
    CallTimer = {
      enabled = true;
    };
    MessageTags = {
      enabled = true;

      tagsList =
        let
          raw = builtins.fetchurl "https://github.com/ravener/termux-bot/blob/main/data/tags.json";
          unfixed = builtins.fromJSON (builtins.readFile raw);
          fixed = map (x: {
            name = "termux:${x.name}";
            value = {
              name = "termux:${x.name}";
              message = (builtins.foldl' (s1: s2: s1 + s2) (builtins.head x.content) (builtins.tail x.content));
            };
          }) unfixed;
        in
        builtins.listToAttrs fixed;
    };
  };
  NoDevtoolsWarning = {
    enabled = true;
  };
  FixImagesQuality = {
    enabled = true;
  };
  YoutubeAdBlock = {
    enabled = true;
  };
  BadgeAPI = {
    enabled = true;
  };
  NoTrack = {
    enabled = true;
    disableAnalytics = true;
  };
  ValidReply = {
    enabled = true;
  };
  ValidUser = {
    enabled = true;
  };
}
