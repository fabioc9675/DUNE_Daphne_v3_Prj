----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.01.2025 19:42:14
-- Design Name: 
-- Module Name: testFCLK - Behavioral
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

entity testFCLK is
--  Port ( );
end testFCLK;

architecture Behavioral of testFCLK is

component adcTopLowF is
  generic(periodo_dclk    : real := 10.0); -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
  Port (FCLK_P     : in std_logic;
        FCLK_N     : in std_logic;
        RST        : in std_logic;
        DATA_P     : in std_logic;
        DATA_N     : in std_logic;
        Q1           : out std_logic;
        Q2           : out std_logic;
        F1           : out std_logic;
        F2           : out std_logic;
        FCLKOut      : out std_logic_vector(13 downto 0);
        DATA_OUT   : out std_logic_vector(13 downto 0)
         );
end component;

signal FCLK_P         : std_logic := '1';
signal FCLK_N         : std_logic := '0';
signal RST          : std_logic;
signal data         : std_logic;
signal data_N         : std_logic;
signal Data_out      : std_logic_vector(13 downto 0);
signal Q1           : std_logic;
signal Q2           : std_logic;
signal F1           : std_logic;
signal F2           : std_logic;
signal FCLKOut      : std_logic_vector(13 downto 0);         
begin

ADC: adcTopLowF 
  generic map (periodo_dclk => 10.0) -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
  Port map (FCLK_P     => FCLK_P,
        FCLK_N     => FCLK_N,
        RST        => RST,
        DATA_P     => DATA,
        DATA_N     => DATA_N,
        Q1      => Q1,
        Q2      => Q2,
        F1      => F1,
        F2      => F2,
        FCLKOut  => FCLKOut,
        DATA_OUT   => DATA_OUT
         );


FCLK_P <= not FCLK_P after 35 ns;
FCLK_N <= not FCLK_P;

DATA_N <= not DATA;
process
begin



RST <= '1';
data <= '0';

wait for 210 ns;

RST <= '0';
wait for 3500 ns;

data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;

data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;

data <= '1';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '0';
wait for 5 ns;

data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '0';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;
data <= '1';
wait for 5 ns;


data <= '0';
wait for 700 ns;
end process;
end Behavioral;
