----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.01.2025 21:51:53
-- Design Name: 
-- Module Name: miserdes - Behavioral
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

entity miserdes is
   Port (CLK      : in std_logic;
         FCLK     : in std_logic; 
         RST      : in std_logic;
         data     : in std_logic;
         Q        : out std_logic_vector(6 downto 0)
         );
end miserdes;

architecture Behavioral of miserdes is

signal a   : std_logic;
signal contador : integer := 0;

begin

process(clk,RST)
begin
 if RST = '1' then
    Q <= "0000000";
    contador <= 0;
    a <= '0';
  elsif rising_edge(clk) then
    if FCLK = '1' and a = '0' then
      Q(0) <= Data;
      a <= '1';
      contador <= 1;
    elsif FCLK = '1' and a = '1' then
      Q(contador) <= data;
      contador <= contador + 1;
    elsif FCLK = '0' then
      a <= '0';
      Q(contador) <= data;
      if contador >= 6 then
         contador <= 0;
      else
         contador <= contador + 1;
      end if;    
    end if;
  end if;
end process;             


end Behavioral;
