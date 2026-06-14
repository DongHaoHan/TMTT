function cond_est = Estimate_cond(Freq, Dx, Dy, Dist, Original_size)

    C = 2.99792458e8;
    Lambda = C / Freq;
    k0 = 2 * pi / Lambda;

    kx_max = pi / Dx;
    ky_max = pi / Dy;
    
    sigma_max = 1.0;

    k_total_max = sqrt(kx_max^2 + ky_max^2);
    
    if k_total_max > k0
        alpha_max = sqrt(k_total_max^2 - k0^2);
        sigma_min = 4*exp(-Dist * alpha_max);
    else
        sigma_min = 1.0;
    end
    cond_est = sigma_max / sigma_min;
end