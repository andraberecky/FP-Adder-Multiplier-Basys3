library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Basys3_FPU_Top is
    Port ( 
        CLK100MHZ : in STD_LOGIC;
        btnC      : in STD_LOGIC; 
        btnU      : in STD_LOGIC;                       
        sw        : in STD_LOGIC_VECTOR(15 downto 0);   
        led       : out STD_LOGIC_VECTOR(15 downto 0);   
        seg       : out STD_LOGIC_VECTOR(6 downto 0);   
        dp        : out STD_LOGIC;                       
        an        : out STD_LOGIC_VECTOR(3 downto 0)     
    );
end Basys3_FPU_Top;

architecture Behavioral of Basys3_FPU_Top is

   signal btn_step_debounced : STD_LOGIC;
    signal btn_reset_debounced : STD_LOGIC;
    signal r0, r1, r2, r3, r4, r5, r6, r7 : STD_LOGIC_VECTOR(31 downto 0);
    signal selected_reg_32 : STD_LOGIC_VECTOR(31 downto 0);
    signal display_data_16 : STD_LOGIC_VECTOR(15 downto 0);
    signal pc_sig : STD_LOGIC_VECTOR(4 downto 0);
    signal done_sig : STD_LOGIC;
begin

    StepBtn: entity work.MPG port map(clk => CLK100MHZ, btn => btnU, en => btn_step_debounced);
    ResetBtn: entity work.MPG port map(clk => CLK100MHZ, btn => btnC, en => btn_reset_debounced);

    TOP: entity work.FPU_Top_Level
        port map (
            clk => CLK100MHZ,
            reset => btn_reset_debounced,
            btn_step => btn_step_debounced,
            reg_out_R0 => r0, reg_out_R1 => r1, reg_out_R2 => r2, reg_out_R3 => r3,
            reg_out_R4 => r4, reg_out_R5 => r5, reg_out_R6 => r6, reg_out_R7 => r7,
            pc_out => pc_sig,
            done_out => done_sig
        );

    process(sw, r0, r1, r2, r3, r4, r5, r6, r7)
    begin
        case sw(2 downto 0) is
            when "000" => selected_reg_32 <= r0;
            when "001" => selected_reg_32 <= r1;
            when "010" => selected_reg_32 <= r2;
            when "011" => selected_reg_32 <= r3;
            when "100" => selected_reg_32 <= r4;
            when "101" => selected_reg_32 <= r5;
            when "110" => selected_reg_32 <= r6;
            when others => selected_reg_32 <= r7;
        end case;
    end process;

    display_data_16 <= selected_reg_32(31 downto 16) when sw(15) = '1' else selected_reg_32(15 downto 0);

    SSD: entity work.SSD
        port map(clk => CLK100MHZ, data => display_data_16, an => an, seg => seg);

    led(4 downto 0) <= pc_sig;  
    led(15) <= done_sig;        
    dp <= '1';              

end Behavioral;