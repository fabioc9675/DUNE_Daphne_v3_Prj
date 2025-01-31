----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2025 08:29:14
-- Design Name: 
-- Module Name: AdcData - Behavioral
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

entity AdcData is
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
end AdcData;

architecture Behavioral of AdcData is

signal IntDatDone		: std_logic;
signal IntDatEna 		: std_logic;
signal IntDatSrds0Out	: std_logic_vector(7 downto 0);
signal IntDatSrds0		: std_logic_vector(7 downto 0);
signal IntDat0			: std_logic_vector(7 downto 0);
signal IntDat0Mux       : std_logic_vector(7 downto 0);
signal IntDat0Swp		: std_logic_vector(7 downto 0);
signal IntDatSwpBus     : std_logic_vector(15 downto 0);


begin


acdataDone: process(DatClkDiv, DatRst)
begin
    if (DatRst = '1') then
       IntDatDone <= '0';
   elsif rising_edge(DatClkDiv) then
       IntDatDone <= DatDone;
   end if;
end process;

IntDatEna <= '1' when (IntDatDone = '1' and DatEna = '1') else '0';

-- ISERDESE2: Input SERial/DESerializer with Bitslip
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
ISERDESE2_D0P : ISERDESE2
generic map (
DATA_RATE => "SDR", -- DDR, SDR
DATA_WIDTH => 4, -- Parallel data width (2-8,10,14)
DYN_CLKDIV_INV_EN => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
DYN_CLK_INV_EN => "FALSE", -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
-- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
INIT_Q1 => '0',
INIT_Q2 => '0',
INIT_Q3 => '0',
INIT_Q4 => '0',
INTERFACE_TYPE => "NETWORKING", -- MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
IOBDELAY => "NONE", -- NONE, BOTH, IBUF, IFD
NUM_CE => 1, -- Number of clock enables (1,2)
OFB_USED => "FALSE", -- Select OFB path (FALSE, TRUE)
SERDES_MODE => "MASTER", -- MASTER, SLAVE
-- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
SRVAL_Q1 => '0',
SRVAL_Q2 => '0',
SRVAL_Q3 => '0',
SRVAL_Q4 => '0'
)
port map (
O => Open, -- 1-bit output: Combinatorial output
-- Q1 - Q8: 1-bit (each) output: Registered data outputs
Q1 => IntDatSrds0Out(6),
Q2 => IntDatSrds0Out(4),
Q3 => IntDatSrds0Out(2),
Q4 => IntDatSrds0Out(0),
Q5 => open,
Q6 => open,
Q7 => open,
Q8 => open,
-- SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
SHIFTOUT1 => open,
SHIFTOUT2 => open,
BITSLIP => DatBitSlip_p, -- 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
-- CLKDIV when asserted (active High). Subsequently, the data seen on the
-- Q1 to Q8 output ports will shift, as in a barrel-shifter operation, one
-- position every time Bitslip is invoked (DDR operation is different from
-- SDR).
-- CE1, CE2: 1-bit (each) input: Data register clock enable inputs
CE1 => IntDatDone,
CE2 => '0',
CLKDIVP => '0', -- 1-bit input: TBD
-- Clocks: 1-bit (each) input: ISERDESE2 clock input ports
CLK => DatClk, -- 1-bit input: High-speed clock
CLKB => '0', -- 1-bit input: High-speed secondary clock
CLKDIV => DatClkDiv, -- 1-bit input: Divided clock
OCLK => '0', -- 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY"
-- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
DYNCLKSEL => '0', -- 1-bit input: Dynamic CLK/CLKB inversion
-- Input Data: 1-bit (each) input: ISERDESE2 data input ports
D => DatD0_p, -- 1-bit input: Data input
DDLY => '0', -- 1-bit input: Serial data from IDELAYE2
OFB => '0', -- 1-bit input: Data feedback from OSERDESE2
OCLKB => '0', -- 1-bit input: High speed negative edge output clock
RST => DatRst, -- 1-bit input: Active high asynchronous reset
-- SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
SHIFTIN1 => '0',
SHIFTIN2 => '0'
);



