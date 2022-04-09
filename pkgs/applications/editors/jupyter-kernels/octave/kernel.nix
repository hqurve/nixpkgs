{ lib, octave, python3Packages
,pkgs
}:

with python3Packages;

buildPythonPackage rec {
  pname = "octave-kernel";
  version = "0.34.2";

  src = /home/joshua/kde/src/octave-kernel/octave_kernel;
  # src = fetchPypi {
  #   pname = "octave_kernel";
  #   inherit version;
  #   sha256 = "sha256-5ki2lekfK7frPsmPBIzYQOfANCUY9x+F2ZRAQSdPTxo=";
  # };

  buildInputs = [ octave];
  propagatedBuildInputs = [ metakernel ipykernel jupyter_kernel_test jsonschema pytest nbconvert ];

  launcher = with pkgs; runCommand "octave-kernel-launcher" {
    inherit octave;
    python = python3.withPackages (ps: [ ps.traitlets ps.jupyter_core ps.ipykernel ps.metakernel ]);
    buildInputs = [ makeWrapper ];
  } ''
    mkdir -p $out/bin

    makeWrapper $python/bin/python $out/bin/octave-kernel \
      --add-flags "-m octave_kernel" \
      --suffix PATH : $out/bin

    makeWrapper $octave/bin/octave-cli $out/bin/octave
  '';
  checkInputs = [ octave ];
  preCheck = ''
    mkdir home
    export HOME=$(realpath home)
    # mkdir -p myjup/kernels/octave/
    # cp octave_kernel/kernel.json myjup/kernels/octave/kernel.json

    # echo '${
      builtins.toJSON {
        argv = ["${launcher}/bin/octave-ke" "-f" "{connection_file}"];
        name = "octave";
        language = "octave";
      }
    }' > myjup/kernels/octave/kernel.json

    # echo hi
    # cat kernels/octave/kernel.json
    # echo hi2
    # export JUPYTER_PATH=$(pwd)/myjup
    
  '';
  checkPhase = ''
    runHook preCheck
    ${launcher.python}/bin/python -m octave_kernel.check
    runHook postCheck
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
