----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2025 20:19:25
-- Design Name: 
-- Module Name: Compare - Behavioral
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

entity Compare is
  Port (DataIn                 : in std_logic_vector(3 downto 0);
        IntRegOutIn_s          : in std_logic_vector(3 downto 0);
        IntEqu                 : out std_logic
     );
end Compare;

architecture Behavioral of Compare is

begin

IntEqu <= '1' when (DataIn = IntRegOutIn_s) else '0';
end Behavioral;
