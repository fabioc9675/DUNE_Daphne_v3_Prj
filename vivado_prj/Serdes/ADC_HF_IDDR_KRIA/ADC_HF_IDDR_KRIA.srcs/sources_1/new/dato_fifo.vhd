----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.02.2025 10:13:55
-- Design Name: 
-- Module Name: dato_fifo - Behavioral
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

entity dato_fifo is
  Port (CLKN         : in std_logic;
        RST         : in std_logic;
        Q_in        : in std_logic_vector(13 downto 0);
        Q_out       : out std_logic_vector(13 downto 0)
         );
end dato_fifo;

architecture Behavioral of dato_fifo is

begin


FDRE_Q0 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(0), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(0), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q1 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(1), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(1), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q2 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(2), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(2), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q3 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(3), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(3), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q4 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(4), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(4), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q5 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(5), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(5), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q6 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(6), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(6), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q7 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(7), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(7), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q8 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(8), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(8), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q9 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(9), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(9), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q10 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(10), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(10), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q11 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(11), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(11), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q12 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(12), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(12), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

FDRE_Q13 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q_out(13), -- 1-bit output: Data
C => CLKN, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q_in(13), -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

end Behavioral;
