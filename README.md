# 1.Introduction
This repository contains the implementation code for the paper titled "Reactive Near-Field Reconstruction via Rayleigh–Sommerfeld Integral: Ill-Conditioning Analysis and Regularization"
# 2.Usage Instructions
1) Run the `Main.m` script in the four respective directories to reproduce the simulation examples presented in the article.
2) Run the `Condition_number_validation.m` script within the 'Patch-Antenna Array' and 'Two Microstrip Lines' directories to reproduce the condition number comparison results.
# 3.Notes
Please note that the measured data used for the experimental validations is not included in this repository
# 4.Acknowledgment
Our code utilizes several MATLAB functions for Tikhonov regularization and L-curve analysis (including `tikhonov.m`, `l_curve.m`, `l_corner.m`, `lcfun.m`, and `csvd.m`). These specific functions are adopted from the well-known Regularization Tools package developed by Prof. Per Christian Hansen, which can be found at https://www.mathworks.com/matlabcentral/fileexchange/52-regtools. 
These functions are distributed under the BSD 3-Clause License. A copy of this license is provided in the `LICENSE_Regularization_Tools.txt` file included in this repository. We sincerely thank Prof. Hansen for making these foundational tools available to the community.
# 5.Maintainers
This project is owned and managed by Dong-Hao Han and Xing-Chang Wei from Zhejiang University, China.
