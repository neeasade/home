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

  modSha256 = "0s1k5k5q15lf58p5d450myv9rhh42ylq12px6ar9yn2ir871fpj4";
  
  meta = with lib; {
    homepage = "https://github.com/tadeokondrak/ircdiscord";
    description = "Connect to Discord from your IRC client";
    platforms = platforms.linux;
    license = licenses.isc;
  };
}
