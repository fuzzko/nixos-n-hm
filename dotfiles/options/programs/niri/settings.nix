{ config, lib, ... }:
let
  inherit (builtins)
    listToAttrs
    ;
  inherit (config.lib.niri) actions;

  utils = import ./utils.nix;

  defaultTerminal = "foot";
  defaultLauncher = "anyrun";
in
{
  outputs."VGA-1" = {
    focus-at-startup = true;
  };

  input = {
    workspace-auto-back-and-forth = true;

    # focus-follow.enable = true;
    # focus-follow.max-scroll-amount = "10%";
  };

  gestures = {
    dnd-edge-view-scroll = {
      trigger-width = 100;
      delay-ms = 300;
      max-speed = 3000;
    };

    hot-corners.enable = true;
  };

  layout =
    let
      inherit (utils)
        decoration
        ;
    in
    {
      gaps = 16;

      center-focused-column = "on-overflow";
      always-center-single-column = true;
      empty-workspace-above-first = true;

      default-column-width = { };

      border = {
        enable = true;

        width = 4.0;

        active =
          with decoration;
          gradient {
            relative-to = "workspace-view";
            angle = 45;
            from = "#2c5484";
            to = "#6eb0ff";
          };
        inactive = with decoration; color "#838a97";
        urgent = with decoration; color "#9d5800";
      };

      shadow.enable = true;
      shadow = {
        color = "#000";
        softness = 8;
        offset = {
          x = 3;
          y = 3;
        };
      };

      focus-ring.enable = false;

      insert-hint.enable = true;
      insert-hint.display = with decoration; color "254862";

      struts = {
        top = 10;
        bottom = 10;
      };

      background-color = "#2c5484";
    };

  # a hidden* workspace, used to hide windows
  workspaces."special" = { };

  environment = {
    # force electron to open as wayland client
    "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
    # fix java apps shows up blank under xwayland-satellite
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
  };

  spawn-at-startup =
    let
      inherit (utils.spawn-at-startup)
        spawn
        spawn-sh
        ;
      service = spawn "systemctl" "--user" "start";
    in
    map (x: builtins.removeAttrs x [ "__functor" ]) [
      (spawn "wl-paste" "--type" "text" "--watch" "cliphist" "store")
      (spawn "wl-paste" "--type" "image" "--watch" "cliphist" "store")

      (service "wpaperd.service")
      (service "wired.service")
      (service "hypridle.service")
      (service "kidex.service")
      (spawn "eww" "daemon")

      (service "niri-session.target")

    ];

  binds =
    let
      # generates `Mod+${i}` binds to switch workspace based on idx
      workspaceBinds = listToAttrs (
        map (i: {
          name = "Mod+${toString i}";
          value = {
            action = with actions; focus-workspace i;
          };
        }) (lib.range 1 9)
      );
    in
    workspaceBinds
    // {
      "Mod+Shift+Slash".action = with actions; show-hotkey-overlay;
      "Ctrl+Alt+Delete".action = with actions; quit;

      "Mod+0" = {
        action = with actions; focus-workspace "special";
        hotkey-overlay.title = "Open special workspace";
      };

      "Mod+Left".action = with actions; focus-column-left;
      "Mod+Right".action = with actions; focus-column-right;
      "Mod+Up".action = with actions; focus-window-or-workspace-up;
      "Mod+Down".action = with actions; focus-window-or-workspace-down;

      "Mod+Home".action = with actions; focus-column-first;
      "Mod+End".action = with actions; focus-column-left;

      "Mod+Shift+Left".action = with actions; move-column-left;
      "Mod+Shift+Right".action = with actions; move-column-right;
      "Mod+Shift+Up".action = with actions; move-window-to-workspace-up { focus = true; };
      "Mod+Shift+Down".action = with actions; move-window-to-workspace-down { focus = true; };

      # don't ask why this was binded as clipboard history
      "Alt+XF86Calculator" = {
        action =
          with actions;
          spawn-sh ''
            cliphist list | anyrun --plugins libstdin.so | cliphist decode | wl-copy
          '';
        repeat = false;
        hotkey-overlay.title = "Open clipboard history";
      };

      "Mod+C" = {
        action = with actions; close-window;
        repeat = false;
      };
      "Mod+Alt+C" = {
        action = with actions; spawn "nu" (toString ./scripts/sigkill-focused-window.nu);
        repeat = false;
        hotkey-overlay.title = "Force close a window";
      };

      "Mod+F".action = with actions; toggle-window-floating;
      "Mod+V".action = with actions; fullscreen-window;

      "Mod+Q".action = with actions; spawn defaultLauncher;
      "Mod+Shift+Q".action = with actions; spawn defaultTerminal;

      "Print".action = with actions; screenshot;
      "Mod+Print".action = with actions; screenshot-window;
      # "Ctrl+Print".action = with actions; screenshot-screen;
    };

  window-rules =
    let
      inherit (utils.window-rules) matches;

      radius = x: {
        bottom-left = x;
        bottom-right = x;
        top-left = x;
        top-right = x;
      };
    in
    [
      {
        open-focused = true;
        clip-to-geometry = true;
        geometry-corner-radius = radius 12.0;
      }

      {
        matches = with matches; [
          (app-id "^steam$")
          (title ''^notificationtoasts_\d+_desktop$'')
        ];

        default-floating-position = {
          x = 10;
          y = 10;
          relative-to = "bottom-right";
        };
      }

      {
        matches = with matches; [
          (app-id "^xdg-desktop-portal-.*$")
        ];

        open-floating = true;
        default-column-width.proportion = .55;
        default-window-height.proportion = .57;
      }

      {
        matches = with matches; [
          (app-id "^foot$")
        ];

        open-floating = true;
      }
    ];

  animations =
    let
      inherit (utils.animations)
        kind
        mkCurveArgs
        ;
    in
    {
      enable = true;

      window-open.enable = true;
      window-open.kind =
        with kind;
        easing {
          duration-ms = 150;
          curve = "ease-out-cubic";
        };

      window-close.enable = true;
      window-close.kind =
        with kind;
        easing {
          duration-ms = 150;
          curve = "ease-out-expo";
        };

      workspace-switch.enable = true;
      workspace-switch.kind =
        with kind;
        spring {
          damping-ratio = 1.0;
          stiffness = 1000;
          epsilon = 0.0001;
        };

      horizontal-view-movement.enable = true;
      horizontal-view-movement.kind =
        with kind;
        spring {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };

      window-movement.enable = true;
      window-movement.kind =
        with kind;
        spring {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };

      window-resize.enable = true;
      window-resize.kind =
        with kind;
        spring {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };

      config-notification-open-close.enable = true;
      config-notification-open-close.kind =
        with kind;
        spring {
          damping-ratio = 0.6;
          stiffness = 800;
          epsilon = 0.0001;
        };

      screenshot-ui-open.enable = true;
      screenshot-ui-open.kind =
        with kind;
        easing {
          duration-ms = 200;
          curve = "ease-out-quad";
        };

      overview-open-close.enable = true;
      overview-open-close.kind =
        with kind;
        spring {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };
    };

  hotkey-overlay.hide-not-bound = true;

  xwayland-satellite.enable = true;
}
