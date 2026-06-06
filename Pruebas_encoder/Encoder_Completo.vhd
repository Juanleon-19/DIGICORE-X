LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Encoder_Completo IS
PORT(
clk                : IN  STD_LOGIC;
rst                : IN  STD_LOGIC;


ENC_A              : IN  STD_LOGIC;
ENC_B              : IN  STD_LOGIC;

Posicion_Continua  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

RPM                : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

Tick_40ms          : OUT STD_LOGIC


);
END ENTITY;

ARCHITECTURE rtl OF Encoder_Completo IS


SIGNAL Tick_40ms_s : STD_LOGIC;

SIGNAL A_ff1  : STD_LOGIC;
SIGNAL A_sync : STD_LOGIC;

SIGNAL B_ff1  : STD_LOGIC;
SIGNAL B_sync : STD_LOGIC;

SIGNAL Enable : STD_LOGIC;
SIGNAL Dir    : STD_LOGIC;

SIGNAL Posicion_s : STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL DeltaP_s : STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL RPM_s : STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN


FF_A1 : ENTITY work.Flip_Flop_D_RE
PORT MAP(
    D   => ENC_A,
    ENA => '1',
    RST => rst,
    CLK => clk,
    Q   => A_ff1
);

FF_A2 : ENTITY work.Flip_Flop_D_RE
PORT MAP(
    D   => A_ff1,
    ENA => '1',
    RST => rst,
    CLK => clk,
    Q   => A_sync
);

FF_B1 : ENTITY work.Flip_Flop_D_RE
PORT MAP(
    D   => ENC_B,
    ENA => '1',
    RST => rst,
    CLK => clk,
    Q   => B_ff1
);

FF_B2 : ENTITY work.Flip_Flop_D_RE
PORT MAP(
    D   => B_ff1,
    ENA => '1',
    RST => rst,
    CLK => clk,
    Q   => B_sync
);

FSM : ENTITY work.decoder_quadratura
PORT MAP(
    clk    => clk,
    rst    => rst,
    A_sync => A_sync,
    B_sync => B_sync,
    Enable => Enable,
    Dir    => Dir
);

CONTADOR_POS : ENTITY work.contador_uni
GENERIC MAP(
    N => 32
)
PORT MAP(
    clk      => clk,
    rst      => rst,
    ena      => Enable,
    syn_clr  => '0',
    ini      => "10000000000000000000000000000000",
    up       => Dir,
    max      => "11111111111111111111111111111111",
    max_tick => OPEN,
    counter  => Posicion_s
);

DIF : ENTITY work.Diferenciador
PORT MAP(
    clk               => clk,
    rst               => rst,
    Posicion_Continua => Posicion_s,
    DeltaP            => DeltaP_s,
    Tick_40ms_out     => Tick_40ms_s
);

RPM_CALC : ENTITY work.DeltaP_a_RPM
PORT MAP(
    clk       => clk,
    rst       => rst,
    Tick_40ms => Tick_40ms_s,
    DeltaP    => DeltaP_s,
    RPM       => RPM_s
);

Posicion_Continua <= Posicion_s;

RPM <= RPM_s;

Tick_40ms <= Tick_40ms_s;


END ARCHITECTURE;
