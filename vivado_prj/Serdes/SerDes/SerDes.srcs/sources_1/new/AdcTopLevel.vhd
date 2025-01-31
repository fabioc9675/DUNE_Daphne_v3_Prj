----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.01.2025 11:15:02
-- Design Name: 
-- Module Name: AdcTopLevel - Behavioral
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

entity AdcTopLevel is
   Port (DCLK_P             : in std_logic; 
         DCLK_N             : in std_logic;
         FCLK_p	            : in std_logic;
		 FCLK_n	            : in std_logic;
		 DATA_p	            : in std_logic;
		 DATA_n	            : in std_logic;
         AdcMemClk          : in std_logic; -- Application clock
         AdcMemRst		    : in std_logic; -- Application reset
         AdcMemEna          : in std_logic; -- Application Enable
         AdcMemFlags        : out std_logic_vector(3 downto 0);
         AdcReSync          : in std_logic;
         SysRefClk          : in std_logic;		-- 200 MHz for IODELAYCTRL from application
         AdcIntrfcRst       : in std_logic;
         AdcIntrfcEna       : in std_logic;
         AdcMemEmpty        : out std_logic;
         AdcMemFull         : out std_logic;
         AdcFrmSyncWrn      : out std_logic;
         AdcBitClkDone      : out std_logic;
         AdcBitClkAlgnWrn   : out std_logic;
         AdcBitClkInvrtd    : out std_logic;
		 AdcIdlyCtrlRdy     : out std_logic;
		 AdcMemDataOut      : out std_logic_vector(15 downto 0);
		 AdcFrmDataOut      : out std_logic_vector(15 downto 0)
          );
end AdcTopLevel;

architecture Behavioral of AdcTopLevel is

component BitClockIn_DCLK is
  Port (BitClkRst   : in std_logic;
        BitClkReSync		: in std_logic;
        BitClkEna   : in std_logic;
        DCLK_P    : in std_logic; 
        DCLK_N    : in std_logic;
        INTClkOut           : out std_logic;
        INTCLKDivOut        : out std_logic; 
        BitClkInvrtd		: out std_logic;
        BitClkAlignWarn 	: out std_logic;
        BitClkDone          : out std_logic);
end component;

component AdcFclk is
    Port ( FrmClk			: in std_logic;
           FrmClkRst		: in std_logic;
           FrmClkDiv		: in std_logic;
           Fclk_N           : in STD_LOGIC;
           Fclk_P           : in STD_LOGIC;
           FrmClkReSync	    : in std_logic;
           FrmClkDone		: in std_logic;		-- Input from clock syncronisation.
           FrmClkEna		: in std_logic;
           FrmClkBitSlip_p	: out std_logic;
           FrmClkBitSlip_n	: out std_logic;
           FrmClkMsbRegEna	: out std_logic;
           FrmClkLsbRegEna	: out std_logic;
           FrmClkReSyncOut	: out std_logic;
           FrmClkSwapMux	: out std_logic;
           FrmClkSyncWarn	: out std_logic;
           FrmClkDat		: out std_logic_vector(15 downto 0)
           );
end component;

component AdcData is
  generic(C_AdcMsbOrLsbFst	: integer := 0
          );     -- 0 = MSB first, 1 = LSB first
  Port (DatD0_n			: in std_logic;
		DatD0_p			: in std_logic;
		DatSwapMux		: in std_logic;
		DatReSync		: in std_logic;
		DatClk			: in std_logic;
        DatClkDiv		: in std_logic;
        DatEna			: in std_logic;
		DatRst			: in std_logic;
		DatBitSlip_p	: in std_logic;
        DatBitSlip_n	: in std_logic;
        DatDone			: in std_logic;
        DatOut			: out std_logic_vector(15 downto 0)
        );
end component;

component AdcMem is
  Port (ClkIn	: in std_logic;
       ClkOut	: in std_logic;
       EnaIn	: in std_logic;
       RstIn	: in std_logic;
       EnaOut	: in std_logic;
       RstOut	: in std_logic;
       DatIn	: in std_logic_vector(15 downto 0);
       Flags	: out std_logic_vector(3 downto 0);
       Empty    : out std_logic;
       Full     : out std_logic;
       DatOut	: out std_logic_vector(15 downto 0) 
        );
end component;



signal IntClk				: std_logic;
signal IntClkDiv			: std_logic;
signal IntRst				: std_logic;
signal IntEna_d				: std_logic;
signal IntEna				: std_logic;
signal IntBitClkDone		: std_logic;
signal IntClkBitSlip_p		: std_logic;
signal IntClkBitSlip_n		: std_logic;
signal IntClkMsbRegEna		: std_logic;
signal IntClkLsbRegEna		: std_logic;
signal IntFrmClkReSyncOut	: std_logic;
signal IntClkSwapMux		: std_logic;
signal IntDataOut 			: std_logic_vector(15 downto 0);

begin

-- IDELAYCTRL: IDELAYE2/ODELAYE2 Tap Delay Value Control
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
idlyctrl: IDELAYCTRL
   port map (
     RDY => AdcIdlyCtrlRdy, -- 1-bit output: Ready output
     REFCLK => SysRefClk, -- 1-bit input: Reference clock input
     RST => AdcIntrfcRst -- 1-bit input: Active high reset input
   );
