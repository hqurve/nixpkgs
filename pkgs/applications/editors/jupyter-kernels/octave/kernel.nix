{ lib, octave, python3Packages
,pkgs
}:

with python3Packages;

buildPythonPackage rec {
  pname = "octave-kernel";
  version = "0.34.1";

  src = fetchPypi {
    pname = "octave_kernel";
    inherit version;
    sha256 = "sha256-S3fFDdeVuBdlOj5v6pYJnyPUUFE8Ga1+w3LavLr/9v4=";
  };

  buildInputs = [ octave];
  propagatedBuildInputs = [ metakernel ipykernel jupyter_kernel_test jsonschema pytest nbconvert ];

  launcher = with pkgs;runCommand "octave-kernel-launcher" {
    inherit octave;
    python = python3.withPackages (ps: [ ps.traitlets ps.jupyter_core ps.ipykernel ps.metakernel ]);
    buildInputs = [ makeWrapper ];
  } ''
    mkdir -p $out/bin

    makeWrapper $python/bin/python $out/bin/octave-kernel \
      --add-flags "-m octave_kernel" \
      --suffix PATH : $octave/bin
  '';
  preCheck = ''
    # mkdir home
    # export HOME=home
    mkdir -p kernels/octave/
    cp octave_kernel/kernel.json kernels/octave/kernel.json

    # echo '${
      builtins.toJSON {
        argv = ["${launcher}/bin/octave-kernel" "-f" "{connection_file}"];
        name = "octave";
        language = "octave";
      }
    }' > kernels/octave/kernel.json

    # echo hi
    # cat kernels/octave/kernel.json
    # echo hi2
    export JUPYTER_PATH=$(pwd)
    
  '';

  # doCheck = false;

  meta = with lib; {
    description = "A Jupyter kernel for Octave.";
    homepage = "https://github.com/Calysto/octave_kernel";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.all;
  };
}
