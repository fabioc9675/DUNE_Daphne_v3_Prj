----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2025 17:59:44
-- Design Name: 
-- Module Name: GenSlipCnt - Behavioral
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

entity GenSlipCnt is
  Port (clk                : in std_logic;
        IntPulse           : in std_logic;
        IntEqu             : in std_logic;
        IntRstIn_d         : in std_logic;
        IntEqu_d           : out std_logic;
        IntSlipCnt_d       : out std_logic_vector(3 downto 0) );
end GenSlipCnt;

architecture Behavioral of GenSlipCnt is

signal IntSlipCnt       : std_logic_vector(3 downto 0);
signal IntSlipCnt_dint  : std_logic_vector(3 downto 0);
signal IntSlipCntRst    : std_logic;


begin

IntSlipCnt_d <= IntSlipCnt_dint;

-- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
-- Clock Enable (posedge clk).
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
DBleNib_FDCE_instN : FDCE
       generic map (
          INIT => '0') -- Initial value of register ('0' or '1')
       port map (
          Q => IntEqu_d, -- Data output
          C => Clk, -- Clock input
          CE => IntEqu, -- Clock enable input
          CLR => IntSlipCntRst, -- Asynchronous clear input
          D => '1' -- Data input
       );
-- End of FDCE_inst instantiation
-- When a double nibble is detected shift the pulse over four taps and reset the shifter
-- at the fifth tap.
---------------------------------------------------------------------------------------------
-- Slip Counter
-- When equality is detected, this counter counts till a preset number and then resets.
---------------------------------------------------------------------------------------------
IntSlipCntRst <= '1' when (IntRstIn_d = '1' or IntSlipCnt_dint= "0101") else '0';
--

gen_slipcnt : for n in 3 downto 0 generate
   
   -- FDRE: Single Data Rate D Flip-Flop with Synchronous Reset and
   -- Clock Enable (posedge clk).
   -- 7 Series
   -- Xilinx HDL Libraries Guide, version 14.7
   CNT_FDRE : FDRE
      generic map (
        INIT => '0') -- Initial value of register ('0' or '1')
      port map (
        Q => IntSlipCnt_dint(n), -- Data output
        C => Clk, -- Clock input
        CE => IntPulse, -- Clock enable input
        R => IntSlipCntRst, -- Synchronous reset input
        D => IntSlipCnt(n) -- Data input
      );
    -- End of FDRE_inst instantiation
end generate gen_slipcnt;

DbleNibl_process: process(IntSlipCnt_dint)
begin
    case IntSlipCnt_dint(3 downto 0) is
        when "0000" => IntSlipCnt <= "0001";  -- after 100 ps;
        when "0001" => IntSlipCnt <= "0011";  -- after 100 ps;
        when "0011" => IntSlipCnt <= "0010";  -- after 100 ps;
        when "0010" => IntSlipCnt <= "0110";  -- after 100 ps;
        when "0110" => IntSlipCnt <= "0111";  -- after 100 ps;
        when "0111" => IntSlipCnt <= "0101";  -- after 100 ps;
        when others => IntSlipCnt <= "0000";  -- after 100 ps;
    end case;
end process;

end Behavioral;
