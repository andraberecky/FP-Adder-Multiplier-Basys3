library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Float_Adder_Top_tb_Extended is
end Float_Adder_Top_tb_Extended;

architecture Extended_Behavioral of Float_Adder_Top_tb_Extended is

    constant LATENCY : integer := 5; 
    constant T_CLK : time := 10 ns;

    component Float_Adder_Top
        Port (
            CLK        : in  STD_LOGIC;
            RST        : in  STD_LOGIC;
            A_in       : in  STD_LOGIC_VECTOR (31 downto 0);
            B_in       : in  STD_LOGIC_VECTOR (31 downto 0);
            sub_op     : in  STD_LOGIC;
            Result_out : out STD_LOGIC_VECTOR (31 downto 0);
            Overflow   : out STD_LOGIC;
            Underflow  : out STD_LOGIC
        );
    end component;
    constant FP_1_0      : STD_LOGIC_VECTOR(31 downto 0) := x"3F800000"; -- 1.0
    constant FP_2_0      : STD_LOGIC_VECTOR(31 downto 0) := x"40000000"; -- 2.0
    constant FP_5_0      : STD_LOGIC_VECTOR(31 downto 0) := x"40A00000"; -- 5.0
    constant FP_10_0     : STD_LOGIC_VECTOR(31 downto 0) := x"41200000"; -- 10.0
    constant FP_0_125    : STD_LOGIC_VECTOR(31 downto 0) := x"3E400000"; -- 0.125
    constant FP_100_0    : STD_LOGIC_VECTOR(31 downto 0) := x"42C80000"; -- 100.0
    constant FP_99_99999 : STD_LOGIC_VECTOR(31 downto 0) := x"42C7FFFE"; -- ~99.99999
    constant FP_TINY_NR  : STD_LOGIC_VECTOR(31 downto 0) := x"30800000"; -- ~2.45e-10
    constant FP_MAX_FLOAT: STD_LOGIC_VECTOR(31 downto 0) := x"7F7FFFFF"; -- Max finite float
    constant FP_INF      : STD_LOGIC_VECTOR(31 downto 0) := x"7F800000"; -- Infinit
    constant FP_M5_0     : STD_LOGIC_VECTOR(31 downto 0) := x"C0A00000"; -- -5.0
    constant FP_TINY_DENOM:STD_LOGIC_VECTOR(31 downto 0) := x"00800000"; -- small nr
    constant FP_TINY_DENOM_2:STD_LOGIC_VECTOR(31 downto 0) := x"007FFFFF"; --  small nr


    signal CLK : STD_LOGIC := '0';
    signal RST : STD_LOGIC := '1';

    signal A_in, B_in, Result_out : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sub_op : STD_LOGIC := '0';
    signal Overflow, Underflow : STD_LOGIC := '0';

begin
    CLK_process: process
    begin
        while true loop
            CLK <= '0'; wait for T_CLK/2;
            CLK <= '1'; wait for T_CLK/2;
        end loop;
    end process;

    RST_process: process
    begin
        RST <= '1'; wait for T_CLK * 2;
        RST <= '0'; wait;
    end process;
    
    DUT: Float_Adder_Top
        port map (CLK => CLK, RST => RST, A_in => A_in, B_in => B_in, sub_op => sub_op, Result_out => Result_out, Overflow => Overflow, Underflow => Underflow);

    stimulus_process: process
        procedure run_test(A_val: in STD_LOGIC_VECTOR(31 downto 0); B_val: in STD_LOGIC_VECTOR(31 downto 0); Op: in STD_LOGIC) is
        begin
            A_in <= A_val;
            B_in <= B_val;
            sub_op <= Op;
            
            for i in 1 to LATENCY loop
                wait until rising_edge(CLK);
            end loop;
            
            for i in 1 to 2 loop
                wait until rising_edge(CLK);
            end loop;
        end procedure;
    begin
        wait until RST = '0';

        -- Test 1: 1.0 + 1.0 = 2.0 
        run_test(FP_1_0, FP_1_0, '0');

        -- Test 2: 10.0 + 0.125 = 10.125 
        run_test(FP_10_0, FP_0_125, '0');

        -- Test 3: 100.0 - 99.99999 
        run_test(FP_100_0, FP_99_99999, '1');

        -- Test 4: 1.0 + small nr
        run_test(FP_1_0, FP_TINY_NR, '0');

        -- Test 5: Overflow (Max + Max = Infinit)
        run_test(FP_MAX_FLOAT, FP_MAX_FLOAT, '0');

        -- Test 6: Underflow (small nr - small nr = 0.0)
        run_test(FP_TINY_DENOM, FP_TINY_DENOM_2, '1');

        -- Test 7: 1.0 + Infinit = Infinit
        run_test(FP_1_0, FP_INF, '0');

        -- Test 8: Infinit - Infinit = NaN
        run_test(FP_INF, FP_INF, '1');

        -- Test 9: -5.0 + 1.0 = -4.0 
        run_test(FP_M5_0, FP_1_0, '0');

        -- Test 10: 2.0 - 5.0 = -3.0
        run_test(FP_2_0, FP_5_0, '1');

        wait;
    end process;
end Extended_Behavioral;