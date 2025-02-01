----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.01.2025 20:10:38
-- Design Name: 
-- Module Name: ADCLowF - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
Library UNISIM;
use UNISIM.vcomponents.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADCLowF is
  generic (periodo_dclk    : real := 10.0); -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
  Port ( FCLK         : in std_logic;
         RST          : in std_logic;
         data         : in std_logic;
         DataOut      : out std_logic_vector(13 downto 0)
         );
end ADCLowF;

architecture Behavioral of ADCLowF is

component miserdes is
   Port (CLK      : in std_logic;
         FCLK     : in std_logic; 
         RST      : in std_logic;
         data     : in std_logic;
         Q        : out std_logic_vector(6 downto 0)
         );
end component;

component dataOUTparalelo is
  Port (FCLK        : in std_logic;
        RST         : in std_logic; 
        Q           : in std_logic_vector(6 downto 0);
        T           : in std_logic_vector(6 downto 0);
        DATAOUT     : out std_logic_vector(13 downto 0)
        );
end component;

--signal clk3   : std_logic;
signal clk1   : std_logic;
signal clk1n  : std_logic;

signal Q      : std_logic_vector(6 downto 0);
signal T      : std_logic_vector(6 downto 0);


begin

-- MMCME2_BASE: Base Mixed Mode Clock Manager
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7
MMCME2_BASE_inst : MMCME2_BASE
generic map (
BANDWIDTH => "OPTIMIZED", -- Jitter programming (OPTIMIZED, HIGH, LOW)
CLKFBOUT_MULT_F => 7.0, -- Multiply value for all CLKOUT (2.000-64.000).
CLKFBOUT_PHASE => 0.0, -- Phase offset in degrees of CLKFB (-360.000-360.000).
CLKIN1_PERIOD => periodo_dclk, -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
-- CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
CLKOUT1_DIVIDE => 2,
CLKOUT2_DIVIDE => 1,
CLKOUT3_DIVIDE => 1,
CLKOUT4_DIVIDE => 1,
CLKOUT5_DIVIDE => 1,
CLKOUT6_DIVIDE => 1,
CLKOUT0_DIVIDE_F => 1.0, -- Divide amount for CLKOUT0 (1.000-128.000).
-- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
CLKOUT0_DUTY_CYCLE => 0.5,
CLKOUT1_DUTY_CYCLE => 0.5,
CLKOUT2_DUTY_CYCLE => 0.5,
CLKOUT3_DUTY_CYCLE => 0.5,
CLKOUT4_DUTY_CYCLE => 0.5,
CLKOUT5_DUTY_CYCLE => 0.5,
CLKOUT6_DUTY_CYCLE => 0.5,
-- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
CLKOUT0_PHASE => 90.0,
CLKOUT1_PHASE => 0.0,
CLKOUT2_PHASE => 0.0,
CLKOUT3_PHASE => 0.0,
CLKOUT4_PHASE => 0.0,
CLKOUT5_PHASE => 0.0,
CLKOUT6_PHASE => 0.0,
CLKOUT4_CASCADE => FALSE, -- Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
DIVCLK_DIVIDE => 1, -- Master division value (1-106)
REF_JITTER1 => 0.0, -- Reference input jitter in UI (0.000-0.999).
STARTUP_WAIT => FALSE -- Delays DONE until MMCM is locked (FALSE, TRUE)
)
port map (
-- Clock Outputs: 1-bit (each) output: User configurable clock outputs
CLKOUT0 => clk1, -- 1-bit output: CLKOUT0
CLKOUT0B => clk1n, -- 1-bit output: Inverted CLKOUT0
CLKOUT1 => open, -- 1-bit output: CLKOUT1
CLKOUT1B => open, -- 1-bit output: Inverted CLKOUT1
CLKOUT2 => open, -- 1-bit output: CLKOUT2
CLKOUT2B => open, -- 1-bit output: Inverted CLKOUT2
CLKOUT3 => open, -- 1-bit output: CLKOUT3
CLKOUT3B => open, -- 1-bit output: Inverted CLKOUT3
CLKOUT4 => open, -- 1-bit output: CLKOUT4
CLKOUT5 => open, -- 1-bit output: CLKOUT5
CLKOUT6 => open, -- 1-bit output: CLKOUT6
-- Feedback Clocks: 1-bit (each) output: Clock feedback ports
CLKFBOUT => open, -- 1-bit output: Feedback clock
CLKFBOUTB => open, -- 1-bit output: Inverted CLKFBOUT
-- Status Ports: 1-bit (each) output: MMCM status ports
LOCKED => open, -- 1-bit output: LOCK
-- Clock Inputs: 1-bit (each) input: Clock input
CLKIN1 => FCLK, -- 1-bit input: Clock
-- Control Ports: 1-bit (each) input: MMCM control ports
PWRDWN => '0', -- 1-bit input: Power-down
RST => RST, -- 1-bit input: Reset
-- Feedback Clocks: 1-bit (each) input: Clock feedback ports
CLKFBIN => FCLK -- 1-bit input: Feedback clock
);
-- End of MMCME2_BASE_inst instantiation

-- ISERDESE3: Input SERial/DESerializer
--            UltraScale
-- Xilinx HDL Language Template, version 2021.2


-- End of ISERDESE3_inst instantiation


--clk3 <= FCLK;
misQ: miserdes 
   Port map(CLK => clk1,
         FCLK   => FCLK, 
         RST    => RST,
         data   => data,
         Q      => Q
         );
      
misT: miserdes 
   Port map(CLK => clk1n,
         FCLK   => FCLK, 
         RST    => RST,
         data   => data,
         Q      => T
         );

datapar: dataOUTparalelo 
  Port map (FCLK => FCLK,
        RST      => RST, 
        Q        => Q,
        T        => T,
        DATAOUT  => DATAOUT
        );

end Behavioral;
