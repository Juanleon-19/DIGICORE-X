LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Diferenciador IS
PORT(
    clk               : IN  STD_LOGIC;
    rst               : IN  STD_LOGIC;
    Posicion_Continua : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    DeltaP            : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	 Tick_40ms_out : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE rtl OF Diferenciador IS

    SIGNAL Tick_40ms          : STD_LOGIC;

    SIGNAL Posicion_Anterior  : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL DeltaP_comb        : STD_LOGIC_VECTOR(32 DOWNTO 0);

    SIGNAL DeltaP_reg         : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    TIMER : ENTITY work.contador_uni
    GENERIC MAP(
        N => 21
    )
    PORT MAP(
        clk      => clk,
        rst      => rst,
        ena      => '1',
        syn_clr  => '0',
        ini      => (OTHERS => '0'),
        up       => '1',
        max      => "111101000101001100001",--111101000101001100001 0 000000000000000000111
        max_tick => Tick_40ms,
        counter  => OPEN
    );

    REG_POS_ANT : ENTITY work.REGISTER_N_BITS
    GENERIC MAP(
        MAX_WIDTH => 32
    )
    PORT MAP(
        D   => Posicion_Continua,
        ENA => Tick_40ms,
        RST => rst,
        CLK => clk,
        Q   => Posicion_Anterior
    );

    RESTADOR : ENTITY work.Sub_Adder
    GENERIC MAP(
        N => 32
    )
    PORT MAP(
        A   => Posicion_Continua,
        B   => Posicion_Anterior,
        SEL => '1',
        R   => DeltaP_comb
    );

    REG_DELTA : ENTITY work.REGISTER_N_BITS
    GENERIC MAP(
        MAX_WIDTH => 32
    )
    PORT MAP(
        D   => DeltaP_comb(31 DOWNTO 0),
        ENA => Tick_40ms,
        RST => rst,
        CLK => clk,
        Q   => DeltaP_reg
    );
DeltaP <= DeltaP_reg;

Tick_40ms_out <= Tick_40ms;

END ARCHITECTURE;