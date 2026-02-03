----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2025 02:29:03 PM
-- Design Name: 
-- Module Name: Exponent_Multiplier - Behavioral
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

entity Exponent_Multiplier is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           exp_A_in : in STD_LOGIC_VECTOR (7 downto 0);
           exp_B_in : in STD_LOGIC_VECTOR (7 downto 0);
           exp_res : out STD_LOGIC_VECTOR (7 downto 0));
end Exponent_Multiplier;

architecture Behavioral of Exponent_Multiplier is
    constant BIAS_CORR : unsigned(7 downto 0) := to_unsigned(127,8); 
    constant EXP_ZERO_UNS : unsigned(7 downto 0) := (others => '0');
    signal exp_a_unsigned : unsigned(7 downto 0);
    signal exp_B_unsigned : unsigned(7 downto 0);
    signal sum : unsigned(8 downto 0);
    signal result_comb : unsigned(8 downto 0);
    signal exp_res_reg : std_logic_vector(7 downto 0);
begin

    exp_a_unsigned <= unsigned(exp_A_in);
    exp_B_unsigned <= unsigned(exp_B_in);
    
    sum <= ('0' & exp_a_unsigned) + ('0' & exp_B_unsigned);
    result_comb <= sum - ('0' & BIAS_CORR); 

    process(CLK, RST)
    begin
        if RST = '1' then
            exp_res_reg <= (others => '0');
        elsif rising_edge(CLK) then
            if sum < ('0' & BIAS_CORR) then
                exp_res_reg <= (others => '0'); 
            elsif result_comb(8) = '1' then
                exp_res_reg <= (others => '1');
            else
                exp_res_reg <= std_logic_vector(result_comb(7 downto 0)); 
            end if;
        end if;
    end process;

    exp_res <= exp_res_reg;

end Behavioral;