//////////////////////////////////////
// PZT controller for the 729 laser //
//////////////////////////////////////
// Dan Crick and Sean Donnellan //////
//////////////////////////////////////

void writeVoltage(int x){    // Send most significant to port A and least significant to port C
  PORTC = x;
  PORTA = x >> 8;

  PORTB = B00000000;      // LD, WR LOW
  PORTB = B00000011;      // LD, WR HIGH
}

// Note: int only goes up to 32000.  We must have an unsigned int to reach 64000
const int dV = 1;     // Voltage increment
const unsigned int Vmax = 65530;
const unsigned int Vmin = 10;
const unsigned int Vmid = 32766; 

unsigned int V = Vmid;

void setup(){
  noInterrupts();
  DDRA = 255;          // Set ports A, B and C as output pins
  DDRB = 255;
  DDRC = 255;
  DDRD = 0;            // D and E as input
  DDRE = 0; 
 // Serial.begin(9600);
  
}



void loop(){
  if (digitalRead(3)) {    // Lock is enabled
    if (digitalRead(2)) {  // Up or down?
      if (V > Vmin) {
        V -= dV;
      }
    }
    else {
      if (V < Vmax) {
        V += dV;
      }
    }
  }


  if (digitalRead(21)) {  // Reset button
    V = Vmid;
  }

  writeVoltage(V);
  //delay(1);
}




