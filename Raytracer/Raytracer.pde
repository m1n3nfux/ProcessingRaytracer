PVector resolution = new PVector(100, 100); 

Ray[] rays = new Ray[int(resolution.x * resolution.y)];
Sphere[] spheres = new Sphere[1];

void setup() {
  spheres[0] = new Sphere(new PVector(50,50,50), 5, new PVector(255, 255, 255));
  
  int index = 0;
  for (int x = 0; x < resolution.x; x++) {
    for (int y = 0; y < resolution.y; y++) {
      rays[index] = ( new Ray( new PVector(x, y, 0), new PVector(0, 0, 1)) );
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
   PVector s_color;
   
   Sphere(PVector center_, int radius_, PVector color_){
     center = center_;
     radius = radius_;
     s_color = color_;
   }
   
   // Class Functions
   
}

public float detect_intersection(Ray ray, Sphere sphere){
  float t0;
  float t1;
  float t2;
  // formeln von scratchapixel.com
  /*float a = ray.direction.dot(ray.direction);
  float b = 2 * ray.direction.dot(ray.origin);
  float c = ray.origin.dot(ray.origin) - sphere.radius * sphere.radius;
  */
  float a = 1;
  float b = 2 * ray.direction.dot(ray.direction) * ray.origin.dot(ray.origin) - sphere.center.dot(sphere.center);
  float c = pow(abs(ray.origin.dot(ray.origin) - sphere.center.dot(sphere.center)), 2);
  float delta = b * b - 4 * a * c;
  if( delta > 0){
    // 2 intersections
    t1 = ( -b + sqrt(delta) ) / ( 2*a );
    t2 = ( -b - sqrt(delta) ) / ( 2*a );
    if(t1 > t2){
      t0 = t2;
    }  else{
      t0 = t1;
    }
  } else if( delta == 0) {
    // 1 intersection
    t0 = -( b / 2*a);

  } else {
    //no intersection
    t0 = 0;
  }
  return t0;
}
/*
public PVector calculate_intersection(float[] t, Ray ray){
  PVector closest_intersection = new PVector();
  if ( t[0] <= t[1] ){
    closest_intersection = ray.origin.add(ray.direction.mult(t[0]));
  }  else if ( t[1] < t[0] ){
    closest_intersection = ray.origin.add(ray.direction.mult(t[1]));
  }
  return closest_intersection;
}
*/

public void render(){ 
  float t_array[] = new float[100*100];
  for(Ray ray : rays){
    float t_min = 0;
    Sphere closest_sphere;
    for(Sphere sphere : spheres){
      float t = detect_intersection(ray, sphere);
      if (t_min == 0) {
        t_min = t;
      } else {
        if (t < t_min) {
          t_min = t;
          closest_sphere = sphere;
        }
      }
    }
    
    // Drawing the pixel
    if (t_min != 0){
      fill(closest_sphere.s_color.x, closest_sphere.s_color.y, closest_sphere.s_color.z);
    } else {
      fill(0,0,0);
    }
    rect(ray.origin.x, ray.origin.y, 1, 1);
  }
}
