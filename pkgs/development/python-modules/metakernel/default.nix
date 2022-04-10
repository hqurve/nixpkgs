{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, jupyter_kernel_test 
, jupyter_core
}:

buildPythonPackage rec {
  pname = "metakernel";
  version = "0.29.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+B8ywp7q42g8H+BPFK+D1VyLfyqgnrYIN3ai/mdcwcA=";
  };

  # buildInputs = [ jupyter_cores ipykernel jupyter_kernel_test ];
  propagatedBuildInputs = [ ipykernel jupyter_kernel_test jupyter_core ];

  # checkInputs = [ jupyter_kernel_test jupyter_cores ];

  # Tests hang, so disable
  # doCheck = false;

  disabledTests = [
    "test_download_magic"
    "test_jigsaw_magic"
    "test_install_magic_magic"
  ];

  meta = with lib; {
    description = "Jupyter/IPython Kernel Tools";
    homepage = "https://github.com/Calysto/metakernel";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thomasjm ];
  };
}
