library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SL is
    generic (
        N, M: integer  -- Generic parameters specifying the sizes of input and output vectors
    );
    port (
        I1: in std_ulogic_vector((N-1) downto 0);     -- Input vector
        O1: out std_ulogic_vector((M-1) downto 0)     -- Output vector
    );
end SL;

architecture SL1 of SL is
    signal D1: unsigned((N-1) downto 0) := (others => '0');  -- Signal to hold the unsigned version of the input vector
    signal R1: unsigned((M-1) downto 0) := (others => '0');  -- Signal to hold the result of the shift operation
begin
    D1 <= unsigned(I1);  -- Convert input vector to unsigned
    
    -- Shift left operation based on the comparison of input (N) and output (M) vector sizes
    R1 <= D1 & to_unsigned(0, M-N) when N < M else  -- Shift and pad with zeros if N < M
          D1((M-1) downto 0) when N > M else       -- Truncate if N > M
          D1;                                       -- No operation if N = M

    O1 <= std_ulogic_vector(R1);  -- Convert result back to std_ulogic_vector and assign to the output port
end SL1;
