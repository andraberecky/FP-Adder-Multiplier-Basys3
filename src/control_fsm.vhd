----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2025 06:59:29 PM
-- Design Name: 
-- Module Name: control_fsm - Behavioral
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

entity control_fsm is
    Port ( clk, reset : in STD_LOGIC;
           instr      : in STD_LOGIC_VECTOR(31 downto 0);
           btn_step   : in STD_LOGIC;
           readA_addr, readB_addr : out STD_LOGIC_VECTOR(2 downto 0);
           write      : out STD_LOGIC;
           write_reg  : out STD_LOGIC_VECTOR(2 downto 0);
           mux_select : out STD_LOGIC_VECTOR(1 downto 0);
           sub_op     : out STD_LOGIC;
           pc_increment : out STD_LOGIC;
           done_out   : out STD_LOGIC;
           op_launch  : out STD_LOGIC  
    );
end control_fsm;

architecture Behavioral of control_fsm is
    type state_type is (IDLE, START_OP, WAIT_PIPE, WRITE_RES, WAIT_STEP, HALT);
    signal current_state, next_state : state_type;
    signal pipe_counter : unsigned(2 downto 0) := (others => '0');
    constant PIPE_LATENCY : unsigned(2 downto 0) := to_unsigned(6,3);
    signal OPCODE_S : STD_LOGIC_VECTOR(2 downto 0);
    signal RD_S     : STD_LOGIC_VECTOR(2 downto 0);
    signal write_reg_pipe : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal mux_select_reg : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal sub_op_reg     : STD_LOGIC := '0';
begin
    OPCODE_S <= instr(31 downto 29);
    RD_S     <= instr(28 downto 26);
    readA_addr <= instr(25 downto 23);
    readB_addr <= instr(22 downto 20);

    process(clk, reset)
    begin
        if reset='1' then
            current_state <= IDLE;
            pipe_counter <= (others=>'0');
            write_reg_pipe <= (others=>'0');
            mux_select_reg <= (others=>'0');
            sub_op_reg <= '0';
        elsif rising_edge(clk) then
            current_state <= next_state;

            if current_state = WAIT_PIPE then
                pipe_counter <= pipe_counter + 1;
            else
                pipe_counter <= (others=>'0');
            end if;

            if current_state = START_OP then
                write_reg_pipe <= RD_S;
                if OPCODE_S = "001" then
                    mux_select_reg <= "01";
                    sub_op_reg <= instr(0);
                elsif OPCODE_S = "010" then
                    mux_select_reg <= "10";
                    sub_op_reg <= '0';
                else
                    mux_select_reg <= (others=>'0');
                    sub_op_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    process(current_state, pipe_counter, OPCODE_S, btn_step)
    begin
        next_state <= current_state;
        write <= '0';
        done_out <= '0';
        pc_increment <= '0';
        op_launch <= '0';

        case current_state is
            when IDLE =>
                if OPCODE_S /= "111" then
                    next_state <= START_OP;
                else
                    next_state <= HALT;
                end if;

            when START_OP =>
                op_launch <= '1';
                next_state <= WAIT_PIPE;

            when WAIT_PIPE =>
                if pipe_counter = PIPE_LATENCY then
                    next_state <= WRITE_RES;
                else
                    next_state <= WAIT_PIPE;
                end if;

            when WRITE_RES =>
                write <= '1';
                next_state <= WAIT_STEP;

            when WAIT_STEP =>
                if btn_step = '1' then
                    pc_increment <= '1';
                    next_state <= IDLE;
                else
                    next_state <= WAIT_STEP;
                end if;

            when HALT =>
                done_out <= '1';
                next_state <= HALT;
        end case;
    end process;

    mux_select <= mux_select_reg;
    sub_op <= sub_op_reg;
    write_reg <= write_reg_pipe;
end Behavioral;