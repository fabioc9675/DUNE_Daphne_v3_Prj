----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2025 08:36:46
-- Design Name: 
-- Module Name: DoubleNibbleDetect - Behavioral
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

entity DoubleNibbleDetect is
  Port (CLK           : in std_logic; 
        RST           : in std_logic;
        DataIn        : in std_logic_vector(3  downto 0);
        DataOut       : out std_logic_vector(3  downto 0);
        Final         : out std_logic
        );
end DoubleNibbleDetect;

architecture Behavioral of DoubleNibbleDetect is

component GenEquCntProcess is
  Port (Clk            : in std_logic; 
        IntEqu         : in std_logic;
        IntRstIn_d     : in std_logic;
        IntEquCnt_d    : out std_logic_vector(3 downto 0)
  );
end  component;

component GenSlipCnt is
  Port (clk                : in std_logic;
        IntPulse           : in std_logic;
        IntEqu             : in std_logic;
        IntRstIn_d         : in std_logic;
        IntEqu_d           : out std_logic;
        IntSlipCnt_d       : out std_logic_vector(3 downto 0) );
end component;

component Compare is
  Port (DataIn                 : in std_logic_vector(3 downto 0);
        IntRegOutIn_s          : in std_logic_vector(3 downto 0);
        IntEqu                 : out std_logic
     );
end component;

component GenerateSRLAddress is
 Port (IntEquCnt_d                    : in std_logic_vector(3 downto 0);
       IntSlipCnt_d                   : in std_logic_vector(3 downto 0);
       IntPulse                       : in std_logic;
       IntRstSet                      : out std_logic;
       IntAddr                        : out std_logic_vector(4 downto 0) 
       );
end component;

signal IntRstSet        : std_logic;
signal IntRstFf_d       : std_logic_vector(7 downto 0) := X"00";
signal IntRegOutIn_s    : std_logic_vector(3 downto 0);
signal IntSrlOut_s      : std_logic_vector(3 downto 0);
signal IntEquCnt_d      : std_logic_vector(3 downto 0);
signal IntSlipCnt_d     : std_logic_vector(3 downto 0);
signal IntAddr          : std_logic_vector(4 downto 0);
signal IntEqu           : std_logic;
signal IntPulse         : std_logic;
signal IntEqu_d         : std_logic;
signal IntSlipCntRst    : std_logic;
signal IntSlipCnt       : std_logic_vector(3 downto 0);
signal IntEquCnt        : std_logic_vector(3 downto 0);
signal IntRstIn         : std_logic;

begin


IntRstIn <= RST or IntRstSet;
-- FDSE: Single Data Rate D Flip-Flop with Synchronous Set and
-- Clock Enable (posedge clk).
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
DbleNibl_I_FDS0 : FDSE
generic map (
INIT => '0') -- Initial value of register ('0' or '1')
port map (
Q => IntRstFf_d(0), -- Data output
C => CLK, -- Clock input
CE => '1', -- Clock enable input
S => IntRstSet, -- Synchronous Set input
D => '0' -- Data input
);
-- End of FDSE_inst instantiation


Gen_rst: for n in 1 to 5 generate
   -- FDSE: Single Data Rate D Flip-Flop with Synchronous Set and
   -- Clock Enable (posedge clk).
   -- 7 Series
   -- Xilinx HDL Libraries Guide, version 14.7
   DbleNibl_I_FDSN : FDSE
     generic map (
        INIT => '0') -- Initial value of register ('0' or '1')
     port map (
        Q => IntRstFf_d(n), -- Data output
        C => CLK, -- Clock input
        CE => '1', -- Clock enable input
        S => IntRstSet, -- Synchronous Set input
        D => IntRstFf_d(n-1) -- Data input
     );
   -- End of FDSE_inst instantiation
end generate Gen_rst;   

