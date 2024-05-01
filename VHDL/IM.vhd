--**********************
--*                    *
--*                    *
--*	   ---         *
--*	--|(0)|---     *
--*	  |---|        *
--*	--|(1)|---     *
--*       |---|        *
--*	--|(2)|-->     *
--*	  |---|        *
--*         .          *
--          .          *
--*	               *
--**********************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library STD;
use STD.textio.all;

entity IM is
generic(N: integer);
port(I1: in std_ulogic_vector(31 downto 0);
     O1: out std_ulogic_vector(31 downto 0));
end IM;

architecture IM1 of IM is
type MEMORY is array (0 to (N-1)) of std_ulogic_vector(31 downto 0); --N*4 byte memory
signal M1: MEMORY := (others => (others => '0'));
signal D1: std_ulogic_vector(29 downto 0) := (others => '0');
signal R1: std_ulogic_vector(31 downto 0) := (others => '0');
begin
	D1 <= I1(31 downto 2); --PC/4	

	M1(0) <=  x"00000000";
	M1(1) <= x"00000000";
	M1(2) <= x"00000000";
	M1(3) <= x"00000000";
    M1(4) <= x"00000110";
	M1(5) <= x"00000010"; 
	M1(6) <= x"00001010"; 
	M1(7) <= x"00001100";
    M1(8) <= x"11111100"; 
	M1(9) <= x"00011001"; 
	M1(10) <= x"00010001"; 
	M1(11) <= x"00100001";
    M1(12) <= x"00110001"; 
	M1(13) <= x"10101010"; 
	M1(14) <= x"80037100"; 
	M1(15) <= x"AA555001";
	M1(16) <= x"7E430021"; 
	M1(17) <= x"7E401021";
	M1(18) <= x"5D5B0001";

	R1 <= M1(to_integer(unsigned(D1))) when to_integer(unsigned(D1)) < (N-1) else
	      std_ulogic_vector(to_signed(-1, 32)) when to_integer(unsigned(D1)) > (N-1);
	
	O1 <= R1;
end IM1;
