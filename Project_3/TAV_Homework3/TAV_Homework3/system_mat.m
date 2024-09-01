function [A, B, C, D] = system_mat(Vx)

    % Parameters
    m = 1575; % vehicle mass
    Jz = 2875; % yaw mass moment of inertia
    af = 1.3; % front semi-wheelbase
    ar = 1.5; % rear semi-wheelbase
    CF = 2*6*1e4; % front axle cornering stiffness 
    CR = 2*5.7*1e4; % rear axle cornering stiffness 

    A = [0 1 0 0
        0 -(CF+CR)/(m*Vx) (CF+CR)/m ((CR*ar)-(CF*af))/(m*Vx)
        0 0 0 1
        0 ((CR*ar)-(CF*af))/(Jz*Vx) ((CF*af)-(CR*ar))/Jz -((CR*ar^2)+(CF*af^2))/(Jz*Vx)];
    
    B1 = [0 CF/m 0 (CF*af)/Jz]';
    
    B2 = [0 ((((CR*ar)-(CF*af))/(m*Vx))-Vx) 0 ((CR*ar^2)+(CF*af^2))/(-Jz*Vx)]';
    B = [B1 B2];

    C = eye(4);
    D = zeros(4,2);
end