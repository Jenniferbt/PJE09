clc; clear all; close all;
time = linspace(0, 0.1, 101);
new_time = linspace(0, 0.1, 1000);

%% Rotational displacement

angles = 0:10:50;
data_list = {};
rotation_matrices = {};

k = 1;
for i = 0:10:50
    filename = ['Displacementxyz_', num2str(i), '.csv'];
    data = readmatrix(filename);
   
    x_data = data(:, 1);
    y_data = data(:, 2);
    z_data = data(:, 3);
    
    theta_x = atan2(y_data, z_data);
    theta_y = atan2(x_data, z_data);
    theta_z = atan2(y_data, x_data);
    
    data(:, 1) = theta_x;
    data(:, 2) = theta_y;
    data(:, 3) = theta_z;

    rotation_matrices{k}={};
    
    for j = 1:1:length(theta_x)

        R_x = [1 0 0;
               0 cos(theta_x(j)) -sin(theta_x(j));
               0 sin(theta_x(j)) cos(theta_x(j))];
    
        R_y = [cos(theta_y(j)) 0 sin(theta_y(j));
               0 1 0;
               -sin(theta_y(j)) 0 cos(theta_y(j))];
    
        R_z = [cos(theta_z(j)) -sin(theta_z(j)) 0;
               sin(theta_z(j)) cos(theta_z(j)) 0;
               0 0 1];
    
        R_total = R_z * R_y * R_x;
        rotation_matrices{k}{end+1} = R_total;
    end

    data_list{end+1} = data;
    k = k + 1;
end

%% Rotational to Euler

eul_total = {};

for i = 1:6
    eul_total{i} = {};
    for j = 1:101
        rotm = rotation_matrices{i}{j};
        eul = rotm2eul(rotm, 'XYZ');
        eul_total{i}{j} = eul;
    end
end

%% Plotting
figure;

for i = 1:6
    toPlot = [];
    for j=1:101
        for k=1:3
            toPlot(j,k) = eul_total{i}{j}(k);
        end
    end
    for k = 1:3
        subplot(1, 3, k);
        hold on
        plot(time, toPlot(:,k), 'LineWidth', 3);
        legend(arrayfun(@(x) sprintf('\\alpha = %d^\\circ', x), ...
        angles, 'UniformOutput', false));    
    end
end

%% Plotting
figure;

for i = 1:6
    toPlot = [];
    for j=1:101
        for k=1:3
            toPlot(j,k) = eul_total{i}{j}(k);
        end
    end

    toPlot = diff(toPlot)/0.001;

    for k = 1:3
        subplot(1, 3, k);
        hold on
        plot(time(1:end-1), toPlot(:,k), 'LineWidth', 3);
        legend(arrayfun(@(x) sprintf('\\alpha = %d^\\circ', x), ...
        angles, 'UniformOutput', false));  
    end
end

%% Plotting
figure;

for i = 1:6
    toPlot = [];
    for j=1:101
        for k=1:3
            toPlot(j,k) = eul_total{i}{j}(k);
        end
    end

    toPlot = diff(diff(toPlot))/0.001;

    for k = 1:3
        subplot(1, 3, k);
        hold on
        plot(time(1:end-2), toPlot(:,k), 'LineWidth', 3);
        legend(arrayfun(@(x) sprintf('\\alpha = %d^\\circ', x), ...
        angles, 'UniformOutput', false));  
        xlim([0 0.012]);
    end
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

%% Rotational matrix

for i = 1:3
    figure;
    plot(new_time, data_interp_all(:, i:3:end), 'LineWidth', 3);
    xlabel('Time (s)');
    ylabel(ylabel_displacement);
    title(velocity_titles{i});
    legend(arrayfun(@(x) sprintf('\\alpha = %d^\\circ', x), ...
        angles, 'UniformOutput', false));
end

%% Graphs

displacement_titles = {'Displacement (x)', 'Displacement (y)', 'Displacement (z)'};
velocity_titles = {'Velocity (x)', 'Velocity (y)', 'Velocity (z)'};
acceleration_titles = {'Acceleration (x)', 'Acceleration (y)', 'Acceleration (z)'};

ylabel_velocity = 'Velocity (rad/s)';
ylabel_acceleration = 'Acceleration (g)';
ylabel_displacement = 'Displacement (rad)';

% Displacement
for i = 1:3
    figure;
    plot(new_time, data_interp_all(:, i:3:end), 'LineWidth', 3);
    xlabel('Time (s)');
    ylabel(ylabel_displacement);
    title(velocity_titles{i});
    legend(arrayfun(@(x) sprintf('\\alpha = %d^\\circ', x), ...
        angles, 'UniformOutput', false));
end

% Velocity
for i = 1:3
    figure;
    plot(new_time, velocity_interp_all(:, i:3:end), 'LineWidth', 3);
    xlabel('Time (s)');
    ylabel(ylabel_velocity);
    title(velocity_titles{i});
    legend(arrayfun(@(x) sprintf('\\alpha = %d^\\circ', x), ...
        angles, 'UniformOutput', false));
end

% Acceleration
for i = 1:3
    figure;
    plot(new_time, acceleration_interp_all(:, i:3:end), 'LineWidth', 3);
    xlabel('Time (s)');
    ylabel(ylabel_acceleration);
    title(acceleration_titles{i});
    legend(arrayfun(@(x) sprintf('\\alpha = %d^\\circ', x), ...
        angles, 'UniformOutput', false));
end
