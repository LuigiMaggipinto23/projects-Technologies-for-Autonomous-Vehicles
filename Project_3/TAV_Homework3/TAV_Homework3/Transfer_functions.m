close all

% Transfer function beta/delta
Vx = 50/3.6;
beta_vs_delta_50 = beta_vs_delta_tf(Vx);

figure(7)
damp(beta_vs_delta_50)
h = bodeplot(beta_vs_delta_50);
setoptions(h, 'FreqUnits', 'Hz', 'PhaseVisible', 'on', 'Grid', 'On', ...
    'Xlim', [0.1 5], 'MagScale', 'Linear', 'MagUnits', 'abs');
hold on

Vx = 120/3.6;
beta_vs_delta_120 = beta_vs_delta_tf(Vx);

h1 = bodeplot(beta_vs_delta_120);
setoptions(h1, 'FreqUnits', 'Hz', 'PhaseVisible', 'on', 'Grid', 'On', ...
    'Xlim', [0.1 5], 'MagScale', 'Linear', 'MagUnits', 'abs');


title('\textbf{Bode Plots of tf $\frac{\beta}{\delta}$}', 'Interpreter', ...
    'latex');

figure(8) 
step(beta_vs_delta_50)
hold on 
step(beta_vs_delta_120)
title('\textbf{Step Response $\beta$}', 'Interpreter', 'latex')

% Transfer function r/delta 
Vx = 50/3.6;
r_vs_delta_50 = r_vs_delta_tf(Vx);

figure(9)
damp(r_vs_delta_50)
h = bodeplot(r_vs_delta_50);
setoptions(h, 'FreqUnits', 'Hz', 'PhaseVisible', 'on', 'Grid', 'On', ...
    'Xlim', [0.1 5], 'MagScale', 'Linear', 'MagUnits', 'abs');
hold on

Vx = 120/3.6;
r_vs_delta_120 = r_vs_delta_tf(Vx);

h1 = bodeplot(r_vs_delta_120);
setoptions(h1, 'FreqUnits', 'Hz', 'PhaseVisible', 'on', 'Grid', 'On', ...
    'Xlim', [0.1 5], 'MagScale', 'Linear', 'MagUnits', 'abs');


title('\textbf{Bode Plots of tf $\frac{r}{\delta}$}', 'Interpreter', ...
    'latex');

figure(10) 
step(r_vs_delta_50)
hold on 
step(r_vs_delta_120)
title('\textbf{Step Response $r$}', 'Interpreter', 'latex')
