#include "driver/pcnt.h"

// =====================================================
// MOTOR 1
// =====================================================

#define M1_IN1 25
#define M1_IN2 26

// =====================================================
// MOTOR 2
// =====================================================

#define M2_IN1 27
#define M2_IN2 14

// =====================================================
// ENCODER 1
// =====================================================

#define ENC1_A 18
#define ENC1_B 19

// =====================================================
// ENCODER 2
// =====================================================

#define ENC2_A 32
#define ENC2_B 33

// =====================================================
// ENCODER CONFIG
// =====================================================

// HEDS-5500
// 500 CPR
// cuadratura x2

const float counts_per_rev_motor = 1000.0;

// reductora
const float gear_ratio = 66.0;

// tiempo muestreo
const float Ts = 0.01; // 10 ms

// =====================================================
// VARIABLES
// =====================================================

long totalCount1 = 0;
long totalCount2 = 0;

float rpmMotor1 = 0;
float rpmMotor2 = 0;

float rpmOutput1 = 0;
float rpmOutput2 = 0;

int pwm1 = 0;
int pwm2 = 0;

unsigned long lastTime = 0;

// =====================================================

void setup() {

  Serial.begin(115200);

  // =====================================================
  // PWM
  // =====================================================

  ledcAttach(M1_IN1, 20000, 8);
  ledcAttach(M1_IN2, 20000, 8);

  ledcAttach(M2_IN1, 20000, 8);
  ledcAttach(M2_IN2, 20000, 8);

  stopMotors();

  // =====================================================
  // ENCODERS
  // =====================================================

  pinMode(ENC1_A, INPUT_PULLUP);
  pinMode(ENC1_B, INPUT_PULLUP);

  pinMode(ENC2_A, INPUT_PULLUP);
  pinMode(ENC2_B, INPUT_PULLUP);

  // =====================================================
  // PCNT ENCODER 1
  // =====================================================

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

  // =====================================================
  // PCNT ENCODER 2
  // =====================================================

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

  // =====================================================
  // INICIAR CONTADORES
  // =====================================================

  pcnt_counter_pause(PCNT_UNIT_0);
  pcnt_counter_clear(PCNT_UNIT_0);
  pcnt_counter_resume(PCNT_UNIT_0);

  pcnt_counter_pause(PCNT_UNIT_1);
  pcnt_counter_clear(PCNT_UNIT_1);
  pcnt_counter_resume(PCNT_UNIT_1);

  lastTime = millis();

  Serial.println("Sistema listo");

  Serial.println("Comandos:");
  Serial.println("f pwm1 pwm2");
  Serial.println("b pwm1 pwm2");
  Serial.println("s");
}

// =====================================================

void loop() {

  // =====================================================
  // SERIAL
  // =====================================================

  if (Serial.available()) {

    String cmd = Serial.readStringUntil('\n');

    cmd.trim();

    processCommand(cmd);
  }

  // =====================================================
  // VELOCIDAD
  // =====================================================

  if (millis() - lastTime >= 10) {

    lastTime += 10;

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

    // =====================================================
    // RPM MOTOR
    // =====================================================

    rpmMotor1 =
      ((float)count1 / counts_per_rev_motor)
      * (60.0 / Ts);

    rpmMotor2 =
      ((float)count2 / counts_per_rev_motor)
      * (60.0 / Ts);

    // =====================================================
    // RPM SALIDA REDUCTORA
    // =====================================================

    rpmOutput1 = rpmMotor1 / gear_ratio;
    rpmOutput2 = rpmMotor2 / gear_ratio;

    // =====================================================
    // IMPRIMIR CSV
    // =====================================================

    Serial.print(pwm1);
    Serial.print(",");

    Serial.print(rpmOutput1, 2);
    Serial.print(",");

    Serial.print(pwm2);
    Serial.print(",");

    Serial.println(rpmOutput2, 2);
  }
}

// =====================================================
// COMANDOS
// =====================================================

void processCommand(String cmd) {

  if (cmd == "s") {

    stopMotors();

    pwm1 = 0;
    pwm2 = 0;

    return;
  }

  char dir = cmd.charAt(0);

  int firstSpace = cmd.indexOf(' ');
  int secondSpace = cmd.indexOf(' ', firstSpace + 1);

  if (firstSpace == -1 || secondSpace == -1) return;

  pwm1 =
    cmd.substring(firstSpace + 1, secondSpace).toInt();

  pwm2 =
    cmd.substring(secondSpace + 1).toInt();

  pwm1 = constrain(pwm1, 0, 255);
  pwm2 = constrain(pwm2, 0, 255);

  // =====================================================
  // FORWARD
  // =====================================================

  if (dir == 'f') {

    ledcWrite(M1_IN1, pwm1);
    ledcWrite(M1_IN2, 0);

    ledcWrite(M2_IN1, pwm2);
    ledcWrite(M2_IN2, 0);
  }

  // =====================================================
  // BACKWARD
  // =====================================================

  else if (dir == 'b') {

    ledcWrite(M1_IN1, 0);
    ledcWrite(M1_IN2, pwm1);

    ledcWrite(M2_IN1, 0);
    ledcWrite(M2_IN2, pwm2);
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