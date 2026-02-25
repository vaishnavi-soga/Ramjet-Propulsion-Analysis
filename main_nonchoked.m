% =========================================================================
% MAE 563 - Non-Ideal RAMJET Analysis Tool
% MAIN SCRIPT: Non-Thermally Choked Validation Case (Case a)
%
% Description:
%   Runs the full RAMJET flow path analysis for Case a, where M2 = 0.15
%   keeps the combustor well below the thermal choking limit.
%   Prints all thermodynamic states and performance metrics to the console.
%
% How to run:
%   >> main_nonchoked
%   When prompted, enter the flight altitude (e.g., 4300 for validation).
%
% Flow path:  State 1 --> Diffuser --> State 2 --> Combustor --> State 3
%             --> Nozzle --> State e --> Far field --> State 4
% =========================================================================

clear; close all; clc;

fprintf('=============================================================\n');
fprintf('  MAE 563 - RAMJET Analysis Tool\n');
fprintf('  Case: NON-Thermally Choked (M2 = 0.15)\n');
fprintf('=============================================================\n\n');

% -------------------------------------------------------------------------
% CONSTANTS & INPUTS
% -------------------------------------------------------------------------
R        = 286.9;   % Gas constant [J/(kg·K)]
z_star   = 8404;    % Reference altitude for isentropic atmosphere [m]
M1       = 2.4;     % Flight Mach number [-]
M2       = 0.15;    % Diffuser exit Mach number [-]  <-- LOW: avoids thermal choking
Tt3_max  = 2400;    % Max allowable combustor exit total temperature [K]
Ae       = 0.015;   % Nozzle exit area [m²]
eta_d    = 0.92;    % Diffuser isentropic efficiency [-]
eta_n    = 0.94;    % Nozzle isentropic efficiency [-]
qf       = 43.2e6;  % Fuel heating value [J/kg]  (kerosene/JP fuel)

% Get altitude from user
z = input('Enter flight altitude in meters (press Enter for 4300 m): ');
if isempty(z), z = 4300; end

fprintf('\nRunning analysis at z = %.0f m, M1 = %.2f, M2 = %.2f\n\n', z, M1, M2);

% -------------------------------------------------------------------------
% MODULE CALLS - Flow Path Computation
% -------------------------------------------------------------------------

% State 1: Freestream / diffuser inlet
[P1, T1, Cp1, Tt1, Pt1, a1, V1] = module1(R, M1, z, z_star);

% State 2: Diffuser exit
[P2, T2, Tt2, Cp2, Pt2, a2, V2, deltaS12] = module2(R, M2, M1, eta_d, Tt1, P1, Pt1);

% State 3: Combustor exit
[P3, Pt3, T3, Tt3, Cp3, a3, V3, M3, q23, deltaS23, deltaS13] = ...
    module3(Tt3_max, Tt2, P2, Pt2, M2, R, deltaS12);

% State e: Nozzle exit
[Pe, Pte, Te, Tte, Cpe, Me, Ve, ae, deltaS3e, deltaS1e, mdot_exit, M_Test] = ...
    module4(Ae, eta_n, P1, Tt3, Pt3, R, deltaS12, deltaS23);

% State 4: Far-field exhaust
[P4, Pt4, T4, Tt4, Cp4, a4, V4, M4, etan_e, deltaS4e, deltaS41] = ...
    module5(R, M_Test, Tte, P1, Pte, deltaS1e);

% Performance metrics
[Thrust, Tj, Tp, TSFC, Isp, mdot_f, mdot_in, f, Veq, eta_th, eta_prop, eta_o, Propulsive_Power] = ...
    module6(q23, qf, mdot_exit, Ve, V1, Pe, P1, Ae);

% -------------------------------------------------------------------------
% PRINT RESULTS TABLE
% -------------------------------------------------------------------------
fprintf('%-30s %8s %8s %8s %8s %8s\n', 'Property', 'State 1', 'State 2', 'State 3', 'State e', 'State 4');
fprintf('%s\n', repmat('-',1,70));
fprintf('%-30s %8.2f %8.2f %8.2f %8.2f %8.2f\n', 'Static Temperature T [K]',   T1,  T2,  T3,  Te,  T4);
fprintf('%-30s %8.2f %8.2f %8.2f %8.2f %8.2f\n', 'Total Temperature Tt [K]',   Tt1, Tt2, Tt3, Tte, Tt4);
fprintf('%-30s %8.4f %8.4f %8.4f %8.4f %8.4f\n', 'Static Pressure P [kPa]',    P1,  P2,  P3,  Pe,  P4);
fprintf('%-30s %8.4f %8.4f %8.4f %8.4f %8.4f\n', 'Total Pressure Pt [kPa]',    Pt1, Pt2, Pt3, Pte, Pt4);
fprintf('%-30s %8.4f %8.4f %8.4f %8.4f %8.4f\n', 'Entropy rise (s-s1) [J/kgK]', 0, deltaS12, deltaS13, deltaS1e, deltaS41);
fprintf('%-30s %8.2f %8.2f %8.2f %8.2f %8.2f\n', 'Flow Velocity V [m/s]',       V1, V2, V3, Ve, V4);
fprintf('%-30s %8.4f %8.4f %8.4f %8.4f %8.4f\n', 'Mach Number M [-]',            M1, M2, M3, Me, M4);

fprintf('\n--- PERFORMANCE METRICS ---\n');
fprintf('%-40s %12.2f N\n',       'Total Thrust',              Thrust);
fprintf('%-40s %12.2f N\n',       '  Jet Thrust (Tj)',         Tj);
fprintf('%-40s %12.2f N\n',       '  Pressure Thrust (Tp)',    Tp);
fprintf('%-40s %12.6f kg/s\n',    'Fuel Mass Flow Rate',       mdot_f);
fprintf('%-40s %12.6f kg/s\n',    'Air Mass Flow Rate',        mdot_in);
fprintf('%-40s %12.6f [-]\n',     'Fuel-to-Air Ratio (f)',     f);
fprintf('%-40s %12.4e kg/(hr·N)\n','TSFC',                     TSFC);
fprintf('%-40s %12.2f s\n',       'Specific Impulse (Isp)',    Isp);
fprintf('%-40s %12.4f [-]\n',     'Thermal Efficiency',        eta_th);
fprintf('%-40s %12.4f [-]\n',     'Propulsive Efficiency',     eta_prop);
fprintf('%-40s %12.4f [-]\n',     'Overall Efficiency',        eta_o);
fprintf('%-40s %12.2f W\n',       'Propulsive Power',          Propulsive_Power);
fprintf('\n');
