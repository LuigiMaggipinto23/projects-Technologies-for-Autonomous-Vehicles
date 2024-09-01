% La pressione del pedale è quasi lineare alla corrente che viene 'passata'
% alla batteria per il calcolo della potenza. 

num_points = 10000;
total_time = 5; %[s]

t = linspace(0, total_time, num_points);
Pedal = zeros(1, num_points);

% Ciclo per assegnare i valori a Q
for i = 1:num_points
    if t(i) <= delay_acc
        Pedal(i) = 0;
    else
        Pedal(i) = acc_pedal;
    end
end

% Plot
plot(t, Pedal);
xlabel('Tempo (s)');
ylabel('Pression');

P_max = 150e3; % [W]
C_max = 310; % [Nm]
RPM_max = 16000; % max speed [rpm]

% Q_bar = Q_max * Pression_ped;
% P_batt = Q_bar * V; 
P_batt = P_max * acc_pedal;

% Efficiency 
eff_engine = 0.90;
eff_trasmission = 0.95;

P_motore = P_batt * eff_engine;
C_motore= (acc_pedal * C_max) * eff_engine; 
 
% Parametri del motore elettrico
RPM_bar = P_motore * 60 / (2 * pi * C_motore); % RPM corrispondenti a P_max e C_max

% RPM da 0 a 16000
RPM = linspace(0, RPM_max, 1000);

% Calcolo di P
P = zeros(size(RPM));
P(RPM <= RPM_bar) = (P_motore / RPM_bar) * RPM(RPM <= RPM_bar);
P(RPM > RPM_bar) = P_motore;

% Calcolo di C
C = zeros(size(RPM));
C(RPM <= RPM_bar) = C_motore;
C(RPM > RPM_bar) = (P_motore * 60) ./ (2 * pi * RPM(RPM > RPM_bar));

% Plot
figure;
yyaxis left;
plot(RPM, C, 'b');
xlabel('RPM');
ylabel('Coppia (Nm)');
title('Andamento di Potenza e Coppia del Motore Elettrico');
yyaxis right;
plot(RPM, P, 'r');
ylabel('Potenza (W)');
legend('Coppia', 'Potenza');
