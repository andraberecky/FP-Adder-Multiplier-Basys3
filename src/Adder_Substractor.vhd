----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2026 05:54:23 PM
-- Design Name: 
-- Module Name: CLA_Adder - Behavioral
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

entity Adder_Subtractor is
    generic (WIDTH : integer := 28);
    Port (
        A    : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        B    : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        SUB  : in  STD_LOGIC;
        Sum  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        Cout : out STD_LOGIC
    );
end Adder_Subtractor;

architecture Behavioral of Adder_Subtractor is
    signal B_mod : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    signal C     : STD_LOGIC_VECTOR(WIDTH downto 0);
begin
    gen_B_mod: for i in 0 to WIDTH-1 generate
        B_mod(i) <= B(i) xor SUB;
    end generate;

    C(0) <= SUB;

    gen_adder: for i in 0 to WIDTH-1 generate
        Sum(i) <= A(i) xor B_mod(i) xor C(i);
        C(i+1) <= (A(i) and B_mod(i)) or (A(i) and C(i)) or (B_mod(i) and C(i));
    end generate;

    Cout <= C(WIDTH);
end Behavioral;
