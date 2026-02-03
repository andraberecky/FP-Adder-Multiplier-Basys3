library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_FPU_Top is
end TB_FPU_Top;

architecture Behavioral of TB_FPU_Top is
    signal clk        : STD_LOGIC := '0';
    signal reset      : STD_LOGIC := '1';
    signal reg_out_R0 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_out_R1 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_out_R2 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_out_R3 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_out_R4 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_out_R5 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_out_R6 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_out_R7 : STD_LOGIC_VECTOR(31 downto 0);
    signal pc_out     : STD_LOGIC_VECTOR(4 downto 0);
    signal done_out   : STD_LOGIC;
    signal btn_step_tb : STD_LOGIC := '0';
    constant CLK_PERIOD : time := 10 ns;
begin

    UUT: entity work.FPU_Top_Level
        port map (
            clk        => clk,
            reset      => reset,
            btn_step   => btn_step_tb,
            reg_out_R0 => reg_out_R0,
            reg_out_R1 => reg_out_R1,
            reg_out_R2 => reg_out_R2,
            reg_out_R3 => reg_out_R3,
            reg_out_R4 => reg_out_R4,
            reg_out_R5 => reg_out_R5,
            reg_out_R6 => reg_out_R6,
            reg_out_R7 => reg_out_R7,
            pc_out     => pc_out,
            done_out   => done_out
        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2.0;
            clk <= '1';
            wait for CLK_PERIOD/2.0;
        end loop;
    end process;

    stimulus: process
    begin
        reset <= '1';
        btn_step_tb <= '0';
        wait for 2*CLK_PERIOD;
        reset <= '0';
        wait for 500 * CLK_PERIOD;
        for i in 0 to 15 loop
        btn_step_tb <= '1';
        wait for 2 * CLK_PERIOD;
        btn_step_tb <= '0';
        wait for 20 * CLK_PERIOD; 
    end loop;
        wait;
    end process;

end Behavioral;
