class Camera {
  PVector origin;
  PVector direction;
  float FOV;
  Camera(PVector origin_, PVector direction_, float FOV_){
    origin = PVector.mult(origin_, u);
    direction = direction_;
    FOV = FOV_;
  }
}
