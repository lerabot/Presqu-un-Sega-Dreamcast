///////////////////////////////////////
//Map related stuff is here
///////////////////////////////////////////

class Map {
  //ATTRIBUTES
  int mapScale;
  //the map name
  String mapName;
  //setting the model name
  PShape mapModel;
  PShape mapFloorModel;
  PShape mapSkyModel;

  PShape lastCheckedFace;
  PShape nextCheckedFace;

  //all the stuff related to the floor and collison detection
  PVector[] floorCorners;
  PVector[] floorCollision = new PVector [1];
  //a counter increase
  int collisionOffset = 0;
  int collisionVectorIndex = 0;

  ArrayList<lcdText> texts;
  String[] mapText;

  TempeteNeige laTempete;
  boolean tempeteActive = false;

  //METHODS
  //constructor
  public Map (int mapScale, String mapName) {
    this.mapName = mapName;
    this.mapScale = mapScale;
    if (this.mapName == "Garage") initPapiGarage();
    if (this.mapName == "Ext") initPapiExt();
    if (this.mapName == "Retour") initPapiRetour();
    if (this.mapName == "Gourdi") initGourdi();
    createText(mapText);
    thePlayer.setMap(this);
  }

  /////////////////////////////////////////////////////
  //Check if the camera is on the floor
  /////////////////////////////////////////////////////

  void drawFace(PShape child) {
    lastCheckedFace.beginShape();
    shape(lastCheckedFace);
    lastCheckedFace.endShape(CLOSE);
  }

  boolean checkFloor() {
    if (mapFloorModel != null) {
      for (int i = 0; i < mapFloorModel.getChildCount (); i++) {
        PShape child = mapFloorModel.getChild(i); 
        //        for (int j = 0; j < 7; j++) {
        if (thePlayer.getFeet().dist(currentShapePosition(child)) < 1500) {  
          //          println("FACE: "+currentShapePosition(child));
          //          println("FEET: "+thePlayer.getFeet());
          //          println("HEIGHT: "+child.getHeight());      
          //          println("DIST: "+ thePlayer.getFeet().dist(currentShapePosition(child)));
          lastCheckedFace = child;
          return true;
        } else {
        }
        //        }
      }
    }
    return false;
  }

  float getFloorLevel(int direction) {
    //needs a floormodel to work
    if (mapFloorModel != null) {
      //check every child of the model
      for (int i = 0; i < mapFloorModel.getChildCount (); i++) {
        PShape child = mapFloorModel.getChild(i);
        //if a lerp of the player at walking distance find a geometry, use this as reference 
        if (thePlayer.playerLerp(direction).dist(currentShapePosition(child)) < 400) {
          if (thePlayer.getPosition().dist(currentShapePosition(child)) > 500) {
            nextCheckedFace = child;
            return currentShapePosition(nextCheckedFace).y;
          }
        }
      }
    }
    return 0;
  }

  void showFloorLevel(int direction) {
    //needs a floormodel to work
    if (mapFloorModel != null) {
      //check every child of the model
      for (int i = 0; i < mapFloorModel.getChildCount (); i++) {
        PShape child = mapFloorModel.getChild(i);
        //if a lerp of the player at walking distance find a geometry, use this as reference 
        if (thePlayer.playerLerp(direction).dist(currentShapePosition(child)) < 1500) {
          if (thePlayer.getPosition().dist(currentShapePosition(child)) > 0) {
            nextCheckedFace = child;
            println("FLKJSDALKJ");
          }
        }
      }
      println("SHIT");
    }
  }

  PVector currentShapePosition(PShape p) {
    float averageX = (p.getVertexX(0) + p.getVertexX(1) + p.getVertexX(2)) /3.0;
    float averageY = (p.getVertexY(0) + p.getVertexY(1) + p.getVertexY(2)) /3.0;
    float averageZ = (p.getVertexZ(0) + p.getVertexZ(1) + p.getVertexZ(2)) /3.0;
    PVector averagePos = new PVector(averageX, averageY, averageZ);
    averagePos.mult(mapScale);
    return averagePos;
  }



