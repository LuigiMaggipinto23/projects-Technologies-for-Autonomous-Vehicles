%% Ideal vs real braking characteristic
close all

% Parameters
m = 1812; % vehicle mass [kg]
g = 9.81;
h = 0.55; % altezza CG dal terreno
L = 2.77; % wheelbase [m]
a = L/2; % distanza orizzontale del centro di gravità CG dal front axle 
b = L-a;
FR_ratio = 3; % front = 3 * rear

% Load
m_person = 60; % [kg]
m_driver = m_person;
m_passengers = 4*m_person;
m_trunk10 = 10; % [kg]
m_trunk50 = 50; % [kg]
offset = 0.5; % [m]

% Standard B: driver + 10 kg in the trunk
a_stdB = ((m*a) + (m_driver*offset) + (m_trunk10*(L+offset))) / (m + m_driver + m_trunk10);
b_stdB = L - a_stdB;

% Standard F: driver + 4 passengers + 50 kg in the trunk
a_stdF = ((m*a) + (m_driver*offset) + (m_passengers*(L-offset)) + (m_trunk50*(L+offset))) ...
    / (m + m_driver + m_passengers + m_trunk50);
b_stdF = L - a_stdF;

mu  = 0.01:0.01:2;
aa = [a a_stdB a_stdF];
bb = [b b_stdB b_stdF];
mm = [m m+m_driver+m_trunk10 m+m_driver+m_passengers+m_trunk50];

figure(1)
hold all

for i=1:3
    F_XF_ideal = mm(i)*g*mu.*(bb(i)+mu*h)/L;
    F_XR_ideal = mm(i)*g*mu.*(aa(i)-mu*h)/L;
    plot(F_XR_ideal,F_XF_ideal)
    plot(F_XR_ideal(mu==0.9),F_XF_ideal(mu==0.9),'rx','HandleVisibility', 'off')
    if i ~= 1 
        text(F_XR_ideal(mu==0.9), F_XF_ideal(mu==0.9), '\mu = 0.9', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    end
end

F_XR_real = linspace(0,max(F_XR_ideal),length(mu));
F_XF_real = FR_ratio*F_XR_real;
plot(F_XR_real,F_XF_real)
ylim([0, max(F_XF_ideal)])

title('Ideal vs real braking parabola')
xlabel('F_{XR} [N]');
ylabel('F_{XF} [N]');
legend('Ideal empty vehicle', 'Ideal STD.B', 'Ideal STD.F', 'Real')
hold off

% Normalizzando per massa 
F_XF_ideal_norm = F_XF_ideal/(m*g);
F_XR_ideal_norm = F_XR_ideal/(m*g);

figure(2)
hold all

% Ideal brake characteristic
% > cambiare l'indice i=1:3 se si vogliono tutte e 3
for i=2:2
    F_XF_ideal_norm = mu.*(bb(i)+mu*h)/L;
    F_XR_ideal_norm = mu.*(aa(i)-mu*h)/L;
    plot(F_XR_ideal_norm,F_XF_ideal_norm,'LineWidth',3)
end

% Real brake characteristic
plot(F_XR_real,F_XF_real,'LineWidth',3)

% Deceleration lines
% Su bagnato mu = 0.35
aG_wet = [0.258 0.349];
% Su asciutto mu = 0.8
aG_dry = [0.68 0.81];

aG = aG_dry;
for i=1:length(aG)
    x = linspace(0,max(F_XR_ideal),length(mu));
    y = -x + aG(i);
    plot(x,y,'r--','LineWidth',2,'HandleVisibility', 'off')
end

% Su bagnato mu = 0.35
% text(0.2, 0.1, 'a_G=-0.26g', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
% text(0.23, 0.18, 'a_G=-0.35g', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
% Su asciutto mu = 0.8
text(0.45, 0.45, 'a_G=-0.81g', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
text(0.37, 0.35, 'a_G=-0.0.68', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    

mmu = [0.35 0.8];
front_wheels_lock = zeros(length(mmu), length(F_XR_real));

% Front wheels locking conditions 
for i=1:length(mmu)
    x = linspace(0,1,length(F_XR_real));
    front_wheels_lock(i,:) = (mmu(i)*(b + (h*x))/(L-(mmu(i)*h)));
    plot(x,front_wheels_lock(i,:))
end

% Rear wheels locking conditions 
for i=1:length(mmu)
    y = a/h - (L+(mmu(i)*h))*x/(mmu(i)*h);
    plot(x,y,'--')
end

title('Ideal vs real braking parabola with normalised forces')
xlabel('|F_{XR}|/mg [-]')
ylabel('|F_{XF}|/mg [-]')
ylim([0 1])
xlim([0 0.5])

legend( ...
    ... %'Ideal empty vehicle', 
    'Ideal STD.B', ...
    ... %'Ideal STD.F', 
    'Real empty', ...
    '\mu = 0.35 front', '\mu = 0.8 front', ...
    '\mu = 0.35 rear', '\mu = 0.8 rear')

hold off
%%
efficiency_wet = aG_wet(1)/mmu(1)
efficiency_dry = aG_dry(1)/mmu(2)