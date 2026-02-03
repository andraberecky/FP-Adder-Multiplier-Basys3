----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2026 10:12:14 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( clk : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end SSD;

architecture Behavioral of SSD is
    signal count : std_logic_vector(15 downto 0) := (others => '0');
    signal hex_digit : std_logic_vector(3 downto 0);
begin
    process(clk) begin
        if rising_edge(clk) then count <= count + 1; end if;
    end process;

    process(count(15 downto 14), data) begin
        case count(15 downto 14) is
            when "00" => an <= "1110"; hex_digit <= data(3 downto 0);
            when "01" => an <= "1101"; hex_digit <= data(7 downto 4);
            when "10" => an <= "1011"; hex_digit <= data(11 downto 8);
            when others => an <= "0111"; hex_digit <= data(15 downto 12);
        end case;
    end process;

    process(hex_digit) begin
        case hex_digit is
            when x"0" => seg <= "1000000"; when x"1" => seg <= "1111001";
            when x"2" => seg <= "0100100"; when x"3" => seg <= "0110000";
            when x"4" => seg <= "0011001"; when x"5" => seg <= "0010010";
            when x"6" => seg <= "0000010"; when x"7" => seg <= "1111000";
            when x"8" => seg <= "0000000"; when x"9" => seg <= "0010000";
            when x"A" => seg <= "0001000"; when x"B" => seg <= "0000011";
            when x"C" => seg <= "1000110"; when x"D" => seg <= "0100001";
            when x"E" => seg <= "0000110"; when others => seg <= "0001110";
        end case;
    end process;
end Behavioral;
