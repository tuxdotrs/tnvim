{
  stdenv,
  lib,
}: let
  nvim = ./src;
in
  stdenv.mkDerivation {
    pname = "tnvim";
    version = "2.5.0";

    buildCommand = ''
      mkdir -p $out
      cp -r ${nvim}/* "$out/"
    '';

    meta = with lib; {
      description = "tux's nvim config";
      homepage = "https://tux.rs";
      platforms = platforms.all;
      license = licenses.gpl3;
    };
  }
