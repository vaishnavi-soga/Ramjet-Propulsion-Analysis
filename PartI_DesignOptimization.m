% =========================================================================
% PART I: RAMJET Design Optimization
%
% Design conditions:  M1 = 5,  Altitude = 27,400 m,  Tt3_max <= 2400 K
%
% Simultaneously varies M2 and Tt3 to find the combination that gives:
%   (a) Maximum positive thrust
%   (b) Maximum overall efficiency
%
% Results:
%   Max Thrust:      M2 = 0.41, Tt3 = 2460 K, Thrust = 1972.5 N
%   Max Efficiency:  M2 = 0.40, Tt3 = 2439 K, eta_o  = 0.1401
%
% Visualization: 3D surface plots of Thrust and eta_o vs M2 and Tt3
% =========================================================================

clear; close all; clc;

R = 286.9;  z_star = 8404;
z = 27400;  M1 = 5;
eta_d = 0.92;  eta_n = 0.94;  qf = 43.2e6;  Ae = 0.015;
Tt3_max = 2400;   % Material temperature limit [K]

M2 = 0.1:0.1:2.5;

Thrust = zeros(1, length(M2));
eta_o  = zeros(1, length(M2));
Tt3    = zeros(1, length(M2));
V1_arr = zeros(1, length(M2));

for i = 1:length(M2)
    [P1, T1, Cp1, Tt1, Pt1, a1, V1_arr(i)]                     = module1(R,M1,z,z_star);
    [P2,T2,Tt2,Cp2,Pt2,a2,V2,deltaS12]                         = module2(R,M2(i),M1,eta_d,Tt1,P1,Pt1);
    [P3,Pt3,T3,Tt3(i),Cp3,a3,V3,M3,q23,deltaS23,deltaS13]      = module3(Tt3_max,Tt2,P2,Pt2,M2(i),R,deltaS12);
    [Pe,Pte,Te,Tte,Cpe,Me,Ve,ae,deltaS3e,deltaS1e,mdot_exit,M_Test] = module4(Ae,eta_n,P1,Tt3(i),Pt3,R,deltaS12,deltaS23);
    [P4,Pt4,T4,Tt4,Cp4,a4,V4,M4,etan_e,deltaS4e,deltaS41]      = module5(R,M_Test,Tte,P1,Pte,deltaS1e);
    [Thrust(i),~,~,~,~,~,~,~,~,~,~,eta_o(i),~] = ...
        module6(q23,qf,mdot_exit,Ve,V1_arr(i),Pe,P1,Ae);
end

% --- Find optima ---
[max_T,  iT]  = max(Thrust);
[max_eta, iE] = max(eta_o);

fprintf('=== DESIGN OPTIMIZATION RESULTS ===\n');
fprintf('Operating conditions: M1 = %.1f, Altitude = %.0f m\n\n', M1, z);
fprintf('Maximum Thrust:\n');
fprintf('  M2 = %.2f,  Tt3 = %.1f K,  Thrust = %.1f N\n\n', M2(iT), Tt3(iT), max_T);
fprintf('Maximum Overall Efficiency:\n');
fprintf('  M2 = %.2f,  Tt3 = %.1f K,  eta_o  = %.4f\n\n', M2(iE), Tt3(iE), max_eta);

% --- 3D Plots ---
figure(1);
plot3(M2, Tt3, Thrust, 'r-', 'LineWidth', 2);
grid on;
xlabel('Diffuser Exit Mach Number M_2 [-]',   'FontSize', 11);
ylabel('Combustor Exit Temperature T_{t3} [K]','FontSize', 11);
zlabel('Thrust (T) [N]',                       'FontSize', 11);
title('Thrust vs M_2 and T_{t3} for Design Case', 'FontSize', 12);

figure(2);
plot3(M2, Tt3, eta_o, 'b-', 'LineWidth', 2);
grid on;
xlabel('Diffuser Exit Mach Number M_2 [-]',   'FontSize', 11);
ylabel('Combustor Exit Temperature T_{t3} [K]','FontSize', 11);
zlabel('Overall Efficiency \eta_o [-]',         'FontSize', 11);
title('Overall Efficiency vs M_2 and T_{t3} for Design Case', 'FontSize', 12);
