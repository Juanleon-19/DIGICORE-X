#include "driver/pcnt.h"

// =====================================================
// MOTORES
// =====================================================

#define M1_IN1 25
#define M1_IN2 26

#define M2_IN1 27
#define M2_IN2 14

// =====================================================
// ENCODERS
// =====================================================

#define ENC1_A 18
#define ENC1_B 19

#define ENC2_A 32
#define ENC2_B 33

// =====================================================
// PARAMETROS ENCODER
// =====================================================

// AJUSTAR SI CAMBIA TU ENCODER
const float CPR = 1000.0;

// reductora
const float GEAR = 66.0;

// =====================================================
// TIEMPO MUESTREO
// =====================================================

// obtenido desde MATLAB

const float Ts = 0.04;

// =====================================================
// PI DISCRETO MOTOR 1
// =====================================================

const float b0_1 = 6.4205;
const float b1_1 = -3.2579;

// =====================================================
// PI DISCRETO MOTOR 2
// =====================================================

const float b0_2 = 8.6196;
const float b1_2 = -4.8781;

// =====================================================
// CROSS COUPLED
// =====================================================

// ganancias acopladas

float Kc1 = 0.0;
float Kc2 = 0.0;

// =====================================================
// REFERENCIAS RPM
// =====================================================

float ref1 = 0;
float ref2 = 0;

// =====================================================
// VELOCIDADES
// =====================================================

float rpm1 = 0;
float rpm2 = 0;

// =====================================================
// ERRORES
// =====================================================

float e1 = 0;
float e2 = 0;

float e1_prev = 0;
float e2_prev = 0;

// =====================================================
// CONTROL
// =====================================================

float u1 = 0;
float u2 = 0;

float u1_prev = 0;
float u2_prev = 0;

// =====================================================
// PWM
// =====================================================

const int PWM_MAX = 255;

// zona muerta

const int DEADZONE = 35;

// =====================================================
// TIMER
// =====================================================

unsigned long lastTime = 0;

// =====================================================
// SETUP
// =====================================================

void setup() {

  Serial.begin(115200);

  // ===================================================
  // PWM
  // ===================================================

  ledcAttach(M1_IN1, 20000, 8);
  ledcAttach(M1_IN2, 20000, 8);

  ledcAttach(M2_IN1, 20000, 8);
  ledcAttach(M2_IN2, 20000, 8);

  stopMotors();

  // ===================================================
  // ENCODER 1
  // ===================================================

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

  // ===================================================
  // ENCODER 2
  // ===================================================

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

  // ===================================================
  // INICIAR CONTADORES
  // ===================================================

  pcnt_counter_resume(PCNT_UNIT_0);
  pcnt_counter_resume(PCNT_UNIT_1);

  lastTime = millis();

  // ===================================================
  // INFO
  // ===================================================

  Serial.println("=================================");
  Serial.println("CONTROL DIGITAL CROSS COUPLED");
  Serial.println("=================================");

  Serial.println("Formato serial:");
  Serial.println("ref1,ref2,Kc1,Kc2");

  Serial.println("Ejemplo:");
  Serial.println("40,40,0.5,0.5");
}

// =====================================================
// LOOP
// =====================================================

