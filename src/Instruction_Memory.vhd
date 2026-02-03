----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2025 06:53:06 PM
-- Design Name: 
-- Module Name: Instruction_Memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_Memory is
    Port (
        addr  : in  STD_LOGIC_VECTOR(4 downto 0);
        instr : out STD_LOGIC_VECTOR(31 downto 0) 
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
    type rom_array is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    
    constant fill20 : STD_LOGIC_VECTOR(19 downto 0) := (others =>'0'); 
    constant fill19 : STD_LOGIC_VECTOR(18 downto 0) := (others =>'0'); 
    constant fill29 : STD_LOGIC_VECTOR(28 downto 0) := (others => '0');

    constant ROM : rom_array := (
        0  => "010" & "000" & "011" & "001" & fill20, -- MUL 4.0 * 1.0 = 4.0
        1  => "010" & "000" & "010" & "100" & fill20, -- MUL 2.0 * 0.25 = 0.5
        2  => "010" & "000" & "111" & "100" & fill20, -- MUL -5.0 * 0.25 = -1.25
        3  => "001" & "000" & "001" & "001" & fill19 & '1', -- ADD, but sub_op='1' => R1-R1 = 0.0
        4  => "010" & "000" & "000" & "101" & fill20, -- MUL 0.0 * -2.0 = 0.0
        5  => "010" & "000" & "010" & "000" & fill20, -- MUL 2.0 * 0.0 = 0.0
        6  => "010" & "000" & "110" & "011" & fill20, -- MUL Inf * 4.0 = Inf 
        7  => "010" & "000" & "101" & "011" & fill20, -- MUL -2.0 * 4.0 = -8.0
        8  => "001" & "000" & "001" & "001" & fill20, -- ADD 1.0 + 1.0 = 2.0
        9  => "001" & "000" & "011" & "100" & fill20, -- ADD 4.0 + 0.25 = 4.25
        10 => "001" & "000" & "001" & "110" & fill20, -- ADD 1.0 + Inf = Inf
        11 => "001" & "000" & "110" & "110" & fill19 & '1', -- ADD, but sub_op='1' => Inf - Inf = NaN
        12 => "001" & "000" & "111" & "001" & fill20, -- ADD -5.0 + 1.0 = -4.0
        13 => "001" & "000" & "010" & "111" & fill20, -- ADD 2.0 + (-5.0) = -3.0
        14 => "001" & "000" & "001" & "001" & fill19 & '1', -- ADD, but sub_op='1' => R1-R1 = 0.0
        15 => "010" & "000" & "110" & "000" & fill20, -- MUL Inf * 0.0 = NaN
        others => "111" & fill29
    );
begin
    instr <= ROM(to_integer(unsigned(addr)));
end Behavioral;