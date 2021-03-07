class Object {
  PVector origin;

  PVector c;
  float roughness;
  float reflectivity;
  float luminance;
  // Dummy functions 
  float intDist(Ray ray) {
    return 0;
  }
  
  PVector getIntNormal(Ray ray) {
    return new PVector();
  }
}

class Sphere extends Object { 
  int radius;

  Sphere(PVector origin_, int radius_, Material material_) {
    origin = PVector.mult(origin_, u);
    radius = radius_ * int(u);
    c = material_.c;
    roughness = material_.roughness;
    reflectivity = material_.reflectivity;
    luminance = material_.luminance;
  } 

  float intDist(Ray ray) {
    float t0;
    float t1;
    float t2;

    // formeln von scratchapixel.com
    float a = pow(ray.direction.mag(), 2);
    float b = PVector.mult(ray.direction, 2).dot(PVector.sub(ray.origin, origin));
    float c = pow((PVector.sub(ray.origin, origin).mag()), 2) - pow(radius, 2);

    float delta = pow(b, 2) - 4 * a * c;
    
    // Look for intersections
    // 2 intersections
    if ( delta > 0) {

      t1 = -0.5 * (b + sqrt(delta))/a;
      t2 = -0.5 * (b - sqrt(delta))/a;
      
      // Get the closest one 
      if (abs(t1) > abs(t2)) {
        t0 = t2;
      } else {
        t0 = t1;
      }
      
    // 1 intersection
    } else if ( delta == 0) {
      t0 = -0.5 * b / a;
      
    // no intersection
    } else {
      t0 = 0;
    }
    
    return t0;
  }
  
  // Calculate the normal of the surface
  PVector getIntNormal(Ray ray) {
    return PVector.sub(origin, ray.intPoint).normalize();
  }
}

class Plane extends Object {
  PVector dimensions;
  PVector rotation;

  PVector normal = new PVector(0, 1, 0);

  Plane(PVector origin_, PVector dimensions_, PVector rotation_, Material material_) {
    origin = PVector.mult(origin_, u);
    dimensions = dimensions_;
    rotation = rotation_;
    
    c = material_.c;
    roughness = material_.roughness;
    reflectivity = material_.reflectivity;
    luminance = material_.luminance;
  }

  Plane(PVector origin_, Material material_) {
    origin = PVector.mult(origin_, u);
    
    c = material_.c;
    roughness = material_.roughness;
    reflectivity = material_.reflectivity;
    luminance = material_.luminance;
  }

  // Calculate the distance between origin and intersection point
  float intDist(Ray ray) {
    float a = PVector.dot(PVector.sub(origin, ray.origin), normal);
    float b = PVector.dot(ray.direction, normal);
    
    if (b != 0) {
      if (a/b > 0) {
        return a / b;
      }
    }
    
    return 0;
  }
  
  PVector getIntNormal(Ray ray) {
    return normal;
  }

}
