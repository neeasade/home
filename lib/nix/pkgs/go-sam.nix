{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "go-sam";
  version = "latest";

  src = fetchFromGitHub {
    owner = "9fans";
    repo = "go";
    rev = "0b266bf61944ab69dd1615779506e899eb814d21";
    sha256 = "0zixxqbk6d4idhsrs9l3yj4q5jni2513hz6swhxpln6f8msa7cp6";
  };

  vendorSha256 = "1ijn8g0yvmg2jp4sr21ccmgnmzqgrp5f4xkcxzw4yypjnz6ih2mb";
  subPackages = [ "cmd/sam" ];

  meta = with lib; {
    description = "Go rewrite of the Sam text editor.";
    homepage = "https://9fans.github.io";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
