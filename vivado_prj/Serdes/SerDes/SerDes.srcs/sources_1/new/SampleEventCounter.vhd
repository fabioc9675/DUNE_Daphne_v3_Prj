----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.01.2025 13:11:48
-- Design Name: 
-- Module Name: SampleEventCounter - Behavioral
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
Library UNISIM;
use UNISIM.vcomponents.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SampleEventCounter is
  Port (FrmClkDiv               : in std_logic;
        FrmClkDone		        : in std_logic;		-- Input from clock syncronisation.
        FrmClkEna		        : in std_logic;
        FrmClkRst               : in std_logic;
        FrmClkReSync	        : in std_logic;
        IntFrmDbleNibFnl        : in std_logic;
        IntFrmEqu_d             : in std_logic;
        IntFrmSwapMux_d         : in std_logic;
        IntFrmBitSlip   		: out std_logic_vector(5 downto 0);
        IntFrmClkRst            : out std_logic;
        FrmClkBitSlip_p	        : out std_logic;
        FrmClkBitSlip_n	        : out std_logic;
        FrmClkReSyncOut	        : out std_logic;
        FrmClkSyncWarn	        : out std_logic;
        IntFrmEna               : out std_logic
   );
end SampleEventCounter;

architecture Behavioral of SampleEventCounter is

component GenPulse is
  Port (Clk		: in std_logic;
        Ena		: in std_logic;
        SigIn	: in std_logic;
        SigOut	: out std_logic
         );
end component;

signal IntFrmEquSet_d		        : std_Logic;
signal IntFrmEnaint                 : std_logic;
signal IntFrmEvntCnt		        : std_logic_vector(3 downto 0); -- count event counter
signal IntFrmEvntCntTc_d	        : std_logic;
signal IntFrmEvntCntTc		        : std_logic;
signal IntFrmSlipCntTc		        : std_logic;
signal IntFrmSlipCnt		        : std_logic_vector(4 downto 0); -- count to 32
signal IntFrmSlipCntTc_d	        : std_logic;
signal IntFrmSlipCntTc_d2           : std_logic;
signal IntFrmSlipCntTc_d1           : std_logic;
signal IntFrmSlipCntTc_d2Ena        : std_logic;
signal IntFrmWarnCnt		        : std_logic_vector(2 downto 0);
signal IntFrmWarnCntTc_d	        : std_logic;
signal IntFrmWarnCntTc		        : std_logic;
signal IntFrmClkReSync              : std_logic;
signal IntFrmReSyncOut  		    : std_logic;
signal IntFrmReSyncOut_d		    : std_logic;
signal IntFrmClkRstint  	        : std_logic;
signal IntFrmBitSlipint		        : std_logic_vector(5 downto 0);


begin

IntFrmEna <= IntFrmEnaint;
----------------------------------------------------------------------------------------------
-- SAMPLE EVENT COUNTER
-- Take a frame sample every 16 ClkDiv cycles.
-----------------------------------------------------------------------------------------------

AdcFrame_EvntCnt_PROCESS : process (FrmClkDiv, IntFrmClkRstint,
                                    IntFrmEquSet_d, IntFrmEnaint)
begin
	if (IntFrmClkRstint = '1') then
		IntFrmEvntCnt <= (others => '0');
		IntFrmEvntCntTc_d <= '0';
	elsif (rising_edge(FrmClkDiv)) then
		if (IntFrmEquSet_d = '0' and IntFrmEnaint = '1') then
			IntFrmEvntCnt <= IntFrmEvntCnt + "01";
			IntFrmEvntCntTc_d <= IntFrmEvntCntTc;
		end if;
	end if;
end process;

IntFrmEvntCntTc <= '1' when (IntFrmEvntCnt = "1110") else '0';

AdcFrame_SlipCnt_PROCESS : process (FrmClkDiv, IntFrmClkRstint,
                                    IntFrmEvntCntTc_d, IntFrmSlipCntTc)
begin
	if (IntFrmClkRstint = '1') then
		IntFrmSlipCnt <= (others => '0');
        IntFrmSlipCntTc_d <= '0';
	elsif rising_edge(FrmClkDiv) then
		if (IntFrmEvntCntTc_d = '0') then
			IntFrmSlipCnt <= IntFrmSlipCnt + "01";
		end if;
        IntFrmSlipCntTc_d <= IntFrmSlipCntTc;
		--if (IntFrmEvntCntTc_d = High and IntFrmSlipCntTc = High) then
		--	IntFrmSlipCntTc_d <= High;
		--else
		--	IntFrmSlipCntTc_d <= Low;
		--end if;
	end if;
end process;

IntFrmSlipCntTc <= '1' when (IntFrmSlipCnt = "10000") else '0'; -- 16 or X'10'

-- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
-- Clock Enable (posedge clk).
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
SlipCntc1 : FDCE
  generic map (
    INIT => '0') -- Initial value of register ('0' or '1')
  port map (
    Q => IntFrmSlipCntTc_d1, -- Data output
    C => FrmClkDiv, -- Clock input
    CE => IntFrmSlipCntTc_d, -- Clock enable input
    CLR => IntFrmSlipCntTc_d2, -- Asynchronous clear input
    D => '1' -- Data input
  );

