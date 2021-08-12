{ lib, stdenv, fetchurl
, jdk, runtimeShell, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "jdt-ls";
  version = "1.2.0";
  timestamp = "202106301459";

  src = fetchurl {
    url = "https://download.eclipse.org/jdtls/milestones/${version}/jdt-language-server-${version}-${timestamp}.tar.gz";
    sha256 = "sha256-qkzh7J67DnOMzqyms1WxGcCfnZL25xpUTKwTnHxpb+c=";
  };

  sourceRoot = ".";

  buildInputs = [ jdk ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = let
    configPath = 
      if stdenv.isLinux then "config_linux"
      else if stdenv.isDarwin then "config_mac"
      else if stdenv.isWindows then "config_win"
      else throw "unsupported platform";
    JARs_dir = "$out/share/java/jdtls";
  in
  ''
    mkdir -p ${JARs_dir}
    cp -R ${configPath} features plugins ${JARs_dir}

    mkdir -p $out/bin
    cp ${./launcher.sh} $out/bin/jdt-ls
    chmod +x $out/bin/jdt-ls
    substituteInPlace $out/bin/jdt-ls \
      --subst-var-by shell ${runtimeShell} \
      --subst-var-by out $out \
      --subst-var-by JARs_dir ${JARs_dir} \
      --subst-var-by configPath ${configPath} \
      --subst-var-by java "${jdk}/bin/java"

  '';
}
