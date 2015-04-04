with import <nixpkgs> {};

pythonPackages.buildPythonPackage rec {
    name = "py-jack-0.5.2";
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/p/py-jack/py-jack-0.5.2.tar.gz";
      sha256 = "67951f7b78ded52f3191a5267cd917f1270a6abe28341ccb3575bdd482488590";
    };

    patches = ./jack_header.patch;
    
    propagatedBuildInputs = with pythonPackages; [
      pkgs.jack2
      numpy
    ];
}

#md5=4e239927913f65b4752f2c4ff8aad105
