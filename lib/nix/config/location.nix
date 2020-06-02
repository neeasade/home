# Locale, timezone and location-specific settings

{ config, ... }:

{
  console = {
#   keyMap = "us";
    useXkbConfig = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Asia/Calcutta";

  # Kolkata
  location = {
    latitude = 22.56;
    longitude = 88.36;
  };
}
