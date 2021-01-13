PVector resolution = new PVector(100, 100); 

Ray[] rays = new Ray[int(resolution.x * resolution.y)];
Sphere[] spheres = new Sphere[1];

void setup() {
  spheres[0] = new Sphere(new PVector(50,50,50), 5);
  
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

class Sphere {
   PVector center;
   int radius;
   
   Sphere(PVector center_, int radius_){
     center = center_;
     radius = radius_;
   }
   
   // Class Functions
   
}

public float[] detect_intersection(Ray ray, Sphere sphere){
  float t0;
  float t1;

  // formeln von scratchapixel.com
  float a = ray.direction.dot(ray.direction);
  float b = 2 * ray.direction.dot(ray.origin);
  float c = ray.origin.dot(ray.origin) - sphere.radius * sphere.radius;
  float delta = b * b - 4 * a * c;
  if( delta > 0){
    // 2 intersections
    t0 = ( -b + sqrt(delta) ) / ( 2*a );
    t1 = ( -b - sqrt(delta) ) / ( 2*a );

  } else if( delta == 0) {
    // 1 intersection
    t0 = -( b / 2*a);
    t1 = t0;

  } else {
    //no intersection
    t0 = 0;
    t1 = 0;
  }
  return new float[] {t0, t1};
}

public PVector calculate_intersection(float t0, float t1, Ray ray){
  PVector closest_intersection = new PVector();
  if ( t0 <= t1 ){
    closest_intersection = ray.origin.add(ray.direction.mult(t0));
  }  else if ( t1 < t0 ){
    closest_intersection = ray.origin.add(ray.direction.mult(t1));
  }
  return closest_intersection;
}
