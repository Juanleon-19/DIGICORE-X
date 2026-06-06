LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Control_Motor IS
PORT(

    CLK : IN STD_LOGIC;
    RST : IN STD_LOGIC;

    SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);

    ENC_A : IN STD_LOGIC;
    ENC_B : IN STD_LOGIC;

    IN1 : OUT STD_LOGIC;
    IN2 : OUT STD_LOGIC

);
END ENTITY;

ARCHITECTURE rtl OF Control_Motor IS

    SIGNAL Referencia : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL RPM : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL RPM_EXT : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL Posicion : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL Potencia : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL Tick_Control : STD_LOGIC;

BEGIN


Referencia <= STD_LOGIC_VECTOR(
                  TO_SIGNED(
                      -30,
                      32
                  )
              );

    --------------------------------------------------
    -- ENCODER
    --------------------------------------------------

    ENCODER : ENTITY work.Encoder_Completo
    PORT MAP(

        clk => CLK,
        rst => RST,

        ENC_A => ENC_A,
        ENC_B => ENC_B,

        Posicion_Continua => Posicion,

        RPM => RPM,

        Tick_40ms => Tick_Control

    );

    --------------------------------------------------
    -- EXTENDER RPM A 32 BITS
    --------------------------------------------------

    RPM_EXT <= STD_LOGIC_VECTOR(
                   TO_SIGNED(
                       TO_INTEGER(
                           UNSIGNED(RPM)
                       ),
                       32
                   )
               );

    --------------------------------------------------
    -- CONTROLADOR PI
    --------------------------------------------------

    CONTROLADOR : ENTITY work.PI_Digital
    PORT MAP(

        clk => CLK,
        rst => RST,

        Tick_Control => Tick_Control,

        Referencia => Referencia,

        RPM => RPM_EXT,

        Potencia => Potencia

    );

    --------------------------------------------------
    -- PWM
    --------------------------------------------------

    PWM : ENTITY work.PWM_MOTOR_CONTROLLER
    PORT MAP(

        CLK => CLK,
        RST => RST,

        POTENCIA => Potencia,

        IN1 => IN1,
        IN2 => IN2

    );

END ARCHITECTURE;