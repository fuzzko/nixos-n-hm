{ ... }: {
  services.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "auto";
    };
    
  };
}
