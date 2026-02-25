# MAE 563 – RAMJET Propulsion Analysis Tool

**Course:** MAE 563 – Introduction to Propulsion Theory and Applications  
**Instructor:** Prof. Werner J.A. Dahm  
**Author:** Vaishanavi Sogalad | ASU ID: 1232641594  
**Institution:** Arizona State University

---

## Overview

This repository contains a MATLAB-based parametric analysis tool for studying the thermodynamic performance of a **non-ideal RAMJET propulsion system**. The tool models the full flow path — from free-stream intake through diffuser, combustor, and nozzle — and computes key performance metrics across a wide range of operating conditions.

The system is validated against two benchmark cases (thermally choked and non-thermally choked nozzle flow) and then used for parametric studies across flight Mach number, altitude, diffuser efficiency, nozzle efficiency, and combustor inlet Mach number.

---

## Repository Structure

```
MAE563-Ramjet-Propulsion-Analysis/
│
├── main_nonchoked.m          # Main script – non-thermally choked case
├── main_choked.m             # Main script – thermally choked case
│
├── module1.m                 # Freestream / diffuser inlet conditions
├── module2.m                 # Diffuser exit conditions
├── module3.m                 # Combustor exit conditions
├── module4.m                 # Nozzle exit conditions
├── module5.m                 # Far-field exhaust state
├── module6.m                 # Thrust, efficiency, TSFC, Isp
│
├── PartA_TsDiagram.m         # T-s diagrams (choked & non-choked)
├── PartB_Atmosphere.m        # Isentropic vs Standard Atmosphere comparison
├── PartC_MachVariation.m     # Effect of flight Mach number (M1)
├── PartD_AltitudeVariation.m # Effect of flight altitude (z)
├── PartE_Optimization.m      # Altitude vs optimal M1 for max η₀ / min TSFC
├── PartF_DiffuserEff.m       # Effect of diffuser efficiency (ηd)
├── PartG_NozzleEff.m         # Effect of nozzle efficiency (ηn)
├── PartH_M2Variation.m       # Effect of combustor inlet Mach number (M2)
├── PartI_Design.m            # Optimal design for max thrust & max η₀
│
└── README.md
```

---

## Inputs

| Parameter | Symbol | Validation Case a | Validation Case b |
|---|---|---|---|
| Flight Altitude | z | 4300 m | 4300 m |
| Flight Mach Number | M₁ | 2.4 | 2.4 |
| Diffuser Efficiency | ηd | 0.92 | 0.92 |
| Diffuser Exit Mach | M₂ | 0.15 | 0.40 |
| Max Combustor Exit Temp | Tt3_max | 2400 K | 2400 K |
| Fuel Heating Value | qf | 43.2 MJ/kg | 43.2 MJ/kg |
| Nozzle Efficiency | ηn | 0.94 | 0.94 |
| Nozzle Exit Area | Ae | 0.015 m² | 0.015 m² |
| Gas Constant | R | 286.9 J/kg·K | 286.9 J/kg·K |

---

## Outputs

For each station (1, 2, 3, e, 4):

- Static and total temperature (T, Tt)
- Static and total pressure (P, Pt)
- Relative entropy (s − s₁)
- Flow velocity and Mach number

Global performance metrics:

- **Total Thrust** (T)
- **Overall Efficiency** (η₀)
- **Fuel Flow Rate** (ṁf)
- **Thrust-Specific Fuel Consumption** (TSFC)
- **Specific Impulse** (Isp)

---

## Atmospheric Model

The tool uses an **isentropic atmosphere model** with a two-regime formulation:

**For z < 7958 m:**

$$\frac{T(z)}{T_s} = 1 - \frac{\gamma - 1}{\gamma} \cdot \frac{z}{z^*}, \quad \frac{P(z)}{P_s} = \left(1 - \frac{\gamma-1}{\gamma} \cdot \frac{z}{z^*}\right)^{\frac{\gamma}{\gamma-1}}$$

**For z > 7958 m:**

$$T(z) = 210 \text{ K}, \quad P(z) = 33.6 \cdot e^{-\left(\frac{z - 7958}{6605}\right)}$$

Where: Ts = 288 K, Ps = 101.3 kPa, γ = 1.4, z* = 8404 m

This model was validated against ICAO Standard Atmosphere data — pressure values match closely, and the temperature model is suitable for the altitude ranges of interest.

---

## Key Findings

| Study | Key Result |
|---|---|
| **Mach Number (Part C)** | Peak overall efficiency η₀ = 0.264 at M₁ = 2.8; thrust peaks between M₁ = 4–4.5 |
| **Altitude (Part D)** | η₀ decreases linearly to ~8,000 m then stabilizes; thrust decreases monotonically |
| **Diffuser Efficiency (Part F)** | Thrust increases 4× from ηd = 0.5 to ηd = 1.0; η₀ peaks at 0.565 (isentropic) |
| **Nozzle Efficiency (Part G)** | Thrust increases <2.5× from ηn = 0.5 to ηn = 1.0 — less impactful than diffuser |
| **Combustor Inlet Mach (Part H)** | Performance degrades sharply above M₂ ≈ 0.3 due to thermal choking |
| **Optimal Design (Part I)** | At M₁ = 5, z = 27,400 m: max thrust = 1972.5 N at M₂ = 0.41, Tt3 = 2460 K |

---

## How to Run

1. Clone this repository:
   ```bash
   git clone https://github.com/vaishnavi-soga/MAE563-Ramjet-Propulsion-Analysis.git
   cd MAE563-Ramjet-Propulsion-Analysis
   ```

2. Open MATLAB and navigate to the repository folder.

3. Run the main validation scripts:
   ```matlab
   main_nonchoked    % Non-thermally choked case
   main_choked       % Thermally choked case
   ```

4. Run any parametric study script (e.g.):
   ```matlab
   PartC_MachVariation
   PartF_DiffuserEff
   ```

> **Note:** All `module*.m` files must be in the same directory or on the MATLAB path.

---

## Dependencies

- MATLAB R2021a or later (no additional toolboxes required)
- Standard built-in functions only (`sqrt`, `linspace`, `plot`, `plot3`, etc.)

---

## License

This project was developed for academic purposes as part of MAE 563 at Arizona State University. Feel free to reference or adapt the code with appropriate attribution.
