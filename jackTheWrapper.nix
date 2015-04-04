with import <nixpkgs> {};

pythonPackages.buildPythonPackage rec {
    name = "Jack-The-Wrapper-0.2.4";
    src = fetchurl {
        url = "https://github.com/mvcisback/Jack_The_Wrapper/archive/0.1.0.tar.gz";
        sha256 = "3cfc03a984e5974440152f39d128ddd9794002155aabb69d5fab1330a1556815";
    };

    propagatedBuildInputs = with pythonPackages; [
      numpy
      (import ./pyJack.nix)
    ];
}
