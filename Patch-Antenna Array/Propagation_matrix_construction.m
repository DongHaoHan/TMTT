function [A, b] = Propagation_matrix_construction(Input_field, Freq, Dx, Dy, Delta_z, Padding_size)
    C = 2.99792458e8;
    Lambda = C / Freq;
    k0 = 2 * pi / Lambda;
    
    [rows_obs, cols_obs] = size(Input_field);
    rows_src = rows_obs + 2*Padding_size;
    cols_src = cols_obs + 2*Padding_size;
    
    Num_pixels_obs = rows_obs * cols_obs;
    Num_pixels_src = rows_src * cols_src;
    
    x_obs = ((0:cols_obs-1) - floor(cols_obs/2)) * Dx;
    y_obs = ((0:rows_obs-1) - floor(rows_obs/2)) * Dy;
    [X_obs_mesh, Y_obs_mesh] = meshgrid(x_obs, y_obs);
    X_obs_vec = X_obs_mesh(:);
    Y_obs_vec = Y_obs_mesh(:);
    
    x_src = ((0:cols_src-1) - floor(cols_src/2)) * Dx;
    y_src = ((0:rows_src-1) - floor(rows_src/2)) * Dy;
    [X_src_mesh, Y_src_mesh] = meshgrid(x_src, y_src);
    X_src_vec = X_src_mesh(:);
    Y_src_vec = Y_src_mesh(:);
    
    A = zeros(Num_pixels_obs, Num_pixels_src); 
    b = Input_field(:);               
    
    Area_element = Dx * Dy; 
    
    for j = 1:Num_pixels_src
        xs = X_src_vec(j);
        ys = Y_src_vec(j);
        
        rx = X_obs_vec - xs;
        ry = Y_obs_vec - ys;
        
        R_dist = sqrt(rx.^2 + ry.^2 + Delta_z^2);
        
        term_phase = exp(-1i * k0 * R_dist);
        term_dist_decay = 1 ./ R_dist;
        term_near_field = term_dist_decay + (1i * k0); 
        obliquity_factor = Delta_z ./ R_dist;
        
        H_vals = (1 / (2*pi) .* obliquity_factor .* term_near_field .* term_dist_decay .* term_phase);
        
        A(:, j) = H_vals * Area_element;
    end
end