-- End of IDELAYCTRL_inst instantiation


-- FDPE: Single Data Rate D Flip-Flop with Asynchronous Preset and
-- Clock Enable (posedge clk).
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
FDPE_RST : FDPE
  generic map (
    INIT => '0') -- Initial value of register ('0' or '1')
  port map (
    Q => IntRst, -- Data output
    C => IntClkDiv, -- Clock input
    CE => '1', -- Clock enable input
    PRE => AdcIntrfcRst, -- Asynchronous preset input
    D => '0' -- Data input
);
-- End of FDPE_inst instantiation

-- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
-- Clock Enable (posedge clk).
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
FDCE_ENA_0 : FDCE
  generic map (
    INIT => '0') -- Initial value of register ('0' or '1')
  port map (
    Q => IntEna_d, -- Data output
    C => IntClkDiv, -- Clock input
    CE => AdcIntrfcEna, -- Clock enable input
    CLR => IntRst, -- Asynchronous clear input
    D => '1' -- Data input
);


FDCE_ENA_1 : FDCE
  generic map (
    INIT => '0') -- Initial value of register ('0' or '1')
  port map (
    Q => IntEna, -- Data output
    C => IntClkDiv, -- Clock input
    CE => '1', -- Clock enable input
    CLR => IntRst, -- Asynchronous clear input
    D => IntEna_d -- Data input
);
-----------------------------------------------------------------------------------------------
-- C_AdcChnls		= c
-- C_AdcWireInt		= w
-- C_AdcBits		= b
-----------------------------------------------------------------------------------------------
-- BIT CLOCK
-- IntClk and IntClkDiv are the clock to be used in the interface.
-----------------------------------------------------------------------------------------------
-- There is no IBUFGDS used on this level of the design.
-- The IBUFGDS can be found in the AdcIo level or in the AdcToplevel_Toplevel.
-- That is this the reason why the DCLK_n is not used here.
-- At the AdcIo level the DCLK_n output is connected to GND.
-- Vivado complains about this with this message:
--    [Synth 8-3331] design AdcToplevel has unconnected port DCLK_n


bitclk_0: BitClockIn_DCLK 
  Port map(BitClkRst    => IntRst,
        BitClkReSync	=> AdcReSync,
        BitClkEna       => IntEna,
        DCLK_P          => DCLK_P, 
        DCLK_N          => DCLK_N,
        INTClkOut       => IntClk,
        INTCLKDivOut    => IntClkDiv, 
        BitClkInvrtd	=> AdcBitClkInvrtd,
        BitClkAlignWarn => AdcBitClkAlgnWrn,
        BitClkDone      => IntBitClkDone	-- out Enables the AdcFrame block.   
        );
        
AdcBitClkDone <= IntBitClkDone; 

Frame : AdcFclk 
    Port map ( FrmClk		=> IntClk,
           FrmClkRst		=> IntRst,
           FrmClkDiv		=> IntClkDiv,
           Fclk_N           => FCLK_n,			-- in input n from IBUFDS_DIFF_OUT 
           Fclk_P           => FCLK_p,			-- in input p from IBUFDS_DIFF_OUT      
           FrmClkReSync	    => AdcReSync,
           FrmClkDone		=> IntBitClkDone,	-- in From AdcClock done.
           FrmClkEna		=> IntEna,
           FrmClkBitSlip_p	=> IntClkBitSlip_p,
           FrmClkBitSlip_n	=> IntClkBitSlip_n,
           FrmClkMsbRegEna	=> IntClkMsbRegEna,
           FrmClkLsbRegEna	=> IntClkLsbRegEna,
           FrmClkReSyncOut	=> IntFrmClkReSyncOut,
           FrmClkSwapMux	=> IntClkSwapMux,
           FrmClkSyncWarn	=> AdcFrmSyncWrn,
           FrmClkDat		=> AdcFrmDataOut
           ); 



dataAdc : AdcData 
  generic map(C_AdcMsbOrLsbFst	=> 0
          )     -- 0 = MSB first, 1 = LSB first
  Port map (DatD0_n			=> DATA_p,
		DatD0_p			    => DATA_n,
		DatSwapMux		    => IntClkSwapMux,
		DatReSync		    => IntFrmClkReSyncOut,
		DatClk			    => IntClk,
        DatClkDiv		    => IntClkDiv,
        DatEna			    => IntEna,
		DatRst			    => IntRst,
		DatBitSlip_p	    => IntClkBitSlip_p,
        DatBitSlip_n	    => IntClkBitSlip_n,
        DatDone			    => IntBitClkDone,
        DatOut			    => IntDataOut
        );

MemAdc: AdcMem
  Port map(ClkIn	=> IntClkDiv,
       ClkOut	    => AdcMemClk,
       EnaIn	    => IntEna,
       RstIn	    => IntRst,
       EnaOut	    => AdcMemEna,
       RstOut	    => AdcMemRst,
       DatIn	    => IntDataOut,
       Flags	    => AdcMemFlags,
       Empty        => AdcMemEmpty,
       Full         => AdcMemFull,
       DatOut	    => AdcMemDataOut 
        );


end Behavioral;
