----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.01.2025 09:20:27
-- Design Name: 
-- Module Name: MControl_BitClk - Behavioral
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

-----------------------------------------------------------------------------------------------
-- Bit clock controller for clock alignment state machine.
-----------------------------------------------------------------------------------------------

entity MControl_BitClk is
  Port (BitClk_RefClkIn        : in std_logic;
        IntBitClkRst           : in std_logic;
        BitClkEna              : in std_logic;
        IntProceed             : in std_logic; 
        IntCalVal              : in std_logic_vector(1 downto 0);
        IntClkCtrlDlyCe        : out std_logic;
        IntClkCtrlDlyInc       : out std_logic;
        IntClkCtrlAlgnWrn      : out std_logic;
        IntClkCtrlDone         : out std_logic;
        IntClkCtrlInvrtd       : out std_logic;
        IntProceedDone	       : out std_logic
         );
end MControl_BitClk;

architecture Behavioral of MControl_BitClk is

type StateType is (Idle, A, B, C, D, E, F, G, G1, H, K, K1, K2, IdlyIncDec, Done);
signal State : StateType;
signal ReturnState : StateType;
signal IntClkCtrlDone_Int   : std_logic;

signal PassedSubState		: std_logic;
signal IntTurnAroundBit		: std_logic;
signal IntStepCnt	 		: std_logic_vector (3 downto 0);
signal IntAction			: std_logic_vector (1 downto 0);
signal IntTimeOutCnt		: std_logic_vector (3 downto 0);
signal IntNumIncDecIdly		: std_logic_vector (3 downto 0);
signal IntCalValReg			: std_logic_vector (1 downto 0);
begin


IntClkCtrlDone <= IntClkCtrlDone_Int;

