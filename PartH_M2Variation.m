% =========================================================================
% PART H: Effect of Combustor Inlet Mach Number (M2)
%
% Sweeps M2 from 0.1 to 2.5, all else constant.
% This shows how sensitive the RAMJET is to diffuser exit Mach number.
%
% Key findings:
%   - Performance degrades sharply when M2 exceeds ~0.3
%     (combustor becomes thermally choked -- heat addition is limited)
%   - Overall efficiency becomes NEGATIVE above M2 ≈ 0.6
%     (more energy consumed than produced -- engine is a drag, not thrust)
%   - Practical operating range: M2 < 0.3 for this flight condition
%
% Physical explanation:
%   The combustor uses Rayleigh flow (heat addition to a constant-area duct).
%   Higher inlet M2 means the choked state is reached at a LOWER temperature,
%   capping heat addition and reducing combustor exit energy.
% =========================================================================

clear; close all; clc;

R = 286.9;  z_star = 8404;  z = 4300;  M1 = 2.4;
Tt3_max = 2400;  Ae = 0.015;  eta_d = 0.92;  eta_n = 0.94;  qf = 43.2e6;

M2 = 0.1:0.1:2.5;

Thrust = zeros(1, length(M2));
TSFC   = zeros(1, length(M2));
eta_o  = zeros(1, length(M2));

for i = 1:length(M2)
    [P1,T1,Cp1,Tt1,Pt1,a1,V1]                                  = module1(R,M1,z,z_star);
    [P2,T2,Tt2,Cp2,Pt2,a2,V2,deltaS12]                         = module2(R,M2(i),M1,eta_d,Tt1,P1,Pt1);
    [P3,Pt3,T3,Tt3,Cp3,a3,V3,M3,q23,deltaS23,deltaS13]         = module3(Tt3_max,Tt2,P2,Pt2,M2(i),R,deltaS12);
    [Pe,Pte,Te,Tte,Cpe,Me,Ve,ae,deltaS3e,deltaS1e,mdot_exit,M_Test] = module4(Ae,eta_n,P1,Tt3,Pt3,R,deltaS12,deltaS23);
    [P4,Pt4,T4,Tt4,Cp4,a4,V4,M4,etan_e,deltaS4e,deltaS41]      = module5(R,M_Test,Tte,P1,Pte,deltaS1e);
    [Thrust(i),~,~,TSFC(i),~,~,~,~,~,~,~,eta_o(i),~] = ...
        module6(q23,qf,mdot_exit,Ve,V1,Pe,P1,Ae);
end

figure(1);
plot(M2, eta_o, 'r-', 'LineWidth', 2);
grid on;
xlabel('Combustor Inlet Mach Number M_2 [-]', 'FontSize', 11);
ylabel('\eta_o [-]',                          'FontSize', 11);
title('M2 vs \eta_o', 'FontSize', 12);
yline(0, 'k--', 'Zero efficiency', 'LineWidth', 1.5);

figure(2);
plot(M2, Thrust, 'b-', 'LineWidth', 2);
grid on;
xlabel('Combustor Inlet Mach Number M_2 [-]', 'FontSize', 11);
ylabel('Thrust [N]',                          'FontSize', 11);
title('M2 vs Thrust', 'FontSize', 12);
yline(0, 'k--', 'Zero thrust', 'LineWidth', 1.5);

figure(3);
plot(M2, TSFC, 'g-', 'LineWidth', 2);
grid on;
xlabel('Combustor Inlet Mach Number M_2 [-]', 'FontSize', 11);
ylabel('TSFC [kg/(hr·N)]',                    'FontSize', 11);
title('M2 vs TSFC', 'FontSize', 12);