SlipCntc2 : FDCE
  generic map (
    INIT => '0') -- Initial value of register ('0' or '1')
  port map (
    Q => IntFrmSlipCntTc_d2, -- Data output
    C => FrmClkDiv, -- Clock input
    CE => '1', -- Clock enable input
    CLR => IntFrmClkRstint, -- Asynchronous clear input
    D => IntFrmSlipCntTc_d2Ena -- Data input
  );

-- End of FDCE_inst instantiation

IntFrmSlipCntTc_d2Ena <= IntFrmSlipCntTc_d and IntFrmSlipCntTc_d1;

-----------------------------------------------------------------------------------------------
-- WARNING EVENT COUNTER
-- When this counter issues terminal count, synchronisation was impossible for 8 times.
-----------------------------------------------------------------------------------------------
AdcFrame_WarnCnt_PROCESS : process (FrmClkDiv, IntFrmClkRstint)
begin
	if (IntFrmClkRstint = '1') then
		IntFrmWarnCnt <= (others => '0');
		IntFrmWarnCntTc_d <= '0';
	elsif (FrmClkDiv'event and FrmClkDiv = '1') then
		if (IntFrmSlipCntTc_d = '1') then
			IntFrmWarnCnt <= IntFrmWarnCnt + "01";
			IntFrmWarnCntTc_d <= IntFrmWarnCntTc;
		end if;
	end if;
end process;

IntFrmWarnCntTc <= '1' when (IntFrmWarnCnt = "110") else '0';
FrmClkSyncWarn <= IntFrmWarnCntTc_d;

GPulse: GenPulse
  Port map(Clk	=> FrmClkDiv,
        Ena		=> '1',
        SigIn	=> FrmClkReSync,
        SigOut	=> IntFrmClkReSync
         );

IntFrmReSyncOut <= IntFrmSlipCntTc_d2 or IntFrmDbleNibFnl or IntFrmClkReSync; -- or FrmClkRst;


-- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
-- Clock Enable (posedge clk).
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
ReSync : FDCE
  generic map (
    INIT => '0') -- Initial value of register ('0' or '1')
  port map (
    Q => IntFrmReSyncOut_d, -- Data output
    C => FrmClkDiv, -- Clock input
    CE => '1', -- Clock enable input
    CLR => '0', -- Asynchronous clear input
    D => IntFrmReSyncOut -- Data input
  );
  
FDCE_DONE: FDCE
  generic map (
    INIT => '0') -- Initial value of register ('0' or '1')
  port map (
    Q => IntFrmEnaint, -- Data output
    C => FrmClkDiv, -- Clock input
    CE => FrmClkEna, -- Clock enable input
    CLR => IntFrmClkRstint, -- Asynchronous clear input
    D => FrmClkDone -- Data input
  );  
-- End of FDCE_inst instantiation

IntFrmClkRstint <= FrmClkRst or IntFrmReSyncOut_d;
FrmClkReSyncOut <= IntFrmReSyncOut_d;

IntFrmClkRst <= IntFrmClkRstint;
-----------------------------------------------------------------------------------------------
-- BITSLIP STATE MACHINE.
-----------------------------------------------------------------------------------------------
AdcFrame_Bitslip_PROCESS : process (IntFrmClkRstint, FrmClkDiv)
subtype IntFrmBitSlipCase is std_logic_vector(5 downto 0);
begin
	if (IntFrmClkRstint = '1') then
		IntFrmBitSlipint <= (others => '0');
	elsif rising_edge(FrmClkDiv) then
		if (IntFrmEnaint = '1' and IntFrmEquSet_d = '0') then
			case IntFrmBitSlipCase'(IntFrmEqu_d, IntFrmEvntCntTc_d, IntFrmBitSlipint(5),
									IntFrmBitSlipint(4), IntFrmBitSlipint(3), IntFrmBitSlipint(2)) is
				when "000000" => IntFrmBitSlipint <= "000000"; -- B
				when "010000" => IntFrmBitSlipint <= "000101"; -- C Slip_p
				when "000001" => IntFrmBitSlipint <= "000100"; -- D
				when "010001" => IntFrmBitSlipint <= "001010"; -- E Slip_n
				when "000010" => IntFrmBitSlipint <= "001000"; -- F
				when "010010" => IntFrmBitSlipint <= "000101"; -- G Slip_p and goto D
				--
				when "100000" => IntFrmBitSlipint <= "000000"; -- H
				when "110000" => IntFrmBitSlipint <= "100101"; -- K Slip_p
				when "101001" => IntFrmBitSlipint <= "110000"; -- L EquSet
				when "101100" => IntFrmBitSlipint <= "110000"; -- M Halt
				--
				when "100001" => IntFrmBitSlipint <= "000100"; -- N
				when "110001" => IntFrmBitSlipint <= "101010"; -- P Slip_n
				when "101010" => IntFrmBitSlipint <= "110000"; -- R EquSet goto M
				--
				when "100010" => IntFrmBitSlipint <= "001000"; -- S
				--when "110010" => IntFrmBitSlip <= "100101"; -- T Slip_p goto L
                when "110010" => IntFrmBitSlipint <= "1001" & IntFrmSwapMux_d & not IntFrmSwapMux_d;
				--
				when others => IntFrmBitSlipint <= "110000";
			end case;
		end if;
	end if;
end process;


IntFrmBitSlip <= IntFrmBitSlipint;
FrmClkBitSlip_p <= IntFrmBitSlipint(0);
FrmClkBitSlip_n <= IntFrmBitSlipint(1);
IntFrmEquSet_d <= IntFrmBitSlipint(4);


end behavioral;