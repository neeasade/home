{ lib, buildPythonPackage, fetchPypi, pythonPackages }:

buildPythonPackage rec {
  pname = "xkeysnail";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ghaqrmi3vv3v3k6b8cisn4gk2l2j7zf4234mpda21lba1bg9bqf";
  };

  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [
    evdev
    xlib
    inotify-simple
  ];

  meta = with lib; {
    description = "Yet another keyboard remapping tool for X environment";
    homepage = "https://github.com/mooz/xkeysnail";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
