{ ... }: {
  services.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      energy_perf_bias = 
    };
  };
}
