LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY STD;
USE STD.textio.ALL;

ENTITY IM IS
	GENERIC (N : INTEGER);
	PORT (
		I1 : IN STD_ULOGIC_VECTOR(31 DOWNTO 0); -- The current PC
		O1 : OUT STD_ULOGIC_VECTOR(31 DOWNTO 0)); -- Return the instruction as the output
END IM;

ARCHITECTURE IM1 OF IM IS
	TYPE MEMORY IS ARRAY (0 TO (N - 1)) OF STD_ULOGIC_VECTOR(31 DOWNTO 0); -- N*4 byte memory, byte-addressable
	SIGNAL M1 : MEMORY := (OTHERS => (OTHERS => '0')); -- memory array contains the instruction
	SIGNAL D1 : STD_ULOGIC_VECTOR(29 DOWNTO 0) := (OTHERS => '0'); -- addressing within the memory
	SIGNAL R1 : STD_ULOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0'); -- output data instruction
BEGIN
	D1 <= I1(31 DOWNTO 2); -- word aligned, divide the PC by 4 to get the same index with the memory address

	-- Define the instruction for the memory
	M1(0) <= x"00000000";
	M1(1) <= x"00000000";
	M1(2) <= x"00000000";
	M1(3) <= x"00000000";
	M1(4) <= x"06000002";
	M1(5) <= x"04010002";
	M1(6) <= x"04220002";
	M1(7) <= x"04430002";
	M1(8) <= x"0FE30000";
	M1(9) <= x"04640002";
	M1(10) <= x"04850002";
	M1(11) <= x"04A60002";
	M1(12) <= x"04C70002";
	M1(13) <= x"0AA80000";
	M1(14) <= x"81074800";
	M1(15) <= x"0AAA0001";
	M1(16) <= x"0FE30021";
	M1(17) <= x"0FE40041";
	-- M1(18) <= x"0AEB0001";

	-- Check whether the PC is included in the memory address
	-- If it is yes, it will return the specific instruction within that memory based on the PC index
	-- Otherwise, it will return an invalid instruction, that is a 32-bit where all of its values is -1
	R1 <= M1(to_integer(unsigned(D1))) WHEN to_integer(unsigned(D1)) < (N - 1) ELSE
		STD_ULOGIC_VECTOR(to_signed(-1, 32)) WHEN to_integer(unsigned(D1)) > (N - 1);

	-- Assign the output value
	O1 <= R1;
END IM1;