let
    pkgs = import <nixpkgs> {};
    stdenv = pkgs.stdenv;
 in rec {
     thesisEnv = pkgs.myEnvFun {
       name = "thesis-env";
       buildInputs = with pkgs; [
            git
            haskellPackages.pandoc
            haskellPackages.pandocCiteproc
            python27
            python27Packages.sympy
            python27Packages.statsModels
            python27Packages.pillow
            python27Packages.ipython
            python27Packages.matplotlib
            python27Packages.numpy
            python27Packages.scipy
            python27Packages.ipdb
            python27Packages.click
            python27Packages.funcy
            python27Packages.uncertainties
            python27Packages.scikitlearn
            (import ./jackTheWrapper.nix)
            (pkgs.texLiveAggregationFun { paths = [
                pkgs.texLive
                pkgs.texLiveExtra
                pkgs.lmodern
                pkgs.texLiveCMSuper
            ]; })
            (import ./languagetool.nix)
        ];
     };
}
