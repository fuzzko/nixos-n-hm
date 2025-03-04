{
  config,
  root,
  lib,
  ...
}:
let
  inherit (lib) attrsets lists;

  terminal = "alacritty";
  runner = "wofi --show drun";
  fileManager = "nautilus";

  cursorSize = 30;

  makeEnv = x: attrsets.mapAttrsToList (name: value: "${name},${toString value}") x;
in
{
  exec-once = [
    terminal
    "systemctl --user start dunst.service"
    "systemctl --user start hyprpolkitagent.service"
    "systemctl --user start hypridle.service"
    "wpaperd -d"
    "wluma &"
    "clipse -listen"
  ];

  monitor = ",preferred,auto,auto";

  env = makeEnv rec {
    "XCURSOR_SIZE" = cursorSize;
    "HYPRCURSOR_SIZE" = cursorSize;
    "XDG_PICTURES_DIR" = /${config.home.homeDirectory}/Pictures;
  };

  general = {
    gaps_in = 5;
    gaps_out = 20;

    border_size = 2;

    resize_on_border = true;

    allow_tearing = false;

    layout = "dwindle";
  };

  decoration = {
    rounding = 10;

    active_opacity = 1.0;
    inactive_opacity = 0.8;

    blur = {
      enabled = true;
      size = 3;
      passes = 1;
      vibrancy = 0.1696;
    };
  };

  animations = {
    enabled = true;

    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  master = {
    new_status = "master";
  };

  misc = {
    force_default_wallpaper = -1;
    disable_hyprland_logo = false;
  };

  input = {
    kb_layout = "us";
    kb_variant = "";
    kb_model = "";
    kb_options = "";
    kb_rules = "";

    follow_mouse = 1;

    sensitivity = 0;

    touchpad.natural_scroll = false;
  };

  gestures = {
    workspace_swipe = false;
  };

  windowrulev2 =
    let
      alacritty = "^(Alacritty)$";
      clipse = "^(clipse)$";
      sober = "^(org.vinegarhq.Sober)$";
      portal = "^(xdg-desktop-portal-.*)$";
    in
    [
      "suppressevent maximize, class:.*"
      "nofocus, class:^$, title:^$, xwayland:1, floating:1,fullscreen:1, pinned:1"
      "float,class:${alacritty},tittle:${alacritty}"
      "float, class:${clipse}"
      "size 622 652, class:${clipse}"
      "pin, class:${clipse}, title:(Sober)"
      # *** Sober -> Fix the external UI
      "float, class:${sober}, title:negative:(Sober)"
      "size 900 688, class:${sober}, title:negative:(Sober)"
      "move onscreen, class:${sober}, title:negative:(Sober)"
      "center, class:${sober}, title:negative:(Sober)"
      "noborder 1, class:${sober}, title:negative:(Sober)"
      # ***
      "fullscreen, class:${sober}" # Might resolve the shiftlock issue
      # *** Make selection more appropriate
      "float, class:${portal}"
      "size 725 443, class:${portal}"
      "move onscreen, class:${portal}"
      "center, class:${portal}"
    ];

  bind =
    let
      passmenu = toString (root + /bin/passmenu);
    in
    lists.flatten ([
      "SUPER, Q, exec, ${terminal}"
      "SUPER, E, exec, ${fileManager}"
      "SUPER, V, togglefloating,"
      "SUPER, R, exec, ${runner}"
      "SUPER, P, pseudo,"
      "SUPER, J, togglesplit,"

      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"

      (builtins.map (
        v:
        let
          bind = toString v;
          workspace = toString (if v == 0 then 10 else v);
        in
        [
          "SUPER, ${bind}, workspace, ${workspace}"
          "SHIFT + SUPER, ${bind}, movetoworkspace, ${workspace}"
        ]
      ) (lists.range 0 9))
      "SUPER, S, togglespecialworkspace, magic"
      "SHIFT + SUPER, S, movetoworkspace, special:magic"

      "SUPER, mouse_down, workspace, e+1"
      "SUPER, mouse_up, workspace, e-1"

      "SUPER, PRINT, exec, hyprshot -m window --freeze"
      ", PRINT, exec, hyprshot -m output --freeze"
      "SHIFT + SUPER, PRINT, exec, hyprshot -m region --freeze"

      "SHIFT + SUPER, V, exec, alacritty --class clipse -e clipse"

      "SHIFT + SUPER, R, exec, kooha"

      "CTRL + SUPER, P, exec, ${passmenu}"
      "CTRL + SUPER, R, exec, ${passmenu} -o"
      "SHIFT + SUPER, C, killactive,"
      "SHIFT + SUPER, M, exit,"
    ]);

  bindm = [
    "SUPER, mouse:272, movewindow"
    "SUPER, mouse:273, resizewindow"
  ];

  bindel = [
    ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
    ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
  ];

  bindl = [
    ",XF86AudioNext, exec, playerctl next"
    ",XF86AudioPause, exec, playerctl play-pause"
    ",XF86AudioPlay, exec, playerctl play-pause"
    ",XF86AudioPrev, exec, playerctl previous"
  ];
}
