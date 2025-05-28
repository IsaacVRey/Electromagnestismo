function espiral()
    % Definición de l`a espira
    global pos_x pos_y pos_z vec_x vec_y vec_z num_espiras puntos_por_espira

    num_espiras = 5;
    puntos_por_espira = 20;
    radio_espira = 1.5;
    espaciado_z = 1;

    delta_theta = 2*pi / puntos_por_espira;
    theta_vals = 0:delta_theta:(2*pi - delta_theta);

    idx = 1;
    for n = 1:num_espiras
        pos_x(idx:idx+puntos_por_espira-1) = radio_espira * cos(theta_vals);
        pos_y(idx:idx+puntos_por_espira-1) = radio_espira * sin(theta_vals);
        pos_z(idx:idx+puntos_por_espira-1) = -num_espiras/2*espaciado_z + (n-1)*espaciado_z;

        vec_x(idx:idx+puntos_por_espira-1) = -pos_y(idx:idx+puntos_por_espira-1) * delta_theta;
        vec_y(idx:idx+puntos_por_espira-1) =  pos_x(idx:idx+puntos_por_espira-1) * delta_theta;

        idx = idx + puntos_por_espira;
    end
    vec_z = zeros(1, puntos_por_espira*num_espiras);

    % Visualización de la espira
    figure(1)
    quiver3(pos_x, pos_y, pos_z, vec_x, vec_y, vec_z, 0.5, '-r', 'LineWidth', 2)
    view(-34, 33)
    title('Corriente en espiras')
    xlabel('x'); ylabel('y'); zlabel('z');
    axis equal

    % Guardar variables necesarias
    assignin('base', 'vec_z', vec_z);
end