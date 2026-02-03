----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2026 05:19:25 PM
-- Design Name: 
-- Module Name: RCA_54bit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RCA_54bit is
    Port ( A, B : in STD_LOGIC_VECTOR(53 downto 0);
           S    : out STD_LOGIC_VECTOR(53 downto 0));
end RCA_54bit;

architecture Behavioral of RCA_54bit is
signal c : std_logic_vector(54 downto 0);
begin
    c(0) <= '0';
    gen: for i in 0 to 53 generate
        FA: entity work.FullAdder port map(
            a    => A(i), 
            b    => B(i), 
            cin  => c(i), 
            sum  => S(i), 
            cout => c(i+1)
        );
    end generate;

end Behavioral;
