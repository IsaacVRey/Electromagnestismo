function campo()
    global pos_x pos_y pos_z vec_x vec_y num_espiras puntos_por_espira
    global campo_magnitud_linea campo_z_linea eje_z

    corriente = 300;
    mu0 = 4*pi*1e-7;
    constante_BS = mu0 * corriente / (4*pi);
    radio_seguro = 0.2;

    paso_espacio = 0.1;
    eje_x = -5:paso_espacio:5;
    eje_y = eje_x;
    eje_z = -10:paso_espacio:10;  % <<< más grande eje_z
    len_x = length(eje_x);
    len_y = length(eje_y);
    len_z = length(eje_z);

    campo_x = zeros(len_x, len_y, len_z);
    campo_y = zeros(len_x, len_y, len_z);
    campo_z = zeros(len_x, len_y, len_z);

    tic
    for ix = 1:len_x
        for iy = 1:len_y
            for iz = 1:len_z
                for iw = 1:num_espiras*puntos_por_espira
                    rx = eje_x(ix) - pos_x(iw);
                    ry = eje_y(iy) - pos_y(iw);
                    rz = eje_z(iz) - pos_z(iw);

                    r_norm = sqrt(rx^2 + ry^2 + rz^2 + radio_seguro^2);
                    r_cubed = r_norm^3;

                    campo_x(ix,iy,iz) = campo_x(ix,iy,iz) + constante_BS * vec_y(iw) * rz / r_cubed;
                    campo_y(ix,iy,iz) = campo_y(ix,iy,iz) + constante_BS * vec_x(iw) * rz / r_cubed;
                    campo_z(ix,iy,iz) = campo_z(ix,iy,iz) + constante_BS * (vec_x(iw) * ry - vec_y(iw) * rx) / r_cubed;
                end
            end
        end
    end
    toc

    magnitud_campo = sqrt(campo_x.^2 + campo_y.^2 + campo_z.^2);

    plano_medio_y = round(len_y / 2);
    campo_x_xz = squeeze(campo_x(:, plano_medio_y, :));
    campo_z_xz = squeeze(campo_z(:, plano_medio_y, :));
    campo_magnitud_xz = squeeze(magnitud_campo(:, plano_medio_y, :));

    % Línea de Bz (CORRECTO para la trayectoria)
    campo_z_linea = squeeze(campo_z(round(len_x/2), round(len_y/2), :));

 
    campo_magnitud_linea = squeeze(campo_magnitud_xz(round(len_x/2), :));

    assignin('base', 'campo_z_linea', campo_z_linea);
    assignin('base', 'campo_magnitud_linea', campo_magnitud_linea);
    assignin('base', 'eje_z', eje_z);

    % Visualización
    figure(2); clf
    pcolor(eje_x, eje_z, (campo_magnitud_xz').^(1/3));
    shading interp; colormap jet; colorbar

    [XX, ZZ] = meshgrid(eje_x, eje_z);
    streamplot = streamslice(XX, ZZ, campo_x_xz', campo_z_xz', 3);
    set(streamplot, 'Color', [0.8 1 0.9]);

    xlabel('x'); ylabel('z');
    title('Campo magnético generado por un solenoide')
end
