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
    //println();
    for(Object obj : objects){
      float t = 0;
      
      t = obj.intDist(this);
      
      if( t != 0 ){ // hit
        if (t_min == 0 || abs(t) < t_min) {
        //if (t_min == 0 || t < t_min) {
          t_min = t;
          closest = obj; 
          
        }
      }
      //println(this.origin, obj, t, t_min);
    }

    if (t_min != 0) {
      intDist = t_min;
      intObj = closest;
      intPoint = PVector.add(origin, PVector.mult(direction, intDist));
      intNormal = intObj.getIntNormal(this);
      
      return true;
    }
    return false;
  }
  
  PVector cast(Object firstHitObject, PVector prevColor, int count) {
    PVector newColor = bg_color;
    
    if (intGet()) {
      if (count < bounces) {
        
        if (count == 0) {
          //intObj.c = new PVector(intNormal.x * 255, intNormal.y * 255, intNormal.z * 255);
          newColor = intObj.c;
          firstHitObject = intObj;
        } else { // Mixing current color with object-color
          newColor = PVector.add(PVector.mult(intObj.c, firstHitObject.reflectivity), PVector.mult(prevColor, 1-firstHitObject.reflectivity));
        }
      
        // Calculating the vector that forms the same angle relative to the normal as the incoming ray 
        PVector d = PVector.mult(direction, intDist);
        PVector intersection_vector = PVector.sub(PVector.mult(intNormal, 2 * PVector.dot(d, intNormal)), d);
        
        
        if (firstHitObject instanceof Sphere) {
          //println(intDist, intObj, firstHitObject);
        }
        
        //print(intersection_vector + ", \t\t\t");
        
        // Calculating the successive ray's origin and direction
        // The roughness-factor controls the amount of surface scattering (randomness of reflection-direction)
        PVector rDirection = 
          PVector.add(
            intersection_vector.normalize(), 
            new PVector(random(-1, 1) * firstHitObject.roughness, random(-1, 1) * firstHitObject.roughness, random(-1, 1) * firstHitObject.roughness)
          ).normalize();
          
        PVector rOrigin = PVector.add(intPoint, PVector.mult(rDirection, 0.01)); // The successive ray gets a small offset 
        //println(firstHitObject.getClass().getName());
        // Only cast the next ray if it doesn't point into the object
        if (PVector.dot(rDirection, intNormal) >= 0) {
          
          Ray r = new Ray(rOrigin, rDirection);
          return r.cast(firstHitObject, newColor, count + 1);
          
        }
      }
    } else if (firstHitObject != null) {
      newColor = PVector.add(PVector.mult(bg_color, 1-firstHitObject.reflectivity), PVector.mult(prevColor, firstHitObject.reflectivity));
    }
    // Returning final color
    return newColor;
  }
  
}
