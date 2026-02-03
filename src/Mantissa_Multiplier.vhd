----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2025 02:39:22 PM
-- Design Name: 
-- Module Name: Mantissa_Multiplier - Behavioral
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

entity Mantissa_Multiplier is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           mantissa_A : in STD_LOGIC_VECTOR (26 downto 0);
           mantissa_B : in STD_LOGIC_VECTOR (26 downto 0);
           mantissa_product : out STD_LOGIC_VECTOR (53 downto 0));
end Mantissa_Multiplier;

architecture Behavioral of Mantissa_Multiplier is
    component FullAdder is
        Port ( a, b, cin : in STD_LOGIC; sum, cout : out STD_LOGIC );
    end component;

    component RCA_54bit is
        Port ( A, B : in STD_LOGIC_VECTOR(53 downto 0);
               S    : out STD_LOGIC_VECTOR(53 downto 0));
    end component;

    type pp_matrix is array (0 to 26) of std_logic_vector(53 downto 0);
    signal p : pp_matrix;

    type stage1_array is array (0 to 17) of std_logic_vector(54 downto 0);
    signal s1 : stage1_array;
    
    type stage2_array is array (0 to 11) of std_logic_vector(54 downto 0);
    signal s2 : stage2_array;
    
    type stage3_array is array (0 to 7) of std_logic_vector(54 downto 0);
    signal s3 : stage3_array;
    
    type stage4_array is array (0 to 5) of std_logic_vector(54 downto 0);
    signal s4 : stage4_array;
    
    type stage5_array is array (0 to 3) of std_logic_vector(54 downto 0);
    signal s5 : stage5_array;
    
    type stage6_array is array (0 to 2) of std_logic_vector(54 downto 0);
    signal s6 : stage6_array;

    signal row_final_A, row_final_B : std_logic_vector(53 downto 0);
    signal res_comb : std_logic_vector(53 downto 0);

begin

    gen_pp: for i in 0 to 26 generate
        process(mantissa_A, mantissa_B)
        begin
            p(i) <= (others => '0');
            for j in 0 to 26 loop
                p(i)(j+i) <= mantissa_A(j) and mantissa_B(i);
            end loop;
        end process;
    end generate;

    stage1_red: for g in 0 to 8 generate
        cols1: for k in 0 to 53 generate
            FA_s1: entity work.FullAdder port map (
                a    => p(g*3)(k),
                b    => p(g*3+1)(k),
                cin  => p(g*3+2)(k),
                sum  => s1(g*2)(k),
                cout => s1(g*2+1)(k+1)
            );
        end generate;
    end generate;

    stage2_red: for g in 0 to 5 generate
        cols2: for k in 0 to 53 generate
            FA_s2: entity work.FullAdder port map (
                a    => s1(g*3)(k),
                b    => s1(g*3+1)(k),
                cin  => s1(g*3+2)(k),
                sum  => s2(g*2)(k),
                cout => s2(g*2+1)(k+1)
            );
        end generate;
    end generate;

    stage3_red: for g in 0 to 3 generate
        cols3: for k in 0 to 53 generate
            FA_s3: entity work.FullAdder port map (
                a    => s2(g*3)(k),
                b    => s2(g*3+1)(k),
                cin  => s2(g*3+2)(k),
                sum  => s3(g*2)(k),
                cout => s3(g*2+1)(k+1)
            );
        end generate;
    end generate;

    stage4_red: for g in 0 to 1 generate
        cols4: for k in 0 to 53 generate
            FA_s4: entity work.FullAdder port map (
                a    => s3(g*3)(k),
                b    => s3(g*3+1)(k),
                cin  => s3(g*3+2)(k),
                sum  => s4(g*2)(k),
                cout => s4(g*2+1)(k+1)
            );
        end generate;
    end generate;
    
    s4(4)(53 downto 0) <= s3(6)(53 downto 0);
    s4(5)(53 downto 0) <= s3(7)(53 downto 0);

    stage5_red: for g in 0 to 1 generate
        cols5: for k in 0 to 53 generate
            FA_s5: entity work.FullAdder port map (
                a    => s4(g*3)(k),
                b    => s4(g*3+1)(k),
                cin  => s4(g*3+2)(k),
                sum  => s5(g*2)(k),
                cout => s5(g*2+1)(k+1)
            );
        end generate;
    end generate;

    stage6_red: for k in 0 to 53 generate
        FA_s6: entity work.FullAdder port map (
            a    => s5(0)(k),
            b    => s5(1)(k),
            cin  => s5(2)(k),
            sum  => s6(0)(k),
            cout => s6(1)(k+1)
        );
    end generate;
    
    s6(2)(53 downto 0) <= s5(3)(53 downto 0);

    row_final_A <= s6(0)(53 downto 0);
    row_final_B <= s6(1)(53 downto 0);

    Final_Adder: entity work.RCA_54bit port map (
        A => row_final_A, 
        B => row_final_B, 
        S => res_comb
    );

    process(CLK, RST)
    begin
        if RST = '1' then
            mantissa_product <= (others => '0');
        elsif rising_edge(CLK) then
            mantissa_product <= res_comb;
        end if;
    end process;
end Behavioral;