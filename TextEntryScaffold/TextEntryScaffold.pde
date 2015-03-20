import java.util.Arrays;
import java.util.Collections;

String[] phrases;
int totalTrialNum = 4; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 300;//441; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
                                      //http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!
//PImage watch = loadImage("watchhand3.png");

//Sensors if you want them
CompassManager compass;
float direction; //the compass direction of the device (updated for you)
AccelerometerManager accel;
float ax, ay, az; //The x,y,z accelerometer values (updated for you)
//touch location is stored in mouseX and mouseY (updated or you)

//Variables for my silly implementation. You can delete these:
char currentLetter = 'a';
boolean started = false;
boolean lettersClicked = false;
String letterPanel = "";

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases
  accel = new AccelerometerManager(this); //start the accelerometer
  compass = new CompassManager(this); //start the compass  
  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(1000, 1000); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 24)); //set the font to arial 24
  noStroke(); //my code doesn't use any strokes.
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(0); //clear background

 // image(watch,-200,200);
  fill(100);
  //rect(200, 200, sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"
  rect(150, 200, sizeOfInputArea, sizeOfInputArea);
  if (finishTime!=0)
  {
    fill(255);
    textAlign(CENTER);
    text("Finished", 280, 150);
    return;
  }

  if(!lettersClicked) {
    if (startTime==0 & !mousePressed)
    {
      fill(255);
      textAlign(CENTER);
      text("Click to start time!", 280, 150); //display this messsage until the user clicks!
    }
  
    if (startTime==0 & mousePressed)
    {
      nextTrial(); //start the trials!
    }
  
    if (startTime!=0)
    {
      //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
      textAlign(LEFT); //align the text left
      fill(128);
      text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
      fill(255);
      text("Target:   " + currentPhrase, 70, 100); //draw the target string
      text("Entered:  " + currentTyped + "|", 70, 140); //draw what the user has entered thus far 
      fill(255, 0, 0);
      rect(200, 600, 200, 200); //drag next button
      fill(255);
      text("NEXT > ", 250, 700); //draw next label
  
  
      //my draw code
      /*textAlign(CENTER);
      text("" + currentLetter, 200+sizeOfInputArea/2, 200+sizeOfInputArea/3); //draw current letter
      fill(255, 0, 0);
      rect(200, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw left red button
      fill(0, 255, 0);
      rect(200+sizeOfInputArea/2, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw right green button
      */
      stroke(153);
      fill(255);
      // first row
      rect(150, 200, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/3);
      
      // second row
      rect(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      
      // third row
      rect(150, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/3, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/3, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
       
       
      fill(0);
      textAlign(CENTER);
      // spacebar
      text("_", 150 + sizeOfInputArea/6, 200 + sizeOfInputArea/6);
      text("abc", 150+sizeOfInputArea/3 + sizeOfInputArea/6, 200 + sizeOfInputArea/6);
      text("def", 150+2*sizeOfInputArea/3+ sizeOfInputArea/6, 200 + sizeOfInputArea/6);
      
      text("ghi", 150 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("jkl", 150+sizeOfInputArea/3 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("mno", 150+2*sizeOfInputArea/3+ sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
  
      text("pqrs", 150 + sizeOfInputArea/6, 200+2*sizeOfInputArea/3 + sizeOfInputArea/6);
      text("tuv", 150+sizeOfInputArea/3 + sizeOfInputArea/6, 200+2*sizeOfInputArea/3 + sizeOfInputArea/6);
      text("wxyz'", 150+2*sizeOfInputArea/3+ sizeOfInputArea/6, 200+2*sizeOfInputArea/3 + sizeOfInputArea/6);
    }
  } else {
   /* stroke(153);
    fill(100);
    rect(150,200+2*sizeOfInputArea/3, sizeOfInputArea, sizeOfInputArea/3);
    fill(0, 255, 0);
    textAlign(CENTER);
    text("Back", 150 + sizeOfInputArea/2, 200+2*sizeOfInputArea/3 + sizeOfInputArea/6);
    */
       //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(255);
    text("Target:   " + currentPhrase, 70, 100); //draw the target string
    text("Entered:  " + currentTyped + "|", 70, 140); //draw what the user has entered thus far 
    if(letterPanel == "abc") {
      stroke(153);
      fill(255);
      rect(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      fill(0);
      textAlign(CENTER);
      text("a", 150 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("b", 150+sizeOfInputArea/3 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("c", 150+2*sizeOfInputArea/3+ sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
    }  
    if(letterPanel == "def") {
      stroke(153);
      fill(255);
      rect(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      fill(0);
      textAlign(CENTER);
      text("d", 150 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("e", 150+sizeOfInputArea/3 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("f", 150+2*sizeOfInputArea/3+ sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
    } 
    if(letterPanel == "ghi") {
      stroke(153);
      fill(255);
      rect(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      fill(0);
      textAlign(CENTER);
      text("g", 150 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("h", 150+sizeOfInputArea/3 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("i", 150+2*sizeOfInputArea/3+ sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
    }     
    if(letterPanel == "jkl") {
      stroke(153);
      fill(255);
      rect(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      fill(0);
      textAlign(CENTER);
      text("j", 150 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("k", 150+sizeOfInputArea/3 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("l", 150+2*sizeOfInputArea/3+ sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
    }    
    if(letterPanel == "mno") {
      stroke(153);
      fill(255);
      rect(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      fill(0);
      textAlign(CENTER);
      text("m", 150 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("n", 150+sizeOfInputArea/3 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("o", 150+2*sizeOfInputArea/3+ sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
    }   
    if(letterPanel == "pqrs") {
      stroke(153);
      fill(255);
      rect(150, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3);
      rect(150+3*sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3);
      fill(0);
      textAlign(CENTER);
      text("p", 150 + sizeOfInputArea/8, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("q", 150+sizeOfInputArea/4 + sizeOfInputArea/8, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("r", 150+2*sizeOfInputArea/4+ sizeOfInputArea/8, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("s", 150+3*sizeOfInputArea/4+ sizeOfInputArea/8, 200+sizeOfInputArea/3 + sizeOfInputArea/6);

    }  
    if(letterPanel == "tuv") {
      stroke(153);
      fill(255);
      rect(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
      fill(0);
      textAlign(CENTER);
      text("t", 150 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("u", 150+sizeOfInputArea/3 + sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("v", 150+2*sizeOfInputArea/3+ sizeOfInputArea/6, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
    }     
    if(letterPanel == "wxyz") {
      stroke(153);
      fill(255);
      rect(150, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3);
      rect(150+sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3);
      rect(150+2*sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3);
      rect(150+3*sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3);
      fill(0);
      textAlign(CENTER);
      text("w", 150 + sizeOfInputArea/8, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("x", 150+sizeOfInputArea/4 + sizeOfInputArea/8, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("y", 150+2*sizeOfInputArea/4+ sizeOfInputArea/8, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
      text("z", 150+3*sizeOfInputArea/4+ sizeOfInputArea/8, 200+sizeOfInputArea/3 + sizeOfInputArea/6);
    }     
  }
}

boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}


void mousePressed()
{

  /*if (didMouseClick(200, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in left button
  {
    currentLetter --;
    if (currentLetter<'_') //wrap around to z
      currentLetter = 'z';
  }

  if (didMouseClick(200+sizeOfInputArea/2, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in right button
  {
    currentLetter ++;
    if (currentLetter>'z') //wrap back to space (aka underscore)
      currentLetter = '_';
  }

  if (didMouseClick(200, 200, sizeOfInputArea, sizeOfInputArea/2)) //check if click occured in letter area
  {
    if (currentLetter=='_') //if underscore, consider that a space bar
      currentTyped+=" ";
    else if (currentLetter=='`' & currentTyped.length()>0) //if `, treat that as a delete command
      currentTyped = currentTyped.substring(0, currentTyped.length()-1);
    else if (currentLetter!='`') //if not any of the above cases, add the current letter to the typed string
      currentTyped+=currentLetter;
  } */
  if(started) {
    if(!lettersClicked) {
      if (didMouseClick(150, 200, sizeOfInputArea/3, sizeOfInputArea/3)) //check if click space
      {
        currentTyped+=" ";
      }
      if (didMouseClick(150+sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/3))
      {
        lettersClicked = true;
        letterPanel = "abc";
      }
      
      if (didMouseClick(150+2*sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/3)){ //check if click in "def"
        lettersClicked = true;
        letterPanel = "def";  
      }
      
      if (didMouseClick(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ //check if click in "ghi"
        lettersClicked = true;
        letterPanel = "ghi";  
        
      }
      
      if (didMouseClick(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ //check if click in "jkl"
        lettersClicked = true;
        letterPanel = "jkl";  
      }
      
      if (didMouseClick(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ //check if click in "mno"
        lettersClicked = true;
        letterPanel = "mno";  
      }
      
      if (didMouseClick(150, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ //check if click in "pqrs"
        lettersClicked = true;
        letterPanel = "pqrs";
      }
      
      if (didMouseClick(150+sizeOfInputArea/3, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ //check if click in "tuv"
        lettersClicked = true;
        letterPanel = "tuv";
      }
      
      if (didMouseClick(150+2*sizeOfInputArea/3, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ //check if click in "wxyz'"
        lettersClicked = true;
        letterPanel = "wxyz";
      }
    } else {
      if( letterPanel == "abc") {
        if (didMouseClick(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ 
          currentTyped+="a";
        }
        else if (didMouseClick(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="b";
        }
        else if (didMouseClick(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="c";
        }
        else{ //If the user clicks on anything other than first row 
          lettersClicked = false;
          letterPanel = "";
        }  
      }
      if( letterPanel == "def") {
        if (didMouseClick(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ 
          currentTyped+="d";
        }
        else if (didMouseClick(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="e";
        }
        else if (didMouseClick(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="f";
        }
        else{ //If the user clicks on anything other than first row 
          lettersClicked = false;
          letterPanel = "";
        }  
      }
      if( letterPanel == "ghi") {
        if (didMouseClick(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ 
          currentTyped+="g";
        }
        else if (didMouseClick(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="h";
        }
        else if (didMouseClick(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="i";
        }
        else{ //If the user clicks on anything other than first row 
          lettersClicked = false;
          letterPanel = "";
        }  
      }
      if( letterPanel == "jkl") {
        if (didMouseClick(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ 
          currentTyped+="j";
        }
        else if (didMouseClick(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="k";
        }
        else if (didMouseClick(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="l";
        }
        else{ //If the user clicks on anything other than first row 
          lettersClicked = false;
          letterPanel = "";
        }  
      }      
      if( letterPanel == "mno") {
        if (didMouseClick(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ 
          currentTyped+="m";
        }
        else if (didMouseClick(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="n";
        }
        else if (didMouseClick(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="o";
        }
        else{ //If the user clicks on anything other than first row 
          lettersClicked = false;
          letterPanel = "";
        }  
      }    
    
      if( letterPanel == "pqrs") {
        if (didMouseClick(150, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3)){ 
          currentTyped+="p";
        }
        else if (didMouseClick(150+sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3)){
          currentTyped+="q";
        }
        else if (didMouseClick(150+2*sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3)){
          currentTyped+="r";
        }
        else if (didMouseClick(150+3*sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3)){
          currentTyped+="s";
        }
        else{ //If the user clicks on anything other than first row 
          lettersClicked = false;
          letterPanel = "";
        }  
      }    
    
    
      if( letterPanel == "tuv") {
        if (didMouseClick(150, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){ 
          currentTyped+="t";
        }
        else if (didMouseClick(150+sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="u";
        }
        else if (didMouseClick(150+2*sizeOfInputArea/3, 200+sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3)){
          currentTyped+="v";
        }
        else{ //If the user clicks on anything other than first row 
          lettersClicked = false;
          letterPanel = "";
        }  
      } 
 
      if( letterPanel == "wxyz") {
        if (didMouseClick(150, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3)){ 
          currentTyped+="w";
        }
        else if (didMouseClick(150+sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3)){
          currentTyped+="x";
        }
        else if (didMouseClick(150+2*sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3)){
          currentTyped+="y";
        }
        else if (didMouseClick(150+3*sizeOfInputArea/4, 200+sizeOfInputArea/3, sizeOfInputArea/4, sizeOfInputArea/3)){
          currentTyped+="z";
        }
        else{ //If the user clicks on anything other than first row 
          lettersClicked = false;
          letterPanel = "";
        }  
      }       
      lettersClicked = false;
      letterPanel = "";
    }
    
  }
  
  

  //You are allowed to have a next button outside the 2" area
  if (didMouseClick(200, 600, 200, 200)) //check if click is in next button
  {
    nextTrial(); //if so, advance to next trial
  }
}


void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

    if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.length();
    lettersEnteredTotal+=currentTyped.length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output
    System.out.println("WPM: " + (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f)); //output
    System.out.println("==================");
    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
    started = true;
  }
  else
  {
    currTrialNum++; //increment trial number
  }

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}




//=========SHOULD NOT NEED TO TOUCH THIS AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2)  
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}

//=========SENSOR EVENTS (PROBABLY DON'T NEED TO TOUCH)=============

public void accelerationEvent(float x, float y, float z) {
//  println("acceleration: " + x + ", " + y + ", " + z);
  ax = x;
  ay = y;
  az = z;
  redraw();
}

void directionEvent(float newDirection) {
  direction = newDirection;
}
