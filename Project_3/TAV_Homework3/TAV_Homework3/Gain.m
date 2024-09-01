close all

% Parameters
m = 1575; % vehicle mass
Jz = 2875; % yaw mass moment of inertia
af = 1.3; % front semi-wheelbase
ar = 1.5; % rear semi-wheelbase
CF = 2*6*1e4; % front axle cornering stiffness 
CR = 2*5.7*1e4; % rear axle cornering stiffness 
L = af+ar;

tau_s = 15;     % steering ratio
delta_max = 25; % [deg];

% Input 
R = 10;

% Gains 
K = (m/L)*(CR*ar-(CF*af))/(CF*CR);
CR_over = 0.98e5;
K_over = (m/L)*(CR_over*ar-(CF*af))/(CF*CR_over);
CR_neutral = 1.04e5;
K_neutral = (m/L)*(CR_neutral*ar-(CF*af))/(CF*CR_neutral);
V_cr = sqrt(-L/K_over);

%% Curvature gain
rho_gain_under = zeros(length(vv), 1);
rho_gain_over = zeros(length(vv), 1);
rho_gain_neutral = zeros(length(vv), 1);
for i=1:length(vv)
    Vx = vv(i);   
    rho_gain_under(i) = 1/(L+(K*Vx^2));
    rho_gain_over(i) = 1/(L+(K_over*Vx^2));
    rho_gain_neutral(i) = 1/(L+(K_neutral*Vx^2));
end

figure(11)
hold all
plot(vv, rho_gain_under)
plot(vv, rho_gain_over, 'r')
plot(vv, rho_gain_neutral, 'k')
xline(V_cr, '--g', 'LineWidth', 1);
hold off
legend('K > 0', 'K < 0', 'K = 0')
title('\textbf{Curvature gain $\rho / \delta$}', 'Interpreter', 'latex')
xlabel('V')
ylabel('$\frac{1}{R \delta}$', 'Interpreter', 'latex')
ylim([0, 3.5])
xlim([0, V_cr])

%%  Lateral acceleration gain
ay_gain = zeros(length(vv), 1);
ay_gain_neutral = zeros(length(vv), 1);
ay_gain_over = zeros(length(vv), 1);
for i=1:length(vv)
    Vx = vv(i);   
    ay_gain(i) = Vx^2/(L+(K*Vx^2));
    ay_gain_neutral(i) = Vx^2/(L+(K_neutral*Vx^2));
    ay_gain_over(i) = Vx^2/(L+(K_over*Vx^2));
end

figure(12)
hold all
plot(vv, ay_gain)
plot(vv, ay_gain_over, 'r')
plot(vv, ay_gain_neutral, 'k')
xline(V_cr, '--g', 'LineWidth', 1);
title('\textbf{Lateral acceleration gain $a_y / \delta$}', 'Interpreter', 'latex')
xlabel('V')
ylabel('$a_y$ [1e4]', 'Interpreter', 'latex')
legend('K > 0', 'K < 0', 'K = 0')
xlim([0, V_cr])
ylim([0, 2.5e4])
%% Yaw rate gain

yaw_rate_gain = zeros(length(vv), 1);
yaw_rate_gain_over = zeros(length(vv), 1);
yaw_rate_gain_neutral = zeros(length(vv), 1);

for i=1:length(vv)
    Vx = vv(i);   
    yaw_rate_gain(i) = Vx/(L+(K*Vx^2));
    yaw_rate_gain_neutral(i) = Vx/(L+(K_neutral*Vx^2));
    yaw_rate_gain_over(i) = Vx/(L+(K_over*Vx^2));
end

figure(13)
hold all
plot(vv, yaw_rate_gain)
plot(vv, yaw_rate_gain_over, 'r')
plot(vv, yaw_rate_gain_neutral, 'k')
xline(V_cr, '--g', 'LineWidth', 1);
title('\textbf{Yaw rate gain $r / \delta$}', 'Interpreter', 'latex')
xlabel('V')
ylabel('$r$', 'Interpreter', 'latex')
legend('K > 0', 'K < 0', 'K = 0')
xlim([0, V_cr])
ylim([0, 300])

%% Sideslip angle gain 

sideslip_gain = zeros(length(vv), 1);
sideslip_gain_over = zeros(length(vv), 1);
sideslip_gain_neutral = zeros(length(vv), 1);

for i=1:length(vv)
    Vx = vv(i);   
    sideslip_gain(i) = ar*(1-((m*af*Vx^2)/(af*L*CR)))/(L+K*Vx^2);
    sideslip_gain_over(i) = ar*(1-((m*af*Vx^2)/(af*L*CR_over)))/(L+K_over*Vx^2);
    sideslip_gain_neutral(i) = ar*(1-((m*af*Vx^2)/(af*L*CR_neutral)))/(L+K_neutral*Vx^2);
end

figure(14)
hold all
plot(vv, sideslip_gain)
plot(vv, sideslip_gain_over, 'r')
plot(vv, sideslip_gain_neutral, 'k')
xline(V_cr, '--g', 'LineWidth', 1);
title('\textbf{Sideslip angle gain $\beta / \delta$}', 'Interpreter', 'latex')
xlabel('V')
ylabel('$\beta$', 'Interpreter', 'latex')
legend('K > 0', 'K < 0', 'K = 0')
xlim([0, V_cr])
ylim([-250, 90])