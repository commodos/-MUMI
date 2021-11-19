# -MUMI
 MUMI: Multisines for multiple inputs toolbox. A Matlab toolbox
 Copyright (C) 2010  Dr. Péter Zoltán Csurcsia
 Details on license can be found in licese file.

 Start using the multisine generator with GUI:
   type 'multisine'

 Start using the multisine generator with command line interface:
   type 'help GenerateSignal'

Files:
   GenerateSignal.m contains the signal generation methods that is also called by mumi.m
   
   Icons folder contains two GUI icons.
   
   Sources folder contains:
    - the default settings file (Test_settings.m) that can be modified
   and auxiliary codes:
    - generateMultiSine.m that generates the frequency domain raw data
    - generateDecadeBand.m and generateOctaveBand.m that generate non-decade frequency lines

   Related article with technical details on the recommended nonlinear framework can be found in
   manuscript.pdf 
   for scientific reference 
   please use:
        Péter Zoltán Csurcsia, Bart Peeters, Johan Schoukens:
        User-friendly nonlinear nonparametric estimation framework for vibro-acoustic industrial measurements with multiple inputs,
        Mechanical Systems and Signal Processing, Volume 145, 2020
        https://doi.org/10.1016/j.ymssp.2020.106926.
