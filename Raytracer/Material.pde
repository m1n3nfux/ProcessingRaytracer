class Material{
  float roughness;
  float reflectivity;
  float luminance;
  PVector c;
  Material(color c_ , float roughness_, float reflectivity_, float luminance_){
    c = new PVector(red(c_),green(c_), blue(c_));
    roughness = roughness_;
    reflectivity = reflectivity_;
    luminance = luminance_;
  }
  
}
