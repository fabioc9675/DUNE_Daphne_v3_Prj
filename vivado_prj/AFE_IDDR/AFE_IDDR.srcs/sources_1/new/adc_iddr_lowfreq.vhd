----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.02.2025 23:16:25
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.VComponents.ALL;


entity adc_iddr_lowfreq is
    -- generic (period_dclk    : real := 25.0);  -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
    Port (
        fclk        : in  std_logic;
        rst         : in  std_logic;
        data        : in  std_logic;
        data_out    : out std_logic_vector(13 downto 0)
         );
end adc_iddr_lowfreq;

architecture Behavioral of adc_iddr_lowfreq is

    component serdes_fab is
        Port (
                clk      : in  std_logic;
                fclk     : in  std_logic;
                rst      : in  std_logic;
                data     : in  std_logic;
                Q        : out std_logic_vector(6 downto 0)
                );
    end component;
     
    component dataOutParallel is
        Port (
                fclk         : in  std_logic;
                rst          : in  std_logic; 
                Q            : in  std_logic_vector(6 downto 0);
                T            : in  std_logic_vector(6 downto 0);
                dataOut      : out std_logic_vector(15 downto 0)  -- verify if 13 downto 0
                );
    end component;
    
    component Q_iddr_serdes is
        Port (
                clk        : in  std_logic;
                rst        : in  std_logic;
                datap      : in  std_logic;
                datan      : in  std_logic;
                Q          : out std_logic_vector(13 downto 0)   
                );
    end component;
    
    component fifo_serdes is
        Port (
                clk      : in  std_logic;
                rst      : in  std_logic;
                Q_in     : in  std_logic_vector(13 downto 0);
                Q_out    : out std_logic_vector(13 downto 0)  
                );
    end component;

    -- Signals
    signal clk1p            : std_logic;
    signal clk1n            : std_logic;
    signal clk1p_int        : std_logic;
    signal clk1n_int        : std_logic;
    
    signal Q                : std_logic_vector(6 downto 0);
    signal T                : std_logic_vector(6 downto 0);
    signal clk_delayed      : std_logic;
    signal cnt_value_in     : std_logic_vector(8 downto 0);
    signal IntClkCtrlDlyCe  : std_logic;
    signal IntClkCtrlDlyInc : std_logic;
    
    signal F1_int           : std_logic;
    signal Q1_int           : std_logic;
    signal F2_int           : std_logic;
    signal Q2_int           : std_logic;
    
    signal dataout_int      : std_logic_vector(13 downto 0);
    signal datafifo_out     : std_logic_vector(13 downto 0);
    signal fclkout_int      : std_logic_vector(13 downto 0);
    signal fclkfifo_out     : std_logic_vector(13 downto 0);
    
    signal clk_feedB        : std_logic;
    signal clk1_intb        : std_logic;
    
