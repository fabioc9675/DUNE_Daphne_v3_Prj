----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.01.2025 22:01:17
-- Design Name: 
-- Module Name: dataOUTparalelo - Behavioral
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

entity dataOUTparalelo is
  Port (FCLK        : in std_logic;
        RST         : in std_logic; 
        Q           : in std_logic_vector(6 downto 0);
        T           : in std_logic_vector(6 downto 0);
        DATAOUT     : out std_logic_vector(13 downto 0)
        );
end dataOUTparalelo;

architecture Behavioral of dataOUTparalelo is

begin

process(FCLK,RST)
begin
if RST = '1' then
   Dataout <= "00000000000000";  
elsif rising_edge(FCLK) then
   DataOut <= T(6) & Q(6) & T(5) & Q(5) & T(4) & Q(4) & T(3) & Q(3) & T(2) & Q(2) & T(1) & Q(1) & T(0) & Q(0); 
end if;
end process; 

end Behavioral;
