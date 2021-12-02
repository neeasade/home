# Mainly upower

{ config, pkgs, ... }:

{
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
    cpufreq.max = 1800000;
  };

  boot = {
    kernel.sysctl = {
      "vm.laptop_mode" = 5;
      "kernel.nmi_watchdog" = 0; # I don't think I have to worry about kernel panics here.
    };
    extraModprobeConfig = ''
      # Suspend audio card after idle time of 1 second
      options snd_hda_intel power_save=1
    '';
  };

  services = {
    udev.extraRules = ''
      # Disable wakeonlan
      ACTION=="add", SUBSYSTEM=="net", NAME=="enp*", RUN+="${pkgs.ethtool}/sbin/ethtool -s $name wol d"
      ACTION=="add", SUBSYSTEM=="net", NAME=="wlp*", RUN+="${pkgs.ethtool}/sbin/ethtool -s $name wol d"
    '';

    # Battery care stuff are, unfortunately, not suppored for my
    # laptop.  See: https://linrunner.de/tlp/settings/battery.html
    tlp = {
      enable = true;
      settings = {
        SOUND_POWER_SAVE_ON_AC = 1;
        SOUND_POWER_SAVE_ON_BAT = 1;

        DISK_DEVICES = "ata-SAMSUNG_MZNLN128HAHQ-000H1_S3T8NA2K935889";
        DISK_IDLE_SECS_ON_AC = 2;

        # Hardware Dependent.  See https://linrunner.de/tlp/settings/graphics.html
        INTEL_GPU_MIN_FREQ_ON_BAT = 300;
        INTEL_GPU_MAX_FREQ_ON_BAT = 300;

        NMI_WATCHDOG = 0;

        # From https://linrunner.de/tlp/settings/network.html,
        # > Power saving mode can cause an unstable Wi-Fi link.
        # Could that be the reason why I'm getting random disconnects?
        # If so, that's kind of annoying.
        WIFI_PWR_ON_AC = "on";
        WIFI_PWR_ON_BAT = "on";
        WOL_DISABLE = "Y";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
      };
    };
  };

  # Try to disable ethernet?
  systemd.services."disable-ethernet" = {
    wantedBy = [ "network.target" ];
    after = [ "network-setup.service" ];
    description = "Set enp1s0 down";
    path = [ pkgs.iproute ];
    script = ''
      ip link set enp1s0 down
      echo "Network enp1s0 is down"
    '';
  };
}
