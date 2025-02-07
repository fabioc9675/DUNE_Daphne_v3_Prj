----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.02.2025 21:05:43
-- Design Name: 
-- Module Name: Q_IDDR_DESERIAL - Behavioral
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

entity Q_IDDR_DESERIAL is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DATAP : in STD_LOGIC;
           DATAN : in STD_LOGIC;
           Q    : out std_logic_vector(13 downto 0)
           );
end Q_IDDR_DESERIAL;

architecture Behavioral of Q_IDDR_DESERIAL is
signal Q0           : std_logic;
signal Q1           : std_logic;
signal Q2           : std_logic;
signal Q3           : std_logic;
signal Q4           : std_logic;
signal Q5           : std_logic;
signal Q6           : std_logic;
signal Q7           : std_logic;
signal Q8           : std_logic;
signal Q9           : std_logic;
signal Q10           : std_logic;
signal Q11           : std_logic;
signal Q12           : std_logic;
signal Q13           : std_logic;

begin

-- FDRE: D Flip-Flop with Clock Enable and Synchronous Reset
-- UltraScale
-- Xilinx HDL Language Template, version 2021.2
FDRE_Q0 : FDRE
generic map (
INIT => '0', -- Initial value of register, '0', '1'
IS_C_INVERTED => '0', -- Optional inversion for C
IS_D_INVERTED => '0', -- Optional inversion for D
IS_R_INVERTED => '0' -- Optional inversion for R
)
port map (
Q => Q0, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => DATAP, -- 1-bit input: Data
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
Q => Q1, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => DATAN, -- 1-bit input: Data
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
Q => Q2, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q0, -- 1-bit input: Data
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
Q => Q3, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q1, -- 1-bit input: Data
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
Q => Q4, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q2, -- 1-bit input: Data
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
Q => Q5, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q3, -- 1-bit input: Data
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
Q => Q6, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q4, -- 1-bit input: Data
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
Q => Q7, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q5, -- 1-bit input: Data
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
Q => Q8, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q6, -- 1-bit input: Data
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
Q => Q9, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q7, -- 1-bit input: Data
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
Q => Q10, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q8, -- 1-bit input: Data
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
Q => Q11, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q9, -- 1-bit input: Data
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
Q => Q12, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q10, -- 1-bit input: Data
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
Q => Q13, -- 1-bit output: Data
C => CLK, -- 1-bit input: Clock
CE => '1', -- 1-bit input: Clock enable
D => Q11, -- 1-bit input: Data
R => RST -- 1-bit input: Synchronous reset
);

Q(0) <= Q1;
Q(1) <= Q0;
Q(2) <= Q3;
Q(3) <= Q2;
Q(4) <= Q5;
Q(5) <= Q4;
Q(6) <= Q7;
Q(7) <= Q6;
Q(8) <= Q9;
Q(9) <= Q8;
Q(10) <= Q11;
Q(11) <= Q10;
Q(12) <= Q13;
Q(13) <= Q12;

end Behavioral;
