----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.01.2025 21:05:02
-- Design Name: 
-- Module Name: adcTopLowF - Behavioral
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

entity adcTopLowF is
  generic(periodo_dclk    : real := 7.14); -- Input clock period (DCLK) in ns to ps resolution (i.e. 33.333 is 30 MHz). 7.14 ns 
  Port (FCLK_P     : in std_logic;
        FCLK_N     : in std_logic;
        RST        : in std_logic;
        DATA_P     : in std_logic;
        DATA_N     : in std_logic;
        DATA_OUT   : out std_logic_vector(13 downto 0)
         );
end adcTopLowF;

architecture Behavioral of adcTopLowF is

component ADCLowF is
  generic (periodo_dclk    : real := 10.0); -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
  Port ( FCLK         : in std_logic;
         RST          : in std_logic;
         data         : in std_logic;
         DataOut      : out std_logic_vector(13 downto 0)
         );
end component;

signal FCLK_INT   : std_logic;
signal Data_INT   : std_logic;

begin


ADCLF: ADCLowF 
  generic map (periodo_dclk => periodo_dclk
  ) -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
  Port map( FCLK => FCLK_INT,
         RST     => RST,
         data    => data_INT,
         DataOut => DATA_OUT
         );

-- IBUFDS: Differential Input Buffer
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
IBUFDS_FCLK : IBUFDS
generic map (
DIFF_TERM => FALSE, -- Differential Termination
IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
IOSTANDARD => "DEFAULT")
port map (
O => FCLK_INT, -- Buffer output
I => FCLK_P, -- Diff_p buffer input (connect directly to top-level port)
IB => FCLK_N -- Diff_n buffer input (connect directly to top-level port)
);

IBUFDS_DATA : IBUFDS
generic map (
DIFF_TERM => FALSE, -- Differential Termination
IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
IOSTANDARD => "DEFAULT")
port map (
O => DATA_INT, -- Buffer output
I => DATA_P, -- Diff_p buffer input (connect directly to top-level port)
IB => DATA_N -- Diff_n buffer input (connect directly to top-level port)
);

-- End of IBUFDS_inst instantiation

end Behavioral;
