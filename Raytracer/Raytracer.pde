PVector resolution = new PVector(1000, 1000); 

PVector bg_color = new PVector(0, 0, 0);

Ray[] rays = new Ray[int(resolution.x * resolution.y)];
Object[] objects = new Object[3];

int bounces = 50;

public void settings(){
  size(600, 600);
  //size(int(resolution.x),int(resolution.y));
  //fullScreen();
}

void setup() {
  objects[0] = new Sphere(new PVector(300, 2500, 3000), 2000, new PVector(72, 79, 84), 0.5, 0.8);
  objects[1] = new Sphere(new PVector(300, -2500, 3000), 2000, new PVector(255, 255, 255), 1, 0.3);
  
  
  // rote Kugel
  objects[2] = new Sphere(new PVector(300, 300, 3000), 200, new PVector(255, 0, 0), 0.3, 0.3);
  
  
  //spheres[1] = new Sphere(new PVector(100, 50, 100), 50, new PVector(0, 200, 255), 0.6, 0.1);
  //spheres[2] = new Sphere(new PVector(500, 50, 100), 50, new PVector(0, 200, 255), 0.7, 0.9);
  
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
  for(Ray ray : rays){
    PVector rColor = ray.cast(null, new PVector(), 0);
    
    // Drawing the pixel
    stroke(rColor.x, rColor.y, rColor.z);
    point(ray.origin.x, ray.origin.y);
  }
}

class Ray {
  PVector origin;
  PVector direction;
  
  // Intersection
  float intDist;
  PVector intPoint;
  PVector intNormal;
  Object intObj;
  
  Ray(PVector origin_, PVector direction_) {
    origin = origin_;
    direction = direction_;
  }
  
  boolean intGet() {
    float t_min = 0;
    Object closest = null;
  
    for(Object obj : objects){
      float t = 0;
      
      t = obj.intDist(this);
      
      if( t != 0 ){ // hit
        if (t_min == 0 || t < t_min) {
          t_min = t;
          closest = obj;
        }
      }
    }
    
    if (t_min != 0) {
      intDist = t_min;
      intObj = closest; 
      intPoint = PVector.add(origin, PVector.mult(direction, t_min));
      intNormal = PVector.sub(intObj.center, intPoint).normalize();
      
      return true;
    }
    return false;
  }
  
  PVector cast(Object firstHitObject, PVector prevColor, int count) {
    PVector newColor = new PVector();
    
    if (intGet()) {      
      if (count < bounces) {
        
        if (count == 0) {
          newColor = intObj.Color;
          firstHitObject = intObj;
        } else { // Mixing current color with object-color
          newColor = PVector.add(PVector.mult(intObj.Color, firstHitObject.gloss), PVector.mult(prevColor, 1-firstHitObject.gloss));
        }
      
        // Calculating the vector that forms the same angle relative to the normal as the incoming ray 
        PVector d = PVector.mult(direction, intDist);
        PVector intersection_vector = PVector.sub(PVector.mult(intNormal, 2 * PVector.dot(d, intNormal)), d);
        
        // Calculating the successive ray's origin and direction
        PVector rDirection = PVector.add(intersection_vector.normalize(), new PVector(random(-1, 1) * intObj.roughness, random(-1, 1) * intObj.roughness, random(-1, 1) * intObj.roughness)).normalize();
        PVector rOrigin = PVector.add(intPoint, PVector.mult(rDirection, 0.01)); // The successive ray gets a small offset 
        
        // Only cast the next ray if it doesn't point into the object
        if (PVector.dot(rDirection, intNormal) >= 0) {
          Ray r = new Ray(rOrigin, rDirection);
          return r.cast(firstHitObject, newColor, count + 1);
        }
      }
      
    }
    
    // Returning final color
    return newColor;
  }
  
}

class Object {
  PVector center;
  
  PVector Color;
  float roughness;
  float gloss;
  
  float intDist(Ray ray) {
    return 0;
  }
}

class Sphere extends Object{ 
   int radius;
   
   Sphere(PVector center_, int radius_, PVector color_, float roughness_, float gloss_){
     center = center_;
     radius = radius_;
     Color = color_;
     roughness = roughness_;
     gloss = gloss_;
   } 
   
  float intDist(Ray ray){
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
