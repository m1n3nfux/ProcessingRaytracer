// ----- User Parameter -----

//camera: position, rotation, FOV, aspectratio, width, density
<<<<<<< Updated upstream
Camera cam = new Camera(new PVector(0,0,000), new PVector(0,0,0), 40, 16.0/9.0, 880, 1);
=======
Camera cam = new Camera(new PVector(0,5,-30), new PVector(-35,0,0), 40, 16.0/9.0, 880, 2);
>>>>>>> Stashed changes
Camera cam1 = new Camera(new PVector(0,0,0), new PVector(0,0,0), 90, 16.0/9.0, 880, 10);

// select active camera
Camera selectedCam = cam;


float scale = 100;

//maximum ray hits
<<<<<<< Updated upstream
int bounces = 10;
=======
int bounces = 4;
>>>>>>> Stashed changes

// background color
PVector bg_color = new PVector(50, 50, 50);


// --------------------------


float u = selectedCam.u;
PImage img = createImage(int(selectedCam.resolution.x), int(selectedCam.resolution.y), RGB);

Object[] objects;

public void settings(){
  size(int(selectedCam.resolution.x),int(selectedCam.resolution.y));
  //fullScreen();

  noLoop();
}

void setup() {
  
<<<<<<< Updated upstream
  objects = new Object[] {
    // Sphere: origin / position, radius, color, roughness, reflectivity  
    new Sphere(new PVector(0, -100, 90), int(50), new PVector(255, 255, 255), 0, 0), // Light
    
    // Plane: origin / position, color, roughness, reflectivity
    new Plane( new PVector(80, 60, 0), new PVector(200, 100, 100), 0.05, 0.6), // (subsoil)
    
    new Sphere(new PVector(-100, 40, 175), int(15), new PVector(46, 259, 151), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(-50, 40, 175), int(15), new PVector(46, 215, 187), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(0, 40, 175), int(15), new PVector(46, 259, 151), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(50, 40, 175), int(15), new PVector(46, 215, 187), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(100, 40, 175), int(15), new PVector(46, 259, 151), 0.2, 0.5), // Small sphere
=======
  // Material syntax: color, roughness, reflectivity, luminance
  // reflectivity: 0 = show own color when lit, 1 = show color of oject in reflectio
  Material blue2 = new Material(color(50,250,150),0.6, 0.5, 0);
  Material blue1 = new Material(color(50,210,180),0.6, 0.5, 0);
  Material ground = new Material(color(200,60,60),0.2, 0.2, 0);
  Material lamp = new Material(color(255,255,255),0,1,1);

  objects = new Object[] {
    // Sphere: origin / position, radius, color, roughness, reflectivity  
    new Sphere(new PVector(0, -100, 50), int(100), lamp), // Light
    
    // Plane: origin / position, color, roughness, reflectivity
    //new Plane( new PVector(0, 55, 0), ground), // (subsoil)
    //new Plane( new PVector(80, -0, 0), lamp),
    new Sphere(new PVector(-100, 40, 50), int(15), blue1), // Small sphere
    new Sphere(new PVector(-50, 40, 50), int(15), blue2), // Small sphere
    new Sphere(new PVector(0, 43, 50), int(15), blue1), // Small sphere
    new Sphere(new PVector(50, 40, 50), int(15), blue2), // Small sphere
    new Sphere(new PVector(100, 40, 50), int(15), blue1), // Small sphere
    
    new Sphere(new PVector(0, 1875, 100), int(2000), ground), // Ground sphere
>>>>>>> Stashed changes
  };
}


int usedRays = 0;
void draw() {
  img.loadPixels();

  // Sending a Ray for every pixel
  for (int x = 0; x < selectedCam.resolution.x; x++) {
    for (int y = 0; y < selectedCam.resolution.y; y++) {
      
      PVector renderColor = new PVector();
      color c;
      
      // Sending multiple Rays per pixel 
      for (int a = 0; a < selectedCam.density.x; a++) {
        for (int b = 0; b < selectedCam.density.y; b++) {
          
          // Creating a new ray
          Ray r = new Ray(
            new PVector(x + selectedCam.origin.x + a/(selectedCam.density.x) - selectedCam.resolution.x/2, y + selectedCam.origin.y + b/(selectedCam.density.y) - selectedCam.resolution.y/2, 0 + selectedCam.origin.z), 
            new PVector( map(x, 0, selectedCam.resolution.x, -selectedCam.FOV , selectedCam.FOV ), map(y, 0, selectedCam.resolution.y, -selectedCam.FOV / selectedCam.aspectratio, selectedCam.FOV / selectedCam.aspectratio), 1)
          );
          // Rotating ray according to camera-rotation
          rotateVector(r.origin, selectedCam.direction);
          rotateVector(r.direction, selectedCam.direction);
          
          // skip pixel if first ray hits background
          if(a == 0 && b==0 && r.intGet() == false){
            renderColor = PVector.mult(bg_color, selectedCam.density.x * selectedCam.density.y);
            a = int(selectedCam.density.x);
            b = int(selectedCam.density.y);
          }
          else {
<<<<<<< Updated upstream
            // casting the ray and adding corresponding color
            PVector col = r.cast(null, new PVector(), 0);
=======
            //casting the ray and adding corresponding color
            PVector col = r.cast(null, null, new PVector(), 0, 0.0, 0);
>>>>>>> Stashed changes
            renderColor.add(col);
            
            usedRays++;
          }
        }
      }
      
      // Averaging color values
      c = color(renderColor.x / (selectedCam.density.x * selectedCam.density.y), renderColor.y / (selectedCam.density.x * selectedCam.density.y), renderColor.z / (selectedCam.density.x * selectedCam.density.y));
      // Adding color to image-array
      img.pixels[int(y * selectedCam.resolution.x) + x] = c; // Adding pixel to image
    }
  }
  
  // Displaying the image
  img.updatePixels();
  image(img, 0, 0);
  
  // Saving the image
  img.save("output.jpg");
  
  // Done message with timer
  println("done [" + millis()/1000 + "s " + (millis() - (millis()/1000 * 1000)) + "ms]");
  println(int(selectedCam.resolution.x * selectedCam.resolution.y) + " pixels rendered, using " + usedRays + " rays at " + int(selectedCam.density.x * selectedCam.density.y) + " rays per pixel");
}

void rotateVector(PVector vector, PVector rotation){ 
  // Around x
  PVector temp = new PVector(vector.y, vector.z).rotate( radians(rotation.x) );
  vector.y = temp.x;
  vector.z = temp.y;
  
  // Around y
  temp = new PVector(vector.x, vector.z).rotate( radians(rotation.y) );
  vector.x = temp.x;
  vector.z = temp.y;
  
  // Around z 
  temp = new PVector(vector.x, vector.y).rotate( radians(rotation.z) );
  vector.x = temp.x;
  vector.y = temp.y;
}
