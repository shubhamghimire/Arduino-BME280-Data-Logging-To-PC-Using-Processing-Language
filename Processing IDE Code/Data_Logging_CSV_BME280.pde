// Don't forget to check COM number and baud rate before running this program


import processing.serial.*;                            //import the required libraries

PrintWriter output;

Serial ArduinoSerial;



//initialize the variables used

int h, min, s, m;

int time;

int timeOffset;

int maxCharacters=0;

long loop=0;

long fileWtites=0;

String row = "";

String incomingString;

char incomingCharacters;

int characterCount = 0;

boolean newData = false;

boolean receiveInProgress = false;

boolean overflow = false;

boolean initialize = false;

int[] PC_Time = new int[3];
int[] MM_DD_YY = new int[3];


String COM="COM7";               //setup COM port (look up in the arduino IDE Tools>Port)



//initialize, start, and end markers.

char startMarker = '<';

char endMarker = '>';

char initializeMarker = '^';



//Document setup

String filename = "Data_Logger";

String columns = "Date, Time, Temperature *c, Pressure hPa, Humidity %, Altitude m,LoopTime";


//Sampling setup

//int maxTime = 2*30*1000;                                 //maximum amount of time you want the program to run for

int samples = 100;                                      //maximum number of data samples you want

int maxChars = 56;                                       //set to one higher than the most characters transmitted

boolean debug = false;                                   //set to true to see more debugging information





void setup() {

  min = minute();

  int sec = second();

  output = createWriter(filename + str(min)+str(sec)+ ".csv");    // creats a file and saves it in the sketch folder

  ArduinoSerial = new Serial(this, COM, 115200);         //sets serial to listen on COM port 3 at 9600 baud

  output.println(columns);

  updateTime();                                          //updates time

  timeOffset = (((min*60) + s)*1000) +m;                 //sets a zero for the time

  println("setup Complete");
}



void draw() {

 if (keyPressed == false) {
       updateTime();

      receiveWithStartEndMarkers();                        

      if (newData == true) {                               
        println("Latest transmition:",row);


        newData = false;                                   
      }

      time = ((((min*60) + s)*1000) +m) - timeOffset;
  }
  else{
    
    keyPressed();
  }

}





void receiveWithStartEndMarkers() {

  characterCount = 0;

  while (ArduinoSerial.available() > 0 && newData == false) {

    incomingCharacters = ArduinoSerial.readChar();                  //reads incoming serial data and stores it as a character

    incomingString = str(incomingCharacters);                       //converts incoming characters to a string

    if (debug) {

      println("Incoming Serial:", incomingString);
    }

    if (incomingString != null) {                                   //check to make sure there is a value

      if (receiveInProgress == true) {



        if (incomingCharacters != endMarker) {              

          row += incomingString;                                    //adds incoming character to transmition

          characterCount++;

          if (characterCount > maxCharacters) {                     //increaces the maximum character count if any transmition is longer than any of the previous

            maxCharacters = characterCount;
          }

          if (characterCount >= maxChars) {                         //marks transmition as bad if there are too many characters

            if (debug) {

              println("characterCount:", characterCount, "                  Overflow");
            }

            overflow = true;
          }
        } else {                                         //runs once end marker is hit

          if (debug) {

            println("endMarkerHit");
          }

          if (overflow == false) {                       //only writes to file if transmition didn't overflow
            row = PC_Date()+","+PC_Time()+","+row;  
            output.println(row);
            fileWtites++;                                //counts total number times the program writes transmitions to the file
          }

          receiveInProgress = false;                     //resets variables

          characterCount = 0;

          newData = true;

          overflow = false;

          loop++;                                        //counts total number of times the program loops
        }
      } else if (incomingCharacters == startMarker && initialize == true) { //only starts transmition if botht eh start and initialization markers are hit

        if (debug) {

          println("startMarkerHit");
        }

        row="";                                           //resets row

        receiveInProgress = true;
      } else if (incomingCharacters == initializeMarker) {

        println("initializeMarkerHit");
        row="";

        initialize = true;
      }
    } else {

      if (debug) {

        println("Incoming String = null");
      }
    }
  }
}





void keyPressed() {

  output.flush();                     // Writes the remaining data to the file

  output.close();                     // Finishes the file

  println("End of transmitions");

  if (debug) {

    println("Number of loops:", loop);

    println("Number of writes:", fileWtites);

    println("Total program run time:", time, "ms");

    println("Longest transmition:", maxCharacters, "characters");

    println("Set maxCharacters to", maxCharacters+1, "to guard against overflows. Currently set at", maxChars);
  }

  exit();                            // Stops the program
}





void updateTime() {                     //updates the time variables

  h = hour();

  min = minute();

  s = second();

  m = millis();
}

String PC_Time()
{
  
 PC_Time[2] = second();  // Values from 0 - 59
 PC_Time[1] = minute();  // Values from 0 - 59
 PC_Time[0] = hour();    // Values from 0 - 23
 return join(nf(PC_Time, 2), ":");

}

String PC_Date()
{
  
 MM_DD_YY[2] = year();  
 MM_DD_YY[1] = day();  
 MM_DD_YY[0] = month();   
 return join(nf(MM_DD_YY, 2), "/");
}
