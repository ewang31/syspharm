%% Generate Normally Distributed Pop
numPatients = 2;

[xdist,fig] = q1_starter(numPatients);

V1 = 2.5 * (xdist/180).^0.45;

results = fopen('simulationData.csv','w');
fprintf(results,"AUC,Cmax,Cmin,Weight,Gender\n");
genders = ["Male\n","Female\n"];
for i = 1:2
    for j = 1:numPatients
        [~,~,AUC,Cmax,Cmin] = runPatient(xdist(i,j),300,"Gut");
        fprintf(results,num2str(AUC) + "," + num2str(Cmax) + ",");
        fprintf(results,num2str(Cmin) + "," + num2str(xdist(i,j)) + ",");
        fprintf(results,genders(i));
    end
end

fclose(results);