clear; clc; close all;

%% 1. Configuration & Parameters
Filename_high = 'Microstrip_lines_3GHz_10mm.near';
Filename_low  = 'Microstrip_lines_3GHz_5mm.near';

Freq = 3e9;
C    = 2.99792458e8;
High_z   = 10e-3;
Low_z = 5e-3;
Delta_z = High_z - Low_z;
Padding_size = 32;

F_name   = 'Times New Roman';
F_size   = 24;
F_weight = 'Bold';

%% 2. Data Acquisition
[Real_high, Imag_high, Dx, Dy, Original_size, X_coor, Y_coor] = Load_data_custom(Filename_high);
[Real_low, Imag_low, ~, ~, ~] = Load_data_custom(Filename_low);

High_field          = Real_high + 1i * Imag_high;
Low_field_reference = Real_low + 1i * Imag_low;

%% 3. Propagation Matrix & Regularization Setup
[A, b] = Propagation_matrix_construction(High_field, Freq, Dx, Dy, Delta_z, Padding_size);

Reference_cond = cond(A);
Estimated_cond = Estimate_cond(Freq, Dx, Dy, Delta_z, Original_size);
fprintf('Reference Condition Number: %.4f dB \n', 20 * log10(Reference_cond));
fprintf('Estimated Condition Number: %.4f dB \n', 20 * log10(Estimated_cond));

[U, s, V] = csvd(A);
[reg_corner, ~, ~, reg_param] = l_curve(U, s, b, 'Tikh');
alpha = reg_corner * 7.5; 

%% 4. Field Reconstruction
[Low_field_reconstructed, ~, ~] = tikhonov(U, s, V, b, alpha);

Total_size = Original_size + 2 * Padding_size;
Low_field_reconstructed = reshape(Low_field_reconstructed, Total_size, Total_size);
Low_field_reconstructed = Low_field_reconstructed(Padding_size+1:Padding_size+Original_size, ...
                                          Padding_size+1:Padding_size+Original_size);

%% 5. Visualization
plot_cfg = @(titlestr, fname) apply_plot_style(titlestr, fname, F_name, F_size, F_weight);

Mag_min = min(abs(Low_field_reference(:)));
Mag_max = max(abs(Low_field_reference(:)));
Pha_min = min(angle(Low_field_reference(:)));
Pha_max = max(angle(Low_field_reference(:)));

figure; pcolor(X_coor*1e3, Y_coor*1e3, abs(High_field));
plot_cfg('Magnitude of Hx (A/m)', 'High_mag');

figure; pcolor(X_coor*1e3, Y_coor*1e3, angle(High_field));
plot_cfg('Phase of Hx (Rad)', 'High_pha');

figure; pcolor(X_coor*1e3, Y_coor*1e3, abs(Low_field_reconstructed));
caxis([Mag_min Mag_max]);
plot_cfg('Magnitude of Hx (A/m)', 'Low_mag_rec_proposed');

figure; pcolor(X_coor*1e3, Y_coor*1e3, angle(Low_field_reconstructed));
caxis([Pha_min Pha_max]);
plot_cfg('Phase of Hx (Rad)', 'Low_pha_rec_proposed');

figure; pcolor(X_coor*1e3, Y_coor*1e3, abs(Low_field_reference));
plot_cfg('Magnitude of Hx (A/m)', 'Low_mag_ref');

figure; pcolor(X_coor*1e3, Y_coor*1e3, angle(Low_field_reference));
plot_cfg('Phase of Hx (Rad)', 'Low_pha_ref');

%% 6. Error Quantification
Rel_Err = Relative_error(Low_field_reconstructed, Low_field_reference);
fprintf('Relative Error: %.4f\n', Rel_Err);

%% Helper Function for Plotting
function apply_plot_style(titlestr, filename, F_name, F_size, F_weight)
    shading interp;
    axis tight;
    colormap(jet);
    colorbar;
    set(gca, 'FontSize', F_size, 'FontName', F_name, 'FontWeight', F_weight);
    xlabel('X Axis (mm)', 'FontSize', F_size, 'FontName', F_name, 'FontWeight', F_weight);
    ylabel('Y Axis (mm)', 'FontSize', F_size, 'FontName', F_name, 'FontWeight', F_weight);
    title(titlestr, 'FontSize', F_size, 'FontName', F_name, 'FontWeight', F_weight);
    print(filename, '-dpng', '-r300');
end