----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2025 07:08:44 PM
-- Design Name: 
-- Module Name: Register_file_8x32 - Behavioral
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

entity Register_File_8x32 is
    Port ( 
        clk, write_en : in  STD_LOGIC;
        write_addr     : in  STD_LOGIC_VECTOR(2 downto 0);
        write_data     : in  STD_LOGIC_VECTOR(31 downto 0);
        readA_addr, readB_addr : in STD_LOGIC_VECTOR(2 downto 0);
        read_data_A    : out STD_LOGIC_VECTOR(31 downto 0);
        read_data_B    : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R0     : out STD_LOGIC_VECTOR(31 downto 0); 
        reg_out_R1     : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R2     : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R3     : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R4     : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R5     : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R6     : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R7     : out STD_LOGIC_VECTOR(31 downto 0) 
    );
end Register_File_8x32;

architecture Behavioral of Register_File_8x32 is
    type register_array is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);

    signal registers : register_array := (
        0 => X"00000000", -- R0: 0.0 
        1 => X"3F800000", -- R1: 1.0 
        2 => X"40000000", -- R2: 2.0 
        3 => X"40800000", -- R3: 4.0 
        4 => X"3E800000", -- R4: 0.25 
        5 => X"C0000000", -- R5: -2.0 
        6 => X"7F800000", -- R6: Infinit 
        7 => X"C0A00000"  -- R7: -5.0 
    );

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' then
                registers(to_integer(unsigned(write_addr))) <= write_data;
            end if;
        end if;
    end process;

    read_data_A <= registers(to_integer(unsigned(readA_addr)));
    read_data_B <= registers(to_integer(unsigned(readB_addr)));
    
    reg_out_R0 <= registers(0);
    reg_out_R1 <= registers(1);
    reg_out_R2 <= registers(2);
    reg_out_R3 <= registers(3);
    reg_out_R4 <= registers(4);
    reg_out_R5 <= registers(5);
    reg_out_R6 <= registers(6);
    reg_out_R7 <= registers(7);

end Behavioral;