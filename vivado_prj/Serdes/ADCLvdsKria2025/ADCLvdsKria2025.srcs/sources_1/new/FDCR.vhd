----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.01.2025 06:41:42
-- Design Name: 
-- Module Name: FDCR - Behavioral
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
	use IEEE.std_logic_1164.all;
	use IEEE.std_logic_UNSIGNED.all;
library UNISIM;
	use UNISIM.vcomponents.all;
---------------------------------------------------------------------------------------------
-- Entity pin description
---------------------------------------------------------------------------------------------
entity Fdcr is
    generic (INIT : bit := '0');
	port (
		D     : in std_logic;
		CE    : in std_logic;
		C     : in std_logic;
		R     : in std_logic;
		Q     : out std_logic
	);
end Fdcr;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture Fdcr_struct of Fdcr is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
-- Functions
-- Constants
constant Low  : std_logic	:= '0';
constant High : std_logic	:= '1';
-- Signals
signal IntDceR  : std_logic;
signal IntQ     : std_logic;
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of Fdcr_struct : architecture is "NO";
---------------------------------------------------------------------------------------------
begin
--
Fdcr_Case : process (IntQ, R, CE, D)
subtype LutOut is std_logic_vector(3 downto 0);
begin
    case LutOut'(IntQ & R & CE & D) is
        when "0011" => IntDceR <= '1';
        when "1000" => IntDceR <= '1';
        when "1001" => IntDceR <= '1';
        when "1011" => IntDceR <= '1';
        when others => IntDceR <= '0';
    end case;
end process Fdcr_Case;
--Fdcr_I_Lut4 : LUT4
--    generic map (INIT => X"0B08")
--    port map (I3 => IntQ, I2 => R, I1 => CE, I0 => D, O => IntDceR);
--
Q <= IntQ;
--
Fdcr_I_Fd : FDCE
    generic map (
        INIT            => '0'
    )
    port map (
        D   =>  IntDceR,
        C   =>  C,
        CE  =>  High,
        CLR =>  Low,
        Q   =>  IntQ
    );
----------------------------------------------------------------------------------------------
end Fdcr_struct;

