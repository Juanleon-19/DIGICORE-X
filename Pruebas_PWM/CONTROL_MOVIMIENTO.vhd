LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CONTROL_MOVIMIENTO IS
PORT(

    CLK : IN STD_LOGIC;
    RST : IN STD_LOGIC;

    CMD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

    POT_M1 : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
    POT_M2 : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)

);
END ENTITY;

ARCHITECTURE rtl OF CONTROL_MOVIMIENTO IS

    TYPE state_type IS (
        STOP,
        ADELANTE,
        ATRAS,
        IZQUIERDA,
        DERECHA
    );

    SIGNAL state      : state_type;
    SIGNAL next_state : state_type;

    CONSTANT VEL_POS : STD_LOGIC_VECTOR(8 DOWNTO 0) := "010010110"; -- +150
    CONSTANT VEL_NEG : STD_LOGIC_VECTOR(8 DOWNTO 0) := "110101010"; -- -150
    CONSTANT VEL_0   : STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";

BEGIN


    PROCESS(CLK,RST)
    BEGIN

        IF RST='1' THEN

            state <= STOP;

        ELSIF rising_edge(CLK) THEN

            state <= next_state;

        END IF;

    END PROCESS;



    PROCESS(state,CMD)
    BEGIN

        next_state <= state;

        CASE CMD IS

            WHEN "000" =>
                next_state <= STOP;

            WHEN "001" =>
                next_state <= ADELANTE;

            WHEN "010" =>
                next_state <= ATRAS;

            WHEN "011" =>
                next_state <= IZQUIERDA;

            WHEN "100" =>
                next_state <= DERECHA;

            WHEN OTHERS =>
                next_state <= STOP;

        END CASE;

    END PROCESS;


    PROCESS(state)
    BEGIN

        CASE state IS

            WHEN STOP =>

                POT_M1 <= VEL_0;
                POT_M2 <= VEL_0;

            WHEN ADELANTE =>

                POT_M1 <= VEL_POS;
                POT_M2 <= VEL_POS;

            WHEN ATRAS =>

                POT_M1 <= VEL_NEG;
                POT_M2 <= VEL_NEG;

            WHEN IZQUIERDA =>

                POT_M1 <= VEL_NEG;
                POT_M2 <= VEL_POS;

            WHEN DERECHA =>

                POT_M1 <= VEL_POS;
                POT_M2 <= VEL_NEG;

        END CASE;

    END PROCESS;

END ARCHITECTURE;