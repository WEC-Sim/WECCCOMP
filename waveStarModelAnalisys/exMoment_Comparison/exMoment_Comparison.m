clearvars; close all; clc;
load('waveData.mat')

%% Plot wave elevation and excitation Moment using the values from Fixed Point A
 
 fig1=figure();fig1.Name='Sea States Fixed Point A'; fig1.ToolBar='none'; fig1.Units='Normalized'; fig1.OuterPosition=[0 0 1 1];
    subplot(3,2,1); yyaxis left; plot(FA_ss1.time,FA_ss1.elevation,'k');  ylabel('Wave Elavation [m]'); title('Sea State 1, H02'); hold on;
                               yyaxis right; plot(FA_ss1.time,FA_ss1.exM,'r'); ylabel('Excitation Moment [Nm]')
    subplot(3,2,2); yyaxis left;  plot(FA_ss2.time,FA_ss2.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 2, H02'); hold on;
                               yyaxis right; plot(FA_ss2.time,FA_ss2.exM,'r'); ylabel('Excitation Moment [Nm]')
    subplot(3,2,3); yyaxis left;  plot(FA_ss3.time,FA_ss3.elevation,'k'); ylabel('Wave Elavation [m]');  title('Sea State 3, H06'); hold on;
                               yyaxis right; plot(FA_ss3.time,FA_ss3.exM,'r'); ylabel('Excitation Moment [Nm]')
    subplot(3,2,4); yyaxis left;  plot(FA_ss4.time,FA_ss4.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 4, H06'); hold on;
                               yyaxis right; plot(FA_ss4.time,FA_ss4.exM,'r'); ylabel('Excitation Moment [Nm]')                    
    subplot(3,2,5); yyaxis left;  plot(FA_ss5.time,FA_ss5.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 5, H10'); hold on;
                               yyaxis right; plot(FA_ss5.time,FA_ss5.exM,'r'); ylabel('Excitation Moment [Nm]')
    subplot(3,2,6); yyaxis left;  plot(FA_ss6.time,FA_ss6.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 6, H10'); hold on;
                               yyaxis right; plot(FA_ss6.time,FA_ss6.exM,'r'); ylabel('Excitation Moment [Nm]')                              

 fig2=figure();fig2.Name='Sea States Fixed Point A_Normalized'; fig2.ToolBar='none'; fig2.Units='Normalized'; fig2.OuterPosition=[0 0 1 1];
    subplot(3,2,1); 
    plot(FA_ss1.time,FA_ss1.elevation./(max(FA_ss1.elevation)),'k-'); title('Sea State 1, H02'); hold on;
                    plot(FA_ss1.time,(FA_ss1.exM + 1.1267)./max(FA_ss1.exM + 1.1267),'r');
                    
    subplot(3,2,2); plot(FA_ss2.time,FA_ss2.elevation./(max(FA_ss2.elevation)),'k-'); title('Sea State 2, H02'); hold on;
                    plot(FA_ss2.time,(FA_ss2.exM + 1.1267)./max(FA_ss2.exM + 1.1267),'r');
                    
    subplot(3,2,3); plot(FA_ss3.time,FA_ss3.elevation./(max(FA_ss3.elevation)),'k-'); title('Sea State 3, H06'); hold on;
                    plot(FA_ss3.time,(FA_ss3.exM + 1.1267)./max(FA_ss3.exM + 1.1267),'r');                    
     
    subplot(3,2,4); plot(FA_ss4.time,FA_ss4.elevation./(max(FA_ss4.elevation)),'k-'); title('Sea State 4, H06'); hold on;
                    plot(FA_ss4.time,(FA_ss4.exM + 1.1267)./max(FA_ss4.exM + 1.1267),'r');
                    
    subplot(3,2,5); plot(FA_ss5.time,FA_ss5.elevation./(max(FA_ss5.elevation)),'k-'); title('Sea State 5, H10'); hold on;
                    plot(FA_ss5.time,(FA_ss5.exM + 1.1267)./max(FA_ss5.exM + 1.1267),'r');
                    
    subplot(3,2,6); plot(FA_ss6.time,FA_ss6.elevation./(max(FA_ss6.elevation)),'k-'); title('Sea State 6, H10'); hold on;
                    plot(FA_ss6.time,(FA_ss6.exM + 1.1267)./max(FA_ss6.exM + 1.1267),'r');                      
% clear fig1




%% Plot wave elevation and excitation Moment using wecSim output 
 close all; clc;
 fig3=figure();fig3.Name='Sea States wecSim'; fig3.ToolBar='none'; fig3.Units='Normalized'; fig3.OuterPosition=[0 0 1 1];
    subplot(3,2,1); yyaxis left; plot(exM_ss1.time,exM_ss1.elevation,'k');  ylabel('Wave Elavation [m]'); title('Sea State 1, H02'); hold on;
                               yyaxis right; plot(exM_ss1.time,exM_ss1.exM,'r'); ylabel('Excitation Moment [Nm]')                         
    subplot(3,2,2); yyaxis left;  plot(exM_ss2.time,exM_ss2.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 2, H02'); hold on;
                               yyaxis right; plot(exM_ss2.time,exM_ss2.exM,'r'); ylabel('Excitation Moment [Nm]')                               
    subplot(3,2,3); yyaxis left;  plot(exM_ss3.time,exM_ss3.elevation,'k'); ylabel('Wave Elavation [m]');  title('Sea State 3, H06'); hold on;
                               yyaxis right; plot(exM_ss3.time,exM_ss3.exM,'r'); ylabel('Excitation Moment [Nm]')                               
    subplot(3,2,4); yyaxis left;  plot(exM_ss4.time,exM_ss4.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 4, H06'); hold on;
                               yyaxis right; plot(exM_ss4.time,exM_ss4.exM,'r'); ylabel('Excitation Moment [Nm]')               
    subplot(3,2,5); yyaxis left;  plot(exM_ss5.time,exM_ss5.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 5, H10'); hold on;
                               yyaxis right; plot(exM_ss5.time,exM_ss5.exM,'r'); ylabel('Excitation Moment [Nm]')                               
    subplot(3,2,6); yyaxis left;  plot(exM_ss6.time,exM_ss6.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 6, H10'); hold on;
                               yyaxis right; plot(exM_ss6.time,exM_ss6.exM,'r'); ylabel('Excitation Moment [Nm]')                              

 fig4=figure();fig4.Name='Sea States wecSim'; fig4.ToolBar='none'; fig4.Units='Normalized'; fig4.OuterPosition=[0 0 1 1];
    subplot(3,2,1); 
    plot(exM_ss1.time,exM_ss1.elevation./max(exM_ss1.elevation),'k-'); title('Sea State 1-Normalised, H02'); hold on;
                    plot(exM_ss1.time,-exM_ss1.exM./max(exM_ss1.exM),'r');
    subplot(3,2,2); plot(exM_ss2.time,exM_ss2.elevation./max(exM_ss2.elevation),'k-'); title('Sea State 1-Normalised, H02'); hold on;
                    plot(exM_ss2.time,-exM_ss2.exM./max(exM_ss2.exM),'r');
    subplot(3,2,3); plot(exM_ss3.time,exM_ss3.elevation./max(exM_ss3.elevation),'k-'); title('Sea State 1-Normalised, H02'); hold on;
                    plot(exM_ss3.time,-exM_ss3.exM./max(exM_ss3.exM),'r');
    subplot(3,2,4); plot(exM_ss4.time,exM_ss4.elevation./max(exM_ss4.elevation),'k-'); title('Sea State 1-Normalised, H02'); hold on;
                    plot(exM_ss4.time,-exM_ss4.exM./max(exM_ss4.exM),'r');
    subplot(3,2,5); plot(exM_ss5.time,exM_ss5.elevation./max(exM_ss5.elevation),'k-'); title('Sea State 1-Normalised, H02'); hold on;
                    plot(exM_ss5.time,-exM_ss5.exM./max(exM_ss5.exM),'r');
    subplot(3,2,6); plot(exM_ss6.time,exM_ss6.elevation./max(exM_ss6.elevation),'k-'); title('Sea State 1-Normalised, H02'); hold on;
                    plot(exM_ss6.time,-exM_ss6.exM./max(exM_ss6.exM),'r');
%% Comparison of the excitation Moment using the values from Fixed Point A and computed using wecSim output
 
 fig3=figure();fig3.Name='Excitation moment Fixed Point A vs Computed'; fig3.ToolBar='none'; fig3.Units='Normalized'; fig3.OuterPosition=[0 0 1 1];
    subplot(3,2,1); plot(FA_ss1.time,FA_ss1.exM + 1.1267,'k'); ylabel('Excitation Moment [Nm]'); title('Excitation Moment, SS1, H02'); hold on;
                               plot(exM_ss1.time,-exM_ss1.exM,'r'); legend('Fixed A','Computed by formula')
    subplot(3,2,2); plot(FA_ss2.time,FA_ss2.exM + 1.1267,'k'); ylabel('Excitation Moment [Nm]'); title('Excitation Moment, SS2, H02'); hold on;
                               plot(exM_ss2.time,-exM_ss2.exM,'r');
    subplot(3,2,3); plot(FA_ss3.time,FA_ss3.exM + 1.1267,'k'); ylabel('Excitation Moment [Nm]'); title('Excitation Moment, SS3, H06'); hold on;
                               plot(exM_ss3.time,-exM_ss3.exM,'r');                               
    subplot(3,2,4); plot(FA_ss4.time,FA_ss4.exM + 1.1267,'k'); ylabel('Excitation Moment [Nm]'); title('Excitation Moment, SS4, H06'); hold on;
                               plot(exM_ss4.time,-exM_ss4.exM,'r');
    subplot(3,2,5); plot(FA_ss5.time,FA_ss5.exM + 1.1267,'k'); ylabel('Excitation Moment [Nm]'); title('Excitation Moment, SS5, H10'); hold on;
                               plot(exM_ss5.time,-exM_ss5.exM,'r');
    subplot(3,2,6); plot(FA_ss6.time,FA_ss6.exM + 1.1267,'k'); ylabel('Excitation Moment [Nm]'); title('Excitation Moment, SS6, H10'); hold on;
                               plot(exM_ss6.time,-exM_ss6.exM,'r');                               
clear fig3
