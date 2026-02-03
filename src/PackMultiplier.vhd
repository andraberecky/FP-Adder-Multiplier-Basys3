----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2025 11:01:53 AM
-- Design Name: 
-- Module Name: PackMultiplier - Behavioral
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

entity PackMultiplier is
    Port(
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        sign : in STD_LOGIC;
        exponent : in STD_LOGIC_VECTOR(7 downto 0);
        mantissa : in STD_LOGIC_VECTOR(22 downto 0);
        number_out : out STD_LOGIC_VECTOR(31 downto 0);
        overflow_out : out STD_LOGIC;
        underflow_out: out STD_LOGIC
    );
end PackMultiplier;

architecture Behavioral of PackMultiplier is
    constant EXP_MIN : integer := 0;
    constant EXP_MAX : integer := 255;
    constant M_ZERO  : STD_LOGIC_VECTOR(22 downto 0) := (others => '0');
    signal number_out_reg : STD_LOGIC_VECTOR(31 downto 0);
    signal overflow_out_reg : STD_LOGIC;
    signal underflow_out_reg : STD_LOGIC;
begin

   process(CLK, RST)
        variable exp_int : integer;
        variable number_calc : STD_LOGIC_VECTOR(31 downto 0);
        constant EXP_MIN_V : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); 
    begin
        if RST = '1' then
        elsif rising_edge(CLK) then
            exp_int := to_integer(unsigned(exponent));

            if exp_int >= EXP_MAX then
                number_out_reg <= sign & X"FF" & M_ZERO;
                overflow_out_reg <= '1';
                underflow_out_reg <= '0';
            
            elsif exp_int = EXP_MIN and mantissa /= M_ZERO then
                number_out_reg <= sign & exponent & mantissa; 
                overflow_out_reg <= '0';
                underflow_out_reg <= '0'; 
            
            elsif exp_int <= EXP_MIN and mantissa = M_ZERO then
                number_out_reg <= sign & X"00" & M_ZERO;
                overflow_out_reg <= '0';
                underflow_out_reg <= '1'; 
            
            else
                number_out_reg <= sign & exponent & mantissa;
                overflow_out_reg <= '0';
                underflow_out_reg <= '0';
            end if;
        end if;
    end process;

    number_out <= number_out_reg;
    overflow_out <= overflow_out_reg;
    underflow_out <= underflow_out_reg;
end Behavioral;