begin

    IntClkCtrlDlyCe <= '0';
    IntClkCtrlDlyInc <= '0';
    cnt_value_in <= "100000000";

    -- MMCME2_BASE: Base Mixed Mode Clock Manager
   --              Artix-7
   -- Xilinx HDL Language Template, version 2022.2

   MMCME2_BASE_inst : MMCME2_BASE
   generic map (
      BANDWIDTH => "OPTIMIZED",  -- Jitter programming (OPTIMIZED, HIGH, LOW)
      CLKFBOUT_MULT_F => 21.0,    -- Multiply value for all CLKOUT (2.000-64.000).
      CLKFBOUT_PHASE => 0.0,     -- Phase offset in degrees of CLKFB (-360.000-360.000).
      CLKIN1_PERIOD => 25.0,      -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      -- CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      CLKOUT1_DIVIDE => 1,
      CLKOUT2_DIVIDE => 1,
      CLKOUT3_DIVIDE => 1,
      CLKOUT4_DIVIDE => 1,
      CLKOUT5_DIVIDE => 1,
      CLKOUT6_DIVIDE => 1,
      CLKOUT0_DIVIDE_F => 3.0,   -- Divide amount for CLKOUT0 (1.000-128.000).
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
      CLKOUT4_CASCADE => FALSE,  -- Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      DIVCLK_DIVIDE => 1,        -- Master division value (1-106)
      REF_JITTER1 => 0.0,        -- Reference input jitter in UI (0.000-0.999).
      STARTUP_WAIT => FALSE      -- Delays DONE until MMCM is locked (FALSE, TRUE)
   )
   port map (
      -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
      CLKOUT0  => clk1p_int,     -- 1-bit output: CLKOUT0
      CLKOUT0B => clk1n_int,     -- 1-bit output: Inverted CLKOUT0
      CLKOUT1  => open,          -- 1-bit output: CLKOUT1
      CLKOUT1B => open,          -- 1-bit output: Inverted CLKOUT1
      CLKOUT2  => open,          -- 1-bit output: CLKOUT2
      CLKOUT2B => open,          -- 1-bit output: Inverted CLKOUT2
      CLKOUT3  => open,          -- 1-bit output: CLKOUT3
      CLKOUT3B => open,          -- 1-bit output: Inverted CLKOUT3
      CLKOUT4  => open,          -- 1-bit output: CLKOUT4
      CLKOUT5  => open,          -- 1-bit output: CLKOUT5
      CLKOUT6  => open,          -- 1-bit output: CLKOUT6
      -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
      CLKFBOUT  => clk_feedB,    -- 1-bit output: Feedback clock
      CLKFBOUTB => open,         -- 1-bit output: Inverted CLKFBOUT
      -- Status Ports: 1-bit (each) output: MMCM status ports
      LOCKED => open,            -- 1-bit output: LOCK
      -- Clock Inputs: 1-bit (each) input: Clock input
      CLKIN1 => fclk,            -- 1-bit input: Clock
      -- Control Ports: 1-bit (each) input: MMCM control ports
      PWRDWN => '0',             -- 1-bit input: Power-down
      RST => rst,                -- 1-bit input: Reset
      -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
      CLKFBIN => clk_feedB      -- 1-bit input: Feedback clock
   );
   -- End of MMCME2_BASE_inst instantiation

    
   -- IDDRE1: Dedicated Double Data Rate (DDR) Input Register
   --         Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2

   IDDRE1_Data : IDDRE1
   generic map (
      DDR_CLK_EDGE => "OPPOSITE_EDGE", -- IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
      IS_CB_INVERTED => '1',           -- Optional inversion for CB
      IS_C_INVERTED => '0'             -- Optional inversion for C
   )
   port map (
      Q1 => Q1_int, -- 1-bit output: Registered parallel output 1
      Q2 => Q2_int, -- 1-bit output: Registered parallel output 2
      C  => clk1_intb,   -- 1-bit input: High-speed clock
      CB => clk1_intb, -- 1-bit input: Inversion of High-speed clock C
      D  => data,   -- 1-bit input: Serial Data Input
      R  => rst    -- 1-bit input: Active-High Async Reset
   );

   -- End of IDDRE1_inst instantiation
   
   -- BUFGCE_1: General Clock Buffer with Clock Enable and Output State 1
   --           Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2

   BUFGCE_1_inst : BUFGCE_1
   port map (
      O   => clk1_intb,    -- 1-bit output: Clock output.
      CE  => '1',          -- 1-bit input: Clock buffer active-High enable.
      I   => clk1p_int     -- 1-bit input: Clock input.
   );

   -- End of BUFGCE_1_inst instantiation
   
   
   -- IDDRE1: Dedicated Double Data Rate (DDR) Input Register
   --         Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2

   IDDRE1_Fclk : IDDRE1
   generic map (
      DDR_CLK_EDGE => "OPPOSITE_EDGE", -- IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
      IS_CB_INVERTED => '1',           -- Optional inversion for CB
      IS_C_INVERTED => '0'             -- Optional inversion for C
   )
   port map (
      Q1 => F1_int, -- 1-bit output: Registered parallel output 1
      Q2 => F2_int, -- 1-bit output: Registered parallel output 2
      C  => clk1_intb,   -- 1-bit input: High-speed clock
      CB => clk1_intb, -- 1-bit input: Inversion of High-speed clock C
      D  => fclk,   -- 1-bit input: Serial Data Input
      R  => rst    -- 1-bit input: Active-High Async Reset
   );

   -- End of IDDRE1_inst instantiation
   
   -- FDRE: D Flip-Flop with Clock Enable and Synchronous Reset
   -- UltraScale
   -- Xilinx HDL Language Template, version 2021.2

    DATACLK : Q_iddr_serdes 
        Port map( 
                CLK => clk1p_int,
                RST => rst,
                DATAP => Q1_int,
                DATAN => Q2_int,
                Q    => DataOut_int
               );
    
    
    FCLKDES : Q_iddr_serdes 
        Port map( 
                CLK     => clk1p_int,
                RST     => rst,
                DATAP   => F1_int,
                DATAN   => F2_int,
                Q       => FCLKOut_int
               );
               
               
    data_fifo_process : fifo_serdes 
      Port map(
                clk        =>  clk1n_int,
                rst        =>  RST,
                Q_in       =>  dataOut_int,
                Q_out      =>  datafifo_out
             );
               
    
    fclk_fifo_process : fifo_serdes 
      Port map(
                clk        =>  clk1n_int,
                rst        =>  RST,
                Q_in       =>  FCLKOUT_INT,
                Q_out      =>  fclkfifo_out
             );
    
      data_out <= datafifo_out when fclkfifo_out = "11111110000000";
       
end Behavioral;
