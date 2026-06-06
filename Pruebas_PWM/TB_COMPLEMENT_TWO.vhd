LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TB_COMPLEMENT_TWO IS
END ENTITY;

ARCHITECTURE TB OF TB_COMPLEMENT_TWO IS

    SIGNAL A : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL Y : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN

    DUT : ENTITY work.Complement_TWO
    GENERIC MAP(
        MAX_WIDTH => 9
    )
    PORT MAP(
        A => A,
        Y => Y
    );

    PROCESS
    BEGIN

        A <= "000000001";
        WAIT FOR 100 ns;

        A <= "111111111";
        WAIT FOR 100 ns;

        A <= "000000101";
        WAIT FOR 100 ns;

        A <= "111111011";
        WAIT FOR 100 ns;

        A <= "011111111";
        WAIT FOR 100 ns;

        A <= "100000001";
        WAIT FOR 100 ns;

        WAIT;

    END PROCESS;

END ARCHITECTURE;