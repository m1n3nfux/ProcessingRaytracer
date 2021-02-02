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
  PVector normal;

  Sphere(PVector origin_, int radius_, PVector c_, float roughness_, float reflectivity_) {
    origin = origin_;
    radius = radius_;
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

      if (t1 > t2) {
        t0 = t2;
      } else {
        t0 = t1;
      }
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
    origin = origin_;
    dimensions = dimensions_;
    rotation = rotation_;
    c = c_;
    roughness = roughness_;
    reflectivity = reflectivity_;
  }

  Plane(PVector origin_, PVector c_, float roughness_, float reflectivity_) {
    origin = origin_;
    c = c_;
    roughness = roughness_;
    reflectivity = reflectivity_;
  }

  float intDist(Ray ray) {
    //println(PVector.dot(PVector.sub(origin, ray.origin), normal));
    //println(PVector.dot(ray.direction, normal), ray.direction, normal);
    float b = PVector.dot(ray.direction, normal);
    
    if (b != 0) {
      return PVector.dot(PVector.sub(origin, ray.origin), normal) / b;
    }
    
    return 0;
  }
  
  PVector getIntNormal(Ray ray) {
    return normal;
  }

  void calc_points() { //calculate points from origin, dimension & rotation
  }
}
