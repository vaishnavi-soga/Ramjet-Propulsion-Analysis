% =========================================================================
% PART D: Effect of Flight Altitude on RAMJET Performance
%
% Sweeps altitude z from 2,000 m to 30,000 m at fixed M1 = 2.4
% Plots: Total Thrust, Overall Efficiency (eta_o), TSFC
%
% Key findings:
%   - Efficiency decreases linearly up to ~8,000 m, then plateaus
%     (because temperature T1 becomes constant in the stratosphere)
%   - Thrust decreases significantly with altitude (less dense air)
%   - TSFC mirrors the efficiency trend
% =========================================================================

clear; close all; clc;

R = 286.9;  z_star = 8404;  M1 = 2.4;
M2 = 0.15;  Tt3_max = 2400;  Ae = 0.015;
eta_d = 0.92;  eta_n = 0.94;  qf = 43.2e6;

z = linspace(2000, 3e4, 24);

Thrust = zeros(1, length(z));
TSFC   = zeros(1, length(z));
eta_o  = zeros(1, length(z));

for zz = 1:length(z)
    [P1,T1,Cp1,Tt1,Pt1,a1,V1]                                  = module1(R,M1,z(zz),z_star);
    [P2,T2,Tt2,Cp2,Pt2,a2,V2,deltaS12]                         = module2(R,M2,M1,eta_d,Tt1,P1,Pt1);
    [P3,Pt3,T3,Tt3,Cp3,a3,V3,M3,q23,deltaS23,deltaS13]         = module3(Tt3_max,Tt2,P2,Pt2,M2,R,deltaS12);
    [Pe,Pte,Te,Tte,Cpe,Me,Ve,ae,deltaS3e,deltaS1e,mdot_exit,M_Test] = module4(Ae,eta_n,P1,Tt3,Pt3,R,deltaS12,deltaS23);
    [P4,Pt4,T4,Tt4,Cp4,a4,V4,M4,etan_e,deltaS4e,deltaS41]      = module5(R,M_Test,Tte,P1,Pte,deltaS1e);
    [Thrust(zz),~,~,TSFC(zz),~,~,~,~,~,~,~,eta_o(zz),~] = ...
        module6(q23,qf,mdot_exit,Ve,V1,Pe,P1,Ae);
end

figure(1);
plot(z, Thrust, 'g-', 'LineWidth', 2);
grid on;
xlabel('Altitude z [m]', 'FontSize', 11);  ylabel('Thrust [N]', 'FontSize', 11);
title('Thrust vs Altitude', 'FontSize', 12);  legend('Total Thrust');

figure(2);
plot(z, eta_o, 'b-', 'LineWidth', 2);
grid on;
xlabel('Altitude z [m]', 'FontSize', 11);  ylabel('Overall Efficiency \eta_o [-]', 'FontSize', 11);
title('Overall Efficiency vs Altitude', 'FontSize', 12);  legend('\eta_o');

figure(3);
plot(z, TSFC, 'r-', 'LineWidth', 2);
grid on;
xlabel('Altitude z [m]', 'FontSize', 11);  ylabel('TSFC [kg/(hr·N)]', 'FontSize', 11);
title('TSFC vs Altitude', 'FontSize', 12);  legend('TSFC');
