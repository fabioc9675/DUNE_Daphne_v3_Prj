----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.01.2025 10:16:03
-- Design Name: 
-- Module Name: AdcClockProcess - Behavioral
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
use IEEE.std_logic_UNSIGNED.all;
use IEEE.std_logic_arith.all;

entity AdcClockProcess is
  Port ( BitClk_RefClkIn     : in std_logic;
         BitClkEna			: in std_logic;
         IntBitClkRst       : in std_logic;
         IntClkCtrlDone     : in std_logic;
         IntProceedDone	    : in std_logic;
         IntClkCtrlOut       : in std_logic_vector(7 downto 0);
         IntCalVal           : out std_logic_vector(1 downto 0);
         IntProceed          : out std_logic
           );
end AdcClockProcess;
-----------------------------------------------------------------------------------------------
-- Bit clock controller for clock alignment input.
-----------------------------------------------------------------------------------------------
-- This input section makes sure 64 bits are captured before action is taken to pass to
-- the state machine for evaluation.
-- 8 samples of the Bit Clock are taken by the ISERDES and then transferred to the parallel
-- FPGA world. The Proceed counter needs 8 reference clock rising edges before terminal count.
-- The Proceed counter terminal count then loads the 2 control bits (made from sampled clock)
-- into an intermediate register (IntCalVal).
--
-- IntCal = '1' when all outputs of the ISERDES are '1 else it's '0'.
-- IntVal = '1' when all outputs are '0' or '1'.
--
architecture Behavioral of AdcClockProcess is
signal IntCal					: std_logic;
signal IntVal					: std_logic;
signal IntProceedCnt			: std_logic_vector (2 downto 0);
signal IntproceedCntTc_d		: std_logic;
signal IntproceedCntTc			: std_logic;
begin


IntCal <= IntClkCtrlOut(7) and IntClkCtrlOut(6) and IntClkCtrlOut(5) and
			IntClkCtrlOut(4) and IntClkCtrlOut(3) and IntClkCtrlOut(2) and
			IntClkCtrlOut(1) and IntClkCtrlOut(0);
			
IntVal <= '1' when (IntClkCtrlOut = "11111111" or IntClkCtrlOut = "00000000") else '0';	


process (BitClkEna, IntBitClkRst, BitClk_RefClkIn, IntProceedDone, IntClkCtrlDone)
begin
   if (IntBitClkRst = '1') then
       IntProceedCnt <= (others => '0');	
       IntProceedCntTc_d <= '0';	
       IntCalVal <= (others => '0');
       IntProceed <= '0';
   elsif rising_edge(BitClk_RefClkIn) then
      if (BitClkEna = '1' and IntClkCtrlDone = '0' ) then
          IntProceedCnt <= IntProceedCnt + 1;
	      IntProceedCntTc_d <= IntProceedCntTc;  
	      if (IntProceedCntTc_d = '1') then
	          IntCalVal <= IntCal & IntVal;
	          IntProceed <= '1'; 
	      elsif (IntProceedDone = '1') then
	          IntProceed <= '0';
	      end if;  
	  end if;
   end if;
end process;

IntProceedCntTc <= '1' when (IntProceedCnt = "110") else '0';   	            
       
end Behavioral;
