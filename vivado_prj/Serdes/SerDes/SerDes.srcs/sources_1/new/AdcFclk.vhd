----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.01.2025 09:44:22
-- Design Name: 
-- Module Name: AdcFclk - Behavioral
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

Library UNISIM;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use UNISIM.vcomponents.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AdcFclk is
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
end AdcFclk;

architecture Behavioral of AdcFclk is

component FCLKNeededBits is
  Port ( FrmClkDiv                : in std_logic;
         IntFrmClkRst             : in std_logic;
         IntFrmSrdsOut            : in std_logic_vector(7 downto 0);
         IntFrmDbleNibFnl         : out std_logic;
         IntFrmSrdsDat            : out std_logic_vector(7 downto 0)
        );
end component;

component GenDataReg is
  Port ( FrmClkDiv                    : in std_logic;
         IntFrmEna                    : in std_logic;                     
         IntFrmClkRst                 : in std_logic;
         IntFrmSwapMux_d              : in std_logic;
         IntFrmMsbRegEna_d            : in std_logic;
         IntFrmLsbRegEna_d            : in std_logic;
         IntFrmSrdsDat                : in std_logic_vector(7 downto 0);
         FrmClkDat		              : out std_logic_vector(15 downto 0)
         );
end component;

component DatReg is
  Port (FrmClkDiv                    : in std_logic;
        IntFrmClkRst                 : in std_logic;
        IntFrmEna                    : in std_logic; 
        IntFrmSrdsDat                : in std_logic_vector(7 downto 0);
        IntFrmEqu_d                  : out std_logic;
        IntFrmMsbRegEna_d            : out std_logic;
        IntFrmLsbRegEna_d            : out std_logic;
        IntFrmSwapMux_d              : out std_logic
       );
end component;

component  SampleEventCounter is
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
end component;

signal IntFrmSrdsOut                : std_logic_vector(7 downto 0);
signal IntFrmBitSlip		        : std_logic_vector(5 downto 0);
signal IntFrmEna			        : std_logic;
signal IntFrmClkRst			        : std_logic; 
signal IntFrmDbleNibFnl		        : std_logic;
signal IntFrmSrdsDat                : std_logic_vector(7 downto 0);
signal IntFrmSwapMux_d		        : std_logic;
signal IntFrmMsbRegEna_d	        : std_logic;
signal IntFrmLsbRegEna_d	        : std_logic;
signal IntFrmEqu_d			        : std_logic;

begin

-- ISERDESE2: Input SERial/DESerializer with Bitslip
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
ISERDESE2_inst_p : ISERDESE2
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
O => open, -- 1-bit output: Combinatorial output
-- Q1 - Q8: 1-bit (each) output: Registered data outputs
Q1 => IntFrmSrdsOut(6),
Q2 => IntFrmSrdsOut(4),
Q3 => IntFrmSrdsOut(2),
Q4 => IntFrmSrdsOut(0),
Q5 => open,
Q6 => open,
Q7 => open,
Q8 => open,
-- SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
SHIFTOUT1 => open,
SHIFTOUT2 => open,
BITSLIP => IntFrmBitSlip(0), -- 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
-- CLKDIV when asserted (active High). Subsequently, the data seen on the
-- Q1 to Q8 output ports will shift, as in a barrel-shifter operation, one
-- position every time Bitslip is invoked (DDR operation is different from
-- SDR).
-- CE1, CE2: 1-bit (each) input: Data register clock enable inputs
CE1 => IntFrmEna,
CE2 => '0',
CLKDIVP => '0', -- 1-bit input: TBD
-- Clocks: 1-bit (each) input: ISERDESE2 clock input ports
CLK => FrmClk, -- 1-bit input: High-speed clock
CLKB => '0', -- 1-bit input: High-speed secondary clock
CLKDIV => FrmClkDiv, -- 1-bit input: Divided clock
OCLK => '0', -- 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY"
-- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
DYNCLKSEL => '0', -- 1-bit input: Dynamic CLK/CLKB inversion
-- Input Data: 1-bit (each) input: ISERDESE2 data input ports
D => Fclk_P, -- 1-bit input: Data input
DDLY => '0', -- 1-bit input: Serial data from IDELAYE2
OFB => '0', -- 1-bit input: Data feedback from OSERDESE2
OCLKB => '0', -- 1-bit input: High speed negative edge output clock
RST => IntFrmClkRst, -- 1-bit input: Active high asynchronous reset
-- SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
SHIFTIN1 => '0',
SHIFTIN2 => '0'
);
-- End of ISERDESE2_inst instantiation





