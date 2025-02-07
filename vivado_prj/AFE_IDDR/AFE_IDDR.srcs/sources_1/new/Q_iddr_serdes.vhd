----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.02.2025 23:01:09
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.VComponents.ALL;


entity Q_iddr_serdes is
    Port ( 
        clk        : in  std_logic;
        rst        : in  std_logic;
        datap      : in  std_logic;
        datan      : in  std_logic;
        Q          : out std_logic_vector(13 downto 0)    
         );
end Q_iddr_serdes;

architecture Behavioral of Q_iddr_serdes is

    signal Q00            : std_logic;
    signal Q01            : std_logic;
    signal Q02            : std_logic;
    signal Q03            : std_logic;
    signal Q04            : std_logic;
    signal Q05            : std_logic;
    signal Q06            : std_logic;
    signal Q07            : std_logic;
    signal Q08            : std_logic;
    signal Q09            : std_logic;
    signal Q10            : std_logic;
    signal Q11            : std_logic;
    signal Q12            : std_logic;
    signal Q13            : std_logic;
--    signal Q14            : std_logic;
--    signal Q15            : std_logic;

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
      Q => Q00,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => datap,       -- 1-bit input: Data
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
      Q => Q01,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => datan,       -- 1-bit input: Data
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
      Q => Q02,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q00,         -- 1-bit input: Data
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
      Q => Q03,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q01,         -- 1-bit input: Data
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
      Q => Q04,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q02,         -- 1-bit input: Data
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
      Q => Q05,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q03,         -- 1-bit input: Data
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
      Q => Q06,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q04,         -- 1-bit input: Data
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
      Q => Q07,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q05,         -- 1-bit input: Data
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
      Q => Q08,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q06,         -- 1-bit input: Data
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
      Q => Q09,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q07,         -- 1-bit input: Data
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
      Q => Q10,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q08,         -- 1-bit input: Data
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
      Q => Q11,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q09,         -- 1-bit input: Data
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
      Q => Q12,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q10,         -- 1-bit input: Data
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
      Q => Q13,         -- 1-bit output: Data
      C => clk,         -- 1-bit input: Clock
      CE => '1',        -- 1-bit input: Clock enable
      D => Q11,         -- 1-bit input: Data
      R => rst          -- 1-bit input: Synchronous reset
   );
   
   -- End of FDRE_inst instantiation
   
   
   -- logica de direccionamiento de datos
   Q(0)  <= Q01;
   Q(1)  <= Q00;
   Q(2)  <= Q03;
   Q(3)  <= Q02;
   Q(4)  <= Q05;
   Q(5)  <= Q04;
   Q(6)  <= Q07;
   Q(7)  <= Q06;
   Q(8)  <= Q09;
   Q(9)  <= Q08;
   Q(10) <= Q11;
   Q(11) <= Q10;
   Q(12) <= Q13;
   Q(13) <= Q12;

end Behavioral;
