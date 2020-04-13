
%% Parameters that might change
D0 = 42;
ka = log(2) / 2.77;
V1 = 2.5;
V2 = 1.5;

%% Parameters that probably won't

k12 = log(2) / 2.77;
k21 = k12;
k_abs = .693;
k_prod = .5; %NOTE THESE HAVE NO BASIS NEED TO CHANGE IT
k_met = .1; %NOTE THEIS HAS NO BASIS NEED TO CHANGE IT
k_cl = 0.2462;
k_cl_dop = 20.49;

%% Actual Simulation

y0 = [D0 0 0 0 .7]; %NOTE THERE NEEDS TO BE AN INITIAL DOPAMINE CONCENTRATION I NEED TO DO THE MATH ON THAT
p = [ka k_cl k_cl_dop k_met k_prod k_abs k12 k21 V1 V2];


options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
[T1,Y1] = ode45(@ldopa_eqns,[0 50],y0,options,p); % simulate model


figure;
subplot(2,2,1);
plot(T1,Y1(:,2));
title("L-dopa Central")
xlabel("Hours")

subplot(2,2,2);
plot(T1,Y1(:,3));
title("Dopamine Central")
xlabel("Hours")

subplot(2,2,3);
plot(T1,Y1(:,4));
title("L-dopa Brain")
xlabel("Hours")

subplot(2,2,4);
plot(T1,Y1(:,5));
title("Dopamine Brain")
xlabel("Hours")