-- ISERDESE2: Input SERial/DESerializer with Bitslip
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
ISERDESE2_inst_n : ISERDESE2
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
O => open, -- 1-bit output: Combinatorial output
-- Q1 - Q8: 1-bit (each) output: Registered data outputs
Q1 => IntFrmSrdsOut(7),
Q2 => IntFrmSrdsOut(5),
Q3 => IntFrmSrdsOut(3),
Q4 => IntFrmSrdsOut(1),
Q5 => open,
Q6 => open,
Q7 => open,
Q8 => open,
-- SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
SHIFTOUT1 => open,
SHIFTOUT2 => open,
BITSLIP => IntFrmBitSlip(1), -- 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
-- CLKDIV when asserted (active High). Subsequently, the data seen on the
-- Q1 to Q8 output ports will shift, as in a barrel-shifter operation, one
-- position every time Bitslip is invoked (DDR operation is different from
-- SDR).
-- CE1, CE2: 1-bit (each) input: Data register clock enable inputs
CE1 => IntFrmEna,
CE2 => '0',
CLKDIVP => '0', -- 1-bit input: TBD
-- Clocks: 1-bit (each) input: ISERDESE2 clock input ports
CLK => FrmClk, -- 1-bit input: High-speed clock
CLKB => '0', -- 1-bit input: High-speed secondary clock
CLKDIV => FrmClkDiv, -- 1-bit input: Divided clock
OCLK => '0', -- 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY"
-- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
DYNCLKSEL => '0', -- 1-bit input: Dynamic CLK/CLKB inversion
-- Input Data: 1-bit (each) input: ISERDESE2 data input ports
D => Fclk_N, -- 1-bit input: Data input
DDLY => '0', -- 1-bit input: Serial data from IDELAYE2
OFB => '0', -- 1-bit input: Data feedback from OSERDESE2
OCLKB => '0', -- 1-bit input: High speed negative edge output clock
RST => IntFrmClkRst, -- 1-bit input: Active high asynchronous reset
-- SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
SHIFTIN1 => '0',
SHIFTIN2 => '0'
);
-- End of ISERDESE2_inst instantiation

dbdlNibble:FCLKNeededBits
  Port map( FrmClkDiv => FrmClkDiv,
         IntFrmClkRst => IntFrmClkRst,
         IntFrmSrdsOut => IntFrmSrdsOut,
         IntFrmDbleNibFnl => IntFrmDbleNibFnl,
         IntFrmSrdsDat => IntFrmSrdsDat
        );
        
GenDatReg_P: GenDataReg 
  Port map( FrmClkDiv    => FrmClkDiv,
         IntFrmEna       => IntFrmEna,                     
         IntFrmClkRst    => IntFrmClkRst,
         IntFrmSwapMux_d  => IntFrmSwapMux_d,
         IntFrmMsbRegEna_d  => IntFrmMsbRegEna_d,
         IntFrmLsbRegEna_d  => IntFrmLsbRegEna_d,
         IntFrmSrdsDat      => IntFrmSrdsDat,
         FrmClkDat		    => FrmClkDat
         );
         
FrameCmpPattern: DatReg 
  Port map(FrmClkDiv  => FrmClkDiv,
        IntFrmClkRst  => IntFrmClkRst,
        IntFrmEna     => IntFrmEna, 
        IntFrmSrdsDat => IntFrmSrdsDat,
        IntFrmEqu_d   => IntFrmEqu_d,
        IntFrmMsbRegEna_d  => IntFrmMsbRegEna_d,
        IntFrmLsbRegEna_d  => IntFrmLsbRegEna_d,
        IntFrmSwapMux_d    => IntFrmSwapMux_d
       );
         
FrmClkMsbRegEna <= IntFrmMsbRegEna_d;
FrmClkLsbRegEna <= IntFrmLsbRegEna_d;       
FrmClkSwapMux	<= IntFrmSwapMux_d;


Sample_Evnt_Cnt: SampleEventCounter
  Port map(FrmClkDiv      => FrmClkDiv,
        FrmClkDone		  => FrmClkDone,		-- Input from clock syncronisation.
        FrmClkEna		  => FrmClkEna,
        FrmClkRst         => FrmClkRst,  
        FrmClkReSync	  => FrmClkReSync,
        IntFrmDbleNibFnl  => IntFrmDbleNibFnl,
        IntFrmEqu_d       => IntFrmEqu_d,
        IntFrmSwapMux_d   => IntFrmSwapMux_d,
        IntFrmBitSlip     => IntFrmBitSlip,
        IntFrmClkRst      => IntFrmClkRst,
        FrmClkBitSlip_p	  => FrmClkBitSlip_p,
        FrmClkBitSlip_n	  => FrmClkBitSlip_n,
        FrmClkReSyncOut	  => FrmClkReSyncOut,
        FrmClkSyncWarn	  => FrmClkSyncWarn,
        IntFrmEna         => IntFrmEna
   );


end Behavioral;
