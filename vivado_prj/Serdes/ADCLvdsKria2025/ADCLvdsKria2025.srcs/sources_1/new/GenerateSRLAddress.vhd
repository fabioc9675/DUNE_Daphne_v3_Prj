----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2025 20:32:34
-- Design Name: 
-- Module Name: GenerateSRLAddress - Behavioral
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

entity GenerateSRLAddress is
 Port (IntEquCnt_d                    : in std_logic_vector(3 downto 0);
       IntSlipCnt_d                   : in std_logic_vector(3 downto 0);
       IntPulse                       : in std_logic;
       IntRstSet                      : out std_logic;
       IntAddr                        : out std_logic_vector(4 downto 0) 
       );
end GenerateSRLAddress;

architecture Behavioral of GenerateSRLAddress is

begin

-----------------------------------------------------------------------------------------------
-- Generate the SRL addresses
---------------------------------------------------------------------------------------------
IntAddr(3 downto 0) <= "0100" when (IntEquCnt_d = "0000" and IntSlipCnt_d = "0000") else
                       "0011" when (IntEquCnt_d = "0001" and IntSlipCnt_d = "0111") else
                       "0010" when (IntEquCnt_d = "0011" and IntSlipCnt_d = "0110") else
                       "0001" when (IntEquCnt_d = "0010" and IntSlipCnt_d = "0010") else
                       "0000" when (IntEquCnt_d = "0110" and IntSlipCnt_d = "0011") else
                       "0100" when (IntEquCnt_d = "0111" and IntSlipCnt_d = "0001");
IntAddr(4) <= '0';


IntRstSet <= '1' when (IntEquCnt_d = "0110" and IntSlipCnt_d = "0000" and IntPulse = '1')
                 else '0';


end Behavioral;
