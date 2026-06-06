-- ============================================================
-- TESTBENCH: tb_Control_Motor
-- Prueba el sistema completo: Encoder + PI + PWM
-- ============================================================

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_Control_Motor IS
END ENTITY;

ARCHITECTURE sim OF tb_Control_Motor IS

    --------------------------------------------------------
    -- Constantes de Simulacion
    --------------------------------------------------------
    CONSTANT CLK_PERIOD : TIME := 20 ns;   -- 50 MHz

    --------------------------------------------------------
    -- Senales del DUT
    --------------------------------------------------------
    SIGNAL CLK   : STD_LOGIC := '0';
    SIGNAL RST   : STD_LOGIC := '1';
    SIGNAL SW    : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ENC_A : STD_LOGIC := '0';
    SIGNAL ENC_B : STD_LOGIC := '0';
    SIGNAL IN1   : STD_LOGIC;
    SIGNAL IN2   : STD_LOGIC;

    --------------------------------------------------------
    -- Senales de monitoreo internas (para observar en sim)
    --------------------------------------------------------
    SIGNAL sim_paso : INTEGER := 0;

BEGIN

    --------------------------------------------------------
    -- DUT: Device Under Test
    --------------------------------------------------------
    DUT : ENTITY work.Control_Motor
    PORT MAP(
        CLK   => CLK,
        RST   => RST,
        SW    => SW,
        ENC_A => ENC_A,
        ENC_B => ENC_B,
        IN1   => IN1,
        IN2   => IN2
    );

    --------------------------------------------------------
    -- Generador de Reloj: 50 MHz
    --------------------------------------------------------
    CLK <= NOT CLK AFTER CLK_PERIOD / 2;

    --------------------------------------------------------
    -- Proceso: Generador de Encoder Cuadratura
    -- Simula un motor girando hacia adelante
    -- Secuencia AB: 00 -> 01 -> 11 -> 10 -> 00 ...
    --------------------------------------------------------
    ENCODER_FWD : PROCESS

        -- Periodo de una fase del encoder (ajustable)
        CONSTANT ENC_PERIOD : TIME := 1 us;

    BEGIN

        -- Espera hasta que el reset termina
        WAIT UNTIL RST = '0';
        WAIT FOR 500 ns;

        -- Genera pulsos de encoder hacia adelante
        LOOP

            -- Estado 00
            ENC_A <= '0'; ENC_B <= '0';
            WAIT FOR ENC_PERIOD;

            -- Estado 01
            ENC_A <= '0'; ENC_B <= '1';
            WAIT FOR ENC_PERIOD;

            -- Estado 11
            ENC_A <= '1'; ENC_B <= '1';
            WAIT FOR ENC_PERIOD;

            -- Estado 10
            ENC_A <= '1'; ENC_B <= '0';
            WAIT FOR ENC_PERIOD;

        END LOOP;

    END PROCESS;

    --------------------------------------------------------
    -- Proceso: Estimulo Principal
    --------------------------------------------------------
    STIMULUS : PROCESS
    BEGIN

        ------------------------------------------------
        -- PASO 0: Reset inicial
        ------------------------------------------------
        sim_paso <= 0;
        RST <= '1';
        SW  <= (OTHERS => '0');
        WAIT FOR 200 ns;

        RST <= '0';
        WAIT FOR 500 ns;

        ------------------------------------------------
        -- PASO 1: Referencia = 0 (sin movimiento)
        ------------------------------------------------
        sim_paso <= 1;
        SW <= "0000000000";    -- Referencia = 0
        WAIT FOR 10 ms;

        ------------------------------------------------
        -- PASO 2: Referencia = 100
        ------------------------------------------------
        sim_paso <= 2;
        SW <= "0001100100";    -- Referencia = 100
        WAIT FOR 40 ms;

        ------------------------------------------------
        -- PASO 3: Referencia = 200
        ------------------------------------------------
        sim_paso <= 3;
        SW <= "0011001000";    -- Referencia = 200
        WAIT FOR 40 ms;

        ------------------------------------------------
        -- PASO 4: Referencia = 511 (maximo positivo)
        ------------------------------------------------
        sim_paso <= 4;
        SW <= "0111111111";    -- Referencia = 511
        WAIT FOR 40 ms;

        ------------------------------------------------
        -- PASO 5: Referencia = 50 (baja referencia)
        ------------------------------------------------
        sim_paso <= 5;
        SW <= "0000110010";    -- Referencia = 50
        WAIT FOR 40 ms;

        ------------------------------------------------
        -- PASO 6: Reset en caliente
        ------------------------------------------------
        sim_paso <= 6;
        RST <= '1';
        WAIT FOR 200 ns;
        RST <= '0';
        WAIT FOR 10 ms;

        ------------------------------------------------
        -- PASO 7: Referencia = 150 tras reset
        ------------------------------------------------
        sim_paso <= 7;
        SW <= "0010010110";    -- Referencia = 150
        WAIT FOR 40 ms;

        ------------------------------------------------
        -- FIN de la simulacion
        ------------------------------------------------
        sim_paso <= 99;
        REPORT "=== SIMULACION COMPLETADA ===" SEVERITY NOTE;
        WAIT;

    END PROCESS;

    --------------------------------------------------------
    -- Proceso: Monitor de Salidas
    -- Reporta cambios en IN1 e IN2 en consola
    --------------------------------------------------------
    MONITOR : PROCESS(IN1, IN2)
    BEGIN

        REPORT
            "Paso=" & INTEGER'IMAGE(sim_paso) &
            " | IN1=" & STD_LOGIC'IMAGE(IN1) &
            " | IN2=" & STD_LOGIC'IMAGE(IN2)
        SEVERITY NOTE;

    END PROCESS;

END ARCHITECTURE;
