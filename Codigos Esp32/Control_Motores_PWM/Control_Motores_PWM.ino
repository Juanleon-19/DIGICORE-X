const int M1_IN1 = 25;
const int M1_IN2 = 26;

const int M2_IN1 = 27;
const int M2_IN2 = 14;

String inputString = "";

void setup() {

  Serial.begin(115200);

  ledcAttach(M1_IN1, 20000, 8);
  ledcAttach(M1_IN2, 20000, 8);

  ledcAttach(M2_IN1, 20000, 8);
  ledcAttach(M2_IN2, 20000, 8);

  stopMotors();

  Serial.println("Control listo");
  Serial.println("Comandos:");
  Serial.println("f 150");
  Serial.println("b 150");
  Serial.println("s");
}

void loop() {

  if (Serial.available()) {

    inputString = Serial.readStringUntil('\n');

    inputString.trim();

    processCommand(inputString);
  }
}

// =====================================

void processCommand(String cmd) {

  if (cmd == "s") {

    stopMotors();

    Serial.println("STOP");

    return;
  }

  char dir = cmd.charAt(0);

  int spaceIndex = cmd.indexOf(' ');

  if (spaceIndex == -1) return;

  int pwm = cmd.substring(spaceIndex + 1).toInt();

  pwm = constrain(pwm, 0, 255);

  if (dir == 'f') {

    forward(pwm);

    Serial.print("FORWARD PWM: ");
    Serial.println(pwm);
  }

  else if (dir == 'b') {

    backward(pwm);

    Serial.print("BACKWARD PWM: ");
    Serial.println(pwm);
  }
}

// =====================================

void forward(int pwm) {

  // motor 1
  ledcWrite(M1_IN1, pwm);
  ledcWrite(M1_IN2, 0);

  // motor 2
  ledcWrite(M2_IN1, pwm);
  ledcWrite(M2_IN2, 0);
}

// =====================================

void backward(int pwm) {

  // motor 1
  ledcWrite(M1_IN1, 0);
  ledcWrite(M1_IN2, pwm);

  // motor 2
  ledcWrite(M2_IN1, 0);
  ledcWrite(M2_IN2, pwm);
}

// =====================================

void stopMotors() {

  ledcWrite(M1_IN1, 0);
  ledcWrite(M1_IN2, 0);

  ledcWrite(M2_IN1, 0);
  ledcWrite(M2_IN2, 0);
}