void loop() {

  // ===================================================
  // LEER SERIAL
  // ===================================================

  if (Serial.available()) {

    String line =
      Serial.readStringUntil('\n');

    int i1 = line.indexOf(',');
    int i2 = line.indexOf(',', i1 + 1);
    int i3 = line.indexOf(',', i2 + 1);

    if (i1 > 0 && i2 > 0 && i3 > 0) {

      ref1 =
        line.substring(0, i1).toFloat();

      ref2 =
        line.substring(i1 + 1, i2).toFloat();

      Kc1 =
        line.substring(i2 + 1, i3).toFloat();

      Kc2 =
        line.substring(i3 + 1).toFloat();
    }
  }

  // ===================================================
  // LOOP CONTROL DIGITAL
  // ===================================================

  if (millis() - lastTime >= (Ts * 1000)) {

    lastTime += (Ts * 1000);

    // ================================================
    // LEER ENCODERS
    // ================================================

    int16_t c1;
    int16_t c2;

    pcnt_get_counter_value(PCNT_UNIT_0, &c1);
    pcnt_get_counter_value(PCNT_UNIT_1, &c2);

    pcnt_counter_clear(PCNT_UNIT_0);
    pcnt_counter_clear(PCNT_UNIT_1);

    // ================================================
    // RPM
    // ================================================

    rpm1 =
      ((float)c1 / CPR)
      * (60.0 / Ts)
      / GEAR;

    rpm2 =
      ((float)c2 / CPR)
      * (60.0 / Ts)
      / GEAR;

    // ================================================
    // ERROR PRINCIPAL
    // ================================================

    e1 = ref1 - rpm1;
    e2 = ref2 - rpm2;

    // ================================================
    // ERROR ACOPLADO
    // ================================================

    float ec = rpm1 - rpm2;

    // ================================================
    // PI DISCRETO
    // ================================================

    u1 =
      u1_prev +
      b0_1 * e1 +
      b1_1 * e1_prev;

    u2 =
      u2_prev +
      b0_2 * e2 +
      b1_2 * e2_prev;

    // ================================================
    // CROSS COUPLED
    // ================================================

    u1 = u1 - Kc1 * ec;

    u2 = u2 + Kc2 * ec;

    // ================================================
    // SATURACION
    // ================================================

    u1 = constrain(u1, -PWM_MAX, PWM_MAX);
    u2 = constrain(u2, -PWM_MAX, PWM_MAX);

    // ================================================
    // ZONA MUERTA
    // ================================================

    if (u1 > 0 && u1 < DEADZONE)
      u1 = DEADZONE;

    if (u1 < 0 && u1 > -DEADZONE)
      u1 = -DEADZONE;

    if (u2 > 0 && u2 < DEADZONE)
      u2 = DEADZONE;

    if (u2 < 0 && u2 > -DEADZONE)
      u2 = -DEADZONE;

    // ================================================
    // SI REFERENCIA = 0
    // ================================================

    if (ref1 == 0)
      u1 = 0;

    if (ref2 == 0)
      u2 = 0;

    // ================================================
    // MOVER MOTORES
    // ================================================

    setMotor(M1_IN1, M1_IN2, u1);

    setMotor(M2_IN1, M2_IN2, u2);

    // ================================================
    // ACTUALIZAR
    // ================================================

    e1_prev = e1;
    e2_prev = e2;

    u1_prev = u1;
    u2_prev = u2;

    // ================================================
    // SERIAL DEBUG
    // ================================================

    Serial.print(ref1);
    Serial.print(",");

    Serial.print(rpm1);
    Serial.print(",");

    Serial.print(ref2);
    Serial.print(",");

    Serial.print(rpm2);
    Serial.print(",");

    Serial.print(u1);
    Serial.print(",");

    Serial.print(u2);
    Serial.print(",");

    Serial.println(ec);
  }
}

// =====================================================
// MOTOR
// =====================================================

void setMotor(int in1, int in2, float pwm) {

  // adelante

  if (pwm > 0) {

    ledcWrite(in1, (int)pwm);
    ledcWrite(in2, 0);
  }

  // atras

  else if (pwm < 0) {

    ledcWrite(in1, 0);
    ledcWrite(in2, (int)(-pwm));
  }

  // stop

  else {

    ledcWrite(in1, 0);
    ledcWrite(in2, 0);
  }
}

// =====================================================
// STOP
// =====================================================

void stopMotors() {

  ledcWrite(M1_IN1, 0);
  ledcWrite(M1_IN2, 0);

  ledcWrite(M2_IN1, 0);
  ledcWrite(M2_IN2, 0);
}