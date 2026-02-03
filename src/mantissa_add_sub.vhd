----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2025 09:35:16 PM
-- Design Name: 
-- Module Name: mantissa_add_sub - Behavioral
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

entity mantissa_add_sub is
    Port(
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        mantissa_A : in  STD_LOGIC_VECTOR(26 downto 0);
        mantissa_B : in  STD_LOGIC_VECTOR(26 downto 0);
        sign_A     : in  STD_LOGIC;
        sign_B     : in  STD_LOGIC;
        result     : out STD_LOGIC_VECTOR(26 downto 0);
        sign_res   : out STD_LOGIC;
        carry_out  : out STD_LOGIC
    );
end mantissa_add_sub;

architecture Behavioral of mantissa_add_sub is
    signal A_ext, B_ext : STD_LOGIC_VECTOR(27 downto 0);
    signal op_A, op_B    : STD_LOGIC_VECTOR(27 downto 0);
    signal sum_add_sub  : STD_LOGIC_VECTOR(27 downto 0);
    signal sub_flag     : STD_LOGIC;
    signal result_reg   : STD_LOGIC_VECTOR(26 downto 0);
    signal sign_res_reg : STD_LOGIC;
begin
    A_ext <= '0' & mantissa_A;
    B_ext <= '0' & mantissa_B;

    process(A_ext, B_ext, sign_A, sign_B)
    begin
        if unsigned(A_ext) >= unsigned(B_ext) then
            op_A <= A_ext;
            op_B <= B_ext;
        else
            op_A <= B_ext;
            op_B <= A_ext;
        end if;
    end process;
    ADD_SUB: entity work.Adder_Subtractor
        generic map(WIDTH => 28)
        port map(
            A => op_A,
            B => op_B,
            SUB => sub_flag,
            Sum => sum_add_sub,
            Cout => open
        );
        
process(CLK, RST)
    variable s : STD_LOGIC;
begin
    if RST='1' then
        result_reg <= (others=>'0');
        sign_res_reg <= '0';
        sub_flag <= '0';
    elsif rising_edge(CLK) then
        if sign_A = sign_B then
            sub_flag <= '0';
            s := sign_A; 
        else
            sub_flag <= '1';
            if unsigned(A_ext) >= unsigned(B_ext) then
                s := sign_A; 
            else
                s := sign_B; 
            end if;
        end if;
       result_reg <= sum_add_sub(26 downto 0);
        sign_res_reg <= s;
    end if;
end process;

    result <= result_reg;
    sign_res <= sign_res_reg;
    carry_out <= sum_add_sub(27) when (sub_flag = '0') else '0';
end Behavioral;