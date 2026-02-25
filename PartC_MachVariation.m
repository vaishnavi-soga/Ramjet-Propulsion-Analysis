% =========================================================================
% PART C: Effect of Flight Mach Number (M1) on RAMJET Performance
%
% Sweeps M1 from 0.8 to 5.0 at fixed altitude (z = 4300 m)
% Plots: Overall Efficiency (eta_o), Total Thrust, TSFC
%
% Key findings:
%   - Peak efficiency at M1 ≈ 2.8  (RAM compression sufficient, not excessive)
%   - Peak thrust between M1 = 4.0 and 4.5
%   - TSFC increases sharply above M1 ≈ 3.5 (more fuel needed at high speed)
%   - RAMJET unsuitable below M1 ≈ 1.5 (insufficient ram compression)
% =========================================================================

clear; close all; clc;

R = 286.9;  z_star = 8404;  z = 4300;
M2 = 0.15;  Tt3_max = 2400;  Ae = 0.015;
eta_d = 0.92;  eta_n = 0.94;  qf = 43.2e6;

M1 = linspace(0.8, 5, 25);

Thrust = zeros(1, length(M1));
TSFC   = zeros(1, length(M1));
eta_o  = zeros(1, length(M1));

for m = 1:length(M1)
    [P1,T1,Cp1,Tt1,Pt1,a1,V1]                                  = module1(R,M1(m),z,z_star);
    [P2,T2,Tt2,Cp2,Pt2,a2,V2,deltaS12]                         = module2(R,M2,M1(m),eta_d,Tt1,P1,Pt1);
    [P3,Pt3,T3,Tt3,Cp3,a3,V3,M3,q23,deltaS23,deltaS13]         = module3(Tt3_max,Tt2,P2,Pt2,M2,R,deltaS12);
    [Pe,Pte,Te,Tte,Cpe,Me,Ve,ae,deltaS3e,deltaS1e,mdot_exit,M_Test] = module4(Ae,eta_n,P1,Tt3,Pt3,R,deltaS12,deltaS23);
    [P4,Pt4,T4,Tt4,Cp4,a4,V4,M4,etan_e,deltaS4e,deltaS41]      = module5(R,M_Test,Tte,P1,Pte,deltaS1e);
    [Thrust(m),~,~,TSFC(m),~,~,~,~,~,~,~,eta_o(m),~] = ...
        module6(q23,qf,mdot_exit,Ve,V1,Pe,P1,Ae);
end

figure(1);
plot(M1, eta_o, 'g-', 'LineWidth', 2);
grid on;
xlabel('Flight Mach Number M_1 [-]',  'FontSize', 11);
ylabel('Overall Efficiency \eta_o [-]', 'FontSize', 11);
title('Effect of Mach Number on Overall Efficiency - Non Thermally Choked Case', 'FontSize', 12);
legend('\eta_o');

figure(2);
plot(M1, Thrust, 'r-', 'LineWidth', 2);
grid on;
xlabel('Flight Mach Number M_1 [-]', 'FontSize', 11);
ylabel('Total Thrust [N]',           'FontSize', 11);
title('Effect of Mach Number on Total Thrust - Non Thermally Choked Case', 'FontSize', 12);
legend('Total Thrust');

figure(3);
plot(M1, TSFC, 'g-', 'LineWidth', 2);
grid on;
xlabel('Flight Mach Number M_1 [-]',           'FontSize', 11);
ylabel('TSFC [kg/(hr·N)]',                     'FontSize', 11);
title('TSFC vs Flight Mach Number', 'FontSize', 12);
legend('TSFC');
