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
// PARAMETROS
// =====================================================

const float CPR = 1000.0;
const float GEAR = 66.0;

const float Ts = 0.01;

// =====================================================
// PWM
// =====================================================

int pwm1 = 0;
int pwm2 = 0;

// =====================================================

unsigned long lastTime = 0;

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

  pcnt_counter_resume(PCNT_UNIT_0);
  pcnt_counter_resume(PCNT_UNIT_1);

  lastTime = millis();
}

// =====================================================

void loop() {

  // ===================================================
  // RECIBIR PWM MATLAB
  // ===================================================

  if (Serial.available()) {

    String line =
      Serial.readStringUntil('\n');

    int comma =
      line.indexOf(',');

    if (comma > 0) {

      pwm1 =
        line.substring(0,comma).toInt();

      pwm2 =
        line.substring(comma+1).toInt();

      setMotor(M1_IN1,M1_IN2,pwm1);
      setMotor(M2_IN1,M2_IN2,pwm2);
    }
  }

  // ===================================================
  // MUESTREO
  // ===================================================

  if (millis() - lastTime >= Ts*1000) {

    lastTime += Ts*1000;

    // ================================================
    // LEER CONTADORES
    // ================================================

    int16_t c1;
    int16_t c2;

    pcnt_get_counter_value(PCNT_UNIT_0,&c1);
    pcnt_get_counter_value(PCNT_UNIT_1,&c2);

    pcnt_counter_clear(PCNT_UNIT_0);
    pcnt_counter_clear(PCNT_UNIT_1);

    // ================================================
    // RPM
    // ================================================

    float rpm1 =
      ((float)c1 / CPR)
      * (60.0 / Ts)
      / GEAR;

    float rpm2 =
      ((float)c2 / CPR)
      * (60.0 / Ts)
      / GEAR;

    // ================================================
    // CSV LIMPIO
    // ================================================

    Serial.print(millis()/1000.0);
    Serial.print(",");

    Serial.print(pwm1);
    Serial.print(",");

    Serial.print(rpm1);
    Serial.print(",");

    Serial.print(pwm2);
    Serial.print(",");

    Serial.println(rpm2);
  }
}

// =====================================================

void setMotor(int in1,int in2,int pwm) {

  if (pwm > 0) {

    ledcWrite(in1,pwm);
    ledcWrite(in2,0);
  }

  else if (pwm < 0) {

    ledcWrite(in1,0);
    ledcWrite(in2,-pwm);
  }

  else {

    ledcWrite(in1,0);
    ledcWrite(in2,0);
  }
}

// =====================================================

void stopMotors() {

  ledcWrite(M1_IN1,0);
  ledcWrite(M1_IN2,0);

  ledcWrite(M2_IN1,0);
  ledcWrite(M2_IN2,0);
}