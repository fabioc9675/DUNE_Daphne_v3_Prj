----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Fabian Castano
-- 
-- Create Date: 01.03.2025 21:44:37
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.VComponents.ALL;


entity iddr_data_fifo is
    Port (
            DCLK_PBufg        : in  std_logic;
            RST               : in  std_logic;
            Data              : in  std_logic;
            QLSB_Out          : out std_logic_vector(13 downto 0);
            QMSB_Out          : out std_logic_vector(13 downto 0)
         );
end iddr_data_fifo;

architecture Behavioral of iddr_data_fifo is

    signal  F01_IDDR          : std_logic;
    signal  F02_IDDR          : std_logic;
    signal  F00_FDCE          : std_logic;
    signal  F01_FDCE          : std_logic;
    signal  F02_FDCE          : std_logic;
    signal  F03_FDCE          : std_logic;
    signal  F04_FDCE          : std_logic;
    signal  F05_FDCE          : std_logic;
    signal  F06_FDCE          : std_logic;
    signal  F07_FDCE          : std_logic;
    signal  F08_FDCE          : std_logic;
    signal  F09_FDCE          : std_logic;
    signal  F10_FDCE          : std_logic;
    signal  F11_FDCE          : std_logic;
    signal  F12_FDCE          : std_logic;
    signal  F13_FDCE          : std_logic;
    signal  F14_FDCE          : std_logic;
    signal  F00_FDCE_SB       : std_logic;
    signal  F01_FDCE_SB       : std_logic;
    signal  F02_FDCE_SB       : std_logic;
    signal  F03_FDCE_SB       : std_logic;
    signal  F04_FDCE_SB       : std_logic;
    signal  F05_FDCE_SB       : std_logic;
    signal  F06_FDCE_SB       : std_logic;
    signal  F07_FDCE_SB       : std_logic;
    signal  F08_FDCE_SB       : std_logic;
    signal  F09_FDCE_SB       : std_logic;
    signal  F10_FDCE_SB       : std_logic;
    signal  F11_FDCE_SB       : std_logic;
    signal  F12_FDCE_SB       : std_logic;
    signal  F13_FDCE_SB       : std_logic;
    signal  F14_FDCE_SB       : std_logic;

begin


   -- IDDRE1: Dedicated Double Data Rate (DDR) Input Register
   --         Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   IDDRE1_inst : IDDRE1
   generic map (
      DDR_CLK_EDGE => "SAME_EDGE_PIPELINED", -- IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
      IS_CB_INVERTED => '1',                 -- Optional inversion for CB
      IS_C_INVERTED => '0'                   -- Optional inversion for C
   )
   port map (
      Q1 => F01_IDDR,     -- 1-bit output: Registered parallel output 1
      Q2 => F02_IDDR,     -- 1-bit output: Registered parallel output 2
      C => DCLK_PBufg,    -- 1-bit input: High-speed clock
      CB => DCLK_PBufg,   -- 1-bit input: Inversion of High-speed clock C
      D => Data,          -- 1-bit input: Serial Data Input
      R => RST            -- 1-bit input: Active-High Async Reset
   );
   -- End of IDDRE1_inst instantiation

   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_0 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F00_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F01_IDDR           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_1 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F01_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F02_IDDR           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation

   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_2 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F02_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F00_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation

   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_3 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F03_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F01_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation

   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_4 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F04_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F02_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation

   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_5 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F05_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F03_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation

   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_6 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F06_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F04_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
      -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_7 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F07_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F05_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
      -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_8 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F08_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F06_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
      -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_9 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F09_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F07_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
      -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_10 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F10_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F08_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
      -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_11 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F11_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F09_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
      -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_12 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F12_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F10_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_13 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F13_FDCE,          -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F11_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   -- %%%%%%%%%%%%%%%%                %%%%                 %%%%%%%%%%%%%
   -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_0 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F00_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F00_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_1 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F01_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F01_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_2 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F02_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F02_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_3 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F03_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F03_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_4 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F04_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F04_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_5 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F05_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F05_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_6 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F06_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F06_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_7 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F07_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F07_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_8 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F08_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F08_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_9 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F09_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F09_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_10 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F10_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F10_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_11 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F11_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F11_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_12 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F12_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F12_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   
   -- FDCE: D Flip-Flop with Clock Enable and Asynchronous Clear
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2
   FDCE_inst_FLSB_13 : FDCE
   generic map (
      INIT => '0',            -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_C_INVERTED => '1',   -- Optional inversion for C
      IS_D_INVERTED => '0'    -- Optional inversion for D
   )
   port map (
      Q => F13_FDCE_SB,       -- 1-bit output: Data
      C => DCLK_PBufg,        -- 1-bit input: Clock
      CE => '1',              -- 1-bit input: Clock enable
      CLR => RST,             -- 1-bit input: Asynchronous clear
      D => F13_FDCE           -- 1-bit input: Data
   );
   -- End of FDCE_inst instantiation
   
   -- Composition of data
   
    QLSB_out <=    F12_FDCE_SB & F13_FDCE_SB & F10_FDCE_SB & F11_FDCE_SB & F08_FDCE_SB & F09_FDCE_SB
                 & F06_FDCE_SB & F07_FDCE_SB & F04_FDCE_SB & F05_FDCE_SB & F02_FDCE_SB
                 & F03_FDCE_SB & F00_FDCE_SB & F01_FDCE_SB;
    QMSB_out <=    F01_FDCE_SB & F00_FDCE_SB & F03_FDCE_SB & F02_FDCE_SB & F05_FDCE_SB & F04_FDCE_SB
                 & F07_FDCE_SB & F06_FDCE_SB & F09_FDCE_SB & F08_FDCE_SB & F11_FDCE_SB 
                 & F10_FDCE_SB & F13_FDCE_SB & F12_FDCE_SB; 



end Behavioral;
