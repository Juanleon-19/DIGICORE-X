LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY TEST_GPIO IS

    PORT(
        CLK : IN STD_LOGIC;
        OUT1 : OUT STD_LOGIC
    );

END ENTITY;

ARCHITECTURE rtl OF TEST_GPIO IS

    SIGNAL contador : STD_LOGIC_VECTOR(25 DOWNTO 0);

BEGIN

    PROCESS(CLK)
    BEGIN

        IF rising_edge(CLK) THEN

            contador <= contador + 1;

        END IF;

    END PROCESS;

    OUT1 <= contador(10);

END ARCHITECTURE;