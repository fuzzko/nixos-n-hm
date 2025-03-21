{ pkgs, ... }: {
  general = {
    immediate_rendering = true;
    ignore_empty_input = true;
    hide_cursor = true;
  };

  background = {
    monitor = "";
    path = "screenshot";
    blur_passes = 2;
  };

  input-field = {
    monitor = "";
    size = "20%, 7%";
    dots_size = 0.28;
    dots_spacing = 0.3;
    outline_thickness = 0;
    rounding = 5;
    fade_on_empty = false;
    outer_color = "$base";
    inner_color = "$overlay1";
    font_color = "$mantle";
    fail_color = "$red";
    check_color = "$blue";
    position = "0, -10%";
    shadow_passes = 1;
    shadow_size = 1;
    font_family = "Terminess Nerd Font";
    dots_text_format = "*";
    placeholder_text = ''
      <span foreground="##$surface2Alpha"><i>Password...</i></span>
    '';
  };

  label =
  let
    date_cmd = "${pkgs.nushell}/bin/nu ${toString ./bin/date.nu}";
  in
  builtins.map (v: v // { monitor = ""; }) [
    {
      text = ''
        cmd[update:1000] ${date_cmd} clock
      '';
      text_align = "left";
      color = "$text";
      font_family = "Terminess Nerd Font";
      font_size = 27;
      shadow_passes = 2;
      position = "1.8%, 5.8%";
    }
    {
      text = ''
        cmd[update:0:1] ${date_cmd} date
      '';
      text_align = "left";
      color = "$text";
      font_family = "Terminess Nerd Font";
      font_size = 20;
      shadow_passes = 2;
      position = "1.8%, 1.8%";
    }
  ];
}
