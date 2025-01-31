----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2025 21:01:15
-- Design Name: 
-- Module Name: FDRSE - Behavioral
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
Library UNISIM;
use UNISIM.vcomponents.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FDRSE is
  Port (D     : in std_logic;
		CE    : in std_logic;
        C     : in std_logic;
        S     : in std_logic;
		R     : in std_logic;
		Q     : out std_logic
          );
end FDRSE;

architecture Behavioral of FDRSE is

signal IntQ     : std_logic;
signal intO     : std_logic;

begin


Fdrse_Case : process (IntQ, D, CE, S)
subtype LutOut is std_logic_vector(3 downto 0);
begin
    case LutOut'(IntQ & D & CE & S) is
        when "0000" => IntO <= '0'; -- IntQ = 0, rest = 0 thus O/Q = 0
        when "0001" => IntO <= '1'; -- Set = 1 thus O/Q = 1
        when "0010" => IntO <= '0'; -- CE = 1, D = 0, IntQ = 0 thus O/Q = 0
        when "0011" => IntO <= '1'; -- Set = 1 thus O/Q = 1
        when "0100" => IntO <= '0'; -- CE = 0, IntQ = 0 thus O/Q = 0
        when "0101" => IntO <= '1'; -- Set = 1 thus O/Q = 1
        when "0110" => IntO <= '1'; -- CE = 1, D = 1 IntQ = 0 thus O/Q = 1
        when "0111" => IntO <= '1'; -- Set = 1 thus O/Q = 1
        when "1000" => IntO <= '1'; -- IntQ = 1 Thus )/Q = 1
        when "1001" => IntO <= '1'; -- Set = 1 thus O/Q = 1
        when "1010" => IntO <= '0'; -- CE = 1, D = 0 IntQ = 1 thus O/Q = 0
        when "1011" => IntO <= '1'; -- Set = 1 thus O/Q = 1
        when "1100" => IntO <= '1'; -- CE = 0, IntQ = 1 thus O/Q = 1
        when "1101" => IntO <= '1'; -- Set = 1 thus O/Q = 1
        when "1110" => IntO <= '1'; -- CE = 1, IntQ & D = 1 thus O/Q = 1
        -- when "1111" => IntO <= '1';
        when others => IntO <= '1'; -- Set = 1 thus O/Q = 1
    end case;
end process Fdrse_Case;
--
Q <= IntQ;

-- FDRE: Single Data Rate D Flip-Flop with Synchronous Reset and
-- Clock Enable (posedge clk).
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
FDRE_inst : FDRE
  generic map (
    INIT => '0') -- Initial value of register ('0' or '1')
  port map (
     Q => IntQ, -- Data output
     C => C, -- Clock input
     CE => '1', -- Clock enable input
     R => R, -- Synchronous reset input
     D => IntO -- Data input
  );
-- End of FDRE_inst instantiation

end Behavioral;
