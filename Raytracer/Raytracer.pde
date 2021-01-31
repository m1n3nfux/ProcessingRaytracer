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
          newColor = PVector.add(PVector.mult(intObj.Color, firstHitObject.reflectivity), PVector.mult(prevColor, 1-firstHitObject.reflectivity));
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
