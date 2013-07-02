////////////////////////////////////////
// Diode-laser loop-filter controller //
//  for the arduino ////////////////////
////////////////////////////////////////
// Made by Dan Crick ///////////////////
////////////////////////////////////////


// First off, give the digital pins some names:

int piezoIntegratorPin = 0;
int piezoEnablePin = 1;
int currentEnablePin = 2;
int currentIntegratorPin = 3;
int autoLockScanSelectPin = 4;
int manualLockScanSelectPin = 5;
int lockDetectorPin = 6;
int toggleSwitchAPin = 12;
int toggleSwitchBPin = 11;
int toggleSwitchCPin = 10;
int greenLED = 9;
int redLED = 8;

long unlockedFor = 0;  // How many loops has it been since the laser was locked?
int MAXUNLOCKEDFOR = 3;

void setup()   
{                
  noInterrupts();
  pinMode(piezoIntegratorPin, OUTPUT);     
  pinMode(piezoEnablePin, OUTPUT);     
  pinMode(currentEnablePin, OUTPUT);     
  pinMode(currentIntegratorPin, OUTPUT);     
  pinMode(autoLockScanSelectPin, OUTPUT);     
  pinMode(manualLockScanSelectPin, OUTPUT);
  pinMode(lockDetectorPin, INPUT);     
  pinMode(7, INPUT);  // Unused
  pinMode(13, OUTPUT);  // Always 5 volts (for the toggle switches)
  digitalWrite(13, HIGH);
  pinMode(toggleSwitchAPin, INPUT);
  pinMode(toggleSwitchBPin, INPUT);
  pinMode(toggleSwitchCPin, INPUT);
  pinMode(greenLED, OUTPUT);
  pinMode(redLED, OUTPUT);

  digitalWrite(autoLockScanSelectPin, HIGH);  
  digitalWrite(manualLockScanSelectPin, HIGH);  
  digitalWrite(piezoIntegratorPin, HIGH);
  digitalWrite(piezoEnablePin, HIGH);
  digitalWrite(currentIntegratorPin, HIGH);
  digitalWrite(currentEnablePin, LOW);
  digitalWrite(greenLED, LOW);
  digitalWrite(redLED, LOW);
}



void loop()                     
{
  bool primaryLock = digitalRead(toggleSwitchAPin);
  bool secondaryLock = digitalRead(toggleSwitchBPin);  
  bool togC = digitalRead(toggleSwitchCPin);
  bool weAreLocked = digitalRead(lockDetectorPin);

  if (weAreLocked) {
    digitalWrite(greenLED, HIGH);
  }
  else {
    digitalWrite(greenLED, LOW);
  }


  if (primaryLock) {
    digitalWrite(currentEnablePin, HIGH);    
  }
  else {
    digitalWrite(currentEnablePin, LOW);
  }

  if (togC) {
    digitalWrite(manualLockScanSelectPin, LOW); // scan
    digitalWrite(redLED, HIGH);
  }
  else {
    if (secondaryLock) {
      if (weAreLocked) {
        //digitalWrite(greenLED, HIGH);
        digitalWrite(redLED, LOW);
        digitalWrite(manualLockScanSelectPin, HIGH); // lock
        digitalWrite(currentIntegratorPin, LOW); // maximum gain
        unlockedFor = 0;
      }
      else {
        //digitalWrite(greenLED, LOW);
        unlockedFor++;
        if (unlockedFor >= MAXUNLOCKEDFOR)
        {
          unlockedFor = MAXUNLOCKEDFOR;
          digitalWrite(currentIntegratorPin, HIGH);
          digitalWrite(manualLockScanSelectPin, LOW); // scan
          digitalWrite(redLED, HIGH);
        }
      }
    }
    else {
      digitalWrite(currentIntegratorPin, HIGH);
      digitalWrite(manualLockScanSelectPin, HIGH); // lock
      digitalWrite(redLED, LOW);
    }
  }

}









