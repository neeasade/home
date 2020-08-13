{ lib, buildGoModule }:

buildGoModule rec {
  pname = "ircdiscord";
  version = "unstable";

  subPackages = [ "cmd/ircdiscord" ];

  src = builtins.fetchGit {
    url = "https://github.com/tadeokondrak/ircdiscord";
    ref = "master";
    rev = "db9efb86a7a0d178dc64f868530aec7dc6cbfdcf";
  };

  vendorSha256 = "17y92b8h8lhdv0j7p5wzlzw7w9snn9w6idfd5f5pfi84iknlq4lk";

  doCheck = false;
  
  meta = with lib; {
    homepage = "https://github.com/tadeokondrak/ircdiscord";
    description = "Connect to Discord from your IRC client";
    platforms = platforms.linux;
    license = licenses.isc;
  };
}
