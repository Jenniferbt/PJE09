clc; clear all; close all;
time = linspace(0, 0.1, 101);
new_time = linspace(0, 0.1, 1000);

%% Rotational displacement

angles = 0:10:50;
data_list = {};

for i = 0:10:50
    % Cargar el archivo CSV correspondiente
    filename = ['Displacementxyz_', num2str(i), '.csv'];
    data = readmatrix(filename);
    
    % Calcular los ángulos en radianes usando atan2
    x_data = data(:, 1);
    y_data = data(:, 2);
    z_data = data(:, 3);
    
    theta_x = atan2(y_data, z_data);
    theta_y = atan2(x_data, z_data);
    theta_z = atan2(y_data, x_data);
    
    % Sobrescribir los datos originales con los ángulos calculados
    data(:, 1) = theta_x;
    data(:, 2) = theta_y;
    data(:, 3) = theta_z;
    
    % Agregar los datos procesados a data_list
    data_list{end+1} = data;
end

%% Interpolation

data_interp_all = [];
velocity_interp_all = [];
acceleration_interp_all = [];

for i = 1:length(data_list)

    velocity = diff(data_list{i})/0.001;
    acceleration = diff(velocity)/0.001;

    %Interpolations

    data_interp = interp1(time, data_list{i}, new_time);
    velocity_interp = interp1(time(1:end-1), velocity, new_time);
    acceleration_interp = interp1(time(1:end-2), acceleration, new_time);
    
    %Graphs
    data_interp_all = [data_interp_all, data_interp];
    velocity_interp_all = [velocity_interp_all, velocity_interp];
    acceleration_interp_all = [acceleration_interp_all, acceleration_interp];
end

%%
figure;
plot(new_time, data_interp_all(:, 1:3:end), 'LineWidth', 3);
xlabel('Time (s)');
ylabel('\theta_x (rad)');
title('Rotational displacement \theta_x');
legend(sprintf('\\alpha = %d^\\circ', angles(1)), sprintf('\\alpha = %d^\\circ', angles(2)), ...
    sprintf('\\alpha = %d^\\circ', angles(3)), sprintf('\\alpha = %d^\\circ', angles(4)), ...
    sprintf('\\alpha = %d^\\circ', angles(5)), sprintf('\\alpha = %d^\\circ', angles(6)));


figure;
plot(new_time, data_interp_all(:, 2:3:end), 'LineWidth', 3);
xlabel('Time (s)');
ylabel('\theta_y (rad)');
title('Rotational displacement \theta_y');
legend(sprintf('\\alpha = %d^\\circ', angles(1)), sprintf('\\alpha = %d^\\circ', angles(2)), ...
    sprintf('\\alpha = %d^\\circ', angles(3)), sprintf('\\alpha = %d^\\circ', angles(4)), ...
    sprintf('\\alpha = %d^\\circ', angles(5)), sprintf('\\alpha = %d^\\circ', angles(6)));


figure;
plot(new_time, data_interp_all(:, 3:3:end), 'LineWidth', 3);
xlabel('Time (s)');
ylabel('\theta_z (rad)');
title('Rotational displacement \theta_z');
legend(sprintf('\\alpha = %d^\\circ', angles(1)), sprintf('\\alpha = %d^\\circ', angles(2)), ...
    sprintf('\\alpha = %d^\\circ', angles(3)), sprintf('\\alpha = %d^\\circ', angles(4)), ...
    sprintf('\\alpha = %d^\\circ', angles(5)), sprintf('\\alpha = %d^\\circ', angles(6)));

%%
% Graficar velocidad
figure;
plot(new_time, velocity_interp_all(:, 1:3:end), 'LineWidth', 3);
xlabel('Time (s)');
ylabel('Velocity (rad/s)');
title('Velocity (x)');
legend(sprintf('\\alpha = %d^\\circ', angles(1)), sprintf('\\alpha = %d^\\circ', angles(2)), ...
    sprintf('\\alpha = %d^\\circ', angles(3)), sprintf('\\alpha = %d^\\circ', angles(4)), ...
    sprintf('\\alpha = %d^\\circ', angles(5)), sprintf('\\alpha = %d^\\circ', angles(6)));

% Graficar velocidad
figure;
plot(new_time, velocity_interp_all(:, 2:3:end), 'LineWidth', 3);
xlabel('Time (s)');
ylabel('Velocity (rad/s)');
title('Velocity (y)');
legend(sprintf('\\alpha = %d^\\circ', angles(1)), sprintf('\\alpha = %d^\\circ', angles(2)), ...
    sprintf('\\alpha = %d^\\circ', angles(3)), sprintf('\\alpha = %d^\\circ', angles(4)), ...
    sprintf('\\alpha = %d^\\circ', angles(5)), sprintf('\\alpha = %d^\\circ', angles(6)));

% Graficar velocidad
figure;
plot(new_time, velocity_interp_all(:, 3:3:end), 'LineWidth', 3);
xlabel('Time (s)');
ylabel('Velocity (rad/s)');
title('Velocity (z)');
legend(sprintf('\\alpha = %d^\\circ', angles(1)), sprintf('\\alpha = %d^\\circ', angles(2)), ...
    sprintf('\\alpha = %d^\\circ', angles(3)), sprintf('\\alpha = %d^\\circ', angles(4)), ...
    sprintf('\\alpha = %d^\\circ', angles(5)), sprintf('\\alpha = %d^\\circ', angles(6)));




%%

% Graficar aceleración
figure;
plot(new_time, acceleration_interp_all(:, 1:3:end), 'LineWidth', 3);
xlabel('Time (s)');
ylabel('Acceleration (g)');
title('Acceleration (x)');
legend(sprintf('\\alpha = %d^\\circ', angles(1)), sprintf('\\alpha = %d^\\circ', angles(2)), ...
    sprintf('\\alpha = %d^\\circ', angles(3)), sprintf('\\alpha = %d^\\circ', angles(4)), ...
    sprintf('\\alpha = %d^\\circ', angles(5)), sprintf('\\alpha = %d^\\circ', angles(6)));

% Graficar aceleración
figure;
plot(new_time, acceleration_interp_all(:, 2:3:end), 'LineWidth', 3);
xlabel('Time (s)');
ylabel('Acceleration (g)');
title('Acceleration (y)');
legend(sprintf('\\alpha = %d^\\circ', angles(1)), sprintf('\\alpha = %d^\\circ', angles(2)), ...
    sprintf('\\alpha = %d^\\circ', angles(3)), sprintf('\\alpha = %d^\\circ', angles(4)), ...
    sprintf('\\alpha = %d^\\circ', angles(5)), sprintf('\\alpha = %d^\\circ', angles(6)));

% Graficar aceleración
figure;
plot(new_time, acceleration_interp_all(:, 3:3:end), 'LineWidth', 3);
xlabel('Time (s)');
ylabel('Acceleration (g)');
title('Acceleration (z)');
legend(sprintf('\\alpha = %d^\\circ', angles(1)), sprintf('\\alpha = %d^\\circ', angles(2)), ...
    sprintf('\\alpha = %d^\\circ', angles(3)), sprintf('\\alpha = %d^\\circ', angles(4)), ...
    sprintf('\\alpha = %d^\\circ', angles(5)), sprintf('\\alpha = %d^\\circ', angles(6)));
