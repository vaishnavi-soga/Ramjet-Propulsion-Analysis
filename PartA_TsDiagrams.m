% =========================================================================
% PART A: T-s Diagrams (Brayton Cycle Visualization)
%
% Plots the Temperature-Entropy diagram for both:
%   Case a: Non-thermally choked (M2 = 0.15)
%   Case b: Thermally choked     (M2 = 0.40)
%
% The T-s diagram shows:
%   1->2 : Compression in diffuser (entropy increases due to irreversibilities)
%   2->3 : Heat addition in combustor at constant pressure
%   3->4 : Expansion in nozzle + exhaust (entropy increases)
%   4->1 : Heat rejection to atmosphere (closes the cycle)
%
% The enclosed area on the T-s diagram represents net work output.
% A larger enclosed area = more thrust potential.
% =========================================================================

clear; close all; clc;

R = 286.9;  z_star = 8404;  z = 4300;
M1 = 2.4;  Tt3_max = 2400;  Ae = 0.015;
eta_d = 0.92;  eta_n = 0.94;  qf = 43.2e6;

M2_cases  = [0.15, 0.40];
titles    = {'T-s Diagram for a Non-Thermally Choked Case', ...
             'T-s Diagram for a Thermally Choked Case (M_2 = 0.4)'};

for k = 1:2
    M2 = M2_cases(k);

    [P1,T1,Cp1,Tt1,Pt1,a1,V1]                                  = module1(R,M1,z,z_star);
    [P2,T2,Tt2,Cp2,Pt2,a2,V2,deltaS12]                         = module2(R,M2,M1,eta_d,Tt1,P1,Pt1);
    [P3,Pt3,T3,Tt3,Cp3,a3,V3,M3,q23,deltaS23,deltaS13]         = module3(Tt3_max,Tt2,P2,Pt2,M2,R,deltaS12);
    [Pe,Pte,Te,Tte,Cpe,Me,Ve,ae,deltaS3e,deltaS1e,mdot_exit,M_Test] = module4(Ae,eta_n,P1,Tt3,Pt3,R,deltaS12,deltaS23);
    [P4,Pt4,T4,Tt4,Cp4,a4,V4,M4,etan_e,deltaS4e,deltaS41]      = module5(R,M_Test,Tte,P1,Pte,deltaS1e);
    [Thrust,Tj,Tp,TSFC,Isp,mdot_f,mdot_in,f,Veq,eta_th,eta_prop,eta_o,Propulsive_Power] = ...
        module6(q23,qf,mdot_exit,Ve,V1,Pe,P1,Ae);

    figure(k); clf;

    % --- Process 1->2: Compression (diffuser) ---
    plot([0, deltaS12], [T1, T2], 'b-', 'LineWidth', 2);
    hold on;

    % --- Process 2->3: Heat addition (combustor, curved due to variable Cp) ---
    T23(1) = T2(1);
    ds     = deltaS13(1) / 100000;
    for n = 1:100000-1
        T23(n+1) = T23(n) + (T23(n) / (986 + 0.179*T23(n))) * ds;
    end
    S23 = linspace(deltaS12, deltaS13, length(T23));
    plot(S23, T23, 'g-', 'LineWidth', 2);

    % --- Process 3->4: Expansion (nozzle + exhaust) ---
    plot([deltaS13, deltaS41], [T3, T4], 'r-', 'LineWidth', 2);

    % --- Process 4->1: Heat rejection (closes cycle) ---
    T41(1) = T1(1);
    ds41   = deltaS41(1) / 100000;
    for n = 1:100000-1
        T41(n+1) = T41(n) + (T23(n) / 1004) * ds41;
        if T41(n) >= T4(1), break; end
    end
    S41 = linspace(0, deltaS41, length(T41));
    plot(S41, T41, 'm-', 'LineWidth', 2);

    % Labels and formatting
    grid on;
    title(titles{k}, 'FontSize', 13, 'FontWeight', 'bold');
    xlabel('Entropy (s) [J/(kg·K)]', 'FontSize', 11);
    ylabel('Temperature (T) [K]',    'FontSize', 11);
    legend('1-2 (Compression)', '3-4 (Expansion)', '2-3 (Heat Addition)', '4-1 (Heat Rejection)', ...
           'Location', 'Best');
end
