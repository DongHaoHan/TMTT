function [Hx_real, Hx_imag, Dx, Dy, Size_n, X_coor, Y_coor] = Load_data_custom(Filename)
    Raw_data = load(Filename);
    Size_n = sqrt(size(Raw_data, 1)); 
    Hx_real = reshape(Raw_data(:, 10), Size_n, Size_n);
    Hx_imag = reshape(Raw_data(:, 11), Size_n, Size_n);
    Dx = (max(Raw_data(:, 1)) - min(Raw_data(:, 1))) / (Size_n - 1);
    Dy = (max(Raw_data(:, 2)) - min(Raw_data(:, 2))) / (Size_n - 1);
    X_coor = reshape(Raw_data(:, 1), Size_n, Size_n);
    Y_coor = reshape(Raw_data(:, 2), Size_n, Size_n);
end