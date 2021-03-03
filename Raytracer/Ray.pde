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
      // Get distance from ray.origin to the intersection point
      t = obj.intDist(this);
      
      if( t != 0 ){ //hit
        // determine closest intersection object
        if (t_min == 0 || t < t_min) {
          t_min = t;
          closest = obj; 
        }
      }
    }

    // calculate relevant information about intersection point
    if (t_min != 0) {
      intDist = t_min;
      intObj = closest;
      intPoint = PVector.add(origin, PVector.mult(direction, intDist));
      intNormal = intObj.getIntNormal(this);
      //if hit
      return true;
    }
    // if no hit
    return false;
  }
  
  // Cast the ray
  PVector cast(Object firstHitObject, PVector prevColor, int count) {
    PVector newColor = bg_color;
    
    if (intGet()) {
      if (count < bounces) {
        
        // Fist bounce color
        if (count == 0) {
          
          //intObj.c = new PVector(intNormal.x * 255, intNormal.y * 255, intNormal.z * 255);
          // ^ Uncomment to display direction of normals as colors
          
          newColor = intObj.c;
          firstHitObject = intObj;
          
        } else { 
          // 2nd-nth bounce: Add oject color to current color according to reflectivity settings
          newColor = PVector.add(PVector.mult(intObj.c, firstHitObject.reflectivity), PVector.mult(prevColor, 1-firstHitObject.reflectivity));
        }
      
        // Calculating the vector that forms the same angle relative to the normal as the incoming ray 
        PVector d = PVector.mult(direction, intDist);
        PVector intersection_vector = PVector.sub(PVector.mult(intNormal, 2 * PVector.dot(d, intNormal)), d);
      
        // Calculating the successive ray's origin and direction
        // The roughness-factor controls the amount of surface scattering (randomness of reflection-direction)
        PVector rDirection = 
          
          PVector.add(
            intersection_vector.normalize(), 
            
            new PVector(
              random(-1, 1) * intObj.roughness, 
              random(-1, 1) * intObj.roughness, 
              random(-1, 1) * intObj.roughness)
          
          ).normalize();
          
        PVector rOrigin = PVector.add(intPoint, PVector.mult(rDirection, 0.01)); // The successive ray gets a small offset to prevent intersection with previous hit object.
        
        // Only cast the next ray if it doesn't point into the object
        if (PVector.dot(rDirection, intNormal) >= 0) {
          
          // create and cast new ray
          Ray r = new Ray(rOrigin, rDirection);
          return r.cast(firstHitObject, newColor, count + 1);
          
        }
      }
      // If ray doesn't hit anything return final color
    } else if (firstHitObject != null) {
      newColor = PVector.add(PVector.mult(bg_color, 1-firstHitObject.reflectivity), PVector.mult(prevColor, firstHitObject.reflectivity));
    }
    // Returning final color
    return newColor;
  }
  
}
