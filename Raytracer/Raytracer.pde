PVector resolution = new PVector(1000, 1000); 

PVector bg_color = new PVector(0, 0, 0);

Ray[] rays = new Ray[int(resolution.x * resolution.y)];
Sphere[] spheres = new Sphere[3];

int iterations = 50;

public void settings(){
  size(600, 600);
  //size(int(resolution.x),int(resolution.y));
  //fullScreen();
}

void setup() {
  //spheres[0] = new Sphere(new PVector(300, 2450, 300), 2000, new PVector(216, 232, 255), 1);
  
  
  // rote Kugel
  spheres[0] = new Sphere(new PVector(300, 300, 300), 150, new PVector(255, 0, 0), 0.3);
  
  
  spheres[1] = new Sphere(new PVector(100,50,100), 50, new PVector(0, 255, 255), 0.6);
  spheres[2] = new Sphere(new PVector(300,150,80), 25, new PVector(0, 0, 255), 0.7);
  //spheres[3] = new Sphere(new PVector(width/2, height/2, 40000), 5000, new PVector(255, 255, 255));
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
  Object intersection_object;
  
  Ray(PVector origin_, PVector direction_) {
    origin = origin_;
    direction = direction_;
  }
  
  // Class Functions
  void get_intersection() {
    float t_min = 0;
    Object closest = null;
  
    for(Sphere sphere : spheres){
      float t = sphere.calc_intersection_dist(this);
      
      if( t != 0 ){ // hit
        if (t_min == 0 || t < t_min) {
          t_min = t;
          closest = sphere;
        }
      }
    }
    
    if (t_min != 0) {
      intersection_dist = t_min;
      intersection_object = closest; 
      intersection_point = PVector.add(origin, PVector.mult(direction, intersection_dist));
      intersection_normal = PVector.sub(intersection_object.center, intersection_point).normalize();
    }
  }
  
  PVector[] cast(PVector[] colors, int count) {
    get_intersection();
    
    if (intersection_dist != 0) {
      colors = ( PVector[] ) append(colors, intersection_object.Color);
      
      if (count  < iterations) {
        // Calculating the vector that forms the same angle relative to the normal as the incoming ray 
        PVector d = PVector.mult(direction, intersection_dist);
        PVector intersection_vector = PVector.sub(PVector.mult(intersection_normal, 2 * PVector.dot(d, intersection_normal)), d);
        
        // Calculating the successive ray's origin and direction
        PVector rDirection = PVector.add(intersection_vector.normalize(), new PVector(random(-1, 1) * intersection_object.roughness, random(-1, 1) * intersection_object.roughness, random(-1, 1) * intersection_object.roughness)).normalize();
        PVector rOrigin = PVector.add(intersection_point, PVector.mult(rDirection, 0.01)); // The successive ray gets a small offset 
        
        // Only cast the next ray if it doesn't point into the object
        if (PVector.dot(rDirection, intersection_normal) >= 0) {
          Ray r = new Ray(rOrigin, rDirection);
          return r.cast(colors, count + 1);
        }
      }
    } else {
      colors = ( PVector[] ) append(colors, bg_color);
    }
    
    // Returning an aray of colors 
    return colors;
  }
  
}

class Object {
  PVector center;
  
  PVector Color;
  float roughness;
}

class Sphere extends Object{ 
   int radius;
   
   Sphere(PVector center_, int radius_, PVector color_, float roughness_){
     center = center_;
     radius = radius_;
     Color = color_;
     roughness = roughness_;
   } 
   
  float calc_intersection_dist(Ray ray){
    float t0;
    float t1;
    float t2;
    
    // formeln von scratchapixel.com
    float a = pow(ray.direction.mag(), 2);
    float b = PVector.mult(ray.direction, 2).dot(PVector.sub(ray.origin, center));
    float c = pow((PVector.sub(ray.origin, center).mag()), 2) - pow(radius, 2);
    
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
    
    return t0;
  }
}

PVector calculate_color(PVector[] colors, float mixfac){
  PVector newcolor = new PVector();
  
  if (colors.length > 0) {
    for(int i = 0; i < colors.length; i++){
      newcolor = PVector.add(PVector.mult(newcolor, mixfac), PVector.mult(colors[i], 1-mixfac));
    }
  }
  
  return newcolor;
}


public void render(){ 
  for(Ray ray : rays){
    PVector rColor = calculate_color(ray.cast(new PVector[] {}, 0), 0.3);
    
    // Drawing the pixel
    stroke(rColor.x, rColor.y, rColor.z);
    point(ray.origin.x, ray.origin.y);
  }

  return;
}