  /////////////////////////////////////////////////////////////////////
  ///////////////////////////Shows the current map ///////////////
  ////////////////////////////////////////////////////////////////////
  void show() {
    //display the current model
    if (mapModel != null && !debug) {
      shape(mapModel);
    }

    //for floor model
    if (mapFloorModel != null && !debug) {
      shape(mapFloorModel);
    }

    if (mapSkyModel != null && !debug) {
      shape(mapSkyModel);
    }

    if (texts != null) {
      for (lcdText t : texts) {
        t.writeText();
      }
    }
    //    if (mapFloorModel != null)
    //      showAverage();

    if (tempeteActive && !debug) {
      laTempete.showTempete();
    }
    //    showFloorLevel(thePlayer.direction);

    //    if (nextCheckedFace != null) {
    //      drawFace(nextCheckedFace);
    //    }
  }

  void initGourdi() {

    //initialize the shape and set it to the position and scale   
    if (debug) {
      //debug map
      mapModel = loadShape("data/map3/map3.obj"); 
      mapModel.scale(mapScale); 
      mapModel.translate(0, -500, 0);
    } else {
      mapFloorModel = loadShape("data/map3/map3.obj"); 
      mapFloorModel.scale(mapScale); 
      mapFloorModel.translate(0, -500, 0);
    }
    thePlayer.cameraJump(1341.1835, -thePlayer.getHeight(), 2589.0117); 
    thePlayer.cameraAim(2244.692, -thePlayer.getHeight(), 804.9005);
    //set the current map name
    mapText = loadStrings("map3/map3_text.txt");
    println(this.mapName+" loaded");
  }

  //////////////////////////PapiGARAGE/////////////////////////////
  void initPapiGarage() {
    floorCorners = new PVector [7]; 
    //set up the floor as a collision object    
    floorCorners[0] = new PVector (-3084.667, -thePlayer.getHeight(), -1021.6255); 
    floorCorners[1] = new PVector (1722.3079, -850.00256, -806.89954); 
    floorCorners[2] = new PVector (1684.7804, -850.00024, -2875.14); 
    floorCorners[3] = new PVector (790.49896, -850.0002, -3563.4263); 
    floorCorners[4] = new PVector (645.8008, -850.00037, -4738.9956); 
    floorCorners[5] = new PVector (-2605.3396, -850.00037, -4892.056); 
    floorCorners[6] = new PVector (-3084.667, -849.9998, -1021.6255); 

    //function that compute where the collision shoud occur and the accuracy
    computeCollisionVector(15); 

    thePlayer.cameraJump(-2399.593, -86.96228, 1492.4738); 
    thePlayer.cameraAim(-2007.3064, -82.30486, 3453.619); 
    //initialize the shape and set it to the position and scale   
    if (debug) {
      mapModel = loadShape("data/debug.obj");
    } else {
      mapModel = loadShape("data/map1/papieGarage31Good.obj");
    }
    mapModel.scale(mapScale);    
    mapModel.translate(0, -25, 0);
    //set the current map name
    mapText = loadStrings("map1/map1_text.txt");
    println(this.mapName+" loaded");
  }

  //////////////////////////PapiEXT/////////////////////////////
  void initPapiExt() {
    PVector tempeteOrigin = new PVector (947.44763, -850.71443, 4120.506); 
    laTempete = new TempeteNeige(5000, tempeteOrigin, 20000); 
    tempeteActive = true; 


    mapText = loadStrings("map2/map2_text.txt");

    //initialize the shape and set it to the position and scale   
    if (debug) {
      //debug map
      mapFloorModel = loadShape("data/map2/map2_shop_floor1.obj"); 
      mapFloorModel.scale(mapScale); 
      mapFloorModel.translate(0, 0, 0);
    } else {
      //map proprieties
      mapModel = loadShape("data/map2/map2_shop.obj"); 
      mapModel.scale(mapScale); 
      mapModel.translate(0, 0, 0); 
      println("map2 main loaded");

      mapFloorModel = loadShape("data/map2/map2_shop_floor1.obj"); 
      mapFloorModel.scale(mapScale); 
      mapFloorModel.translate(0, 0, 0);
      println("map2 floor loaded");

      mapSkyModel = loadShape("data/map2/map2_shop_ciel.obj"); 
      mapSkyModel.scale(mapScale);  
      mapSkyModel.translate(0, 0, 0);
      println("map2 sky loaded");
    }
    thePlayer.cameraJump(-15790.673, -94.43428, -2025.185); 
    thePlayer.cameraAim(-13873.002, -95.42826, -1457.8029);
    //set the current map name
    println(this.mapName+" loaded");
  }
  
