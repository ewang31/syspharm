function dydt = ldopa_eqns(t,y,p)
% This function defines equations to simulate how l-dopa affects dopamine
% concentration.

%% Parameters
% I will just be defining paramaters here. Some of these do NOT change.

ka = p(1); %Absorption from gut
k_cl = p(2); %Clearence rate of levopa from central
k_cl_dop = p(3); %Clearence rate of dopamine from central
k_met = p(4); %Metabolism rate of l-dopa to dopamine
k_prod = p(5); %Production rate of dopamine in the brain
k_abs = p(6); %Absorption rate of dopamine in the brain
k12 = p(7); %Transport from the central to brain
k21 = p(8); %Transport from brain to central
V1 = p(9); % Central compartment volume
V2 = p(10); % Brain compartment volume

k12 = k12 * V2/V1;
%% Equations
dydt = zeros(6,1);
dydt(1) = -ka * V1 *  y(1); %Drug in the gut
dydt(2) = ka * y(1) - k_cl * y(2) - k12 * y(2) - k_met * y(2) + k21 * y(4) * V2 / V1; %l-dopa in the blood stream
dydt(3) = k_met * y(2) - k_cl_dop * y(3); %dopamine in blood stream
dydt(4) = k12 * y(2) * V1 / V2 - k21 * y(4) - k_met * y(4); %l-dopa in the brain
dydt(5) = k_met*y(4) + k_prod - k_abs * y(5); %dopamine in the brain
dydt(6) = k_cl*y(2)*V1 + k_met*y(2)*V1 + k_met*y(4)*V2; %Mass balance

end