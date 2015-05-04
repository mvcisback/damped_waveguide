with import <nixpkgs> {};

stdenv.mkDerivation rec {
    name = "languagetool-cli-2.8";
    src = fetchurl {
        url = "https://languagetool.org/download/LanguageTool-2.8.zip";
        sha256 = "2d4d38dc6aeab828654fbb6bd805253c22c1c463c2adcfd2379879c9dfa026f3";
    };

    buildInputs = [ makeWrapper unzip ];

    installPhase =
    ''
      mkdir -p $out/bin
      
      cp -r * $out/
      cp languagetool-*.jar $out
      makeWrapper ${jdk}/bin/java $out/bin/languagetool \
         --add-flags "-jar $out/languagetool-commandline.jar "
    '';
    
}
