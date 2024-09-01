% European Brake regulations

%If you want to evaluate the European Brake regulations with other tests
%change the .mat below. In particular, it is mandatory to press the brake
% pedal to perform the test correctly.
load results_mu_0_85_emergency_brake.mat
acc_vehicle = [];
beta = 0.75;

for i = 1:length(ax.Data)
    if ax.Data(i) < 0
        acc_vehicle = [acc_vehicle, abs(ax.Data(i))];
    end
end

z = sort(acc_vehicle / g);

eq4 = NaN(size(z));
eq5 = NaN(size(z));
eq6 = NaN(size(z));

condition_eq4 = (z > 0.15) & (z < 0.8);
eq4(condition_eq4) = (b + (z(condition_eq4) * h)) ./ L;

condition_eq5 = (z > 0.15) & (z < 0.52);
eq5(condition_eq5) = ((z(condition_eq5) + 0.04) .* (b + (z(condition_eq5) * h))) ./ (0.7 * L * z(condition_eq5));

eq6(condition_eq5) = 1 - (((z(condition_eq5) + 0.04) .* (a - z(condition_eq5) * h)) ./ (0.7 * L * z(condition_eq5)));

figure(7);
hold on;
plot(z, eq4, 'r-', 'DisplayName', 'eq4');
plot(z, eq5, 'g-', 'DisplayName', 'eq5');
plot(z, eq6, 'b-', 'DisplayName', 'eq6');

yline(beta, 'r--', 'LineWidth', 1.5, 'DisplayName', ['\beta = ' num2str(beta)]);
yline(1, 'm--', 'DisplayName', '\beta = 1');

xlabel('z');
ylabel('\beta');
title('European Brake Regulations');
xlim([0, 1]);
legend;
hold off