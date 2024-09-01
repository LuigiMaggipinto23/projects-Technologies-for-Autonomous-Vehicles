%% Longitudinal acceleration and speed test
speed_75 = load('results_mu_0_75_speed_test.mat');
speed_85 = load('results_mu_0_85_speed_test.mat');
speed_90 = load('results_mu_0_90_speed_test.mat');

figure(8)
hold all;

plot(speed_75.tout, speed_75.ax.Data, 'r-', 'DisplayName', 'mu = 0.75'); 
plot(speed_85.tout, speed_85.ax.Data, 'g-', 'DisplayName', 'mu = 0.85'); 
plot(speed_90.tout, speed_90.ax.Data, 'b-', 'DisplayName', 'mu = 0.90'); 

title('Longitudinal acceleration test')
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')
legend;

text(speed_75.tout(end), speed_75.ax.Data(end), 'Asphalt wet', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'r');
text(speed_85.tout(end), speed_85.ax.Data(end), 'Asphalt dry', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'g');
text(speed_75.tout(end), speed_90.ax.Data(end), 'Cobblestones dry', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'b');
hold off

figure(2)
hold all;

plot(speed_75.tout, speed_75.vx.Data, 'r-', 'DisplayName', 'mu = 0.75');
plot(speed_85.tout, speed_85.vx.Data, 'g-', 'DisplayName', 'mu = 0.85');
plot(speed_90.tout, speed_90.vx.Data, 'b-', 'DisplayName', 'mu = 0.90');

title('Longitudinal speed test')
xlabel('Time [s]')
ylabel('Speed [m/s]')
legend;
hold off


%% Emergency braking test

em_brake_mu_75 = load('results_mu_0_75_emergency_brake.mat');
em_brake_mu_85 = load('results_mu_0_85_emergency_brake.mat');

figure(9)
hold on;
 
plot(em_brake_mu_75.tout, em_brake_mu_75.ax.Data, 'r-', 'DisplayName', 'mu = 0.75'); 
plot(em_brake_mu_85.tout,  em_brake_mu_85.ax.Data, 'g-', 'DisplayName', 'mu = 0.85'); 

title('Emergency braking test')
xlabel('Time [s]')
ylabel('Speed [m/s]')
legend;
hold off

%% Acceleration time

load results_acc_times.mat

figure(10)
hold on;

plot(tout, vx.Data, 'b-');

title(sprintf('Acceleration time - acceleration pedal=%.1f', acc_pedal))
xlabel('Time [s]')
ylabel('Speed [m/s]')

v_target = 100 / 3.6; % 27.78 m/s
v_target2 = 200/3.6;

[~, idx_target] = min(abs(vx.Data - v_target));
[~, idx_target2] = min(abs(vx.Data - v_target2));

t_target = tout(idx_target);
t_target2 = tout(idx_target2);

plot(t_target, v_target, 'rx', 'MarkerSize', 10, 'DisplayName', sprintf('v_100 = %.2f m/s', v_target));
plot(t_target2, v_target2, 'gx', 'MarkerSize', 10, 'DisplayName', sprintf('v_200 = %.2f m/s', v_target2));

text(t_target, v_target, sprintf(' t = %.2f s', t_target), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'r');
text(t_target2, v_target2, sprintf(' t = %.2f s', t_target2), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'g');

legend('Speed', sprintf('v_1 = %.2f m/s', v_target), sprintf('v_2 = %.2f m/s', v_target2));

hold off

%% Tip-in Tip-off test

load results_tipin_tipoff.mat 
 
figure (11)
hold on
plot(tout, vx.Data);

title('Speed - Tip-in Tip-off test')
xlabel('Time [s]')
ylabel('Speed [m/s]')

figure(12)
plot(tout, ax.Data)
title('Acceleration - Tip-in Tip-off test')
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')
hold off

