LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_PI_Digital IS
END ENTITY;

ARCHITECTURE sim OF tb_PI_Digital IS

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '1';

    SIGNAL Tick_Control : STD_LOGIC := '0';

    SIGNAL Referencia :
        STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL DeltaP :
        STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL Potencia :
        STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN

    DUT : ENTITY work.PI_Digital
    PORT MAP(

        clk => clk,
        rst => rst,

        Tick_Control => Tick_Control,

        Referencia => Referencia,

        

        Potencia => Potencia

    );

    --------------------------------------------------
    -- CLOCK
    --------------------------------------------------

    clk <= NOT clk AFTER 10 ns;

    --------------------------------------------------
    -- TICK 40 ms ACELERADO
    --------------------------------------------------

    PROCESS
    BEGIN

        WAIT FOR 1 us;

        Tick_Control <= '1';

        WAIT FOR 20 ns;

        Tick_Control <= '0';

    END PROCESS;

    --------------------------------------------------
    -- ESTIMULOS
    --------------------------------------------------

    PROCESS
    BEGIN

        WAIT FOR 100 ns;

        rst <= '0';

        --------------------------------------------------
        -- REFERENCIA = 20
        --------------------------------------------------

        Referencia <=
        STD_LOGIC_VECTOR(
            TO_SIGNED(20,32)
        );

        --------------------------------------------------
        -- MOTOR PARADO
        --------------------------------------------------

        DeltaP <=
        STD_LOGIC_VECTOR(
            TO_SIGNED(0,32)
        );

        WAIT FOR 100 us;

        --------------------------------------------------
        -- EMPIEZA A ACELERAR
        --------------------------------------------------

        DeltaP <=
        STD_LOGIC_VECTOR(
            TO_SIGNED(5,32)
        );

        WAIT FOR 100 us;

        DeltaP <=
        STD_LOGIC_VECTOR(
            TO_SIGNED(10,32)
        );

        WAIT FOR 100 us;

        DeltaP <=
        STD_LOGIC_VECTOR(
            TO_SIGNED(15,32)
        );

        WAIT FOR 100 us;

        DeltaP <=
        STD_LOGIC_VECTOR(
            TO_SIGNED(20,32)
        );

        WAIT FOR 100 us;

        --------------------------------------------------
        -- SOBREPASA
        --------------------------------------------------

        DeltaP <=
        STD_LOGIC_VECTOR(
            TO_SIGNED(25,32)
        );

        WAIT FOR 100 us;

        --------------------------------------------------
        -- VUELVE
        --------------------------------------------------

        DeltaP <=
        STD_LOGIC_VECTOR(
            TO_SIGNED(20,32)
        );

        WAIT FOR 100 us;

        WAIT;

    END PROCESS;

END ARCHITECTURE;