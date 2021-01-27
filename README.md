# Data Logging in Arduino (Saving data to PC)

The main thing is Arduino itself can’t write the data to PC, it can only send the data to Serial Monitor. So, we have to use third-party tools or languages for this process. You can use either Python or Processing language to fetch and save the data from Arduino serial monitor. I am using Processing language for this time. I am going to use Arduino Uno with BME 280 Sensor by Adafruit which measure Temperature, Pressure and Humidity. The altitude value will be calculated using the current pressure value.


# Implementation Method

1. First connect Arduino with the sensor. You can use either I2C or SPI communication interface.
2. Then, write Arduino program to read data from the sensor and display in serial monitor using real time.
3. While writing Arduino program, you should keep in mind the following things:



        
        
