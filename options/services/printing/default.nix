{ pkgs, ... }: {
  services.printing.enable = true;
  services.printing = {
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      (epson-201401w.override {
        stdenv = clangStdenv;
      })
    ];
  };
}
