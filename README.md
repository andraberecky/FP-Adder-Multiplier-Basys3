# Floating-Point Arithmetic Logic Unit
## Project Overview
This project implements a 32-bit single-precision Floating-Point Arithmetic Logic Unit (FP ALU) following the IEEE-754 standard. The ALU performs **addition** and **multiplication** on floating-point numbers with full handling of special cases like zero, infinity, and NaN.

The ALU is implemented in **VHDL** and synthesized on an FPGA using **Xilinx Vivado**.

---

## Features

- Floating-point **addition** and **multiplication**
- IEEE-754 single-precision compliance
- Handling of special cases and exceptions:
  - Overflow
  - Underflow
  - Not a Number (NaN)
  - Infinity
- Modular design for scalability and testing
- Fully synthesizable for FPGA platforms

---

## System Architecture

The ALU consists of the following main components:

### FP Adder
- Exponent Alignment
- Mantissa Add/Subtract
- Normalization
- Rounding
- Pack/Unpack

### FP Multiplier
- Exponent Operation
- Mantissa Multiplication
- Normalization
- Rounding
- Pack/Unpack

### Other Components
- **Register File:** 8 registers storing 32-bit floating-point numbers  
- **Control Unit:** FSM managing ALU operations and instruction flow  
- **Instruction Memory:** ROM storing arithmetic instructions  
- **Program Counter:** 5-bit counter for instruction sequencing  
- **Seven Segment Display:** Displaying values on Basys 3 board  
- **MonoPulse Generator:** Debouncing push buttons  

---

## Algorithms

### Addition
1. Check for special operands (±Inf, NaN, 0)
2. Unpack operands (Sign, Exponent, Mantissa)
3. Align exponents
4. Add/Subtract mantissas based on sign
5. Normalize result
6. Round mantissa to fit precision
7. Pack result into 32-bit IEEE-754 format

### Multiplication
1. Check for special operands
2. Unpack operands
3. Compute result sign (XOR)
4. Add exponents and subtract bias
5. Multiply mantissas
6. Normalize product
7. Round mantissa to fit precision
8. Pack result into 32-bit IEEE-754 format

---

## Testing

| Instruction | Operand 1 | Operand 2 | Operation | Expected Result | Got Result |
|------------|-----------|-----------|-----------|----------------|------------|
| ADD        | 1.0       | 1.0       | ADD       | 2.0            | 2.0        |
| MUL        | 4.0       | 1.0       | MUL       | 4.0            | 4.0        |
| ADD        | Inf       | -Inf      | ADD       | NaN            | NaN        |
| ...        | ...       | ...       | ...       | ...            | ...        |

*Tests cover normal, zero, infinity, and NaN cases.*

---

## Tools & Technologies

- **VHDL** for hardware description
- **Xilinx Vivado** for simulation and synthesis
- **Basys 3 FPGA Board** for deployment
