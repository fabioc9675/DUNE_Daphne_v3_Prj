----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.01.2025 21:11:20
-- Design Name: 
-- Module Name: FCLKNeededBits - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FCLKNeededBits is
  Port ( FrmClkDiv                : in std_logic;
         IntFrmClkRst             : in std_logic;
         IntFrmSrdsOut            : in std_logic_vector(7 downto 0);
         IntFrmDbleNibFnl         : out std_logic;
         IntFrmSrdsDat            : out std_logic_vector(7 downto 0)
        );
end FCLKNeededBits;

architecture Behavioral of FCLKNeededBits is


component  DoubleNibbleDetect is
  Port (CLK           : in std_logic; 
        RST           : in std_logic;
        DataIn        : in std_logic_vector(3  downto 0);
        DataOut       : out std_logic_vector(3  downto 0);
        Final         : out std_logic
        );
end component;

signal IntFrmSrdsDatEvn		        : std_logic_vector(3 downto 0);
signal IntFrmSrdsDatOdd             : std_logic_vector(3 downto 0);
signal IntFrmSrdsDatEvn_d           : std_logic_vector(3 downto 0);
signal IntFrmSrdsDatOdd_d           : std_logic_vector(3 downto 0);
signal IntFrmDbleNibFnlEvn          : std_logic;
signal IntFrmDbleNibFnlEvn_d        : std_logic;
signal IntFrmDbleNibFnlOdd          : std_logic;
signal IntFrmDbleNibFnlOdd_d        : std_logic;



begin

IntFrmSrdsDatEvn <= IntFrmSrdsOut(6) & IntFrmSrdsOut(4) &
	                    IntFrmSrdsOut(2) & IntFrmSrdsOut(0);
IntFrmSrdsDatOdd <= not IntFrmSrdsOut(7) & not IntFrmSrdsOut(5) &
                    not IntFrmSrdsOut(3) & not IntFrmSrdsOut(1);


 genDble_evn: DoubleNibbleDetect 
  Port map(CLK           => FrmClkDiv, 
        RST              => IntFrmClkRst,
        DataIn           => IntFrmSrdsDatEvn,
        DataOut          => IntFrmSrdsDatEvn_d,
        Final            => IntFrmDbleNibFnlEvn
        );

genDble_odd: DoubleNibbleDetect 
  Port map(CLK           => FrmClkDiv, 
        RST              => IntFrmClkRst,
        DataIn           => IntFrmSrdsDatOdd,
        DataOut          => IntFrmSrdsDatOdd_d,
        Final            => IntFrmDbleNibFnlOdd
        );


adcframe_process: process(FrmClkDiv, IntFrmClkRst)
begin
    if (IntFrmClkRst = '1') then
       IntFrmDbleNibFnlOdd_d <= '0';
       IntFrmDbleNibFnlEvn_d <= '0';
    elsif (rising_edge(FrmClkDiv)) then
         IntFrmDbleNibFnlOdd_d <= IntFrmDbleNibFnlOdd;
         IntFrmDbleNibFnlEvn_d <= IntFrmDbleNibFnlEvn;
   end if;
end process;         


IntFrmDbleNibFnl <= IntFrmDbleNibFnlOdd_d and IntFrmDbleNibFnlEvn_d;
IntFrmSrdsDat(7) <= IntFrmSrdsDatOdd_d(3);
IntFrmSrdsDat(6) <= IntFrmSrdsDatEvn_d(3);
IntFrmSrdsDat(5) <= IntFrmSrdsDatOdd_d(2);
IntFrmSrdsDat(4) <= IntFrmSrdsDatEvn_d(2);
IntFrmSrdsDat(3) <= IntFrmSrdsDatOdd_d(1);
IntFrmSrdsDat(2) <= IntFrmSrdsDatEvn_d(1);
IntFrmSrdsDat(1) <= IntFrmSrdsDatOdd_d(0);
IntFrmSrdsDat(0) <= IntFrmSrdsDatEvn_d(0);

end Behavioral;
