function tryectoria()
    global campo_z_linea eje_z

    m = 0.009;          % Masa del dipolo (kg)
    mag = 100;         % Momento magnético (tus valores)
    gamma = 0.08;       % Factor de fricción (tus valores)
    dt = 0.05;          % Paso de tiempo (tus valores)
    delta = 0.005;       % Distancia para gradiente

    % --- Caída con campo magnético ---
    z(1) = 5;           % Posición inicial (m)
    vz(1) = 0.7;        % Velocidad inicial (m/s)
    t(1) = 0;
    C = 1;

    while z(C) > -6
        Bz_forward = interp1(eje_z, campo_z_linea, z(C) + delta, 'linear', 'extrap');
        Bz_backward = interp1(eje_z, campo_z_linea, z(C) - delta, 'linear', 'extrap');
        dBz_dz = (Bz_forward - Bz_backward) / (2*delta);

        Fm = -mag * dBz_dz;
        Ff = -gamma * vz(C);
        F = Fm - m * 9.81 - Ff;

        a = F / m;

        z(C+1) = z(C) + vz(C)*dt + 0.5*a*dt^2;
        vz(C+1) = vz(C) + a*dt;
        t(C+1) = t(C) + dt;

        C = C + 1;
    end

    % --- Caída libre para comparación ---
    z_free(1) =5;
    vz_free(1) = 0;
    t_free(1) = 0;

    for i = 1:length(t)-1
        a_free = -9.81;
        z_free(i+1) = z_free(i) + vz_free(i)*dt + 0.5*a_free*dt^2;
        vz_free(i+1) = vz_free(i) + a_free*dt;
        t_free(i+1) = t_free(i) + dt;

        if z_free(i+1) < 0
            break;
        end
    end

    % --- Gráfica comparativa ---
    figure(3); clf;
    plot(t, z, 'r-', 'LineWidth', 2); hold on;
    plot(t_free, z_free, 'b--', 'LineWidth', 2);
    xlabel('time (s)');
    ylabel('z position (m)');
    title('Position vs time of a Magnetic dipole falling through a current ring');
    legend('Fall over a current ring', 'Free fall (no Magnetic force)');
    grid on;
    axis([0 7 -6 6]);
end
