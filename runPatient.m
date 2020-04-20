function[T1,Y1,AUC,C_max,C_min] = runPatient(V1,D0,dosageType)
       
    if(dosageType == "Gut")
        D_g = D0 * .3;
        D_l = 0;
    elseif(dosageType == "Lung")
        D_g = D0 * .5 * .3;
        D_l = D0 * .5;
    else
        error("Invalid variable name: dosageType");
    end
    %% Parameters that might change
    %V1 = 2.5; %Need to pass weight in here for this variable to change.
    

    %% Parameters that probably won't
    ka = log(2) / 2.77;
    V2 = 1.5;
    ka_lung = log(2)/1.5;
    k12 = log(2) / 2.77;
    k21 = k12;
    k_abs = .693;
    k_prod = .5; %NOTE THESE HAVE NO BASIS NEED TO CHANGE IT
    k_met = .1; %NOTE THEIS HAS NO BASIS NEED TO CHANGE IT
    k_cl = 0.2462;
    k_cl_dop = 20.49;

    %% Actual Simulation

    y0 = [D_g 0 0 0 k_prod/k_met D_l 0]; %NOTE THERE NEEDS TO BE AN INITIAL DOPAMINE CONCENTRATION I NEED TO DO THE MATH ON THAT
    p = [ka k_cl k_cl_dop k_met k_prod k_abs k12 k21 V1 V2 ka_lung];


    options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
    [T1,Y1] = ode45(@ldopa_eqns,[0 50],y0,options,p); % simulate model
    MassBal = ((Y1 * [1 V1 0 V2 0 1 1].') - (D_g+D_l))/(D_g+D_l);
    if(max(MassBal) > 1e-5)
        disp("Mass Balance Broken");
    end
    AUC = trapz(T1,Y1(:,5));
    C_max = max(Y1(:,5));
    C_min = min(Y1(:,5));

%     figure;
%     subplot(2,2,1);
%     plot(T1,Y1(:,2));
%     title("L-dopa Central")
%     xlabel("Hours")
%     ylabel("nM");
% 
%     subplot(2,2,2);
%     plot(T1,Y1(:,4));
%     title("L-dopa Brain")
%     xlabel("Hours")
%     ylabel("nM");
% 
%     subplot(2,2,3);
%     plot(T1,Y1(:,5));
%     title("Dopamine Brain")
%     xlabel("Hours")
%     ylabel("nM");
% 
%     subplot(2,2,4);
%     plot(T1,MassBal);
%     title("Mass Balance");
%     xlabel("Hours")
%     ylabel("Deviation");
end