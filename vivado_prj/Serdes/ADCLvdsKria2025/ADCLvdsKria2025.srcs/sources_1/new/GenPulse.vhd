----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.01.2025 06:44:01
-- Design Name: 
-- Module Name: GenPulse - Behavioral
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

entity GenPulse is
  Port (Clk		: in std_logic;
        Ena		: in std_logic;
        SigIn	: in std_logic;
        SigOut	: out std_logic
         );
end GenPulse;

architecture Behavioral of GenPulse is

component Fdcr is
    generic (INIT : bit := '0');
	port (
		D     : in std_logic;
		CE    : in std_logic;
		C     : in std_logic;
		R     : in std_logic;
		Q     : out std_logic
	);
end component;

signal IntSigClr    : std_logic;

begin

FDCR_I: Fdcr 
--    generic map (INIT => '0'
--         );
	port map(
		D  =>  SigIn,
		CE =>  Ena,
		C  =>  clk, 
		R  => IntSigClr,
		Q  => SigOut
	);

FDCR_II: Fdcr 
--    generic map (INIT => '0'
--         );
	port map(
		D  =>  SigIn,
		CE =>  '1',
		C  =>  clk, 
		R  => '0',
		Q  => IntSigClr
	);

end Behavioral;
