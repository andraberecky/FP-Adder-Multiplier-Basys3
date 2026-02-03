----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2025 07:21:13 PM
-- Design Name: 
-- Module Name: FPU_Top_Level - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FPU_Top_Level is
    Port (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        btn_step   : in  STD_LOGIC;
        reg_out_R0 : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R1 : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R2 : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R3 : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R4 : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R5 : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R6 : out STD_LOGIC_VECTOR(31 downto 0);
        reg_out_R7 : out STD_LOGIC_VECTOR(31 downto 0);
        pc_out     : out STD_LOGIC_VECTOR(4 downto 0);
        done_out   : out STD_LOGIC
    );
end FPU_Top_Level;

architecture Behavioral of FPU_Top_Level is

    signal pc_increment : STD_LOGIC;
    signal pc_addr      : STD_LOGIC_VECTOR(4 downto 0);
    signal instr_out    : STD_LOGIC_VECTOR(31 downto 0);
    signal readA_addr, readB_addr, write_reg_addr : STD_LOGIC_VECTOR(2 downto 0);
    signal write_en, sub_op : STD_LOGIC;
    signal mux_select : STD_LOGIC_VECTOR(1 downto 0);
    signal read_data_A, read_data_B : STD_LOGIC_VECTOR(31 downto 0);
    signal A_reg, B_reg : STD_LOGIC_VECTOR(31 downto 0);
    signal op_launch_sig : STD_LOGIC;
    signal adder_result, mul_result : STD_LOGIC_VECTOR(31 downto 0);
    signal overflow_add, underflow_add : STD_LOGIC;
    signal overflow_mul, underflow_mul : STD_LOGIC;
    signal done_fsm : STD_LOGIC;
    signal write_data_mux : STD_LOGIC_VECTOR(31 downto 0);

begin

    PC: entity work.Program_Counter
        Port map ( clk => clk,
                   reset => reset,
                   pc_increment => pc_increment,
                   pc_out => pc_addr
        );
    pc_out <= pc_addr;

    IM: entity work.Instruction_Memory
        Port map ( addr => pc_addr,
                   instr => instr_out
        );

    FSM: entity work.control_fsm
        Port map ( clk        => clk,
                   reset      => reset,
                   instr      => instr_out,
                   btn_step   => btn_step,
                   readA_addr => readA_addr,
                   readB_addr => readB_addr,
                   write      => write_en,
                   write_reg  => write_reg_addr,
                   mux_select => mux_select,
                   sub_op     => sub_op,
                   pc_increment => pc_increment,
                   done_out   => done_fsm,
                   op_launch  => op_launch_sig
        );

    REG_FILE: entity work.Register_File_8x32
        Port map (
            clk        => clk,
            write_en   => write_en,
            write_addr => write_reg_addr,
            write_data => write_data_mux,
            readA_addr => readA_addr,
            readB_addr => readB_addr,
            read_data_A => read_data_A,
            read_data_B => read_data_B,
            reg_out_R0 => reg_out_R0,
            reg_out_R1 => reg_out_R1,
            reg_out_R2 => reg_out_R2,
            reg_out_R3 => reg_out_R3,
            reg_out_R4 => reg_out_R4,
            reg_out_R5 => reg_out_R5,
            reg_out_R6 => reg_out_R6,
            reg_out_R7 => reg_out_R7
        );

    ADDER: entity work.Float_Adder_Top
        Port map ( CLK => clk,
                   RST => reset,
                   A_in => A_reg,
                   B_in => B_reg,
                   sub_op => sub_op,
                   Result_out => adder_result,
                   Overflow => overflow_add,
                   Underflow => underflow_add
        );

    MULTIPLIER: entity work.Float_Multiplier_Top
        Port map ( CLK => clk,
                   RST => reset,
                   A_in => A_reg,
                   B_in => B_reg,
                   Result => mul_result,
                   Overflow => overflow_mul,
                   Underflow => underflow_mul
        );

    process(clk, reset)
    begin
        if reset = '1' then
            A_reg <= (others => '0');
            B_reg <= (others => '0');
        elsif rising_edge(clk) then
            if op_launch_sig = '1' then
                A_reg <= read_data_A;
                B_reg <= read_data_B;
            end if;
        end if;
    end process;

    with mux_select select
        write_data_mux <= adder_result when "01",
                          mul_result   when "10",
                          (others => '0') when others;

    done_out <= done_fsm;

end Behavioral;
