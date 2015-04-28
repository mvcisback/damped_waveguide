let
    pkgs = import <nixpkgs> {};
    stdenv = pkgs.stdenv;
    lib = pkgs.haskell-ng.lib;
    env = pkgs.haskellngPackages.ghcWithPackages (p: with p; [
      ihaskell
      ihaskell-charts
      ihaskell-diagrams
      dimensional-tf
      statistics
      cassava
      hmatrix
      numeric-tools
      integration
      numeric-prelude
    ]);
    ihaskellSh = pkgs.writeScriptBin "ihaskell-notebook" ''
    #!/bin/sh
    export GHC_PACKAGE_PATH="$(echo ${env}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
    export PATH="${pkgs.ihaskell}/bin:${env}/bin:${pkgs.python27Packages.ipython}/bin"
    ${pkgs.ihaskell}/bin/ihaskell install -l $(${pkgs.env}/bin/ghc --print-libdir) && ${pkgs.python27Packages.ipython}/bin/ipython notebook --kernel=haskell
      '';    
 in rec {
     thesisEnv = pkgs.myEnvFun {
       name = "thesis-env";
       buildInputs = with pkgs; [
            git
            haskellPackages.pandoc
            haskellPackages.pandocCiteproc
            env
            python27
            python27Packages.sympy
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

        ];
     };
}
