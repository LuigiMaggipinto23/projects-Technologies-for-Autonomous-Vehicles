close all

% Pole placement - To use it, run Init.m until POLES section

for i = 1:size(P,1)
    if any(real(P(i,:)) > 0)
        disp(['Pole configuration ', num2str(i), ' is unstable due to eigenvalues with positive real parts.']);
        continue;
    end
    K = acker(A, B(:,1), P(i,:));

    open("open_loop_lateral_dyn.slx")
    sim("open_loop_lateral_dyn.slx")

    error_1 = e1.Data;

     if abs(error_1(end)) > 1e-3
        disp(['Pole configuration ', num2str(i), ' did NOT achieve asymptotic stability.']);
     elseif abs(error_1(end)) <= 1e-3 && abs(error_1(end)) > 1e-5
        disp(['Pole configuration ', num2str(i), ' needs more time to achieve asymptotic stability.']);
        disp(['Max error: ', num2str(max(abs(error_1(:))))]);
     else
        disp(['Pole configuration ', num2str(i), ' achieved asymptotic stability.']);
        disp(['Max error: ', num2str(max(abs(error_1(:))))]);
    end
end