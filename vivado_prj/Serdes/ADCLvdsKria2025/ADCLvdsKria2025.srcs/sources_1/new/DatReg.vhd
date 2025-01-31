----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 14:07:34
-- Design Name: 
-- Module Name: DatReg - Behavioral
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

entity DatReg is
  Port (FrmClkDiv                    : in std_logic;
        IntFrmClkRst                 : in std_logic;
        IntFrmEna                    : in std_logic; 
        IntFrmSrdsDat                : in std_logic_vector(7 downto 0);
        IntFrmEqu_d                  : out std_logic;
        IntFrmMsbRegEna_d            : out std_logic;
        IntFrmLsbRegEna_d            : out std_logic;
        IntFrmSwapMux_d              : out std_logic
       );
end DatReg;

architecture Behavioral of DatReg is

constant IntPatternA : std_logic_vector(7 downto 0) := "00000001";
constant IntPatternB : std_logic_vector(7 downto 0) := "11100000";
constant IntPatternC : std_logic_vector(7 downto 0) := "00000010";
constant IntPatternD : std_logic_vector(7 downto 0) := "11010000";

signal IntFrmCmp                    : std_logic_vector(3 downto 0);
signal IntFrmEquGte			        : std_logic;		
signal IntFrmMsbAllZero_d_Ena       : std_logic;
signal IntFrmMsbAllZero_d 	        : std_logic;		
signal IntFrmEqu_dint   	        : std_logic;
signal IntFrmSwapMux_d_Ena          : std_logic;
signal IntFrmLsbMsb_d_Ena           : std_logic;
signal IntFrmLsbMsb_d 		        : std_logic;
signal IntFrmRegEna_d		        : std_logic;
signal IntFrmMsbRegEna_dint         : std_logic;
signal IntFrmLsbRegEna_dint         : std_logic;

begin


IntFrmEqu_d <= IntFrmEqu_dint;
-----------------------------------------------------------------------------------------------
-- FRAME PATTERN COMPARATOR
-----------------------------------------------------------------------------------------------
IntFrmCmp(2 downto 0) <= "101" when (IntFrmSrdsDat = IntPatternA) else	-- Equ, 	, Msb
						 "100" when (IntFrmSrdsDat = IntPatternB) else	-- Equ, 	, Lsb
						 "111" when (IntFrmSrdsDat = IntPatternC) else	-- Equ, swpd, Msb
						 "110" when (IntFrmSrdsDat = IntPatternD) else	-- Equ, Swpd, Lsb
						 "000";
IntFrmCmp(3) <= '0';


--
-- When "Equ" goes high, one of the four patterns has been found.
-- The other two signals will reflect (Msb or Lsb, bitswapped or not) what pattern has been
-- found. WHen "Equ" thus goes high, store the status of all signals and make sure it can't
-- be changed.
--

IntFrmEquGte <= IntFrmCmp(2) and IntFrmEna;

-- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
-- Clock Enable (posedge clk).
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
FDC_FrmMsbALLzero_d : FDCE
    generic map (
      INIT => '0') -- Initial value of register ('0' or '1')
    port map (
      Q => IntFrmMsbAllZero_d, -- Data output
      C => FrmClkDiv, -- Clock input
      CE => IntFrmMsbAllZero_d_Ena, -- Clock enable input
      CLR => IntFrmClkRst, -- Asynchronous clear input
      D => IntFrmCmp(3) -- Data input
);

FDC_FrmEqu_d : FDCE
    generic map (
      INIT => '0') -- Initial value of register ('0' or '1')
    port map (
      Q => IntFrmEqu_dint, -- Data output
      C => FrmClkDiv, -- Clock input
      CE => '1', -- Clock enable input
      CLR => IntFrmClkRst, -- Asynchronous clear input
      D => IntFrmEquGte -- Data input
);

