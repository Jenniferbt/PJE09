clc; clear all; close all;

%Matrix with the info from the simulations. 
%Column 1 is 0º... and Column 6 is 50º.
data = readmatrix('Simulation_results_new.csv');
angles = 0:10:50;
time = 0:0.004:0.1;

%% Interpolation

% Displacement (mm)

new_dt = 0.0001;
new_time = 0:0.0001:0.1;
interpolation = interp1(time, data, new_time, "makima");

figure;
plot(new_time, interpolation)
hold on
plot(time, data,'ro')
title('Displacement')
xlabel('Time (s)')
ylabel('Displacement (mm)')
legend('0º', '10º', '20º', '30º', '40º', '50º', 'Location','best')

%% Velocity
figure;

% Velocity (m/s)
init_velocity = 5.6; % mm/s

%Initial velocity assessment with the OG data:
velocity = diff(data)/(1000*0.004); %known points

% Calculated velocity from the interpolation of the displacement (smooth)
% Differential from the interpolation
velocity_1 = diff(interpolation)/(1000*new_dt);
velocity_1 = interp1(new_time(1:10:end-1), velocity_1(1:10:end,:), ...
 new_time(1:end-1), "makima");

subplot(1, 2, 1);
plot(new_time(1:end-1), velocity_1)
title('From the interpolation of the displacement')
hold on
%plot(time(1:end-1), velocity,'ro')
hold off

legend('0º', '10º', '20º', '30º', '40º', '50º', 'Location','best')
xlabel('Time (s)')
ylabel('Velocity (m/s)')


%Calculated velocity interpolation from the known points
%Interpolation from the original points
velocity_2 = interp1(time(1:end-1), velocity, new_time, "makima");

subplot(1, 2, 2);
plot(new_time, velocity_2)
title('Interpolation from the original points')
hold on
plot(time(1:end-1), velocity,'ro')
hold off

legend('0º', '10º', '20º', '30º', '40º', '50º', 'Location','best')
xlabel('Time (s)')
ylabel('Velocity (m/s)')

%% Acceleration
figure;

%Initial acceleration assessment with the OG data:
acceleration = diff(diff(data))/(1000*0.004); %known points

% Calculated acceleration from the interpolation of the velocity (smooth)
% Differential from the interpolation
acceleration_1 = diff(velocity_1)/(9800*new_dt);
acceleration_1 = interp1(new_time(1:10:end-2), acceleration_1(1:10:end,:), ...
 new_time(1:end-2), "makima");

subplot(1, 2, 1);
plot(new_time(1:end-2), acceleration_1)
title('From the interpolation of the displacement')
hold on
%plot(time(1:end-2), acceleration,'ro')
hold off

legend('0º', '10º', '20º', '30º', '40º', '50º', 'Location','best')
xlabel('Time (s)')
ylabel('Acceleration (g)')

%Calculated velocity interpolation from the known points
%Interpolation from the original points
acceleration_2 = interp1(time(1:end-2), acceleration, new_time, "makima");

subplot(1, 2, 2);
plot(new_time, acceleration_2/9.8)
title('Interpolation from the original points')
hold on
plot(time(1:end-2), acceleration/9.8,'ro')
hold off

legend('0º', '10º', '20º', '30º', '40º', '50º', 'Location','best')
xlabel('Time (s)')
ylabel('Acceleration (g)')


%% Comparison with the OG data from the simulation

figure;

data_0 = readmatrix('Results_0.csv');

interpolation_velocity = interp1(time, data_0, new_time, "makima");

subplot(1, 2, 1);
plot(new_time, interpolation_velocity(:,2)/100)
title('Interpolation from the results in Fusion')
hold on
plot(time, data_0(:,2)/100,'ro')
hold off
xlabel('Time (s)')
ylabel('Velocity (m/s)')

subplot(1, 2, 2);
plot(new_time, velocity_2(:,1))
title('Interpolation from the original points')
hold on
plot(time(1:end-1), velocity(:,1),'ro')
hold off

xlabel('Time (s)')
ylabel('Velocity (m/s)')

