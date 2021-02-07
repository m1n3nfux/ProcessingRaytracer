float aspectratio = 16.0 / 9.0;
float frameWidth = 880;
float frameHeight = frameWidth / aspectratio;

float scale = 100;
float u = frameWidth / scale;

PVector resolution = new PVector(frameWidth, frameHeight); 
float FOV = 10; // in degrees; max is 180

PVector bg_color = new PVector(50, 50, 50);


PImage img = createImage(int(resolution.x), int(resolution.y), RGB);

int bounces = 10;
PVector density = new PVector(1, 1);

Object[] objects;
Camera cam = new Camera(new PVector(0, 0, 0), new PVector(0, 90, 0));

public void settings(){
  size(int(resolution.x),int(resolution.y));
  //fullScreen();

  noLoop();
}

void setup() {
  
  objects = new Object[] {
    new Sphere(new PVector(50, -100, 90), int(50), new PVector(255, 255, 255), 0, 0), // Light
    new Plane( new PVector(80, 60, 0), new PVector(200, 100, 100), 0.0, 0.5), // (subsoil)
    
    new Sphere(new PVector(-50, 40, 50), int(5), new PVector(46, 259, 151), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(60, 40, 50), int(5), new PVector(46, 215, 187), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(50, 40, 50), int(5), new PVector(46, 259, 151), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(80, 40, 50), int(5), new PVector(46, 215, 187), 0.2, 0.5), // Small sphere
    new Sphere(new PVector(100, 40, 50), int(5), new PVector(46, 259, 151), 0.2, 0.5), // Small sphere
};
  
  // Converting FOV from degrees to 0 - 1
  FOV = map(FOV, 0, 180, 0, 1);
}


void draw() {
  img.loadPixels();
  
  // Sending a Ray for every pixel
  for (int x = 0; x < resolution.x; x++) {
    for (int y = 0; y < resolution.y; y++) {
      
      PVector renderColor = new PVector();
      color c;
      for (int a = 0; a < density.x; a++) {
        for (int b = 0; b < density.y; b++) {
          
          PVector rDirection = new PVector( map(x, 0, resolution.x, -FOV , FOV ), map(y, 0, resolution.y, -FOV / aspectratio, FOV / aspectratio), 1);
          
          Ray r = new Ray(
            new PVector(x + a/(density.x), y + b/(density.y), 0), 
            PVector.add(rDirection, cam.direction).normalize()
          );
          
          if(a == 0 && b==0 && r.intGet() == false){
            renderColor = PVector.mult(bg_color, density.x * density.y);
            //break;
            a = int(density.x);
            b = int(density.y);
          }
          else {
            PVector col = r.cast(null, new PVector(), 0);
            renderColor.add(col);
            
          }
        }
      }
      
      c = color(renderColor.x / (density.x * density.y), renderColor.y / (density.x * density.y), renderColor.z / (density.x * density.y));
      //println(red(c), green(c), blue(c));
      img.pixels[int(y * resolution.x) + x] = c; // Adding pixel to image
      
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
  println(int(resolution.x * resolution.y) + " pixels rendered, using " + int((resolution.x * resolution.y) * (density.x * density.y)) + " rays. (" + int(density.x * density.y) + " rays per pixel)");
}
