LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PI_Digital IS
PORT(

    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;

    Tick_Control : IN STD_LOGIC;

    Referencia : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    RPM        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    Potencia   : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)

);
END ENTITY;

ARCHITECTURE rtl OF PI_Digital IS

    SIGNAL e_anterior : INTEGER := 0;
    SIGNAL u_anterior : INTEGER := 0;
    SIGNAL potencia_s : INTEGER := 0;

BEGIN

PROCESS(clk,rst)

    VARIABLE e_actual : INTEGER;
    VARIABLE control  : INTEGER;

BEGIN

    IF rst='1' THEN

        e_anterior <= 0;
        u_anterior <= 0;
        potencia_s <= 0;

    ELSIF rising_edge(clk) THEN

        IF Tick_Control='1' THEN

e_actual :=
TO_INTEGER(SIGNED(Referencia))
-
TO_INTEGER(SIGNED(RPM));

            control :=
                u_anterior
                +
                (
                    (6421 * e_actual)
                    -
                    (3258 * e_anterior)
                ) / 1000;

            IF control > 255 THEN

                control := 255;

            ELSIF control < -255 THEN

                control := -255;

            END IF;

            -- Zona muerta estilo Arduino

            IF control > 0 AND control < 25 THEN

                control := 25;

            ELSIF control < 0 AND control > -25 THEN

                control := -25;

            END IF;

            -- Si referencia es cero, detener

            IF TO_INTEGER(SIGNED(Referencia)) = 0 THEN

                control := 0;

            END IF;

            potencia_s <= control;

            u_anterior <= control;

            e_anterior <= e_actual;

        END IF;

    END IF;

END PROCESS;

Potencia <= STD_LOGIC_VECTOR(TO_SIGNED(potencia_s,9));

END ARCHITECTURE;