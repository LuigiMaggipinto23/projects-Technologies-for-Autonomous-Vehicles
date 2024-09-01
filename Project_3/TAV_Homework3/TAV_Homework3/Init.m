clear all
close all
clc

% Main file - here you set all the parameters and simulate the system in
% simulink. There is also the frequency analysis


% Parameters
m = 1575; % vehicle mass
Jz = 2875; % yaw mass moment of inertia
af = 1.3; % front semi-wheelbase
ar = 1.5; % rear semi-wheelbase
CF = 2*6*1e4; % front axle cornering stiffness 
CR = 2*5.7*1e4; % rear axle cornering stiffness 
L = af+ar;

% Prompt the user to enter a value to modify CR
delta_CR = input('Enter a value between -1.5e4 and 1.5e4 to modify CR: ');

% Check that the entered value meets the specifications
if delta_CR < -1.5e4 || delta_CR > 1.5e4
    % If the value does not meet the specifications, set it to 0
    disp('Invalid value. Setting to 0.');
    delta_CR = 0;
end

% Modify the value of CR
CR = CR + delta_CR;

% Display the new value of CR
disp(['The new value of CR is: ', num2str(CR)]);

tau_s = 15;     % steering ratio
delta_max = 25; % [deg];

% Input 
R = 10;

%% Select the manoeuvre
sel_man = menu('Select manoeuvre','Step steer','Sine Sweep','Drift','Obstacle Avoidance');

delta_vol_max_ramp = 0;
dvol_max = 0;
t_drift_cs_1 = 0; t_drift_cs_2 = 0;
dvol_drift1 = 0; dvol_drift2 = 0; dvol_drift3 = 0;
delay = 1;
delay_return = 13+delay;

if isempty(sel_man)
    sel_man=1;
end
switch sel_man
    case 1
        %         (Step steer)
        Ts = 10;      % [s]
        Vx = 30/3.6;  % [m/s]
    case 2
        %        (Sine)
        Ts = 100;
        t_end_sim=5;
        Vx = 30/3.6;
    case 3
        Ts = 25;
        Vx = 80/3.6;                % (drift) [km/h]
        t_drift_cs_1 = 5*1 +3*0;
        t_drift_cs_2 = 14.38*1+ 7.136*0;
        dvol_drift= [30 -85*1+(-85*0.6*0) 0];
        dvol_drift1 = dvol_drift(1);
        dvol_drift2 = -dvol_drift(2)+dvol_drift(1);
        dvol_drift3 = dvol_drift(3)-dvol_drift(2);
    case 4
        Ts = 50;
        Vx = 80/3.6;                % [km/h]
        t_drift_cs_1 = 5*1+3*0;
        t_drift_cs_2 = t_drift_cs_1*2;
        dvol_drift= [30 30*2 30];
        dvol_drift1 = dvol_drift(1);
        dvol_drift2 = dvol_drift(2);
        dvol_drift3 = dvol_drift(3);

end

%% State Space Model
[A, B, C, D] = system_mat(Vx); 
eigenvalues = eig(A); 

%% POLES
P = [-2 - 2i, -2 + 2i, -6, -5;
    -23 + 6i, -23 - 6i, -9, -12;
    -2 + 2i, 0, -1.5, 0;
    -1 + 2i, -1 - 2i, -1, -1.5;
    -2 + 2i, -2 - 2i, -3 + 3i, -3 - 3i;
    -2 , -1, -3, -5];

% To check the poles, please follow the instructions in Poles.m

%% Simulation
close all

p = P(1,:);

K = place(A,B(:,1),p);

open("open_loop_lateral_dyn.slx");
sim("open_loop_lateral_dyn.slx");

% Trajectory
figure(1)
plot(X.Data, Y.Data,'LineWidth',3)
title('Trajectory')
xlabel('X')
ylabel('Y')
grid on
axis equal

steer_type = CF*af - (CR*ar) % negativo: understeering

if steer_type == 0
    disp("Neutral steering");
elseif steer_type > 0
    disp("Oversteering");
    V_cr = sqrt(CF*CR*L^2/(m*(af*CF-ar*CR)))*3.6;
    disp(['critical speed: ',num2str(round(V_cr*10)/10),' km/h'])
else
    disp("Understeering");
end

mf = m*af/L; mr = m-mf;
K_us_an = (mf/CF-mr/CR);
K_beta_an = (m/(L^2))*((CF*(af^2)+CR*(ar^2))/(CF*CR));

% tangent speed (beta=0)
V_beta0 = sqrt(ar*L*CR/af/m)*3.6;
disp(' ')
disp(['understeering gradient: K_US = ',num2str(K_us_an),' rad/(m/s^2)'])
disp(['slip angle gradient: K_beta = ',num2str(K_beta_an),' rad/(m/s^2)'])
disp(['tangent speed: V_beta = ',num2str(V_beta0),' km/h'])

%% Frequency 
vv =10:5:300;
vv = vv/3.6;

POLES = zeros(length(vv),4);
ZETA = zeros(length(vv),4);
FREQ = zeros(length(vv),4);

for i=1:length(vv)

    % State Space Model
    [A, B, C, D] = system_mat(vv(i));    
    G = ss(A,B,C,D);

    [Wn,Z,P] = damp(G);
    POLES(i,:)=P;
    ZETA(i,:)=Z;
    FREQ(i,:)=Wn;

    DET_A(i)=det(A);
    TR_A(i)=trace(A);
end

figure(1)
plot(FREQ(:,3:4));
legend('wn1', 'wn2')
title('Natural Frequencies')

figure(2)
plot(ZETA(:,3))
hold on
plot(ZETA(:,4),'square')
legend('\xi_1', '\xi_2')
title('Damping Ratio')

figure(3)
plot(real(POLES(:,3:4)),imag(POLES(:,3:4)),'o')
title('Poles')
