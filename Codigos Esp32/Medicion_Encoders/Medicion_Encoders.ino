#include "driver/pcnt.h"

// =========================
// ENCODER 1
// =========================

#define ENC1_A 18
#define ENC1_B 19

// =========================
// ENCODER 2
// =========================

#define ENC2_A 32
#define ENC2_B 33

const float counts_per_rev = 66000.0;

// acumuladores totales
long totalCount1 = 0;
long totalCount2 = 0;

void setup() {

  Serial.begin(115200);

  // =========================
  // PINES
  // =========================

  pinMode(ENC1_A, INPUT_PULLUP);
  pinMode(ENC1_B, INPUT_PULLUP);

  pinMode(ENC2_A, INPUT_PULLUP);
  pinMode(ENC2_B, INPUT_PULLUP);

  // =========================
  // CONFIG ENCODER 1
  // =========================

  pcnt_config_t pcnt1 = {};

  pcnt1.pulse_gpio_num = ENC1_A;
  pcnt1.ctrl_gpio_num  = ENC1_B;

  pcnt1.unit = PCNT_UNIT_0;
  pcnt1.channel = PCNT_CHANNEL_0;

  pcnt1.pos_mode = PCNT_COUNT_INC;
  pcnt1.neg_mode = PCNT_COUNT_DEC;

  pcnt1.lctrl_mode = PCNT_MODE_REVERSE;
  pcnt1.hctrl_mode = PCNT_MODE_KEEP;

  pcnt1.counter_h_lim = 32767;
  pcnt1.counter_l_lim = -32768;

  pcnt_unit_config(&pcnt1);

  // =========================
  // CONFIG ENCODER 2
  // =========================

  pcnt_config_t pcnt2 = {};

  pcnt2.pulse_gpio_num = ENC2_A;
  pcnt2.ctrl_gpio_num  = ENC2_B;

  pcnt2.unit = PCNT_UNIT_1;
  pcnt2.channel = PCNT_CHANNEL_0;

  pcnt2.pos_mode = PCNT_COUNT_INC;
  pcnt2.neg_mode = PCNT_COUNT_DEC;

  pcnt2.lctrl_mode = PCNT_MODE_REVERSE;
  pcnt2.hctrl_mode = PCNT_MODE_KEEP;

  pcnt2.counter_h_lim = 32767;
  pcnt2.counter_l_lim = -32768;

  pcnt_unit_config(&pcnt2);

  // =========================
  // INICIAR CONTADORES
  // =========================

  pcnt_counter_pause(PCNT_UNIT_0);
  pcnt_counter_clear(PCNT_UNIT_0);
  pcnt_counter_resume(PCNT_UNIT_0);

  pcnt_counter_pause(PCNT_UNIT_1);
  pcnt_counter_clear(PCNT_UNIT_1);
  pcnt_counter_resume(PCNT_UNIT_1);

  Serial.println("2 Encoders listos");
}

void loop() {

  int16_t count1;
  int16_t count2;

  // leer hardware
  pcnt_get_counter_value(PCNT_UNIT_0, &count1);
  pcnt_get_counter_value(PCNT_UNIT_1, &count2);

  // acumular
  totalCount1 += count1;
  totalCount2 += count2;

  // limpiar hardware
  pcnt_counter_clear(PCNT_UNIT_0);
  pcnt_counter_clear(PCNT_UNIT_1);

  // convertir a grados
  float angle1 =
      ((float)totalCount1 / counts_per_rev) * 360.0;

  float angle2 =
      ((float)totalCount2 / counts_per_rev) * 360.0;

  // imprimir
  Serial.print("Enc1: ");
  Serial.print(angle1, 3);

  Serial.print(" deg");

  Serial.print("   |   ");

  Serial.print("Enc2: ");
  Serial.print(angle2, 3);

  Serial.println(" deg");

  delay(10);
}