Gen_rst_6_7: for n in 6 to 7 generate
   -- FDSE: Single Data Rate D Flip-Flop with Synchronous Set and
   -- Clock Enable (posedge clk).
   -- 7 Series
   -- Xilinx HDL Libraries Guide, version 14.7
   DbleNibl_I_FDSN : FDSE
     generic map (
        INIT => '0') -- Initial value of register ('0' or '1')
     port map (
        Q => IntRstFf_d(n), -- Data output
        C => CLK, -- Clock input
        CE => '1', -- Clock enable input
        S => IntRstIn, -- Synchronous Set input
        D => IntRstFf_d(n-1) -- Data input
     );
   -- End of FDSE_inst instantiation
end generate Gen_rst_6_7;

gen_reg: for n in 3 downto 0 generate
   -- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
   -- Clock Enable (posedge clk).
   -- 7 Series
   -- Xilinx HDL Libraries Guide, version 14.7
   FDCE_instN : FDCE
       generic map (
          INIT => '0') -- Initial value of register ('0' or '1')
       port map (
          Q => IntRegOutIn_s(n), -- Data output
          C => Clk, -- Clock input
          CE => '1', -- Clock enable input
          CLR => IntRstFf_d(7), -- Asynchronous clear input
          D => DataIn(n) -- Data input
       );
   -- End of FDCE_inst instantiation
   
   
   -- SRLC32E: 32-bit variable length shift register LUT
   -- with clock enable (Mapped to a SliceM LUT6)
   -- 7 Series
   -- Xilinx HDL Libraries Guide, version 14.7
   SRLC32E_instN : SRLC32E
      generic map (
         INIT => X"00000000")
      port map (
         Q => IntSrlOut_s(n), -- SRL data output
         Q31 => open, -- SRL cascade output pin
         A => IntAddr, -- 5-bit shift depth select input
         CE => '1', -- Clock enable input
         CLK => CLK, -- Clock input
         D => IntRegOutIn_s(n) -- SRL data input
       );
   -- End of SRLC32E_inst instantiation
   
   
   -- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
   -- Clock Enable (posedge clk).
   -- 7 Series
   -- Xilinx HDL Libraries Guide, version 14.7
   OUT_FDCE_instN : FDCE
       generic map (
          INIT => '0') -- Initial value of register ('0' or '1')
       port map (
          Q => DataOut(n), -- Data output
          C => Clk, -- Clock input
          CE => '1', -- Clock enable input
          CLR => IntRstFf_d(7), -- Asynchronous clear input
          D => IntSrlOut_s(n) -- Data input
       );
   -- End of FDCE_inst instantiation
   
end generate gen_reg;  


---------------------------------------------------------------------------------------------
-- Compare present and past for equality.
---------------------------------------------------------------------------------------------

comparepresent: Compare 
  Port map(DataIn  => DataIn,
        IntRegOutIn_s  =>  IntRegOutIn_s,
        IntEqu       => IntEqu
     );

-----------------------------------------------------------------------------------------------
-- Generate the SRL addresses
---------------------------------------------------------------------------------------------

Generate_SRL: GenerateSRLAddress 
 Port map(IntEquCnt_d => IntEquCnt_d,
       IntSlipCnt_d => IntSlipCnt_d,
       IntPulse     => IntPulse,
       IntRstSet    => IntRstSet,
       IntAddr      => IntAddr 
       );


Final <= IntRstSet; 

---------------------------------------------------------------------------------------------
-- Equal/Double nibble detect counters
---------------------------------------------------------------------------------------------
IntPulse <= IntEqu or IntEqu_d;  

genslipcntrst: GenSlipCnt 
  Port map (clk   => clk,
        IntPulse  => IntPulse,
        IntEqu    => IntEqu,
        IntRstIn_d  =>  IntRstFf_d(7),
        IntEqu_d    => IntEqu_d,
        IntSlipCnt_d  => IntSlipCnt_d
         );

GenEQU: GenEquCntProcess
  Port map (Clk => CLK, 
        IntEqu  => IntEqu,
        IntRstIn_d => IntRstFf_d(7),
        IntEquCnt_d  => IntEquCnt_d
  );


end Behavioral;
