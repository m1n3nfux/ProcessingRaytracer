PVector resolution = new PVector(100, 100); 

Ray[] rays = new Ray[int(resolution.x * resolution.y)];

void setup() {
  int index = 0;
  for (int x = 0; x < resolution.x; x++) {
    for (int y = 0; y < resolution.y; y++) {
      rays[index] = ( new Ray( new PVector(x, y), new PVector(0, 0, 1)) );
      index++;
    }
  }
}

void draw() {
  for(Ray ray : rays) {
    println(PVector.add(ray.origin, ray.direction.mult(4)));
  }
}

class Ray {
  PVector origin;
  PVector direction;
  
  Ray(PVector origin_, PVector direction_) {
    origin = origin_;
    direction = direction_;
  }
  
  // Class Functions

}
