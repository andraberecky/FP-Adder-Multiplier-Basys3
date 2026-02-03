----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2025 11:00:32 AM
-- Design Name: 
-- Module Name: RoundingMultiplier - Behavioral
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

entity RoundingMultiplier is
    Port (
        CLK          : in  STD_LOGIC;
        RST          : in  STD_LOGIC;
        mantissa_in  : in  STD_LOGIC_VECTOR(26 downto 0); 
        exponent_in  : in  STD_LOGIC_VECTOR(7 downto 0); 
        mantissa_out : out STD_LOGIC_VECTOR(22 downto 0);
        exponent_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end RoundingMultiplier;

architecture Behavioral of RoundingMultiplier is
    signal mantissa_out_reg : STD_LOGIC_VECTOR(22 downto 0);
    signal exponent_out_reg : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(CLK, RST)
        variable mant_u        : unsigned(26 downto 0);
        variable exp_u         : unsigned(7 downto 0);
        variable mant_rounded  : unsigned(24 downto 0);
        variable add_one       : unsigned(24 downto 0);
        variable LSB, G, R, S  : boolean;
        variable round_up      : boolean;
        variable kept_24       : unsigned(23 downto 0);
    begin
        if RST = '1' then
            mantissa_out_reg <= (others => '0');
            exponent_out_reg <= (others => '0');
        elsif rising_edge(CLK) then
            mant_u := unsigned(mantissa_in);
            exp_u  := unsigned(exponent_in);
            LSB := (mant_u(3) = '1'); 
            G   := (mant_u(2) = '1'); 
            R   := (mant_u(1) = '1'); 
            S   := (mant_u(0) = '1'); 
            round_up := (G and (R or S)) or (LSB and G and not (R or S));
            add_one := (others => '0');
            if round_up then
                add_one(0) := '1';
            end if;

            mant_rounded := ("0" & mant_u(26 downto 3)) + add_one; 

            if mant_rounded(24) = '1' then
                if exp_u /= to_unsigned(255, 8) then
                    exp_u := exp_u + 1;
                end if;
                kept_24 := mant_rounded(24 downto 1); 
            else
                kept_24 := mant_rounded(23 downto 0);
            end if;
            
            mantissa_out_reg <= std_logic_vector(kept_24(22 downto 0));
            exponent_out_reg <= std_logic_vector(exp_u);
        end if;
    end process;

    mantissa_out <= mantissa_out_reg;
    exponent_out <= exponent_out_reg;
end Behavioral;