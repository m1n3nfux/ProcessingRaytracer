float scale = 100;

//camera: position, rotation, FOV, aspectratio, width, density
Camera cam = new Camera(new PVector(0,0,0), new PVector(0,0,0), 90, 16.0/9.0, 880, new PVector(1,1));
Camera cam1 = new Camera(new PVector(0,0,0), new PVector(0,0,0), 90, 16.0/9.0, 880, new PVector(10,10));


// camera-dependent values
Camera selectedCam = cam;


PImage img = createImage(int(selectedCam.resolution.x), int(selectedCam.resolution.y), RGB);

int bounces = 10;

PVector bg_color = new PVector(50, 50, 50);

float u = selectedCam.u;

Object[] objects;

public void settings(){
  size(int(selectedCam.resolution.x),int(selectedCam.resolution.y));
  //fullScreen();

  noLoop();
}

void setup() {
  
  objects = new Object[] {
    new Sphere(new PVector(50, -100, 90), int(50), new PVector(255, 255, 255), 0, 0), // Light
    new Plane( new PVector(80, 60, 0), new PVector(200, 100, 100), 0.0, 0.5), // (subsoil)
    
    new Sphere(new PVector(-50, 40, 175), int(15), new PVector(46, 259, 151), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(0, 40, 175), int(15), new PVector(46, 215, 187), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(50, 40, 175), int(15), new PVector(46, 259, 151), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(100, 40, 175), int(15), new PVector(46, 215, 187), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(150, 40, 175), int(15), new PVector(46, 259, 151), 0.2, 0.5), // Small sphere
  };
}


void draw() {
  img.loadPixels();
  
  println(selectedCam, selectedCam.origin);
  
  // Sending a Ray for every pixel
  for (int x = 0; x < selectedCam.resolution.x; x++) {
    for (int y = 0; y < selectedCam.resolution.y; y++) {
      
      PVector renderColor = new PVector();
      color c;
      for (int a = 0; a < selectedCam.density.x; a++) {
        for (int b = 0; b < selectedCam.density.y; b++) {
          
          Ray r = new Ray(
            new PVector(x + selectedCam.origin.x + a/(selectedCam.density.x), y + selectedCam.origin.y + b/(selectedCam.density.y), 0 + selectedCam.origin.z), 
            new PVector( map(x, 0, selectedCam.resolution.x, -selectedCam.FOV , selectedCam.FOV ), map(y, 0, selectedCam.resolution.y, -selectedCam.FOV / selectedCam.aspectratio, selectedCam.FOV / selectedCam.aspectratio), 1)
          );
          
          if(a == 0 && b==0 && r.intGet() == false){
            renderColor = PVector.mult(bg_color, selectedCam.density.x * selectedCam.density.y);
            //break;
            a = int(selectedCam.density.x);
            b = int(selectedCam.density.y);
          }
          else {
            PVector col = r.cast(null, new PVector(), 0);
            renderColor.add(col);
            
          }
        }
      }
      
      c = color(renderColor.x / (selectedCam.density.x * selectedCam.density.y), renderColor.y / (selectedCam.density.x * selectedCam.density.y), renderColor.z / (selectedCam.density.x * selectedCam.density.y));
      //println(red(c), green(c), blue(c));
      img.pixels[int(y * selectedCam.resolution.x) + x] = c; // Adding pixel to image
    }
  }
  
  /*
  Ray r = new Ray( new PVector(x + a/(density/2), y + b/(density/2), 0), new PVector(0, 0, 1));
        if(a == 0 && r.intGet() == false){
          a = density;
        }
        else {
          PVector col = r.cast(null, new PVector(), 0);
          f++;
          //println(col);
          renderColor.add(col);
          
          b++;
        }
  */
  
  // Displaying the image
  img.updatePixels();
  image(img, 0, 0);
  
  // Saving the image
  //img.save("output.jpg");
  
  // Done message with timer
  println("done [" + millis()/1000 + "s " + (millis() - (millis()/1000 * 1000)) + "ms]");
  println(int(selectedCam.resolution.x * selectedCam.resolution.y) + " pixels rendered, using " + int((selectedCam.resolution.x * selectedCam.resolution.y) * (selectedCam.density.x * selectedCam.density.y)) + " rays. (" + int(selectedCam.density.x * selectedCam.density.y) + " rays per pixel)");
}
