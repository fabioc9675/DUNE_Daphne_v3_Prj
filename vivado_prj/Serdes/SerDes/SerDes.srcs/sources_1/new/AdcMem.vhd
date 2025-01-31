----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2025 15:31:55
-- Design Name: 
-- Module Name: AdcMem - Behavioral
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
library UNISIM;
use UNISIM.vcomponents.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AdcMem is
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
end AdcMem;

architecture Behavioral of AdcMem is

component Cnt_5b_Bin is
  Port (CntClk	: in std_logic;
		CntEna	: in std_logic;
		CntRst	: in std_logic;
		CntOut	: out std_logic_vector(4 downto 0);
		CntTc	: out std_logic
		 );
end component;

component FDRSE is
  Port (D     : in std_logic;
		CE    : in std_logic;
        C     : in std_logic;
        S     : in std_logic;
		R     : in std_logic;
		Q     : out std_logic
          );
end component;

signal IntWrAddr		: std_logic_vector(4 downto 0);
signal IntRdAddr		: std_logic_vector(4 downto 0);
signal IntRamToFf		: std_logic_vector(15 downto 0);
signal IntFlags			: std_logic_vector(3 downto 0);

begin

Gen_1: for n in 15 downto 0 generate
  -- RAM32X1D: 32 x 1 positive edge write, asynchronous read
  -- dual-port distributed RAM (Mapped to SliceM LUT6)
  -- 7 Series
  -- Xilinx HDL Libraries Guide, version 14.7
  AdcMem_I_ram64x1d: RAM32X1D
  generic map (
    INIT => X"00000000") -- Initial contents of RAM
  port map (
    DPO => IntRamToFf(n), -- Read-only 1-bit data output
    SPO => open, -- R/W 1-bit data output
    A0 => IntWrAddr(0), -- R/W address[0] input bit
    A1 => IntWrAddr(1), -- R/W address[1] input bit
    A2 => IntWrAddr(2), -- R/W address[2] input bit
    A3 => IntWrAddr(3), -- R/W address[3] input bit
    A4 => IntWrAddr(4), -- R/W address[4] input bit
    D => DatIn(n), -- Write 1-bit data input
    DPRA0 => IntRdAddr(0), -- Read-only address[0] input bit
    DPRA1 => IntRdAddr(1), -- Read-only address[1] input bit
    DPRA2 => IntRdAddr(2), -- Read-only address[2] input bit
    DPRA3 => IntRdAddr(3), -- Read-only address[3] input bit
    DPRA4 => IntRdAddr(4), -- Read-only address[4] input bit
    WCLK => ClkIn, -- Write clock input
    WE => '1' -- Write enable input
   );
   -- End of RAM32X1D_inst instantiation
   
   -- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
   -- Clock Enable (posedge clk).
   -- 7 Series
   -- Xilinx HDL Libraries Guide, version 14.7
   AdcMemFDCE_inst : FDCE
     generic map (
        INIT => '0') -- Initial value of register ('0' or '1')
     port map (
        Q => DatOut(n), -- Data output
        C => ClkOut, -- Clock input
        CE => EnaOut, -- Clock enable input
        CLR => RstOut, -- Asynchronous clear input
         D =>IntRamToFf(n) -- Data input
    );
     -- End of FDCE_inst instantiation
end generate Gen_1;


WrAddrCnt : Cnt_5b_Bin 
  Port map (CntClk	=> ClkIn,
		CntEna	=> EnaIn,
		CntRst	=> RstIn,
		CntOut	=> IntWrAddr,
		CntTc	=> open
		 );
		 
		     
RdAddrCnt : Cnt_5b_Bin 
  Port map (CntClk	=> ClkOut,
		CntEna	=> EnaOut,
		CntRst	=> RstOut,
		CntOut	=> IntRdAddr,
		CntTc	=> open
		 );
		     
------------------------------------------------------------------------------------------------
-- Flags.
-- Four write flags are decoded
--		memory is filled between empty and 1/4 = IntFlag(0) -- Empty
--		memory is filled between 1/4 and 1/2 = IntFlag(1) -- Low Half
--		memory is filled between 1/2 and 3/4 = IntFlag(2) -- High Half
--		memory is filled between 3/4 and Full = IntFlag(3) -- Full
-- The flags are registered at the read or application clock for signalling to the application
-- Interface. One flag is used as auto-enable of the read counter.
-- This flag can be any flag, but here is chosen to register the Low and High flags
-- so that a natural spread and fill of the memory occurs.
-----------------------------------------------------------------------------------------------
-- Full
	IntFlags(3) <=	'1' when IntWrAddr(4 downto 3) = "11" and IntRdAddr(4 downto 3) = "00" else
					'1' when IntWrAddr(4 downto 3) = "10" and IntRdAddr(4 downto 3) = "11" else
					'1' when IntWrAddr(4 downto 3) = "01" and IntRdAddr(4 downto 3) = "10" else
					'1' when IntWrAddr(4 downto 3) = "00" and IntRdAddr(4 downto 3) = "01" else
					'0';
-- High Half
	IntFlags(2) <=	'1' when IntWrAddr(4 downto 3) = "11" and IntRdAddr(4 downto 3) = "01" else
					'1' when IntWrAddr(4 downto 3) = "10" and IntRdAddr(4 downto 3) = "00" else
					'1' when IntWrAddr(4 downto 3) = "01" and IntRdAddr(4 downto 3) = "11" else
					'1' when IntWrAddr(4 downto 3) = "00" and IntRdAddr(4 downto 3) = "10" else
					'0';
-- Low half
	IntFlags(1) <=	'1' when IntWrAddr(4 downto 3) = "11" and IntRdAddr(4 downto 3) = "10" else
					'1' when IntWrAddr(4 downto 3) = "10" and IntRdAddr(4 downto 3) = "01" else
					'1' when IntWrAddr(4 downto 3) = "01" and IntRdAddr(4 downto 3) = "00" else
					'1' when IntWrAddr(4 downto 3) = "00" and IntRdAddr(4 downto 3) = "11" else
					'0';
-- Empty
	IntFlags(0) <=	'1' when IntWrAddr(4 downto 3) = "11" and IntRdAddr(4 downto 3) = "11" else
					'1' when IntWrAddr(4 downto 3) = "10" and IntRdAddr(4 downto 3) = "10" else
					'1' when IntWrAddr(4 downto 3) = "01" and IntRdAddr(4 downto 3) = "01" else
					'1' when IntWrAddr(4 downto 3) = "00" and IntRdAddr(4 downto 3) = "00" else
					'0'; 
					
Flags <= Intflags;					   

Fdrs_E: FDRSE 
  Port map(D  => '0',
		CE    => '0',
        C     => ClkOut,
        S     => IntFlags(0),
		R     => IntFlags(3),
		Q     => Empty
          );


Fdrs_F: FDRSE 
  Port map(D  => '0',
		CE    => '0',
        C     => ClkIn,
        S     => IntFlags(3),
		R     => IntFlags(0),
		Q     => Full
          );

    
end Behavioral;
