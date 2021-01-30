PVector resolution = new PVector(700, 700); 

PVector bg_color = new PVector(0, 0, 0);

Ray[] rays = new Ray[int(resolution.x * resolution.y)];
Sphere[] spheres = new Sphere[3];

int iterations = 9;

public void settings(){
  size(int(resolution.x),int(resolution.y));
  //fullScreen();
}

void setup() {
  spheres[0] = new Sphere(new PVector(500, 250,300), 150, new PVector(255, 0, 0), 0.3);
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
  Sphere intersection_object;
  
  Ray(PVector origin_, PVector direction_) {
    origin = origin_;
    direction = direction_;
  }
  
  // Class Functions
  void get_intersection() {
    float t_min = 0;
    Sphere closest_sphere = null;
  
    for(Sphere sphere : spheres){
      float t = calc_intersection_dist(this, sphere);
      
      if( t != 0 ){ // hit
        if (t_min == 0 || t < t_min) {
          t_min = t;
          closest_sphere = sphere;
        }
      }
    }
    
    if (t_min != 0) {
      intersection_dist = t_min;
      intersection_object = closest_sphere; 
      intersection_point = calc_intersection_point(t_min, this);
      intersection_normal = PVector.sub(intersection_point, intersection_object.center).normalize();
      
    }
  }
  
  PVector[] cast(PVector[] rColor, int count) {
    get_intersection();
    
    if (intersection_dist != 0) {
      rColor = ( PVector[] ) append(rColor, intersection_object.s_color);  
      
      if (count  < iterations) {
        PVector d = PVector.mult(direction, intersection_dist);
        PVector intersection_vector = PVector.sub(PVector.mult(intersection_normal, 2 * PVector.dot(d, intersection_normal)), d);
        
        PVector rDirection = PVector.add(intersection_vector.normalize(), new PVector(random(0, 1) * intersection_object.roughness, random(0, 1) * intersection_object.roughness, random(0, 1) * intersection_object.roughness)).normalize();
        PVector rOrigin = PVector.add(intersection_point, PVector.mult(rDirection, 0.001)); // The successive ray gets a small offset 
        
        Ray r = new Ray(rOrigin, rDirection);
        return r.cast(rColor, count + 1);
      }
    } else {
      rColor = ( PVector[] ) append(rColor, bg_color);
    }
    
    return rColor;// pixel zeichnen mit colour an pos
  }
  
}

class Sphere {
   PVector center;
   int radius;
   PVector s_color;
   float roughness;
   
   Sphere(PVector center_, int radius_, PVector color_, float r){
     center = center_;
     radius = radius_;
     s_color = color_;
     roughness = r;
   }
   
   // Class Functions
   
}

public float calc_intersection_dist(Ray ray, Sphere sphere){
  float t0;
  float t1;
  float t2;
  
  // formeln von scratchapixel.com
  float a = pow(ray.direction.mag(), 2);
  float b = PVector.mult(ray.direction, 2).dot(PVector.sub(ray.origin, sphere.center));
  float c = pow((PVector.sub(ray.origin, sphere.center).mag()), 2) - pow(sphere.radius, 2);
  //println(a);
  
  
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
  
  //println(t0);
  return t0;
}

public PVector calc_intersection_point(float t, Ray ray){
  PVector intersection_point = new PVector();
  intersection_point = PVector.add(ray.origin, PVector.mult(ray.direction, t));
  
  return intersection_point;
}

PVector calculate_color(PVector[] colors, float mixfac){
  PVector newcolor;
  if (colors.length > 0) {
    newcolor = colors[0];
    for(int i = 0; i < colors.length; i++){
      newcolor = PVector.add(PVector.mult(newcolor, mixfac), PVector.mult(colors[i], 1-mixfac));
    }
  } else {
    newcolor = new PVector(0, 0, 0);
  }
  
  return newcolor;
}


public void render(){ 
  for(Ray ray : rays){
    PVector rColor = calculate_color(ray.cast(new PVector[] {}, 0), 0.7);
    
    // Drawing the pixel
    stroke(rColor.x, rColor.y, rColor.z);
    point(ray.origin.x, ray.origin.y);
  }

  return;
}
