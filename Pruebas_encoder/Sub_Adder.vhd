LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Sub_Adder IS
GENERIC(
    N : INTEGER := 32
);
PORT(
    A   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    B   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    SEL : IN  STD_LOGIC;
    R   : OUT STD_LOGIC_VECTOR(N DOWNTO 0)
);
END ENTITY;

ARCHITECTURE structure OF Sub_Adder IS

SIGNAL Bx : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL C  : STD_LOGIC_VECTOR(N DOWNTO 0);

BEGIN

    C(0) <= SEL;

    GEN_BX :
    FOR i IN 0 TO N-1 GENERATE
    BEGIN

        Bx(i) <= B(i) XOR SEL;

    END GENERATE;

    GEN_FA :
    FOR i IN 0 TO N-1 GENERATE
    BEGIN

        FA : ENTITY work.FullAdder
        PORT MAP(
            X     => A(i),
            Y     => Bx(i),
            C_IN  => C(i),
            S     => R(i),
            C_OUT => C(i+1)
        );

    END GENERATE;

    R(N) <= C(N) XOR SEL;

END ARCHITECTURE;