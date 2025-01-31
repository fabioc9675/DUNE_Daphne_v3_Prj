----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 22:26:55
-- Design Name: 
-- Module Name: ensayo - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ensayo is
  Port (IntPatternA          : out std_logic_vector(7 downto 0);
        IntPatternB          : out std_logic_vector(7 downto 0);
        IntPatternC          : out std_logic_vector(7 downto 0);
        IntPatternD          : out std_logic_vector(7 downto 0)
        
   );
end ensayo;

architecture Behavioral of ensayo is

--function str_to_stdlvec(Inp: string) return std_logic_vector is
--	variable Temp : std_logic_vector(Inp'range) := (others => 'X');
--	begin
--		for i in Inp'range loop
--			if (Inp(i) = '1') then
--				Temp(i) := '1';
--			elsif (Inp(i) = '0') then
--				Temp(i) := '0';
--			end if;
--		end loop;
--	return Temp;
--	end function str_to_stdlvec;
	
function SymChck (Inp: std_logic_vector) return std_logic is
	variable Temp : std_logic_vector((Inp'left-1)/2 downto 0) := (others => '0');
	variable Sym : std_logic := '0';
	begin
		for n in (Inp'left-1)/2 downto 0 loop
			Temp(n) := Inp((n*2)+1) xor Inp(n*2);
			Sym := Temp(n) or Sym;
		end loop;
		assert false
		report CR & " Pattern XORed/ORed = " & stdlvec_to_str(Temp) & CR
		severity note;
	return Sym;
	end function SymChck;	
	
function BitShft(Inp: std_logic_vector; Wire: integer) return std_logic_vector is
	variable Temp : std_logic_vector(Inp'range):= (others => '0');
	begin
-- Bit shift all bits.
-- Example: 16-bit frame word = 11111111_00000000 or 00000000_11110000
-- After shifting the word returned looks as: 11111110_00000001 and 00000000_01111000
		if (SymChck(Inp) = '0') then
			if (Wire = 1 ) then		-- 1-wire, shift 15-bits
				for n in Inp'left downto 0 loop
					if (n /= 0) then
						Temp(n) := Inp(n-1);
					elsif (n = 0) then
						Temp(Temp'right) := Inp(Inp'left);
					end if;
				end loop;
			else -- (Wire = 2)		-- 2-wire, shift 8-bits
				for n in (Inp'left-8) downto 0 loop
					if (n /= 0) then
						Temp(n) := Inp(n-1);
					elsif (n = 0) then
						Temp(Temp'right) := Inp(Inp'left-8);
					end if;
				end loop;
			end if;
		elsif (SymChck(Inp) = '1') then
		-- Don't do anything, return the word as it came in.
			Temp := Inp;
		end if;
		--
		assert false
		report	CR &
				" Pattern Shifted = " & stdlvec_to_str(Temp) & CR &
				" Comparator Value A = " & stdlvec_to_str(Temp(15 downto 8)) & CR &
				" Comparator Value B = " & stdlvec_to_str(Temp(7 downto 0)) & CR
		severity note;
	return Temp;
	end function BitShft;
	
	function BitSwap(Inp: std_logic_vector) return std_logic_vector is
	variable Temp : std_logic_vector(Inp'range);
	begin
		for n in (Inp'left-1)/2 downto 0 loop
			Temp((n*2)+1) := Inp(n*2);
			Temp(n*2) := Inp((n*2)+1);
		end loop;
		assert false
		report CR &
				" Pattern Bit Swapped = " & stdlvec_to_str(Temp) & CR &
				" Comparator Value C = " & stdlvec_to_str(Temp(15 downto 8)) & CR &
				" Comparator Value D = " & stdlvec_to_str(Temp(7 downto 0))	& CR
		severity note;
	return Temp;
	end function BitSwap;	

--constant IntPattern	: std_logic_vector(15 downto 0)	:= str_to_stdlvec("0000000011110000");
constant IntPattern	: std_logic_vector(15 downto 0)	:= "0000000011110000";
constant IntPatternBitShifted : std_logic_vector(15 downto 0)	:= BitShft(IntPattern, 1);
constant IntPatternBitSwapped : std_logic_vector(15 downto 0)	:= BitSwap(IntPatternBitShifted);
begin

IntPatternA <= IntPatternBitShifted(15 downto 8);
IntPatternB <= IntPatternBitShifted(7 downto 0);
IntPatternC <= IntPatternBitSwapped(15 downto 8);
IntPatternD <= IntPatternBitSwapped(7 downto 0);

end Behavioral;
