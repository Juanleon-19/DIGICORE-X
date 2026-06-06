LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Complement_TWO IS

    GENERIC(
        MAX_WIDTH : INTEGER := 9
    );

    PORT(
        A : IN  STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
        Y : OUT STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE structure OF Complement_TWO IS

    SIGNAL An : STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
    SIGNAL c  : STD_LOGIC_VECTOR(MAX_WIDTH DOWNTO 0);

BEGIN

    An <= NOT A;

    c(0) <= '1';

    GEN_COMP2 : FOR i IN 0 TO MAX_WIDTH-1 GENERATE

        Y(i) <= An(i) XOR c(i);
        c(i+1) <= An(i) AND c(i);

    END GENERATE;

END ARCHITECTURE;