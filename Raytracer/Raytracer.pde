PVector resolution = new PVector(10, 10); 

Ray[] rays = new Ray[int(resolution.x * resolution.y)];
Sphere[] spheres = new Sphere[3];

public void settings(){
  size(int(resolution.x),int(resolution.y));
}

void setup() {
  spheres[1] = new Sphere(new PVector(0,0,50), 5, new PVector(255, 0, 0));
  spheres[0] = new Sphere(new PVector(0,0,200), 10, new PVector(0, 255, 255));
  spheres[2] = new Sphere(new PVector(0,0,30), 2, new PVector(0, 0, 255));
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
  
  // ".mult(0.5)" ist ein hotfix von komischem verschieben von allem .mult(0.5)
  PVector l = ray.origin.sub(sphere.center); 
  
  float a = ray.direction.dot(ray.direction);
  
  //float b = 2 * ray.direction.dot(ray.origin); //origial
  float b = 2 * ray.direction.dot(l);
  
  //float c = ray.origin.dot(ray.origin) - sphere.radius * sphere.radius; // original
  float c = l.dot(l) - (sphere.radius * sphere.radius);
  
  
  //float a = 1;
  //float b = 2 * ray.direction.dot(ray.direction) * ray.origin.dot(ray.origin) - sphere.center.dot(sphere.center);
  //float c = pow(abs(ray.origin.dot(ray.origin) - sphere.center.dot(sphere.center)), 2);
  
  float delta = b * b - 4 * a * c;
  if( delta > 0){
    // 2 intersections
    //t1 = -0.5 * (b + sqrt(delta));
    //t2 = -0.5 * (b - sqrt(delta));
    
    t1 = -0.5 * (b + sqrt(delta))/a;
    t2 = -0.5 * (b - sqrt(delta))/a;
    
    if(t1 > t2){
      t0 = t2;
    }  else{
      t0 = t1;
    }
  } else if( delta == 0) {
    // 1 intersection
    t0 = -0.5 * b / a;
  
  
  } else {
    //no intersection
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
  //float t_array[[t(sphere1), t(sphere2) ],[]] = new float[100*100];
  //t_array[pixel[0]]
  
  for(Ray ray : rays){
    float t_min = 0;
    Sphere closest_sphere;
    PVector closest_sphere_color = new PVector(0,0,0);
    float t_array[][] = new float[spheres.length][2];
    
    for(int i = 0; i < spheres.length; i++){
      Sphere sphere = spheres[i];
      float t = detect_intersection(ray, sphere);
      
      t_array[i] = new float[] { i, t };
      //println(t);
      /*if( t != 0 ){
        // if hit
        if (t_min == 0) {
          //first hit
          t_min = t;
          closest_sphere = sphere;
          closest_sphere_color = closest_sphere.s_color;
        } else if (t < t_min) {
          //even closer hit
            t_min = t;
            closest_sphere = sphere;
            closest_sphere_color = closest_sphere.s_color;
        }
      }*/
    println(t_array[i]);
    }
    //println(t_min);
    // Drawing the pixel
    
    if (t_min != 0){
      //if any hit, fill color = color of closest sphere
      stroke(closest_sphere_color.x, closest_sphere_color.y, closest_sphere_color.z);
    } else {
      //if no hit, fill color = background color
      stroke(0,0,0);
    }
    point(ray.origin.x, ray.origin.y);
    
  }
  return;
}
