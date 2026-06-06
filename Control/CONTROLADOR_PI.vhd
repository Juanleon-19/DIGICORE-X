LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PI_Digital IS
PORT(

    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;

    Tick_Control : IN STD_LOGIC;

    Referencia : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    DeltaP     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    Potencia   : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)

);
END ENTITY;

ARCHITECTURE rtl OF PI_Digital IS

    SIGNAL e_actual   : INTEGER;
    SIGNAL e_anterior : INTEGER := 0;

    SIGNAL u_actual   : INTEGER := 0;
    SIGNAL u_anterior : INTEGER := 0;

BEGIN

PROCESS(clk,rst)

    VARIABLE temp : INTEGER;

BEGIN

    IF rst='1' THEN

        e_anterior <= 0;

        u_anterior <= 0;

        u_actual <= 0;

    ELSIF rising_edge(clk) THEN

        IF Tick_Control='1' THEN

            e_actual <=
                to_integer(signed(Referencia))
                -
                to_integer(signed(DeltaP));

            temp :=
                u_anterior
                +
                (
                    595 *
                    (
                        to_integer(signed(Referencia))
                        -
                        to_integer(signed(DeltaP))
                    )
                    -
                    398 *
                    e_anterior
                ) / 1024;

            IF temp > 255 THEN

                temp := 255;

            ELSIF temp < -255 THEN

                temp := -255;

            END IF;

            u_actual <= temp;

            u_anterior <= temp;

            e_anterior <=
                to_integer(signed(Referencia))
                -
                to_integer(signed(DeltaP));

        END IF;

    END IF;

END PROCESS;

Potencia <=
    STD_LOGIC_VECTOR(
        to_signed(u_actual,9)
    );

END ARCHITECTURE;	