    //////////////////////////Le retour/////////////////////////////
  void initPapiRetour() {
    PVector tempeteOrigin = new PVector (947.44763, -850.71443, 4120.506); 
    laTempete = new TempeteNeige(5000, tempeteOrigin, 20000); 
    tempeteActive = true; 


    mapText = loadStrings("map2/map2_text.txt");

    //initialize the shape and set it to the position and scale   
    if (debug) {
      //debug map
      mapFloorModel = loadShape("data/map4/map2_shop_floor1.obj"); 
      mapFloorModel.scale(mapScale); 
      mapFloorModel.translate(0, 0, 0);
    } else {
      //map proprieties
      mapModel = loadShape("data/map4/map4_shop.obj"); 
      mapModel.scale(mapScale); 
      mapModel.translate(0, 0, 0); 

      mapFloorModel = loadShape("data/map4/map2_shop_floor1.obj"); 
      mapFloorModel.scale(mapScale); 
      mapFloorModel.translate(0, 0, 0);

      mapSkyModel = loadShape("data/map4/map2_shop_ciel.obj"); 
      mapSkyModel.scale(mapScale);  
      mapSkyModel.translate(0, 0, 0);
    }
    thePlayer.cameraJump(-15790.673, -94.43428, -2025.185); 
    thePlayer.cameraAim(-13873.002, -95.42826, -1457.8029);
    //set the current map name
    println(this.mapName+" loaded");
  }

  //////////////////////////////UTILITY////////////////////////////////////


  //this function read the mapText file and create all the needed lcdText objects
  void createText(String textfile[]) {
    //initialize the arrayText
    texts = new ArrayList<lcdText>();
    //goes throught every line of the .txt file
    for (int i = 0; i < textfile.length; i++) {
      //check if the line isn't blank
      if (textfile[i].length() != 0) {
        //checks if the first char is #, which marks a new block of text
        if (textfile[i].charAt(0) == '#') {
          String getName = textfile[i].substring(2);
          //splits the second line in 3, since it contain the position of each text
          String[] getPosition = split(textfile[i+1], ',');
          //assings these value to a new PVector
          PVector textPosition = new PVector(float(getPosition[0]), -thePlayer.getHeight(), float(getPosition[2]));
          //fills a string with the text content
          String[] theText = new String[10];
          for (int j = 0; j < 10; j++) {
            int lineToAdd = i+2+j;
            if (textfile[lineToAdd].length() != 0) {
              theText[j] = textfile[lineToAdd];
            } else {
              j = 10;
            }
          }
          //create a text 
          texts.add(new lcdText(textPosition, i+2, getName, theText));
        }
      }
    }
  }

  void showAverage() {
    for (int i = 0; i < mapFloorModel.getChildCount (); i++) {
      PShape child = mapFloorModel.getChild(i);
      if (i % 3 == 0) 
        showTarget(currentShapePosition(child).x, currentShapePosition(child).y, currentShapePosition(child).z);
    }
  }


  //create collision vectors if it has a floor
  void computeCollisionVector(int precision) {
    //checks if said map has a floor
    if (mapFloorModel != null) {
      //calculate the number of collision vertex to be created in relation ship to the number of borders and precision
      collisionVectorIndex = precision * (floorCorners.length-1); 
      floorCollision = new PVector [collisionVectorIndex]; 
      //goes through all the edges of the floor
      for (int i = 0; i < floorCorners.length-1; i++) {
        //sets an origin
        PVector current = new PVector (0, 0, 0); 
        //and a destination
        PVector target = new PVector (0, 0, 0); 
        // assigns a floor corner to the origin     
        current.set(floorCorners[i]); 
        // and assign a nother floor corner to the destination
        target.set(floorCorners[i+1]); 

        //goes from the origin to the destination and devides the vertex lenght byt the precision amount
        for (int j = 0; j < precision; j++) {
          floorCollision[j+collisionOffset] = PVector.lerp(current, target, j*0.1);
        }    
        //continues to index the floorCollisions even if there's a new line
        collisionOffset = collisionOffset + precision;
      }
    }    
    println(mapName + collisionVectorIndex);
  }

  //  //a boolean funtion to check the collision
  //  boolean checkCollision () {
  //    //needs a floor to happen
  //      //checks through all the collision vector
  //      for (int i = 0; i < collisionVectorIndex; i++) {
  //        //if one of these vector is too close to the camera  
  //        if (floorCollision[i].dist(thePlayer.getPosition()) < 250) {
  //          //print which one and return true          
  //          println("Dist"+i+" "+floorCollision[i].dist(thePlayer.getPosition())); 
  //          return true;
  //        }
  //      }
  //    }
  //    //if none, just return false
  //    return false;
  //  }
}

