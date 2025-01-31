----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 12:27:30
-- Design Name: 
-- Module Name: GenDataReg - Behavioral
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

entity GenDataReg is
  Port ( FrmClkDiv                    : in std_logic;
         IntFrmEna                    : in std_logic;                     
         IntFrmClkRst                 : in std_logic;
         IntFrmSwapMux_d              : in std_logic;
         IntFrmMsbRegEna_d            : in std_logic;
         IntFrmLsbRegEna_d            : in std_logic;
         IntFrmSrdsDat                : in std_logic_vector(7 downto 0);
         FrmClkDat		              : out std_logic_vector(15 downto 0)
         );
end GenDataReg;

architecture Behavioral of GenDataReg is

signal IntFrmDat			        : std_logic_vector(7 downto 0);
signal IntFrmDatMux                 : std_logic_vector(7 downto 0);
signal IntFrmDatSwp			        : std_logic_vector(7 downto 0);
signal IntFrmDatSwpBus              : std_logic_vector(15 downto 0);
begin

gen_datReg: for n in 7 downto 0 generate
    -- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
    -- Clock Enable (posedge clk).
    -- 7 Series
    -- Xilinx HDL Libraries Guide, version 14.7
    FDCEReg : FDCE
       generic map (
          INIT => '0') -- Initial value of register ('0' or '1')
       port map (
         Q => IntFrmDat(n), -- Data output
         C => FrmClkDiv, -- Clock input
         CE => IntFrmEna, -- Clock enable input
         CLR => IntFrmClkRst, -- Asynchronous clear input
         D => IntFrmSrdsDat(n) -- Data input
     );
-- End of FDCE_inst instantiation
end generate gen_datReg;

IntFrmDatMux(7) <= IntFrmDat(6) when (IntFrmSwapMux_d = '1') else IntFrmDat(7);
IntFrmDatMux(6) <= IntFrmDat(7) when (IntFrmSwapMux_d = '1') else IntFrmDat(6);
IntFrmDatMux(5) <= IntFrmDat(4) when (IntFrmSwapMux_d = '1') else IntFrmDat(5);
IntFrmDatMux(4) <= IntFrmDat(5) when (IntFrmSwapMux_d = '1') else IntFrmDat(4);
IntFrmDatMux(3) <= IntFrmDat(2) when (IntFrmSwapMux_d = '1') else IntFrmDat(3);
IntFrmDatMux(2) <= IntFrmDat(3) when (IntFrmSwapMux_d = '1') else IntFrmDat(2);
IntFrmDatMux(1) <= IntFrmDat(0) when (IntFrmSwapMux_d = '1') else IntFrmDat(1);
IntFrmDatMux(0) <= IntFrmDat(1) when (IntFrmSwapMux_d = '1') else IntFrmDat(0);

gen3_datReg: for n in 7 downto 0 generate
    -- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
    -- Clock Enable (posedge clk).
    -- 7 Series
    -- Xilinx HDL Libraries Guide, version 14.7
    FDCEReg_3 : FDCE
       generic map (
          INIT => '0') -- Initial value of register ('0' or '1')
       port map (
         Q => IntFrmDatSwp(n), -- Data output
         C => FrmClkDiv, -- Clock input
         CE => IntFrmEna, -- Clock enable input
         CLR => IntFrmClkRst, -- Asynchronous clear input
         D => IntFrmDatMux(n) -- Data input
     );
-- End of FDCE_inst instantiation
end generate gen3_datReg;

IntFrmDatSwpBus <= IntFrmDatSwp(7) & IntFrmDatSwp(6) & IntFrmDatSwp(5) & IntFrmDatSwp(4) &
                  IntFrmDatSwp(3) & IntFrmDatSwp(2) & IntFrmDatSwp(1) & IntFrmDatSwp(0) &
                  IntFrmDatSwp(7) & IntFrmDatSwp(6) & IntFrmDatSwp(5) & IntFrmDatSwp(4) &
                  IntFrmDatSwp(3) & IntFrmDatSwp(2) & IntFrmDatSwp(1) & IntFrmDatSwp(0);

Gen_reg_H: for n in 8 to 15 generate                  
    -- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
    -- Clock Enable (posedge clk).
    -- 7 Series
    -- Xilinx HDL Libraries Guide, version 14.7
    FDCEReg_H : FDCE
       generic map (
          INIT => '0') -- Initial value of register ('0' or '1')
       port map (
         Q => FrmClkDat(n), -- Data output
         C => FrmClkDiv, -- Clock input
         CE => IntFrmMsbRegEna_d, -- Clock enable input
         CLR => IntFrmClkRst, -- Asynchronous clear input
         D => IntFrmDatSwpBus(n) -- Data input
     );
-- End of FDCE_inst instantiation                  
end generate Gen_reg_H;           


Gen_reg_L: for n in 0 to 7 generate                  
    -- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
    -- Clock Enable (posedge clk).
    -- 7 Series
    -- Xilinx HDL Libraries Guide, version 14.7
    FDCEReg_L : FDCE
       generic map (
          INIT => '0') -- Initial value of register ('0' or '1')
       port map (
         Q => FrmClkDat(n), -- Data output
         C => FrmClkDiv, -- Clock input
         CE => IntFrmLsbRegEna_d, -- Clock enable input
         CLR => IntFrmClkRst, -- Asynchronous clear input
         D => IntFrmDatSwpBus(n) -- Data input
     );
-- End of FDCE_inst instantiation                  
end generate Gen_reg_L;            

end Behavioral;
