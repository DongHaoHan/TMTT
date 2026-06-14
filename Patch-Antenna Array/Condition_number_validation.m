clear; clc; close all;
%% 1. Configuration & Parameters
Filename_high = 'Patch-antenna_array_2G_26.6mm.near';
Freq = 2e9;
C    = 2.99792458e8;
Padding_size = 32;
Start_delta_z = 5e-3;
End_delta_z   = 20e-3;
Step_delta_z  = 0.1e-3;
Delta_z_list = Start_delta_z:Step_delta_z:End_delta_z;
F_name   = 'Times New Roman';
F_size   = 12;
F_weight = 'Bold';

%% 2. Data Acquisition
[Real_high, Imag_high, Dx, Dy, Original_size, X_coor, Y_coor] = Load_data_custom(Filename_high);
High_field = Real_high + 1i * Imag_high;

%% 3. Condition Number Evaluation
Num_points = length(Delta_z_list);
Ref_cond_list = zeros(Num_points, 1);
Est_cond_list = zeros(Num_points, 1);

for i = 1:Num_points
    Current_Delta_z = Delta_z_list(i);
    fprintf('Condition number calculated for delta = %.1f mm\n', Current_Delta_z * 1e3);
    [A, ~] = Propagation_matrix_construction(High_field, Freq, Dx, Dy, Current_Delta_z, Padding_size);
    Ref_cond_list(i) = cond(A);
    Est_cond_list(i) = Estimate_cond(Freq, Dx, Dy, Current_Delta_z, Original_size);
end

Ref_cond_list_db = 20 * log10(Ref_cond_list);
Est_cond_list_db = 20 * log10(Est_cond_list);

%% 4. Visualization
figure;
plot(Delta_z_list * 1e3, Ref_cond_list_db, 'r-', 'LineWidth', 2); hold on;
plot(Delta_z_list * 1e3, Est_cond_list_db, 'b--', 'LineWidth', 2);

legend({'Reference Condition Number (dB)', 'Estimated Condition Number (dB)'}, ...
    'Location', 'best', 'FontName', F_name, 'FontSize', F_size, 'FontWeight', F_weight);
set(gca, 'FontSize', F_size, 'FontName', F_name, 'FontWeight', F_weight);
xlabel('Delta z (mm)', 'FontSize', F_size, 'FontName', F_name, 'FontWeight', F_weight);
ylabel('Condition Number (dB)', 'FontSize', F_size, 'FontName', F_name, 'FontWeight', F_weight);
grid on; axis tight;

%% 5. Data Saving
Results_Table = table(Delta_z_list(:) * 1e3, Ref_cond_list_db(:), Est_cond_list_db(:), ...
    'VariableNames', {'Delta_z_mm', 'Reference_cond_dB', 'Estimated_cond_dB'});
Output_filename = 'Condition_Number_Results_dB.xlsx';
writetable(Results_Table, Output_filename);
fprintf('Results saved to %s\n', Output_filename);