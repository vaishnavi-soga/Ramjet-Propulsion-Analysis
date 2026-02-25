function [Thrust, Tj, Tp, TSFC, Isp, mdot_f, mdot_in, f, Veq, ...
          eta_th, eta_prop, eta_o, Propulsive_Power] = ...
    module6(q23, qf, mdot_exit, Ve, V1, Pe, P1, Ae)
% MODULE6  Computes overall engine performance metrics
%
%   This is the final module. It combines the flow conditions from all previous
%   modules to compute the thrust, fuel consumption, and efficiencies that
%   define how well the RAMJET engine is performing.
%
%   HOW THRUST IS CALCULATED:
%     Total Thrust = Jet Thrust (Tj) + Pressure Thrust (Tp)
%
%     Jet Thrust (Tj):
%       Comes from the momentum difference between the exhaust jet and the
%       incoming air. Tj = mdot_in * [(1+f)*Ve - V1]
%
%     Pressure Thrust (Tp):
%       Comes from the pressure difference at the nozzle exit vs ambient.
%       Tp = (Pe - P1) * Ae
%       (This is zero for a perfectly expanded nozzle where Pe = P1)
%
%   EFFICIENCY DEFINITIONS:
%     Thermal efficiency (eta_th):
%       How much of the fuel's chemical energy is converted to kinetic energy.
%       eta_th = (KE_exit - KE_inlet) / (mdot_in * q23)
%
%     Propulsive efficiency (eta_prop):
%       How much of the added kinetic energy actually becomes thrust power.
%       eta_prop = 2 / (1 + Veq/V1)   [Froude efficiency]
%
%     Overall efficiency (eta_o):
%       eta_o = eta_th * eta_prop
%
%   INPUTS:
%     q23      - Heat added per unit mass in combustor [J/kg]
%     qf       - Fuel heating value [J/kg]  (e.g. 43.2e6 for jet fuel)
%     mdot_exit- Mass flow rate at nozzle exit [kg/s]
%     Ve       - Exhaust velocity [m/s]
%     V1       - Freestream (inlet) velocity [m/s]
%     Pe       - Nozzle exit static pressure [kPa]
%     P1       - Freestream static pressure [kPa]
%     Ae       - Nozzle exit area [m²]
%
%   OUTPUTS:
%     Thrust          - Total thrust force [N]
%     Tj              - Jet (momentum) thrust component [N]
%     Tp              - Pressure thrust component [N]
%     TSFC            - Thrust-specific fuel consumption [kg/(hr·N)] or [kg/(N·s)]
%     Isp             - Specific impulse [s]
%     mdot_f          - Fuel mass flow rate [kg/s]
%     mdot_in         - Air mass flow rate entering engine [kg/s]
%     f               - Fuel-to-air ratio [-]
%     Veq             - Equivalent (effective) exhaust velocity [m/s]
%     eta_th          - Thermal efficiency [-]
%     eta_prop        - Propulsive efficiency [-]
%     eta_o           - Overall efficiency [-]
%     Propulsive_Power - Thrust power = Thrust * V1 [W]

    g = 9.81;   % Gravitational acceleration [m/s²]

    % --- Mass flow rates ---
    % Energy balance: mdot_in * qf = q23 * mdot_in  (only air burns, not all fuel)
    mdot_in = mdot_exit / (1 + q23 / qf);
    mdot_f  = mdot_exit - mdot_in;
    f       = mdot_f / mdot_in;   % Fuel-to-air ratio

    % --- Thrust ---
    Tj     = mdot_in * ((1 + f) * Ve - V1);          % Jet thrust [N]
    Tp     = (Pe - P1) * Ae * 1000;                  % Pressure thrust [N] (kPa * m² * 1000 = N)
    Thrust = Tj + Tp;                                  % Total thrust [N]

    % --- Fuel consumption metrics ---
    TSFC = mdot_f * 3600 ./ Thrust;                  % [kg/(hr·N)]
    Isp  = Thrust ./ (mdot_f * g);                   % [s]

    % --- Equivalent exhaust velocity (accounts for pressure term) ---
    Veq = Ve + (Pe - P1) * 1000 * Ae / mdot_exit;

    % --- Efficiencies ---
    eta_th   = ((mdot_exit * 0.5 * Veq.^2) - (mdot_in * 0.5 * V1.^2)) ...
               / (mdot_in * q23);
    eta_prop = 2 / (1 + Veq / V1);
    eta_o    = eta_th * eta_prop;

    % --- Propulsive Power ---
    Propulsive_Power = Thrust .* V1;   % [W]

end
