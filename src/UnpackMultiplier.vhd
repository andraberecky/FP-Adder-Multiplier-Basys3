----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2025 10:49:53 AM
-- Design Name: 
-- Module Name: UnpackMultiplier - Behavioral
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

entity UnpackMultiplier is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           number : in STD_LOGIC_VECTOR (31 downto 0);
           sign : out STD_LOGIC;
           exponent : out STD_LOGIC_VECTOR (7 downto 0);
           mantissa : out STD_LOGIC_VECTOR (22 downto 0);
           mantissa_extended : out STD_LOGIC_VECTOR (26 downto 0)
           );
end UnpackMultiplier;

architecture Behavioral of UnpackMultiplier is
    signal normal : std_logic;
    signal sign_reg : std_logic;
    signal exponent_reg : std_logic_vector(7 downto 0);
    signal mantissa_reg : std_logic_vector(22 downto 0);
    signal mantissa_ext_reg : std_logic_vector(26 downto 0);
begin

    normal <= '1' when number(30 downto 23) /= "00000000" and number(30 downto 23) /= "11111111" else '0';
                          
    process(CLK, RST)
    begin
        if RST = '1' then
            sign_reg <= '0';
            exponent_reg <= (others => '0');
            mantissa_reg <= (others => '0');
            mantissa_ext_reg <= (others => '0');
       elsif rising_edge(CLK) then
            sign_reg <= number(31);
            exponent_reg <= number(30 downto 23);
            mantissa_reg <= number(22 downto 0);
            
            if normal = '1' then
                 mantissa_ext_reg <= '1' & number(22 downto 0) & "000"; 
            else
                 mantissa_ext_reg <= '0' & number(22 downto 0) & "000"; 
            end if;
        end if;
    end process;

    sign <= sign_reg;
    exponent <= exponent_reg;
    mantissa <= mantissa_reg;
    mantissa_extended <= mantissa_ext_reg;

end Behavioral;