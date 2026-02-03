----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2025 11:13:38 PM
-- Design Name: 
-- Module Name: Adder_tb - Behavioral
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

entity Adder_tb is
end Adder_tb;

architecture Behavioral of Adder_tb is

    signal A, B       : STD_LOGIC_VECTOR(31 downto 0);
    signal sub_op     : STD_LOGIC;
    signal result     : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- Instan?ierea adder-ului
    UUT: entity work.Adder
        port map(
            A       => A,
            B       => B,
            sub_op  => sub_op,
            result  => result
        );

    -- Procesul de test
    stim_proc: process
    begin
        -- Test 1: 1.0 + 2.0
        A <= x"3F800000"; -- 1.0 în IEEE754
        B <= x"40000000"; -- 2.0 în IEEE754
        sub_op <= '0';
        wait for 20 ns;

        -- Test 2: 2.0 - 1.5
        A <= x"40000000"; -- 2.0
        B <= x"3FC00000"; -- 1.5
        sub_op <= '1';
        wait for 20 ns;

        -- Test 3: 0 + 0
        A <= x"00000000";
        B <= x"00000000";
        sub_op <= '0';
        wait for 20 ns;

        -- Stop simularea
        wait;
    end process;

end Behavioral;
