library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Float_Multiplier_Top_tb is
end Float_Multiplier_Top_tb;

architecture tb of Float_Multiplier_Top_tb is
    signal CLK       : STD_LOGIC := '0';
    signal RST       : STD_LOGIC := '0';
    signal A_in      : STD_LOGIC_VECTOR(31 downto 0);
    signal B_in      : STD_LOGIC_VECTOR(31 downto 0);
    signal Result    : STD_LOGIC_VECTOR(31 downto 0);
    signal Overflow  : STD_LOGIC;
    signal Underflow : STD_LOGIC;

    constant FP_ZERO  : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    constant FP_ONE   : STD_LOGIC_VECTOR(31 downto 0) := X"3F800000";
    constant FP_TWO   : STD_LOGIC_VECTOR(31 downto 0) := X"40000000";
    constant FP_HALF  : STD_LOGIC_VECTOR(31 downto 0) := X"3F000000";
    constant FP_INF   : STD_LOGIC_VECTOR(31 downto 0) := X"7F800000";
    constant FP_MTWO  : STD_LOGIC_VECTOR(31 downto 0) := X"C0000000";
    constant FP_QUARTER : STD_LOGIC_VECTOR(31 downto 0) := X"3E800000";
    constant FP_FOUR    : STD_LOGIC_VECTOR(31 downto 0) := X"40800000";
    constant FP_MNINE   : STD_LOGIC_VECTOR(31 downto 0) := X"C1100000";
    
begin
    
    CLK_process: process
    begin
        while true loop
            CLK <= '0'; wait for 5 ns;
            CLK <= '1'; wait for 5 ns;
        end loop;
    end process;

    RST_process: process
    begin
        RST <= '1'; wait for 20 ns;
        RST <= '0'; wait;
    end process;

    DUT: entity work.Float_Multiplier_Top
        port map(
            CLK => CLK, RST => RST, A_in => A_in, B_in => B_in,
            Result => Result, Overflow => Overflow, Underflow => Underflow
        );

    stimulus_process: process
    begin
        wait until RST = '0';

        -- Test 1: 4.0 * 1.0 = 4.0
        A_in <= FP_FOUR; B_in <= FP_ONE;
        for i in 1 to 6 loop
            wait until rising_edge(CLK);
        end loop;
        for i in 1 to 3 loop
            wait until rising_edge(CLK); 
        end loop;
        -- Test 2: 2.0 * 0.25 = 0.5
        A_in <= FP_TWO; B_in <= FP_QUARTER;
        for i in 1 to 6 loop
            wait until rising_edge(CLK);
        end loop;
        for i in 1 to 3 loop
            wait until rising_edge(CLK); 
        end loop;
        -- Test 3: -9.0 * 0.5 = -4.5
        A_in <= FP_MNINE; B_in <= FP_HALF;
        for i in 1 to 6 loop
            wait until rising_edge(CLK);
        end loop;
        for i in 1 to 3 loop
            wait until rising_edge(CLK); 
        end loop;
        -- Test 4: 0.0 * (-2.0) = 0.0
        A_in <= FP_ZERO; B_in <= FP_MTWO;
        for i in 1 to 6 loop
            wait until rising_edge(CLK);
        end loop;
        for i in 1 to 3 loop
            wait until rising_edge(CLK); 
        end loop;
        -- Test 5: Infinit * 4.0 = Infinit
        A_in <= FP_INF; B_in <= FP_FOUR;
        for i in 1 to 6 loop
            wait until rising_edge(CLK);
        end loop;
        for i in 1 to 3 loop
            wait until rising_edge(CLK); 
        end loop;
        -- Test 6: 2.0 * 0.0 = 0.0
        A_in <= FP_TWO; B_in <= FP_ZERO;
        for i in 1 to 6 loop
            wait until rising_edge(CLK);
        end loop;
        for i in 1 to 3 loop
            wait until rising_edge(CLK); 
        end loop;
        -- Test 7: -2.0 * 4.0 = -8.0
        A_in <= FP_MTWO; B_in <= FP_FOUR;
        for i in 1 to 6 loop
            wait until rising_edge(CLK);
        end loop;
        for i in 1 to 3 loop
            wait until rising_edge(CLK); 
        end loop;
       
        A_in <= X"FFFFFFFF"; 
        B_in <= X"FFFFFFFF";
        wait;
    end process;
    end tb;