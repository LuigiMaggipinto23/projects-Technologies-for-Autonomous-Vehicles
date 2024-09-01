close all

% Plot of the vehicle responce variables

%% Lateral angle error
figure(10)
plot (e1.time, e1.Data);
title('Lateral deviation e_1(t)')
xlabel('t')
ylabel('e_1')
grid on

%% Heading angle error
figure(11)
plot (e2_dot.time, e2_dot.Data);
title('Heading angle error e_2 dot(t)');
xlabel('t')
ylabel('e_2 dot')
grid on

%% Lateral acceleration 
figure(12)
plot (lateral_acc.time, lateral_acc.Data);
title('Lateral Acceleration')
xlabel('t')
ylabel('a_y')
grid on

%% Yaw rate
figure(13)
plot (yaw_rate.time, yaw_rate.Data);
title('Yaw rate')
xlabel('t')
ylabel('$\dot{\psi}$', 'Interpreter', 'latex')
grid on

%% Sideslip angle
figure(14)
plot (beta.time, beta.Data);
title('Sideslip Angle')
xlabel('t')
ylabel('\beta')
grid on

%% Slip angles
figure(15)
hold on
plot(slipangles_front.time, slipangles_front.Data, 'r', 'DisplayName', 'Front');
plot(slipangles_rear.time, slipangles_rear.Data, 'b', 'DisplayName', 'Rear');
title('Slip Angles')
xlabel('t')
ylabel('\alpha')
legend('show');
grid on 
hold off

%% K_FF and K contributions
figure(16)
hold on
yline(KFF.Data, '--g', 'LineWidth', 1);
plot(delta_v.Time, delta_v.Data)
plot(Feedback.Time, Feedback.Data)
title('Feedback and Feedforward contributions')
xlabel('t')
legend('K_{ff}','\delta_v', 'K');
grid on 
hold off

