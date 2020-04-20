function [xdist, fig] = q1_starter(NumberOfSubjects)
%% distribution parameters 


% Size of the populations - by making this a parameter, we can easily test 
% the code with small numbers that run quickly, and then run it with 
% larger populations once we're satisfied that it's working.

weightCutOff = 50;
% Minumum weight; set to 0 to only remove nonpositives
    
Male = 1;
Female = 2; % indexing for matrices

means(Male) = 191;
means(Female) = 164.3;
SD(Male) = 61.57;
SD(Female) = 67.32;

ls = {'-b';'-r'}; % linestyles for male, female distributions
GroupName = {'Male','Female'};

%% PART ONE - NORMAL DISTRIBUTIONS 
    
% Generate Normal Distribution lines
x = [1:1:300]; % x = weight, y = density
for i=Male:Female
    y(i,:) = 1/(SD(i)*sqrt(2*pi()))*exp((-(x(:)-means(i)).^2)/(2*SD(i)^2));
end

% Plotting the normal distributions by themselves
figure('visible','off');
title('Distribution of weights');    
xlabel('weight (lb)');
ylabel('density');
hold on;
for i=Male:Female
	plot (x,y(i,:),ls{i},'LineWidth',3); 
end
legend('Male','Female')

%% PART TWO - GENERATE 2 SUBPOPULATIONS USING RANDOM NUMBERS

% Initiate Random Numbers (helpful to make results reproducible)
rng(0,'twister');
% Generate Subpopulations
for i=Male:Female % 2 subpops 
	xtemp = SD(i).*randn(NumberOfSubjects,1)+means(i); 
    % This gives us a first attempt; next we must identify weights below 
    % the cutoff and replace them
    a=length(xtemp(xtemp<=weightCutOff)); % count people below x lb
    cycle = 1;
    while a>0 % if there are any nonpositives, replace them
        %fprintf ('series %i, cycle %i, negs %i\n',i,1,a);
        xtemp(xtemp<=50)=SD(i).*randn(a,1)+means(i);        
        a=length(xtemp(xtemp<=weightCutOff)); 
        cycle = cycle + 1;
	end % check again for nonpositives and loop if nec.
    xdist(i,:) = xtemp; % This is the final weight distribution
end


% Output the means, SDs of the simulated populations
simmeans = mean(xdist,2);
simSDs = std(xdist,0,2);
%fprintf('Male population, input mean %4.1f, simulated mean %4.1f; input SD %4.1f, simulated SD %4.1f \n',means(Male),simmeans(Male),SD(Male),simSDs(Male))
%fprintf('Female population, input mean %4.1f, simulated mean %4.1f; input SD %4.1f, simulated SD %4.1f \n',means(Female),simmeans(Female),SD(Female),simSDs(Female))
for i = Male:Female
	xtemp = round(xdist(i,:)); % xdist here is the list of patient weights for subpopulation i
    for j = 1:length(x)
    	ysamp(i,j) = length(xtemp(xtemp==x(j)))/NumberOfSubjects;
    end
end

% Overlaying normal distributions and the sample distributions
% three panels
fig = figure('visible', 'off');
title('Distribution of weights');    
ylabel('density');
xlabel('weight (lb)'); % note how we only need one x-axis label
hold on;
% Note how we generate different linestyles using conditional statements
for i=Male:Female
    plot (x,ysamp(i,:),ls{i},'LineWidth',2);
end
for i=Male:Female
    plot (x,y(i,:),ls{i},'LineWidth',1.5); 
	% did this separately so that these lines come to the front
end

% Boxplots
% Another way of visualizing the sample populations on one panel.
figure('visible','off');
hold on;
title('Weight distribution - sample subpopulations')
ylabel('Weight (lb)')
boxplot (xdist','Labels',GroupName);

patientID = (1:NumberOfSubjects)';
Weights = xdist';
save('WeightDistribs.mat','patientID','Weights');
end