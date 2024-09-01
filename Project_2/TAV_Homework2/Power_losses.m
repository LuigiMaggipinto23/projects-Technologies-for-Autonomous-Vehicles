%% Plots
close all
clc

%If you want to evaluate the Power Losses with other tests
%change the .mat below
load results_regular_test.mat

% Parameters
eta_engine = 0.9;
eta_trasmission = 0.95;
E_max = 58e3; % [Wh]
SOC_init = 0.95; % initial State Of Charge
Radius = 0.35; % [m]

%% Power necessary for motion
w_engine = vel_engine.Data * 2 * pi / 60;
Pn = C.Data .* w_engine / eta_engine;

figure(1)
plot(tout,Pn)
title('Power necessary for motion')
xlabel('Time [s]')
ylabel('Power [W]')


%% Energy recuperated
figure(2)
plot(tout,Er.Data/3600)
title('Energy recuperated')
xlabel('Time [s]')
ylabel('[Wh]')

%% State of Charge
En = cumtrapz(tout, Pn); 
E_out = (En - Er.Data) / 3600;
Delta_SOC = E_out / E_max;
SOC = (SOC_init*ones(length(Delta_SOC),1)) - Delta_SOC;

figure(3)
plot(tout,SOC)
title('State of Charge')
xlabel('Time [s]')
ylabel('SOC [%]')

%% Longitudinal slip power losses
C_rear = Fx_rear.Data * Radius;
P_long_slip_rear = (C_rear.* (w_rear.Data)).*(slip_rear.Data);

figure(4)
plot(tout,P_long_slip_rear)
title('Longitudinal slip power losses')
xlabel('Time [s]')
ylabel('[W]')

C_front = Fx_front.Data * Radius;
P_long_slip_front = (C_front.* (w_front.Data)).*(slip_front.Data);

hold on
plot(tout,P_long_slip_front)
legend('Rear axle', 'Front axle')
hold off

%% Trasmission and electric powertrain power losses
P_trasmission = Pn*(1-eta_trasmission);
P_powertrain = Pn*(1-eta_engine);

figure(5)
plot(tout,P_trasmission)
hold on 
plot(tout,P_powertrain)
hold off
title('Trasmission and powertrain power losses')
xlabel('Time [s]')
ylabel('[W]')
legend('Transmission', 'Powertrain')

%% Aerodynamic power loss
P_aero_drag = F_a.Data .* vx.Data;

figure(6) 
plot(tout,P_aero_drag)
title('Aerodynamic power loss')
xlabel('Time [s]')
ylabel('[W]')

%% Rolling resistance power losses

P_roll_rear = (F_roll_rear.Data * Radius) .* (w_rear.Data);
P_roll_front = (F_roll_front.Data * Radius) .* (w_front.Data);

figure(7)
plot(tout,P_roll_rear)
hold on 
plot(tout,P_roll_front)
hold off
title('Rolling resistance power losses')
xlabel('Time [s]')
ylabel('[W]')
legend('Rear axle', 'Front axle')


