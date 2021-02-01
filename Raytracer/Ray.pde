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
        PVector rDirection = PVector.add(intersection_vector.normalize(), new PVector(random(-1, 1) * firstHitObject.roughness, random(-1, 1) * firstHitObject.roughness, random(-1, 1) * firstHitObject.roughness)).normalize();
        PVector rOrigin = PVector.add(intPoint, PVector.mult(rDirection, 0.01)); // The successive ray gets a small offset 
        
        // Only cast the next ray if it doesn't point into the object
        if (PVector.dot(rDirection, intNormal) >= 0) {
          Ray r = new Ray(rOrigin, rDirection);
          return r.cast(firstHitObject, newColor, count + 1);
        }
      } else if (count == bounces) {
        newColor = PVector.add(PVector.mult(bg_color, firstHitObject.reflectivity), PVector.mult(prevColor, 1-firstHitObject.reflectivity));
      }
    } 
    
    // Returning final color
    return newColor;
  }
  
}
