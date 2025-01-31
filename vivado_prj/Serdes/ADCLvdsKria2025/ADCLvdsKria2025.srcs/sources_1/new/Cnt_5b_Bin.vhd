----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2025 17:28:23
-- Design Name: 
-- Module Name: Cnt_5b_Bin - Behavioral
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

entity Cnt_5b_Bin is
  Port (CntClk	: in std_logic;
		CntEna	: in std_logic;
		CntRst	: in std_logic;
		CntOut	: out std_logic_vector(4 downto 0);
		CntTc	: out std_logic
		 );
end Cnt_5b_Bin;

architecture Behavioral of Cnt_5b_Bin is


signal IntCnt		: std_logic_vector(4 downto 0);
signal IntCntLog	: std_logic_vector(4 downto 0);
signal IntCntTc		: std_logic;

begin

process (IntCnt)
begin
    BinLog : case IntCnt(4 downto 0) is
        when "00000" => IntCntLog <= "00001";
        when "00001" => IntCntLog <= "00010";
        when "00010" => IntCntLog <= "00011";
        when "00011" => IntCntLog <= "00100";
        when "00100" => IntCntLog <= "00101";
        when "00101" => IntCntLog <= "00110";
        when "00110" => IntCntLog <= "00111";
        when "00111" => IntCntLog <= "01000";
        when "01000" => IntCntLog <= "01001";
        when "01001" => IntCntLog <= "01010";
        when "01010" => IntCntLog <= "01011";
        when "01011" => IntCntLog <= "01100";
        when "01100" => IntCntLog <= "01101";
        when "01101" => IntCntLog <= "01110";
        when "01110" => IntCntLog <= "01111";
        when "01111" => IntCntLog <= "10000";
        when "10000" => IntCntLog <= "10001";
        when "10001" => IntCntLog <= "10010";
        when "10010" => IntCntLog <= "10011";
        when "10011" => IntCntLog <= "10100";
        when "10100" => IntCntLog <= "10101";
        when "10101" => IntCntLog <= "10110";
        when "10110" => IntCntLog <= "10111";
        when "10111" => IntCntLog <= "11000";
        when "11000" => IntCntLog <= "11001";
        when "11001" => IntCntLog <= "11010";
        when "11010" => IntCntLog <= "11011";
        when "11011" => IntCntLog <= "11100";
        when "11100" => IntCntLog <= "11101";
        when "11101" => IntCntLog <= "11110";
        when "11110" => IntCntLog <= "11111";
        -- when "11111" => IntCntLog <= "00000";
		when others => IntCntLog <= "00000";
    end case;
end process;

Cnt_Ffs_PROCESS : process (CntClk, CntRst, CntEna)
begin
    if (CntClk'EVENT and CntClk = '1') then
        if (CntRst = '1') then
            IntCnt <= (others => '0');
            CntTc <= '0';
        elsif (CntEna = '1') then
            IntCnt <= IntCntLog;
            CntTc <= IntCntTc;
        end if; 
   	end if;
end process;
--
IntCntTc <= '1' when (IntCnt(4 downto 0) = "11110") else '0';
CntOut <= IntCnt;
end Behavioral;
