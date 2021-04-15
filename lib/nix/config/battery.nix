# Mainly upower

{ config, pkgs, ... }:

{
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
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
    tlp = {
      enable = true;
      settings = {
        WOL_DISABLE = "Y";
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
