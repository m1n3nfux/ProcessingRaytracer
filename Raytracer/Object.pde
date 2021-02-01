class Object {
  PVector center;
  
  PVector Color;
  float roughness;
  float reflectivity;
  
  float intDist(Ray ray) {
    return 0;
  }
}

class Sphere extends Object{ 
   int radius;
   
   Sphere(PVector center_, int radius_, PVector color_, float roughness_, float reflectivity_){
     center = center_;
     radius = radius_;
     Color = color_;
     roughness = roughness_;
     reflectivity = reflectivity_;
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

class plane extends Object{
  
  
}
