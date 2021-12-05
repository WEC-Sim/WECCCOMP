clearvars;close all;clc;
load('Output_wave6.mat')
wave = [output.wave.time, output.wave.elevation];
save('../wave6.mat','wave','-mat')