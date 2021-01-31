PVector resolution = new PVector(1000, 1000); 
PVector bg_color = new PVector(0, 0, 0);

Object[] objects = new Object[3];

int bounces = 50;

public void settings(){
  size(int(resolution.x),int(resolution.y));
  //fullScreen();
  noLoop();
}

void setup() {
  objects[0] = new Sphere(new PVector(300, 2500, 3000), 2000, new PVector(72, 79, 84), 0.5, 0.8);
  objects[1] = new Sphere(new PVector(300, -2500, 3000), 2000, new PVector(255, 255, 255), 1, 0.3);
  
  
  // rote Kugel
  objects[2] = new Sphere(new PVector(300, 300, 3000), 200, new PVector(255, 0, 0), 0.3, 0.3);
  
  
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
}
