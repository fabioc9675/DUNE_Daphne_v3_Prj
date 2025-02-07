----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
--
-- Create Date: 06.02.2025 22:45:38
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.ALL;

entity fifo_serdes is
    Port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        Q_in     : in  std_logic_vector(13 downto 0);
        Q_out    : out std_logic_vector(13 downto 0)  
         );
end fifo_serdes;

architecture Behavioral of fifo_serdes is

begin

   -- FDRE: D Flip-Flop with Clock Enable and Synchronous Reset
   --       Kintex UltraScale+
   -- Xilinx HDL Language Template, version 2022.2

   FDRE_Q0 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(0),    -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(0),     -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q1 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(1),    -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(1),     -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q2 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(2),    -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(2),     -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q3 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(3),    -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(3),     -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q4 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(4),    -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(4),     -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q5 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(5),    -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(5),     -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q6 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(6),    -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(6),     -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q7 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(7),    -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(7),     -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q8 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(8),    -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(8),     -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q9 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(9),    -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(9),     -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q10 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(10),   -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(10),    -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q11 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(11),   -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(11),    -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q12 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(12),   -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(12),    -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
   FDRE_Q13 : FDRE
   generic map (
      INIT => '0',          -- Initial value of register, '0', '1'
      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D_INVERTED => '0', -- Optional inversion for D
      IS_R_INVERTED => '0'  -- Optional inversion for R
   )
   port map (
      Q => Q_out(13),   -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q_in(13),    -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   
--   FDRE_Q14 : FDRE
--   generic map (
--      INIT => '0',          -- Initial value of register, '0', '1'
--      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
--      IS_C_INVERTED => '0', -- Optional inversion for C
--      IS_D_INVERTED => '0', -- Optional inversion for D
--      IS_R_INVERTED => '0'  -- Optional inversion for R
--   )
--   port map (
--      Q => Q_out(14),   -- 1-bit output: Data
--      C => clk,         -- 1-bit input: Clock
--      CE => '1',        -- 1-bit input: Clock enable
--      D => Q_in(14),    -- 1-bit input: Data
--      R => rst          -- 1-bit input: Synchronous reset
--   );
   
   
--   FDRE_Q15 : FDRE
--   generic map (
--      INIT => '0',          -- Initial value of register, '0', '1'
--      -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
--      IS_C_INVERTED => '0', -- Optional inversion for C
--      IS_D_INVERTED => '0', -- Optional inversion for D
--      IS_R_INVERTED => '0'  -- Optional inversion for R
--   )
--   port map (
--      Q => Q_out(15),   -- 1-bit output: Data
--      C => clk,         -- 1-bit input: Clock
--      CE => '1',        -- 1-bit input: Clock enable
--      D => Q_in(15),    -- 1-bit input: Data
--      R => rst          -- 1-bit input: Synchronous reset
--   );
   
   -- End of FDRE_inst instantiation

end Behavioral;
