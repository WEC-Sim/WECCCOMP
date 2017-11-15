%Example of user input MATLAB file for post processing
close all
clear power power_eff

%Plot waves
waves.plotEta(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end
rampTime = simu.rampTime;

%Plot RY response for Float
output.plotResponse(1,5);    

%Plot RY forces for Float
plotForces(output,1,5)

%Calculate and plot power 
time =  output.ptos.time;
power = output.ptos.powerInternalMechanics(:,3);
eff = 0.7;
for i = 1:length(power)
    if power(i)>= 0
        power_eff(i) = power(i)*eff;
    else
        power_eff(i) = power(i)/eff;
    end
end
figure
plot(time,power,time,power_eff)
hold on
line([rampTime,rampTime],[1.25*min(power),1.25*max(power)],'Color','k')
xlabel('Time (s)')
ylabel('Power(W)')
title(['body' num2str(1) ' (' output.bodies(1).name ') Power'])
legend('power','power w/eff')