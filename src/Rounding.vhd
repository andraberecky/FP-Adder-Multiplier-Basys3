----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2025 10:40:18 PM
-- Design Name: 
-- Module Name: Rounding - Behavioral
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

entity Rounding is
    Port (
        CLK          : in  STD_LOGIC;
        RST          : in  STD_LOGIC;
        mantissa_in  : in  STD_LOGIC_VECTOR(26 downto 0);
        exponent_in  : in  STD_LOGIC_VECTOR(7 downto 0);
        mantissa_out : out STD_LOGIC_VECTOR(22 downto 0);
        exponent_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Rounding;

architecture Behavioral of Rounding is
    signal mantissa_out_reg : STD_LOGIC_VECTOR(22 downto 0);
    signal exponent_out_reg : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(CLK, RST)
        variable mant_var : unsigned(26 downto 0);
        variable exp_var  : unsigned(7 downto 0);
        variable mant_rounded : unsigned(24 downto 0);
        variable add_one : unsigned(24 downto 0);
        variable LSB, G, R, S : std_logic;
        variable round_up : std_logic;
    begin
        if RST='1' then
            mantissa_out_reg <= (others=>'0');
            exponent_out_reg <= (others=>'0');
        elsif rising_edge(CLK) then
            mant_var := unsigned(mantissa_in);
            exp_var := unsigned(exponent_in);

            LSB := mant_var(3);
            G   := mant_var(2);
            R   := mant_var(1);
            S   := mant_var(0);

            round_up := (G and (R or S)) or (LSB and G and not (R or S));
            add_one := (others=>'0');
            if round_up='1' then add_one(0) := '1'; end if;

            mant_rounded := ("0"&mant_var(26 downto 3)) + add_one;

            if mant_rounded(24)='1' then
                if exp_var < 255 then exp_var := exp_var +1; end if;
                mantissa_out_reg <= std_logic_vector(mant_rounded(23 downto 1));
            else
                mantissa_out_reg <= std_logic_vector(mant_rounded(22 downto 0));
            end if;

            exponent_out_reg <= std_logic_vector(exp_var);
        end if;
    end process;

    mantissa_out <= mantissa_out_reg;
    exponent_out <= exponent_out_reg;
end Behavioral;