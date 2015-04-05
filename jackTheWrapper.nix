with import <nixpkgs> {};

pythonPackages.buildPythonPackage rec {
    name = "Jack-The-Wrapper-0.2.4";
    src = fetchurl {
        url = "https://github.com/mvcisback/Jack_The_Wrapper/archive/0.1.2.tar.gz";
        sha256 = "a427aa69a1a8565bf68efe5f4c069110f6bfebef3559a45784d56985e1b64524";
    };

    propagatedBuildInputs = with pythonPackages; [
      numpy
      (import ./pyJack.nix)
    ];
}
