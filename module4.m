function [Pe, Pte, Te, Tte, Cpe, Me, Ve, ae, deltaS3e, deltaS1e, mdot_exit, M_Test] = ...
    module4(Ae, eta_n, P1, Tt3, Pt3, R, deltaS12, deltaS23)
% MODULE4  Computes thermodynamic and flow properties at the nozzle exit (State e)
%
%   The converging nozzle expands the combustor gases from total conditions
%   (Pt3, Tt3) down to near ambient pressure (P1), accelerating the flow
%   to produce thrust.
%
%   NOZZLE CHOKING:
%     If the pressure ratio across the nozzle is large enough, the flow
%     reaches M=1 at the nozzle throat (choked). The test Mach number
%     M_Test determines whether the nozzle is choked:
%       - M_Test < 1  --> Nozzle is NOT choked  (Me = M_Test, Pe = P1)
%       - M_Test >= 1 --> Nozzle IS choked       (Me = 1, Pe > P1)
%
%   Non-ideal nozzle modelled with isentropic efficiency eta_n.
%
%   INPUTS:
%     Ae       - Nozzle exit area [m²]
%     eta_n    - Isentropic efficiency of the nozzle [-]
%     P1       - Ambient (freestream) static pressure [kPa]
%     Tt3      - Total temperature entering nozzle [K]
%     Pt3      - Total pressure entering nozzle [kPa]
%     R        - Gas constant [J/(kg·K)]
%     deltaS12 - Entropy rise diffuser [J/(kg·K)]
%     deltaS23 - Entropy rise combustor [J/(kg·K)]
%
%   OUTPUTS:
%     Pe        - Static pressure at nozzle exit [kPa]
%     Pte       - Total pressure at nozzle exit [kPa]
%     Te        - Static temperature at nozzle exit [K]
%     Tte       - Total temperature at nozzle exit [K]
%     Cpe       - Specific heat at nozzle exit temperature [J/(kg·K)]
%     Me        - Mach number at nozzle exit [-]
%     Ve        - Exhaust velocity [m/s]
%     ae        - Speed of sound at nozzle exit [m/s]
%     deltaS3e  - Entropy rise through nozzle [J/(kg·K)]
%     deltaS1e  - Cumulative entropy rise state 1 to nozzle exit [J/(kg·K)]
%     mdot_exit - Mass flow rate at nozzle exit [kg/s]
%     M_Test    - Unconstrained (ideal) exit Mach number used to test choking [-]

    gamma   = 1.3;
    P_ratio = P1 / Pt3;

    % Compute ideal exit Mach number (to test if nozzle would choke)
    M_Test = sqrt( (2 / (gamma - 1)) * ...
                   (eta_n * (1 - P_ratio^((gamma-1)/gamma))) / ...
                   (1 - eta_n * (1 - P_ratio^((gamma-1)/gamma))) );

    if M_Test < 1
        % --- Not choked: flow exits at ambient pressure ---
        Me = M_Test;
        Pe = P1;
    else
        % --- Choked: flow exits at M=1, exit pressure > ambient ---
        Me = 1;
        Pe = Pt3 * (1 - (1/eta_n) * ((gamma-1)/(gamma+1)))^(gamma/(gamma-1));
    end

    % Total temperature conserved through adiabatic nozzle (1st Law)
    Tte = Tt3;

    % Static temperature and total pressure at exit
    Te  = Tte / (1 + ((gamma - 1) / 2) * Me^2);
    Pte = Pe  * (1 + ((gamma - 1) / 2) * Me^2)^(gamma / (gamma - 1));

    % Speed of sound and exhaust velocity
    ae = sqrt(gamma * R * Te);
    Ve = Me * ae;

    % Mass flow rate at nozzle exit (ideal gas law, pressure in kPa -> Pa via *1000)
    mdot_exit = (Pe * 1000 * Ve * Ae) / (R * Te);

    % Entropy
    Cpe      = 986 + 0.179 * Te;
    deltaS3e = Cpe * log(Tte / Tt3) - R * log(Pte / Pt3);
    deltaS1e = deltaS3e + deltaS23 + deltaS12;

end
