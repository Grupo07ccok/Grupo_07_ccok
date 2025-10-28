const int PINO_SENSOR_TEMPERATURA = A3;
float temperaturaCelsius;
// int temperatura_max = 30;
// int temperatura_min = 20;

void setup() {
  Serial.begin(9600);
}
void loop() {
  int valorLeitura = analogRead(PINO_SENSOR_TEMPERATURA);
  temperaturaCelsius = (valorLeitura * 5.0 / 1023.0) / 0.01;

  Serial.println(temperaturaCelsius);

  delay(1800000);
}


  // Serial.print("Temperatura Min:");
  // Serial.print(temperatura_min);
  // Serial.print("Temperatura Max:");
  // Serial.print(temperatura_max);
  // // Serial.print(",");
  // // Serial.print("Temperatura atual:");
<<<<<<< HEAD
=======
  Serial.println(temperaturaCelsius);


  delay(2000); // 1.800.000 milisegundos para coletar dados a cada 30 minutos
}
>>>>>>> 5b176773d76582bbf68dd5f379074aff6b4976e7
