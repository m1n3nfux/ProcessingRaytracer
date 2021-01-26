PVector resolution = new PVector(400, 400); 

PVector bg_color = new PVector(0, 0, 0);

Ray[] rays = new Ray[int(resolution.x * resolution.y)];
Sphere[] spheres = new Sphere[3];

public void settings(){
  size(int(resolution.x),int(resolution.y));
}

void setup() {
  spheres[2] = new Sphere(new PVector(5,5,50), 20, new PVector(255, 0, 0));
  spheres[1] = new Sphere(new PVector(0,0,300), 200, new PVector(0, 255, 255));
  spheres[0] = new Sphere(new PVector(200,200,30), 20, new PVector(0, 0, 255));
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
  
  // Intersection
  float intersection_dist;
  PVector intersection_point;
  PVector intersection_normal;
  Sphere intersection_object;
  
  Ray(PVector origin_, PVector direction_) {
    origin = origin_;
    direction = direction_;
  }
  
  // Class Functions
  void get_intersection() {
    float t_min = 0;
    Sphere closest_sphere = null;
  
    for(Sphere sphere : spheres){
      float t = calc_intersection_dist(this, sphere);
      
      if( t != 0 ){ // hit
        if (t_min == 0 || t < t_min) {
          t_min = t;
          closest_sphere = sphere;
        }
      }
    }
    
    intersection_dist = t_min;
    intersection_object = closest_sphere; 
    intersection_point = calc_intersection_point(t_min, this);
    intersection_normal = PVector.sub(intersection_point, intersection_object.center).normalize();
  }
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

public float calc_intersection_dist(Ray ray, Sphere sphere){
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

public PVector calc_intersection_point(float t, Ray ray){
  PVector intersection_point = new PVector();
  intersection_point = PVector.add(ray.origin, PVector.mult(ray.direction, t));
  
  return intersection_point;
}


public void render(){ 
  for(Ray ray : rays){
    ray.get_intersection();
    
    // Drawing the pixel
    if (ray.intersection_dist != 0){ //if any hit, fill color = color of closest sphere
      stroke(ray.intersection_object.s_color.x, ray.intersection_object.s_color.y, ray.intersection_object.s_color.z);
    } else { //if no hit, fill color = background color
      stroke(bg_color.x, bg_color.y, bg_color.z);
    }
    point(ray.origin.x, ray.origin.y);
    
  }

  return;
}
