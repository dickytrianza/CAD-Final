library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX3 is
    generic (N: integer);  -- Generic parameter for vector size
    port (
        I1: in std_ulogic_vector((N-1) downto 0);  -- Input vector 1
        I2: in std_ulogic_vector((N-1) downto 0);  -- Input vector 2
        I3: in std_ulogic_vector((N-1) downto 0);  -- Input vector 3
        C1: in std_ulogic_vector(1 downto 0);      -- Control signal (2-bit)
        O1: out std_ulogic_vector((N-1) downto 0)  -- Output vector
    );
end MUX3;

architecture MUX1 of MUX3 is
    -- Signals to hold input vectors and control signal
    signal D1: std_ulogic_vector((N-1) downto 0) := (others => '0');
    signal D2: std_ulogic_vector((N-1) downto 0) := (others => '0');
    signal D3: std_ulogic_vector((N-1) downto 0) := (others => '0');
    signal D4: std_ulogic_vector(1 downto 0) := (others => '0');
    -- Signal to hold selected output vector
    signal R1: std_ulogic_vector((N-1) downto 0) := (others => '0');
begin
    -- Assign input vectors and control signal to internal signals
    D1 <= I1;
    D2 <= I2;
    D3 <= I3;
    D4 <= C1;

    -- Select output based on control signal
    R1 <= D1 when D4 = "00" else  -- Select input vector 1 when control signal is "00"
          D2 when D4 = "01" else  -- Select input vector 2 when control signal is "01"
          D3;                     -- Select input vector 3 when control signal is "10"

    -- Assign selected output vector to output port
    O1 <= R1;
end MUX1;
