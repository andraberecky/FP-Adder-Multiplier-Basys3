----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2025 02:43:24 PM
-- Design Name: 
-- Module Name: Normalize_Multiplier - Behavioral
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

entity Normalize_Multiplier is
    Port (
        CLK          : in  STD_LOGIC;
        RST          : in  STD_LOGIC;
        mantissa_in  : in  STD_LOGIC_VECTOR (53 downto 0); 
        exponent_in  : in  STD_LOGIC_VECTOR (7 downto 0);  
        mantissa_out : out STD_LOGIC_VECTOR (26 downto 0); 
        exponent_out : out STD_LOGIC_VECTOR (7 downto 0)
    );
end Normalize_Multiplier;

architecture Behavioral of Normalize_Multiplier is
    signal mantissa_norm_reg : STD_LOGIC_VECTOR(26 downto 0);
    signal exponent_out_reg  : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(CLK, RST)
        variable mant_u     : unsigned(53 downto 0);
        variable exp_u      : unsigned(7 downto 0);
        variable mant_shifted : unsigned(53 downto 0);
        variable shift_flag : std_logic;
    begin
        if RST = '1' then
            mantissa_norm_reg <= (others => '0');
            exponent_out_reg  <= (others => '0');
        elsif rising_edge(CLK) then
        mant_u := unsigned(mantissa_in); 
        exp_u  := unsigned(exponent_in); 
        
        if mant_u(53) = '1' then 
            mantissa_norm_reg <= std_logic_vector(mant_u(53 downto 27)); 
            exponent_out_reg  <= std_logic_vector(exp_u + 1);
        else 
            mantissa_norm_reg <= std_logic_vector(mant_u(52 downto 26)); 
            exponent_out_reg  <= exponent_in;
        end if;
    end if;
    end process;

    mantissa_out <= mantissa_norm_reg;
    exponent_out <= exponent_out_reg;
end Behavioral;