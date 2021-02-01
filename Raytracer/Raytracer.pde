PVector resolution = new PVector(600, 600); 
PVector bg_color = new PVector(50, 50, 50);

Object[] objects = new Object[3];

PImage img = createImage(int(resolution.x), int(resolution.y), RGB);

int bounces = 2;

public void settings(){
  size(int(resolution.x),int(resolution.y));
  //fullScreen();
  noLoop();
}

void setup() {
  // sphere(PVector(coordinates), radius, PVector(color), roughness, reflectivity);
  //objects[0] = new Sphere(new PVector(300, 2500, 3000), 2000, new PVector(72, 79, 84), 0.5, 0.8);
  
  //light source
  objects[2] = new Sphere(new PVector(300, -500, 1200), 500, new PVector(255, 255, 255), 1, 1);
  
  
  //small sphere
  objects[0] = new Sphere(new PVector(300, 200, 1200), 150, new PVector(100, 100, 100), 0.3, 0.7);
  
  //big sphere (subsoil)
  objects[1] = new Sphere(new PVector(300,1550, 1200), 1200, new PVector(255,255,0), 0.2, 0.5);
  
  //spheres[1] = new Sphere(new PVector(100, 50, 100), 50, new PVector(0, 200, 255), 0.6, 0.1);
  //spheres[2] = new Sphere(new PVector(500, 50, 100), 50, new PVector(0, 200, 255), 0.7, 0.9);
}


void draw() {
  img.loadPixels();
  
  // Sending a Ray for every pixel
  for (int x = 0; x < resolution.x; x++) {
    for (int y = 0; y < resolution.y; y++) {
      
      Ray r = new Ray( new PVector(x, y, 0), new PVector(0, 0, 1));
      PVector rColor = r.cast(null, new PVector(), 0);
      
      // Adding pixel to image
      img.pixels[int(y * resolution.x) + x] = color(rColor.x, rColor.y, rColor.z);
      
    }
  }
  
  // Displaying the image
  img.updatePixels();
  image(img, 0, 0);
  
  // Saving the image
  img.save("output.jpg");
  
  // Done message with timer
  print("done [" + millis()/1000 + "s " + (millis() - (millis()/1000 * 1000)) + "ms]");
}
