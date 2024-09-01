function tdf = beta_vs_delta_tf(Vx)

s = tf('s');

m = 1575; % vehicle mass
Jz = 2875; % yaw mass moment of inertia
af = 1.3; % front semi-wheelbase
ar = 1.5; % rear semi-wheelbase
CF = 2*6*1e4; % front axle cornering stiffness 
CR = 2*5.7*1e4; % rear axle cornering stiffness 
Yb = -(CF+CR);
Yr = (1/Vx)*(-af*CF + (ar*CR));
Yd = CF;
Nb = (-af*CF + (ar*CR));
Nr = -(1/Vx)*(af^2*CF + (ar^2*CR));
Nd = af*CF;

num = Jz*Yd*s/(m*Vx) + (-Nr*Yd - Nd*(m*Vx - Yr))/(m*Vx);
denom = Jz*s^2 + (-Nr -(Yb*Jz)/(m*Vx))*s + (Nb + (Yb*Nr-(Yr*Nb))/(m*Vx));
tdf = num/denom;

end