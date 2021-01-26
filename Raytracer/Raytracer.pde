PVector resolution = new PVector(150, 150); 

PVector bg_color = new PVector(0, 0, 0);

Ray[] rays = new Ray[int(resolution.x * resolution.y)];
Sphere[] spheres = new Sphere[3];

public void settings(){
  size(int(resolution.x),int(resolution.y));
}

void setup() {
  spheres[2] = new Sphere(new PVector(50,0,50), 50, new PVector(255, 0, 0));
  spheres[1] = new Sphere(new PVector(0,0,200), 100, new PVector(0, 255, 255));
  spheres[0] = new Sphere(new PVector(0,0,30), 20, new PVector(0, 0, 255));
  noLoop();
  int index = 0;
  for (int x = 0; x < resolution.x; x++) {
    for (int y = 0; y < resolution.y; y++) {
      rays[index] = ( new Ray( new PVector(x, y, 0), new PVector(0, 0, 1)) );
      index++;
    }
  }
  
}

void draw() {
  /*for(Ray ray : rays) {
    println(PVector.add(ray.origin, ray.direction.mult(4)));
  }
  */
  render();
   
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
  float a = pow(ray.direction.mag(), 2);
  float b = PVector.mult(ray.direction, 2).dot(PVector.sub(ray.origin, sphere.center));
  float c = pow((PVector.sub(ray.origin, sphere.center).mag()), 2) - pow(sphere.radius, 2);
  //println(a);
  
  
  float delta = pow(b, 2) - 4 * a * c;
  if( delta > 0){ // 2 intersections
    
    t1 = -0.5 * (b + sqrt(delta))/a;
    t2 = -0.5 * (b - sqrt(delta))/a;
    
    if(t1 > t2){
      t0 = t2;
    } else {
      t0 = t1;
    }
  
  } else if( delta == 0) { // 1 intersection
    t0 = -0.5 * b / a;
  
  
  } else { //no intersection
    t0 = 0;
  }
  
  //println(t0);
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
  for(Ray ray : rays){
    float t_min = 0;
    Sphere closest_sphere;
    PVector closest_sphere_color = new PVector(0,0,0);
  
    for(Sphere sphere : spheres){
      float t = detect_intersection(ray, sphere);
      
      if( t != 0 ){ // hit
        if (t_min == 0 || t < t_min) {
          t_min = t;
          closest_sphere = sphere;
          closest_sphere_color = closest_sphere.s_color;
        }
      }
    }
    
    // Drawing the pixel
    if (t_min != 0){ //if any hit, fill color = color of closest sphere
      stroke(closest_sphere_color.x, closest_sphere_color.y, closest_sphere_color.z);
    } else { //if no hit, fill color = background color
      stroke(bg_color.x, bg_color.y, bg_color.z);
    }
    point(ray.origin.x, ray.origin.y);
    
  }

  return;
}
