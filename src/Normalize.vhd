----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2025 10:11:24 PM
-- Design Name: 
-- Module Name: Normalize - Behavioral
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

entity Normalize is
    Port(
        CLK : in STD_LOGIC;  
        RST : in STD_LOGIC;  
        mantissa_in : in  STD_LOGIC_VECTOR(26 downto 0);
        exponent_in : in  STD_LOGIC_VECTOR(7 downto 0);
        carry_in    : in  STD_LOGIC;
        mantissa_out: out STD_LOGIC_VECTOR(26 downto 0);
        exponent_out: out STD_LOGIC_VECTOR(7 downto 0)
    );
end Normalize;

architecture Behavioral of Normalize is

    signal mantissa_out_reg: STD_LOGIC_VECTOR(26 downto 0);
    signal exponent_out_reg: STD_LOGIC_VECTOR(7 downto 0);
    signal mant  : unsigned(26 downto 0);
    signal exp   : unsigned(7 downto 0);
    signal shift : unsigned(4 downto 0);
    
    constant MANT_ZERO_UNS : unsigned(26 downto 0) := (others => '0');
    
begin
    mant <= unsigned(mantissa_in);
    exp  <= unsigned(exponent_in);

    shift <= 
        "00000" when mant(26)='1' else
        "00001" when mant(25)='1' else
        "00010" when mant(24)='1' else
        "00011" when mant(23)='1' else
        "00100" when mant(22)='1' else
        "00101" when mant(21)='1' else
        "00110" when mant(20)='1' else
        "00111" when mant(19)='1' else
        "01000" when mant(18)='1' else
        "01001" when mant(17)='1' else
        "01010" when mant(16)='1' else
        "01011" when mant(15)='1' else
        "01100" when mant(14)='1' else
        "01101" when mant(13)='1' else
        "01110" when mant(12)='1' else
        "01111" when mant(11)='1' else
        "10000" when mant(10)='1' else
        "10001" when mant(9) ='1' else
        "10010" when mant(8) ='1' else
        "10011" when mant(7) ='1' else
        "10100" when mant(6) ='1' else
        "10101" when mant(5) ='1' else
        "10110" when mant(4) ='1' else
        "10111" when mant(3) ='1' else
        "11000" when mant(2) ='1' else
        "11001" when mant(1) ='1' else
        "11010" when mant(0) ='1' else
        "00000"; 

    process(CLK, RST)
        variable mant_calc : STD_LOGIC_VECTOR(26 downto 0);
        variable exp_calc : STD_LOGIC_VECTOR(7 downto 0);
    begin
        if RST = '1' then
            mantissa_out_reg <= (others => '0');
            exponent_out_reg <= (others => '0');
        elsif rising_edge(CLK) then
            if carry_in = '1' then
                mant_calc := std_logic_vector(shift_right(mant, 1));
                exp_calc := std_logic_vector(exp + 1);
            else
                mant_calc := std_logic_vector(shift_left(mant, to_integer(shift)));
                if mant = MANT_ZERO_UNS then
                    exp_calc := "00000000";
                elsif exp < shift then
                    exp_calc := "00000000";
                else
                    exp_calc := std_logic_vector(exp - shift);
                end if;
            end if;
            mantissa_out_reg <= mant_calc;
            exponent_out_reg <= exp_calc;
        end if;
    end process;

    mantissa_out <= mantissa_out_reg;
    exponent_out <= exponent_out_reg;
end Behavioral;