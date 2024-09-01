close all

% Bode plots

StatesNames = {'e_1', 'e1_dot', 'e_2', 'e2_dot'};
InputNames = {'\delta', '\psi_d'};
OutputNames = {'e1', 'e1_dot', 'e_2', 'e2_dot'};

indices = [1 3]; 

[A, B, C, D] = system_mat(40/3.6);
sys = ss(A,B,C(indices,:),D(indices,:),'StateName', StatesNames, 'InputName', InputNames, ...
    'OutputName', OutputNames(indices));

hfig = figure('Name','Bode Plots V_x = 40 km/h');
h = bodeplot(sys);
title('Bode Plots V_x = 40 km/h');
setoptions(h, 'FreqUnits', 'Hz', 'PhaseVisible', 'on', 'Grid', 'On', ...
    'Xlim', [0.1 10], 'MagScale', 'Linear', 'MagUnits', 'abs');

[A, B, C, D] = system_mat(300/3.6);
sys = ss(A,B,C(indices,:),D(indices,:),'StateName', StatesNames, 'InputName', InputNames, ...
    'OutputName', OutputNames(indices));

hfig = figure('Name','Bode Plots V_x = 300 km/h');
h = bodeplot(sys);
title('Bode Plots V_x = 300 km/h');
setoptions(h, 'FreqUnits', 'Hz', 'PhaseVisible', 'on', 'Grid', 'On', ...
    'Xlim', [0.1 10], 'MagScale', 'Linear', 'MagUnits', 'abs');