AdcClock_State_PROCESS : process (BitClk_RefClkIn, IntBitClkRst, BitClkEna, IntProceed, IntCalVal)
subtype ActCalVal is std_logic_vector (4 downto 0);
begin
	if (IntBitClkRst = '1') then
		State				<= Idle;
		ReturnState			<= Idle;
		PassedSubState		<= '0';
		--
		IntNumIncDecIdly	<= "0000";	-- Max. 16
		IntAction			<= "00";
		IntClkCtrlDlyInc	<= '1';
		IntClkCtrlDlyCe		<= '0';
		IntClkCtrlDone_Int 		<= '0';
		IntClkCtrlAlgnWrn	<= '0';
		IntClkCtrlInvrtd	<= '0';
		IntTurnAroundBit	<= '0';
		IntProceedDone		<= '0';
		IntClkCtrlDone_Int		<= '0';
		IntCalValReg		<= (others => '0');		-- 2-bit
		IntTimeOutCnt		<= (others => '0');		-- 4-bit
		IntStepCnt	 		<= (others => '0');		-- 4-bit (16)
	elsif rising_edge(BitClk_RefClkIn) then
		if (BitClkEna = '1' and IntClkCtrlDone_Int = '0') then
		case State is
			when Idle =>
				IntProceedDone <= '0';
				PassedSubState <= '0';
		        IntStepCnt	   <= (others => '0');
				case ActCalVal'(IntAction(1 downto 0) & IntCalVal (1 downto 0) & IntProceed) is
					when "00001" => State <= A;
					when "01001" => State <= B;
					when "10001" => State <= B;
					when "11001" => State <= B;
					when "01111" => State <= C;
					when "01101" => State <= D;
					when "01011" => State <= D;
					when "00011" => State <= E;
					when "00101" => State <= E;
					when "00111" => State <= E;
					when "10011" => State <= F;
					when "11011" => State <= F;
					when "10101" => State <= F;
					when "11101" => State <= F;
					when "10111" => State <= F;
					when "11111" => State <= F;
					when others => State <= Idle;
				end case;
			when A => 						-- First time and sampling in jitter or cross area.
				IntAction <= "01";					-- Set the action bits and go to next step.
				State <= B;
			when B =>						-- Input is sampled in jitter or clock cross area.
				if (PassedSubState = '1') then
					PassedSubState <= '0';			-- Clear the pass through the substate bit.
					IntProceedDone <= '1';			-- Reset the proceed bit.
					State <= Idle;					-- Return for a new sample of the input.
				elsif (IntTimeOutCnt = "1111") then	-- When arriving here something is wrong.
					IntTimeOutCnt <= "0000";		-- Reset the counter.
					IntAction <= "00";				-- reset the action bits.
					IntClkCtrlAlgnWrn <= '1';		-- Raise a FLAG.
					IntProceedDone <= '1';			-- Reset the proceed bit.
					State <= Idle;					-- Retry, return for new sample of input.
				else
					IntTimeOutCnt <= IntTimeOutCnt + 1;
					IntNumIncDecIdly <= "0010";		-- Number increments or decrements to do.
					ReturnState <= State;			-- This state is the state to return too.
					IntProceedDone <= '1';			-- Reset the proceed bit.
					IntClkCtrlDlyInc <= '1';		-- Set for increment.
					State <= IdlyIncDec;			-- Jump to Increment/decrement sub-state.
				end if;
			when C =>						-- After first sample, jitter or cross, is now high.
				IntNumIncDecIdly <= "0010";			-- Number increments or decrements to do.
				ReturnState <= Done;				-- This state is the state to return too.
				IntClkCtrlDlyInc	<= '0';			-- Set for decrement.
				State <= IdlyIncDec;
			when D =>						-- Same as C but with indication of 180-deg shift.
				IntClkCtrlInvrtd <= '1';
				State <= C;
			when E =>						-- First saple with valid data.
				IntCalValReg <= IntCalVal;			-- Register the sampled value
				IntAction <= "10";
				IntProceedDone <= '1';				-- Reset the proceed bit.
				IntNumIncDecIdly <= "0001";			-- Number increments or decrements to do.
				ReturnState <= Idle;				-- When increment is done return sampling.
				IntClkCtrlDlyInc <= '1';			-- Set for increment
				State <= IdlyIncDec;				-- Jump to Increment/decrement sub-state.
			when F =>						-- Next samples with valid data.
				if (IntCalVal /= IntCalValReg) then
					State <= G;				-- The new CalVal value is different from the first.
				else
					if (IntStepCnt = "1111") then 	-- Step counter at the end, 15
						if (IntTurnAroundBit = '0') then
							State <= H;				-- No edge found and first time here.
						elsif (IntCalValReg = "11") then
							State <= K;			-- A turnaround already happend.
						else					-- No edge is found (large 1/2 period).
							State <= K1;		-- Move the clock edge to near the correct
						end if;					-- edge.
					else
						IntStepCnt <= IntStepCnt + 1;
						IntNumIncDecIdly <= "0001";	-- Number increments or decrements to do.
						IntProceedDone <= '1';		-- Reset the proceed bit.
						ReturnState <= Idle;		-- When increment is done return sampling.
						IntClkCtrlDlyInc <= '1';	-- Set for increment
						State <= IdlyIncDec;		-- Jump to Increment/decrement sub-state.
					end if;
				end if;
			when G =>
				if (IntCalValReg /= "01") then
					IntClkCtrlInvrtd <= '1';
					State <= G1;
				else
					State <= G1;
				end if;
			when G1 =>
				if (IntTimeOutCnt = "00") then
					State <= Done;
				else
					IntNumIncDecIdly <= "0010";	-- Number increments or decrements to do.
					ReturnState <= Done;		-- After decrement it's finished.
					IntClkCtrlDlyInc <= '0';	-- Set for decrement
					State <= IdlyIncDec;		-- Jump to the Increment/decrement sub-state.
				end if;
			when H =>
				IntTurnAroundBit <= '1';		-- Indicate that the Idelay jumps to 0.
				IntStepCnt <= IntStepCnt + 1;	-- Set all registers to zero.
				IntAction <= "00";				-- Take one step, let the counter flow over
				IntCalValReg <= "00";			-- The idelay turn over to 0.
				IntTimeOutCnt <= "0000";		-- Start sampling from scratch.
				IntNumIncDecIdly <= "0001";		-- Number increments or decrements to do.
				IntProceedDone <= '1';			-- Reset the proceed bit.
				ReturnState <= Idle;			-- After increment go sampling for new.
				IntClkCtrlDlyInc <= '1';		-- Set for increment.
				State <= IdlyIncDec;			-- Jump to the Increment/decrement sub-state.
			when K =>
				IntNumIncDecIdly <= "1111";		-- Number increments or decrements to do.
				ReturnState <= K2;				-- After increment it is done.
				IntClkCtrlDlyInc <= '1';		-- Set for increment.
				State <= IdlyIncDec;			-- Jump to the Increment/decrement sub-state.
			when K1 =>
				IntNumIncDecIdly <= "1110";		-- Number increments or decrements to do.
				ReturnState <= K2;				-- After increment it is done.
				IntClkCtrlDlyInc <= '1';		-- Set for increment.
				State <= IdlyIncDec;			-- Jump to the Increment/decrement sub-state.
			when K2 =>
				IntNumIncDecIdly <= "0001";		-- Number increments or decrements to do.
				ReturnState <= Done;			-- After increment it is done.
				IntClkCtrlDlyInc <= '1';		-- Set for increment.
				State <= IdlyIncDec;			-- Jump to the Increment/decrement sub-state.
			--
			when IdlyIncDec =>				-- Increment or decrement by enable.
				if (IntNumIncDecIdly /= "0000") then			-- Check number of tap jumps
					IntNumIncDecIdly <= IntNumIncDecIdly - 1;	-- If not 0 jump and decrement.
					IntClkCtrlDlyCe <= '1';						-- Do the jump. enable it.
				else
					IntClkCtrlDlyCe <= '0';		-- when it is enabled, disbale it
					PassedSubState <= '1';		-- Set a check bit "I've been here and passed".
					State <= ReturnState;		-- Return to origin.
				end if;
			when Done =>					-- Alignment done.
				IntClkCtrlDone_Int <= '1';				-- Alignment is done.
		end case;
		end if;
	end if;
end process;

           
     
     
end Behavioral;
