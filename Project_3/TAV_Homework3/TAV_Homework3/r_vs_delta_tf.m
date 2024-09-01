function fdt = r_vs_delta_tf(V)

s = tf('s');

m = 1575; % vehicle mass
Jz = 2875; % yaw mass moment of inertia
af = 1.3; % front semi-wheelbase
ar = 1.5; % rear semi-wheelbase
CF = 2*6*1e4; % front axle cornering stiffness 
CR = 2*5.7*1e4; % rear axle cornering stiffness 
Yb = -(CF+CR);
Yr = (1/V)*(-af*CF + (ar*CR));
Yd = CF;
Nb = (-af*CF + (ar*CR));
Nr = -(1/V)*(af^2*CF + (ar^2*CR));
Nd = af*CF;

num = Nd*s + (Nb*Yd - (Yb*Nd))/(m*V);
denom = Jz*s^2 + (-Nr -(Yb*Jz)/(m*V))*s + (Nb + (Yb*Nr-(Yr*Nb))/(m*V));
fdt = num/denom;

end