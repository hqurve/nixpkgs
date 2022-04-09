{ lib, buildPythonPackage, fetchPypi, jupyter-client, jsonschema, ipykernel }:
buildPythonPackage rec {
  pname = "jupyter_kernel_test";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-evJVzmEwniwIcJq69sfOpd4xJajrM66hZpl/mUh/9DQ=";
  };

  buildInputs = [ jupyter-client jsonschema ];

  checkInputs = [ ipykernel
  ];

  meta = with lib; {
    description = "A tool for testing Jupyter kernels";
    license = licenses.bsd3;
    homepage = "https://github.com/jupyter/jupyter_kernel_test";
    maintainers = with maintainers; [ hqurve ];
  };
}
