class Object {
  PVector origin;

  PVector c;
  float roughness;
  float reflectivity;

  float intDist(Ray ray) {
    return 0;
  }
  
  PVector getIntNormal(Ray ray) {
    return new PVector();
  }
}

class Sphere extends Object { 
  int radius;

  Sphere(PVector origin_, int radius_, PVector c_, float roughness_, float reflectivity_) {
    origin = PVector.mult(origin_, u);
    radius = radius_ * int(u);
    c = c_;
    roughness = roughness_;
    reflectivity = reflectivity_;
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
    if ( delta > 0) { // 2 intersections

      t1 = -0.5 * (b + sqrt(delta))/a;
      t2 = -0.5 * (b - sqrt(delta))/a;
      
      if (abs(t1) > abs(t2)) { // originally t1 < t2 -> in case of problems
        t0 = t2;
      } else {
        t0 = t1;
      }
      //println(ray.origin.x, ray.origin.y, ray.origin.z, this, t1, t2, t0);
    } else if ( delta == 0) { // 1 intersection
      t0 = -0.5 * b / a;
      
    } else { //no intersection
      t0 = 0;
    }
    
    return t0;
  }
  
  PVector getIntNormal(Ray ray) {
    return PVector.sub(origin, ray.intPoint).normalize();
  }
}

class Plane extends Object {
  PVector dimensions;
  PVector rotation;

  PVector normal = new PVector(0, 1, 0);

  Plane(PVector origin_, PVector dimensions_, PVector rotation_, PVector c_, float roughness_, float reflectivity_) {
    origin = PVector.mult(origin_, u);
    dimensions = dimensions_;
    rotation = rotation_;
    c = c_;
    roughness = roughness_;
    reflectivity = reflectivity_;
  }

  Plane(PVector origin_, PVector c_, float roughness_, float reflectivity_) {
    origin = PVector.mult(origin_, u);
    c = c_;
    roughness = roughness_;
    reflectivity = reflectivity_;
  }

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

  void calc_points() { //calculate points from origin, dimension & rotation
  }
}
