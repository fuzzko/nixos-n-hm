{ ... }:
{
  services.hypridle.enable = true;

  services.hypridle.settings = {
    general = {
      lock_cmd = ''
        pidof hyprlock || hyprlock
      '';
      before_sleep_cmd = ''
        loginctl lock-session
      '';
      after_sleep_cmd = ''
        niri msg power-on-monitors
      '';
    };

    listener =
      let
        mkListener = timeout: set: { inherit timeout; } // set;
      in
      [
        (mkListener 150 {
          on-timeout = ''
            brightnessctl -s set 10
          '';
          on-resume = ''
            brightnessctl -r
          '';
        })
        {
          timeout = 300;
          on-timeout = ''
            loginctl lock-session
          '';
        }
        {
          timeout = 330;
          on-timeout = ''
            niri msg power-off-monitors
          '';
          on-resume = ''
            niri msg power-on-monitors
          '';
        }
        {
          timeout = 1800;
          on-timeout = ''
            systemctl suspend
          '';
        }
      ];
  };
}
