----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Fabian Castano
-- 
-- Create Date: 01.03.2025 20:57:57
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.VComponents.ALL;

entity iddr_clk_gen is
    Port (
            FCLK        : in  std_logic;
            RST         : in  std_logic;
            DATA_CLKP   : out std_logic
         );
end iddr_clk_gen;

architecture Behavioral of iddr_clk_gen is

    signal    CLKFBOUT        : std_logic;
    signal    CLKFBIN         : std_logic;
    signal    DCLK_P          : std_logic;

begin

   -- MMCME4_BASE: Base Mixed Mode Clock Manager (MMCM)
   --              Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2

   MMCME4_BASE_inst : MMCME4_BASE
   generic map (
      BANDWIDTH => "OPTIMIZED",   -- Jitter programming
      CLKFBOUT_MULT_F => 21.0,    -- Multiply value for all CLKOUT
      CLKFBOUT_PHASE => 0.0,      -- Phase offset in degrees of CLKFB
      CLKIN1_PERIOD => 25.0,      -- Input clock period in ns to ps resolution (i.e., 33.333 is 30 MHz).
      CLKOUT0_DIVIDE_F => 3.0,    -- Divide amount for CLKOUT0
      CLKOUT0_DUTY_CYCLE => 0.5,  -- Duty cycle for CLKOUT0
      CLKOUT0_PHASE => 0.0,       -- Phase offset for CLKOUT0
      CLKOUT1_DIVIDE => 1,        -- Divide amount for CLKOUT (1-128)
      CLKOUT1_DUTY_CYCLE => 0.5,  -- Duty cycle for CLKOUT outputs (0.001-0.999).
      CLKOUT1_PHASE => 0.0,       -- Phase offset for CLKOUT outputs (-360.000-360.000).
      CLKOUT2_DIVIDE => 1,        -- Divide amount for CLKOUT (1-128)
      CLKOUT2_DUTY_CYCLE => 0.5,  -- Duty cycle for CLKOUT outputs (0.001-0.999).
      CLKOUT2_PHASE => 0.0,       -- Phase offset for CLKOUT outputs (-360.000-360.000).
      CLKOUT3_DIVIDE => 1,        -- Divide amount for CLKOUT (1-128)
      CLKOUT3_DUTY_CYCLE => 0.5,  -- Duty cycle for CLKOUT outputs (0.001-0.999).
      CLKOUT3_PHASE => 0.0,       -- Phase offset for CLKOUT outputs (-360.000-360.000).
      CLKOUT4_CASCADE => "FALSE", -- Divide amount for CLKOUT (1-128)
      CLKOUT4_DIVIDE => 1,        -- Divide amount for CLKOUT (1-128)
      CLKOUT4_DUTY_CYCLE => 0.5,  -- Duty cycle for CLKOUT outputs (0.001-0.999).
      CLKOUT4_PHASE => 0.0,       -- Phase offset for CLKOUT outputs (-360.000-360.000).
      CLKOUT5_DIVIDE => 1,        -- Divide amount for CLKOUT (1-128)
      CLKOUT5_DUTY_CYCLE => 0.5,  -- Duty cycle for CLKOUT outputs (0.001-0.999).
      CLKOUT5_PHASE => 0.0,       -- Phase offset for CLKOUT outputs (-360.000-360.000).
      CLKOUT6_DIVIDE => 1,        -- Divide amount for CLKOUT (1-128)
      CLKOUT6_DUTY_CYCLE => 0.5,  -- Duty cycle for CLKOUT outputs (0.001-0.999).
      CLKOUT6_PHASE => 0.0,       -- Phase offset for CLKOUT outputs (-360.000-360.000).
      DIVCLK_DIVIDE => 1,         -- Master division value
      IS_CLKFBIN_INVERTED => '0', -- Optional inversion for CLKFBIN
      IS_CLKIN1_INVERTED => '0',  -- Optional inversion for CLKIN1
      IS_PWRDWN_INVERTED => '0',  -- Optional inversion for PWRDWN
      IS_RST_INVERTED => '0',     -- Optional inversion for RST
      REF_JITTER1 => 0.0,         -- Reference input jitter in UI (0.000-0.999).
      STARTUP_WAIT => "FALSE"     -- Delays DONE until MMCM is locked
   )
   port map (
      CLKFBOUT => CLKFBOUT,   -- 1-bit output: Feedback clock pin to the MMCM
      CLKFBOUTB => open,      -- CLKFBOUTB, -- 1-bit output: Inverted CLKFBOUT
      CLKOUT0 => DCLK_P,      -- 1-bit output: CLKOUT0
      CLKOUT0B => open,       -- CLKOUT0B,   -- 1-bit output: Inverted CLKOUT0
      CLKOUT1 => open,        -- CLKOUT1,     -- 1-bit output: CLKOUT1
      CLKOUT1B => open,       -- CLKOUT1B,   -- 1-bit output: Inverted CLKOUT1
      CLKOUT2 => open,        -- CLKOUT2,     -- 1-bit output: CLKOUT2
      CLKOUT2B => open,       -- CLKOUT2B,   -- 1-bit output: Inverted CLKOUT2
      CLKOUT3 => open,        -- CLKOUT3,     -- 1-bit output: CLKOUT3
      CLKOUT3B => open,       -- CLKOUT3B,   -- 1-bit output: Inverted CLKOUT3
      CLKOUT4 => open,        -- CLKOUT4,     -- 1-bit output: CLKOUT4
      CLKOUT5 => open,        -- CLKOUT5,     -- 1-bit output: CLKOUT5
      CLKOUT6 => open,        -- CLKOUT6,     -- 1-bit output: CLKOUT6
      LOCKED => open,         -- LOCKED,       -- 1-bit output: LOCK
      CLKFBIN => CLKFBIN,     -- 1-bit input: Feedback clock pin to the MMCM
      CLKIN1 => FCLK,         -- 1-bit input: Primary clock
      PWRDWN => '0',          -- 1-bit input: Power-down
      RST => RST              -- 1-bit input: Reset
   );
   -- End of MMCME4_BASE_inst instantiation
				
   CLKFBIN   <=   CLKFBOUT;
   
   -- BUFG: General Clock Buffer
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2

   BUFG_inst : BUFG
   port map (
      O => DATA_CLKP,   -- 1-bit output: Clock output.
      I => DCLK_P       -- 1-bit input: Clock input.
   );
   -- End of BUFG_inst instantiation	
				
end Behavioral;
