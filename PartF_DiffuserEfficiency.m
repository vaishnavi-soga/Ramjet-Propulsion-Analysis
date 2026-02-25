% =========================================================================
% PART F: Effect of Diffuser Isentropic Efficiency (eta_d)
%
% Sweeps eta_d from 0.5 (very lossy) to 1.0 (ideal/isentropic)
% Plots: Overall Efficiency, Total Thrust, TSFC
%
% Key findings:
%   - At eta_d = 1.0 (isentropic), no entropy is generated in the diffuser
%     --> maximum total pressure recovery --> max performance
%   - Thrust increases ~4x from eta_d=0.5 to eta_d=1.0
%   - Improving the diffuser is MORE impactful than improving the nozzle
%     (compare with Part G results)
%
% Physical insight:
%   The diffuser is the most thermodynamically critical component in a RAMJET.
%   Poor diffusers waste the kinetic energy that was "free" from flight speed.
% =========================================================================

clear; close all; clc;

R = 286.9;  z_star = 8404;  z = 4300;  M1 = 2.4;
M2 = 0.15;  Tt3_max = 2400;  Ae = 0.015;  eta_n = 0.94;  qf = 43.2e6;

eta_d = 0.5:0.05:1.0;

Thrust = zeros(1, length(eta_d));
TSFC   = zeros(1, length(eta_d));
eta_o  = zeros(1, length(eta_d));

for i = 1:length(eta_d)
    [P1,T1,Cp1,Tt1,Pt1,a1,V1]                                  = module1(R,M1,z,z_star);
    [P2,T2,Tt2,Cp2,Pt2,a2,V2,deltaS12]                         = module2(R,M2,M1,eta_d(i),Tt1,P1,Pt1);
    [P3,Pt3,T3,Tt3,Cp3,a3,V3,M3,q23,deltaS23,deltaS13]         = module3(Tt3_max,Tt2,P2,Pt2,M2,R,deltaS12);
    [Pe,Pte,Te,Tte,Cpe,Me,Ve,ae,deltaS3e,deltaS1e,mdot_exit,M_Test] = module4(Ae,eta_n,P1,Tt3,Pt3,R,deltaS12,deltaS23);
    [P4,Pt4,T4,Tt4,Cp4,a4,V4,M4,etan_e,deltaS4e,deltaS41]      = module5(R,M_Test,Tte,P1,Pte,deltaS1e);
    [Thrust(i),~,~,TSFC(i),~,~,~,~,~,~,~,eta_o(i),~] = ...
        module6(q23,qf,mdot_exit,Ve,V1,Pe,P1,Ae);
end

figure(1);
plot(eta_d, eta_o, 'b-', 'LineWidth', 2);
grid on;
xlabel('Diffuser Efficiency \eta_d [-]', 'FontSize', 11);
ylabel('Overall Efficiency \eta_o [-]',  'FontSize', 11);
title('Overall Efficiency vs Diffuser Efficiency', 'FontSize', 12);

figure(2);
plot(eta_d, Thrust, 'b-', 'LineWidth', 2);
grid on;
xlabel('Diffuser Efficiency \eta_d [-]', 'FontSize', 11);
ylabel('Thrust [N]',                     'FontSize', 11);
title('\eta_d vs Thrust', 'FontSize', 12);

figure(3);
plot(eta_d, TSFC, 'r-', 'LineWidth', 2);
grid on;
xlabel('Diffuser Efficiency \eta_d [-]', 'FontSize', 11);
ylabel('TSFC [kg/(hr·N)]',               'FontSize', 11);
title('TSFC vs Diffuser Efficiency', 'FontSize', 12);
