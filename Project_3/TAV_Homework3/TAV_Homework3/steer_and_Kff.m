close all

% How Steer and KFF change with rear axle cornering stiffness variatons

delta = linspace(0,20000, 20);

Cr = zeros(length(delta));
ST = zeros(length(delta));
kff = zeros(length(delta));

for i = 1:length(delta)
    Cr(i) = CR - delta(i);
    ST(i) = (CF * af - ((CR - delta(i)) * ar)); 
    kff(i) = ((m*Vx^2)/L)*((ar/CF) - (af/Cr(i)) + ((af*K(3))/Cr(i))) + L - ar*K(3);
end

figure(9)
plot(Cr, ST, 'o-'); 
xlabel('Rear Cornering Stiffness [1e5]');
ylabel('Steer type [1e4]');
title('Oversteering/Understeering/Neutral');
xlim([0.9e5, 1.15e5])


hold on;
line(get(gca,'XLim'), [0 0], 'Color', 'r', 'LineWidth', 0.5);

text(min(get(gca,'XLim')), max(get(gca,'YLim')), 'Oversteering', 'Color', 'g', 'FontSize', 10, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
text(mean(get(gca,'XLim')), 0, 'Neutral', 'Color', 'r', 'FontSize', 10, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
text(max(get(gca,'XLim')), min(get(gca,'YLim')), 'Understeering', 'Color', 'g', 'FontSize', 10, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
hold off;

figure(10)
plot(Cr, kff);
xlabel('Rear Cornering Stiffness [1e5]');
ylabel('K_{ff}')
title('K_{ff}');
xlim([0.9e5, 1.15e5])
ylim([-0.75, -0.4])