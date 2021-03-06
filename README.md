# Data Logging in Arduino (Saving data to PC)

The main thing is Arduino itself can’t write the data to PC, it can only send the data to Serial Monitor. So, we have to use third-party tools or languages for this process. You can use either Python or Processing language to fetch and save the data from Arduino serial monitor. I am using Processing language for this time. I am going to use Arduino Uno with BME 280 Sensor by Adafruit which measure Temperature, Pressure and Humidity. The altitude value will be calculated using the current pressure value.

# Items Used

- [Arduino UNO Rev3](https://store.arduino.cc/usa/arduino-uno-rev3)
- [Arduino IDE v1.8.13](https://www.arduino.cc/en/software)
- [BME280 Sensor](https://www.adafruit.com/product/2652)
- [Processing IDE](https://processing.org/reference/environment/)

# Implementation Method

1. First connect Arduino with the sensor. You can use either I2C or SPI communication interface.
2. Then, write Arduino program to read data from the sensor and display data in serial monitor.
3. There are few things to keep in mind while writing the Arduino program which are explained into the points 4, 5 and 6.
4. There must be an initialization marker so that the processing starts reading the data after the initialization marker is started. We are using  ^ sign for initialization marker in the program.
5. After initialization of the Processing program, it starts reading data from the arduino serial monitor and we are going to save that data in tabular format. In Arduino serial monitor data comes in fraction of seconds (you can define interval by delay function), so the Processing program must differentiate rows.
6. For that a row of data for temperature, pressure, humidity and altitude is written inside these two signs <26.3, 1014.82, 55.4, 45>. The processing program writes this data in a single row and when ‘>’ sign comes the program moves to the next row. 