ISERDESE2_D0N : ISERDESE2
generic map (
DATA_RATE => "SDR", -- DDR, SDR
DATA_WIDTH => 4, -- Parallel data width (2-8,10,14)
DYN_CLKDIV_INV_EN => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
DYN_CLK_INV_EN => "FALSE", -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
-- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
INIT_Q1 => '0',
INIT_Q2 => '0',
INIT_Q3 => '0',
INIT_Q4 => '0',
INTERFACE_TYPE => "NETWORKING", -- MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
IOBDELAY => "NONE", -- NONE, BOTH, IBUF, IFD
NUM_CE => 1, -- Number of clock enables (1,2)
OFB_USED => "FALSE", -- Select OFB path (FALSE, TRUE)
SERDES_MODE => "MASTER", -- MASTER, SLAVE
-- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
SRVAL_Q1 => '0',
SRVAL_Q2 => '0',
SRVAL_Q3 => '0',
SRVAL_Q4 => '0'
)
port map (
O => Open, -- 1-bit output: Combinatorial output
-- Q1 - Q8: 1-bit (each) output: Registered data outputs
Q1 => IntDatSrds0Out(7),
Q2 => IntDatSrds0Out(5),
Q3 => IntDatSrds0Out(3),
Q4 => IntDatSrds0Out(1),
Q5 => open,
Q6 => open,
Q7 => open,
Q8 => open,
-- SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
SHIFTOUT1 => open,
SHIFTOUT2 => open,
BITSLIP => DatBitSlip_n, -- 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
-- CLKDIV when asserted (active High). Subsequently, the data seen on the
-- Q1 to Q8 output ports will shift, as in a barrel-shifter operation, one
-- position every time Bitslip is invoked (DDR operation is different from
-- SDR).
-- CE1, CE2: 1-bit (each) input: Data register clock enable inputs
CE1 => IntDatDone,
CE2 => '0',
CLKDIVP => '0', -- 1-bit input: TBD
-- Clocks: 1-bit (each) input: ISERDESE2 clock input ports
CLK => DatClk, -- 1-bit input: High-speed clock
CLKB => '0', -- 1-bit input: High-speed secondary clock
CLKDIV => DatClkDiv, -- 1-bit input: Divided clock
OCLK => '0', -- 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY"
-- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
DYNCLKSEL => '0', -- 1-bit input: Dynamic CLK/CLKB inversion
-- Input Data: 1-bit (each) input: ISERDESE2 data input ports
D => DatD0_n, -- 1-bit input: Data input
DDLY => '0', -- 1-bit input: Serial data from IDELAYE2
OFB => '0', -- 1-bit input: Data feedback from OSERDESE2
OCLKB => '0', -- 1-bit input: High speed negative edge output clock
RST => DatRst, -- 1-bit input: Active high asynchronous reset
-- SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
SHIFTIN1 => '0',
SHIFTIN2 => '0'
);
-- End of ISERDESE2_inst instantiation              

IntDatSrds0 <=      not IntDatSrds0Out(7) & IntDatSrds0Out(6) &
					not IntDatSrds0Out(5) & IntDatSrds0Out(4) &
					not IntDatSrds0Out(3) & IntDatSrds0Out(2) &
					not IntDatSrds0Out(1) & IntDatSrds0Out(0);
					
DatReg : for n in 7 downto 0 generate
   -- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
   -- Clock Enable (posedge clk).
   -- 7 Series
   -- Xilinx HDL Libraries Guide, version 14.7
   FDCE_inst_Reg0 : FDCE
      generic map (
        INIT => '0') -- Initial value of register ('0' or '1')
      port map (
        Q => IntDat0(n), -- Data output
        C => DatClkDiv, -- Clock input
        CE => IntDatEna, -- Clock enable input
        CLR => DatReSync, -- Asynchronous clear input
        D => IntDatSrds0(n) -- Data input
        );
end generate DatReg;        
        
-- End of FDCE_inst instantiation					

IntDat0Mux(7) <= IntDat0(6)     when (DatSwapMux = '1') else IntDat0(7);
IntDat0Mux(6) <= IntDat0(7)     when (DatSwapMux = '1') else IntDat0(6);
IntDat0Mux(5) <= IntDat0(4)     when (DatSwapMux = '1') else IntDat0(5);
IntDat0Mux(4) <= IntDat0(5)     when (DatSwapMux = '1') else IntDat0(4);
IntDat0Mux(3) <= IntDat0(2)     when (DatSwapMux = '1') else IntDat0(3);
IntDat0Mux(2) <= IntDat0(3)     when (DatSwapMux = '1') else IntDat0(2);
IntDat0Mux(1) <= IntDat0(0)     when (DatSwapMux = '1') else IntDat0(1);
IntDat0Mux(0) <= IntDat0(1)     when (DatSwapMux = '1') else IntDat0(0);

DatReg1: for n in 7 downto 0 generate
   -- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
   -- Clock Enable (posedge clk).
   -- 7 Series
   -- Xilinx HDL Libraries Guide, version 14.7
   FDCE_inst_Reg1 : FDCE
      generic map (
        INIT => '0') -- Initial value of register ('0' or '1')
      port map (
        Q => IntDat0Swp(n), -- Data output
        C => DatClkDiv, -- Clock input
        CE => IntDatEna, -- Clock enable input
        CLR => DatReSync, -- Asynchronous clear input
        D => IntDat0Mux(n) -- Data input
        ); 
end generate DatReg1;


gen_1_Msb: if C_AdcMsbOrLsbFst = 0 generate
    DatOut <= IntDat0Swp(7 downto 0) & IntDat0Swp(7 downto 0);    
end generate gen_1_Msb;
gen_1_Lsb : if C_AdcMsbOrLsbFst = 1 generate
    DatOut <=               IntDat0Swp(0) & IntDat0Swp(1) & IntDat0Swp(2) & IntDat0Swp(3) &
                            IntDat0Swp(4) & IntDat0Swp(5) & IntDat0Swp(6) & IntDat0Swp(7) &
                            IntDat0Swp(0) & IntDat0Swp(1) & IntDat0Swp(2) & IntDat0Swp(3) &
                            IntDat0Swp(4) & IntDat0Swp(5) & IntDat0Swp(6) & IntDat0Swp(7); 
end generate gen_1_Lsb;    
end Behavioral;