FDC_FrmSwapMux_d : FDCE
    generic map (
      INIT => '0') -- Initial value of register ('0' or '1')
    port map (
      Q => IntFrmSwapMux_d, -- Data output
      C => FrmClkDiv, -- Clock input
      CE => IntFrmSwapMux_d_Ena, -- Clock enable input
      CLR => IntFrmClkRst, -- Asynchronous clear input
      D => IntFrmCmp(1) -- Data input
);

FDC_FrmLsbMsb_d : FDCE
    generic map (
      INIT => '0') -- Initial value of register ('0' or '1')
    port map (
      Q => IntFrmLsbMsb_d, -- Data output
      C => FrmClkDiv, -- Clock input
      CE => IntFrmLsbMsb_d_Ena, -- Clock enable input
      CLR => IntFrmClkRst, -- Asynchronous clear input
      D => IntFrmCmp(0) -- Data input
);

-- End of FDCE_inst instantiation


IntFrmMsbAllZero_d_Ena <= IntFrmCmp(2) and not IntFrmEqu_dint;
IntFrmSwapMux_d_Ena <= IntFrmCmp(2)and not IntFrmEqu_dint;
IntFrmLsbMsb_d_Ena <= IntFrmCmp(2) and not IntFrmEqu_dint;

-----------------------------------------------------------------------------------------------
-- OUTPUT REGISTER ENABLER
-----------------------------------------------------------------------------------------------
AdcFrame_EnaSel_PROCESS : process (FrmClkDiv, IntFrmMsbAllZero_d, IntFrmEqu_dint)
subtype IntFrmRegEnaCase is std_logic_vector(4 downto 0);
begin
	if (IntFrmMsbAllZero_d = '1') then
		IntFrmRegEna_d <= '0';
		IntFrmMsbRegEna_dint <= '1';
		IntFrmLsbRegEna_dint <= '1';
	elsif (FrmClkDiv'event and FrmClkDiv = '1') then
		case IntFrmRegEnaCase'(IntFrmLsbMsb_d, IntFrmEqu_dint, IntFrmRegEna_d,
									IntFrmMsbRegEna_dint, IntFrmLsbRegEna_dint) is
			when "00001" =>	IntFrmRegEna_d <= '0';
							IntFrmMsbRegEna_dint <= '0'; -- A
							IntFrmLsbRegEna_dint <= '1'; --
			when "01001" =>	IntFrmRegEna_d <= '1';
							IntFrmMsbRegEna_dint <= '0'; -- B
							IntFrmLsbRegEna_dint <= '1'; --
			when "01101" =>	IntFrmRegEna_d <= '1';
							IntFrmMsbRegEna_dint <= '1'; -- C
							IntFrmLsbRegEna_dint <= '0'; --
			when "01110" =>	IntFrmRegEna_d <= '1';
							IntFrmMsbRegEna_dint <= '0'; -- D, goto C
							IntFrmLsbRegEna_dint <= '1'; --
			--
			when "11001" =>	IntFrmRegEna_d <= '1';
							IntFrmMsbRegEna_dint <= '1'; -- E
							IntFrmLsbRegEna_dint <= '0'; --
			when "11110" =>	IntFrmRegEna_d <= '1';
							IntFrmMsbRegEna_dint <= '0'; -- F
							IntFrmLsbRegEna_dint <= '1'; --
			when "11101" =>	IntFrmRegEna_d <= '1';
							IntFrmMsbRegEna_dint <= '1'; -- G, goto F
							IntFrmLsbRegEna_dint <= '0'; --
			--
			when others =>	IntFrmRegEna_d <= '0';
							IntFrmMsbRegEna_dint <= '0';
							IntFrmLsbRegEna_dint <= '1';
		end case;
	end if;
end process;

IntFrmMsbRegEna_d <= IntFrmMsbRegEna_dint; 
IntFrmLsbRegEna_d <= IntFrmLsbRegEna_dint;

end Behavioral;
