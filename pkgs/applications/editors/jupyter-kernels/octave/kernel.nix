{ lib, octave, python3Packages }:

with python3Packages;

buildPythonPackage rec {
  pname = "octave-kernel";
  version = "0.34.1";

  src = fetchPypi {
    pname = "octave_kernel";
    inherit version;
    sha256 = "sha256-S3fFDdeVuBdlOj5v6pYJnyPUUFE8Ga1+w3LavLr/9v4=";
  };

  propagatedBuildInputs = [ metakernel ipykernel ];

  # Tests require jupyter_kernel_test to run, but it hasn't seen a
  # release since 2017 and seems slightly abandoned.
  # Doing fetchPypi on it doesn't work, even though it exists here:
  # https://pypi.org/project/jupyter_kernel_test/.
  doCheck = false;

  meta = with lib; {
    description = "A Jupyter kernel for Octave.";
    homepage = "https://github.com/Calysto/octave_kernel";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.all;
  };
}
