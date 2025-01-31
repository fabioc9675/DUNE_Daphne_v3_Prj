----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2025 11:01:21
-- Design Name: 
-- Module Name: GenEquCntProcess - Behavioral
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

entity GenEquCntProcess is
  Port (Clk            : in std_logic; 
        IntEqu         : in std_logic;
        IntRstIn_d     : in std_logic;
        IntEquCnt_d    : out std_logic_vector(3 downto 0)
  );
end GenEquCntProcess;

architecture Behavioral of GenEquCntProcess is
signal IntEquCnt        : std_logic_vector(3 downto 0);
signal IntEquCnt_d_int      : std_logic_vector(3 downto 0);
begin

IntEquCnt_d <= IntEquCnt_d_int;

gen_equCnt: for n in 3 downto 0 generate
   -- FDRE: Single Data Rate D Flip-Flop with Synchronous Reset and
   -- Clock Enable (posedge clk).
   -- 7 Series
   -- Xilinx HDL Libraries Guide, version 14.7
   EQU_I_FDRE : FDRE
      generic map (
        INIT => '0') -- Initial value of register ('0' or '1')
      port map (
        Q => IntEquCnt_d_int(n), -- Data output
        C => Clk, -- Clock input
        CE => IntEqu, -- Clock enable input
        R => IntRstIn_d, -- Synchronous reset input
        D => IntEquCnt(n) -- Data input
      );
    -- End of FDRE_inst instantiation
end generate gen_equCnt; 
  

DbleNibl_EquCnt_PROCESS : process (IntEquCnt_d_int)
begin
    case IntEquCnt_d_int(3 downto 0) is
        when "0000" => IntEquCnt <= "0001";  -- after 100 ps;
        when "0001" => IntEquCnt <= "0011";  -- after 100 ps;
        when "0011" => IntEquCnt <= "0010";  -- after 100 ps;
        when "0010" => IntEquCnt <= "0110";  -- after 100 ps;
        when "0110" => IntEquCnt <= "0111";  -- after 100 ps;
        when "0111" => IntEquCnt <= "0101";  -- after 100 ps;
        when "0101" => IntEquCnt <= "0100";  -- after 100 ps;
        when "0100" => IntEquCnt <= "1100";  -- after 100 ps;
        when "1100" => IntEquCnt <= "1101";  -- after 100 ps;
        when "1101" => IntEquCnt <= "1111";  -- after 100 ps;
        when "1111" => IntEquCnt <= "1110";  -- after 100 ps;
        when "1110" => IntEquCnt <= "1010";  -- after 100 ps;
        when "1010" => IntEquCnt <= "1011";  -- after 100 ps;
        when "1011" => IntEquCnt <= "1001";  -- after 100 ps;
        when "1001" => IntEquCnt <= "1000";  -- after 100 ps;
        when others => IntEquCnt <= "0000";  -- after 100 ps;
    end case;
end process;


end Behavioral;
