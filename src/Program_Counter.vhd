----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2025 06:49:31 PM
-- Design Name: 
-- Module Name: Program_Counter - Behavioral
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

entity Program_Counter is
    Port (
        clk            : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        pc_increment   : in  STD_LOGIC; 
        pc_out         : out STD_LOGIC_VECTOR(4 downto 0)
    );
end Program_Counter;

architecture Behavioral of Program_Counter is
    signal pc_reg : unsigned(4 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');
        elsif rising_edge(clk) then
            if pc_increment = '1' then
                pc_reg <= pc_reg + 1;
            end if;
        end if;
    end process;
    
    pc_out <= STD_LOGIC_VECTOR(pc_reg);
end Behavioral;
