----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2025 02:59:05 PM
-- Design Name: 
-- Module Name: Exponent_Alignment - Behavioral
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

entity Exponent_Alignment is
    Port (
        CLK : in STD_LOGIC; 
        RST : in STD_LOGIC; 
        exp_A_in : in  STD_LOGIC_VECTOR(7 downto 0);
        exp_B_in : in  STD_LOGIC_VECTOR(7 downto 0);
        mantissa_A_in : in  STD_LOGIC_VECTOR(26 downto 0);
        mantissa_B_in : in  STD_LOGIC_VECTOR(26 downto 0);
        exp_out : out STD_LOGIC_VECTOR(7 downto 0);
        mantissa_A_out : out STD_LOGIC_VECTOR(26 downto 0);
        mantissa_B_out : out STD_LOGIC_VECTOR(26 downto 0);
        swap_flag : out STD_LOGIC
    );
end Exponent_Alignment;

architecture Behavioral of Exponent_Alignment is
    signal exp_out_reg : STD_LOGIC_VECTOR(7 downto 0);
    signal mantA_out_reg : STD_LOGIC_VECTOR(26 downto 0);
    signal mantB_out_reg : STD_LOGIC_VECTOR(26 downto 0);
    signal swap_flag_reg : STD_LOGIC;

    signal exp_calc : STD_LOGIC_VECTOR(7 downto 0);
    signal mantA_calc : STD_LOGIC_VECTOR(26 downto 0);
    signal mantB_calc : STD_LOGIC_VECTOR(26 downto 0);
    signal swap_calc : STD_LOGIC;
    
begin
    process(exp_A_in, exp_B_in, mantissa_A_in, mantissa_B_in)
        variable expA : unsigned(7 downto 0);
        variable expB : unsigned(7 downto 0);
        variable diff : integer;
    begin
        expA := unsigned(exp_A_in);
        expB := unsigned(exp_B_in);

        exp_calc <= exp_A_in;
        mantA_calc <= mantissa_A_in;
        mantB_calc <= mantissa_B_in;
        swap_calc <= '0';

        if (expA > expB) or 
           (expA = expB and unsigned(mantissa_A_in) >= unsigned(mantissa_B_in)) then
            
            exp_calc <= exp_A_in;
            diff := to_integer(expA - expB);
            swap_calc <= '0';
            mantA_calc <= mantissa_A_in;
            
            if diff > 26 then
                mantB_calc <= (others => '0');
            else
                mantB_calc <= std_logic_vector(shift_right(unsigned(mantissa_B_in), diff));
            end if;
            
        else 
            
            exp_calc <= exp_B_in;
            diff := to_integer(expB - expA);
            swap_calc <= '1';
            mantB_calc <= mantissa_B_in;
            
            if diff > 26 then
                mantA_calc <= (others => '0');
            else
                mantA_calc <= std_logic_vector(shift_right(unsigned(mantissa_A_in), diff));
            end if;
            
        end if;
    end process;

    process(CLK, RST)
    begin
        if RST = '1' then
            exp_out_reg <= (others => '0');
            mantA_out_reg <= (others => '0');
            mantB_out_reg <= (others => '0');
            swap_flag_reg <= '0';
        elsif rising_edge(CLK) then
            exp_out_reg <= exp_calc; 
            mantA_out_reg <= mantA_calc;
            mantB_out_reg <= mantB_calc;
            swap_flag_reg <= swap_calc;
        end if;
    end process;

    exp_out <= exp_out_reg;
    mantissa_A_out <= mantA_out_reg;
    mantissa_B_out <= mantB_out_reg;
    swap_flag <= swap_flag_reg;
end Behavioral;