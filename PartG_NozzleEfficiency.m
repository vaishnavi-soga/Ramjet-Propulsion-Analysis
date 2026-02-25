% =========================================================================
% PART G: Effect of Nozzle Isentropic Efficiency (eta_n)
%
% Sweeps eta_n from 0.5 to 1.0, all else constant.
% Compare with Part F (diffuser efficiency).
%
% Key finding:
%   Nozzle efficiency matters, but less than diffuser efficiency.
%   Diffuser: thrust increases ~4x from 50% to 100% efficiency
%   Nozzle:   thrust increases only ~2.3x over the same range
%
%   --> Invest more in diffuser aerodynamics than nozzle design
%       if thrust maximization is the goal.
% =========================================================================

clear; close all; clc;

R = 286.9;  z_star = 8404;  z = 4300;  M1 = 2.4;
M2 = 0.15;  Tt3_max = 2400;  Ae = 0.015;  eta_d = 0.92;  qf = 43.2e6;

eta_n = 0.5:0.05:1.0;

Thrust = zeros(1, length(eta_n));
TSFC   = zeros(1, length(eta_n));
eta_o  = zeros(1, length(eta_n));

for i = 1:length(eta_n)
    [P1,T1,Cp1,Tt1,Pt1,a1,V1]                                  = module1(R,M1,z,z_star);
    [P2,T2,Tt2,Cp2,Pt2,a2,V2,deltaS12]                         = module2(R,M2,M1,eta_d,Tt1,P1,Pt1);
    [P3,Pt3,T3,Tt3,Cp3,a3,V3,M3,q23,deltaS23,deltaS13]         = module3(Tt3_max,Tt2,P2,Pt2,M2,R,deltaS12);
    [Pe,Pte,Te,Tte,Cpe,Me,Ve,ae,deltaS3e,deltaS1e,mdot_exit,M_Test] = module4(Ae,eta_n(i),P1,Tt3,Pt3,R,deltaS12,deltaS23);
    [P4,Pt4,T4,Tt4,Cp4,a4,V4,M4,etan_e,deltaS4e,deltaS41]      = module5(R,M_Test,Tte,P1,Pte,deltaS1e);
    [Thrust(i),~,~,TSFC(i),~,~,~,~,~,~,~,eta_o(i),~] = ...
        module6(q23,qf,mdot_exit,Ve,V1,Pe,P1,Ae);
end

figure(1);
plot(eta_n, eta_o, 'b-', 'LineWidth', 2);
grid on;
xlabel('Nozzle Efficiency \eta_n [-]',   'FontSize', 11);
ylabel('Overall Efficiency \eta_o [-]',  'FontSize', 11);
title('Overall Efficiency VS Nozzle Efficiency', 'FontSize', 12);

figure(2);
plot(eta_n, Thrust, 'b-', 'LineWidth', 2);
grid on;
xlabel('Nozzle Efficiency \eta_n [-]', 'FontSize', 11);
ylabel('Thrust [N]',                   'FontSize', 11);
title('Thrust VS Nozzle Efficiency', 'FontSize', 12);

figure(3);
plot(eta_n, TSFC, 'b-', 'LineWidth', 2);
grid on;
xlabel('Nozzle Efficiency \eta_n [-]', 'FontSize', 11);
ylabel('TSFC [kg/(hr·N)]',             'FontSize', 11);
title('TSFC VS Nozzle Efficiency', 'FontSize', 12);
