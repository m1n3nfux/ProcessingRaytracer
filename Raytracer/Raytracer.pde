PVector resolution = new PVector(600, 600); 
PVector bg_color = new PVector(255, 255, 255);

Object[] objects = new Object[3];

int bounces = 5;

public void settings(){
  size(int(resolution.x),int(resolution.y));
  //fullScreen();
  noLoop();
}

void setup() {
  // sphere(PVector(coordinates), radius, PVector(color), roughness, reflectivity);
  //objects[0] = new Sphere(new PVector(300, 2500, 3000), 2000, new PVector(72, 79, 84), 0.5, 0.8);
  
  //light source
  objects[0] = new Sphere(new PVector(300, -2000, 3000), 2000, new PVector(255, 255, 255), 0, 1);
  
  
  //small sphere
  objects[1] = new Sphere(new PVector(300, 200, 3000), 150, new PVector(50, 50, 50), 0.01, 1);
  
  //big sphere (subsoil)
  objects[2] = new Sphere(new PVector(300,12350, 3000), 12000, new PVector(50,50,50), 0.1, 0.3);
  
  //spheres[1] = new Sphere(new PVector(100, 50, 100), 50, new PVector(0, 200, 255), 0.6, 0.1);
  //spheres[2] = new Sphere(new PVector(500, 50, 100), 50, new PVector(0, 200, 255), 0.7, 0.9);
}


void draw() {
  // Sending a Ray for every pixel
  for (int x = 0; x < resolution.x; x++) {
    for (int y = 0; y < resolution.y; y++) {
      
      Ray r = new Ray( new PVector(x, y, 0), new PVector(0, 0, 1));
      PVector rColor = r.cast(null, new PVector(), 0);
      
      // Drawing the pixel
      stroke(rColor.x, rColor.y, rColor.z);
      point(r.origin.x, r.origin.y);
      
    }
  }
  
  // Done message with timer
  print("done [" + millis()/1000 + "s " + (millis() - (millis()/1000 * 1000)) + "ms]");
}
