%% INSTRUCTIONS:
% Run this first section to populate the workspace 
% with all variables that the model needs,
% then each test section can be run separtely.
% If you run all at once, all results will be saved in
% separate files to be later analysed.

%% Inizialise parameters

% TAV module
close all; clc; clear; 
warning off

% Load tyre data (Pacejka model coefficients)
% File with the tyre data
WheelFile = 'Tyre215_50_19_Comb';      
% Wheel Initialization
pacn = [];
eval(['[Pacejka]=' WheelFile ';'])
pacn = struct2cell(Pacejka);
for ii = 1:size(pacn)
    Pace(ii) = pacn{ii};
end
Pacn = Pace';     % array containing the coefficients of Pacejka tyre model

% Battery
V = 800; % [V]
E_max = 58e3; % [Wh]
Q_max = E_max/V; % [A]
SOC_init = 0.95; % initial State Of Charge

% Electric Motor
gear_ratio = 10.5; 
eff_transmission = 0.95;
eff_engine = 0.9;
% Wheel mass moment of inertia [kg m^2]
Jns = 1;

rho = 1.29; % [kg/(m^3)] aereodrag coefficient
Cx = 0.27; 

% Torsional stiffness [N*m/rad]
Kt = 9000;

% Tyre rolling resistance coefficients
f0 = 0.009; % [-]
f1 = 0; % [s/m]
f2 = 6.5e-6;  % [s^2/m^2]

% Vehicle parameters
Af = 2.36; % frontal area [m^2]
m = 1812; % vehicle mass [kg]
g = 9.81; % gravity [m/s^2] 
L = 2.77; % wheelbase [m]

Wr = 0.5*m;
a = (Wr*L)/m; % distanza orizzontale del centro di gravità CG dal front axle 
b = L-a;

alpha = 0; % pendenza strada 
gamma = 0; % camber angle
h = 0.55; % altezza CG dal terreno


Radius = 0.35; % [m] raggio ruota

% Braking
max_braking_force = 15*m; 
delay_brake = 0.02; % 20 ms

% Brake pedal parameters
l_p = 5; % brake pedal ratio
B = 5; % brake booster ratio
eta_p = 0.9;
max_dec = -0.2*g;

% Regeneration
regen_scaling = 1/10;

delay_acc = 0.02;

% Relaxation lengths [m]
lon_r = 0.055;

Ts = 100;

%% Regular Test
acc_pedal = 1;
time_acc = 1;
velstart = 10;

delay_release_acc = 30;

brake_pedal = 0.4; 
time_brake = 30;

delay_release_brake = 10;

tip_in_tip_off = 0;

mu = 0.85;

open("Project_model_2023b.slx")
sim("Project_model_2023b.slx")

save results_regular_test vel_engine C Er Fx_rear w_rear slip_rear ...
    Fx_front w_front slip_front F_a F_roll_rear F_roll_front vx ax tout

%% Acceleration time test

acc_pedal = 1;
time_acc = 1;
velstart = 1;

delay_release_acc = (Ts-1);

brake_pedal = 0; 
time_brake = 0;
delay_release_brake = 1;

tip_in_tip_off = 0;

mu = 0.85;

sim("Project_model_2023b.slx")

save results_acc_times vel_engine C Er Fx_rear w_rear slip_rear ...
 Fx_front w_front slip_front F_a F_roll_rear F_roll_front vx ax tout

%% Tip-in Tip-off test

acc_pedal = 1;
time_acc = 5;
velstart = 10;
delay_release_acc = 1;

brake_pedal = 1; 
time_brake = 19;
delay_release_brake = 1;

tip_in_tip_off = 1;

sim("Project_model_2023b.slx")

save results_tipin_tipoff vel_engine C Er Fx_rear w_rear slip_rear ...
    Fx_front w_front slip_front F_a F_roll_rear F_roll_front vx ax tout

%% Longitudinal acceleration and speed test 

velstart = 10;

acc_pedal = 1;
time_acc = 0;
delay_release_acc = 30;

brake_pedal = 0.6; 
time_brake = 30;
delay_release_brake = 10;

tip_in_tip_off = 0;

mmu = [0.90 0.85 0.75];
mmu2str = [90 85 75];

for i = 1:length(mmu)
    mu = mmu(i);
    sim("Project_model_2023b.slx")
    save(strcat(['results_mu_0_',num2str(mmu2str(i)),'_speed_test']), ...
        'vx', 'ax', 'tout');
end

%% Emergency braking test 

acc_pedal = 0;
velstart = 100/3.6;

brake_pedal = 1; 
time_brake = 0;
delay_release_brake = 100;

tip_in_tip_off = 0;

mmu = [0.85 0.75];
mmu2str = [85,75];

for i = 1:length(mmu)
    mu = mmu(i);
    sim("Project_model_2023b.slx")
    save(strcat(['results_mu_0_',num2str(mmu2str(i))],'_emergency_brake'), ...
        'vx', 'ax', 'tout');
end
