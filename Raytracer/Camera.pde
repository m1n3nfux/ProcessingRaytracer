class Camera {
 PVector origin;
 PVector direction = new PVector();
 
 Camera(PVector origin_, PVector direction_) {
   origin = origin_;
   direction.x = map(direction_.x, 0, 360, 0, 1);
   direction.y = map(direction_.y, 0, 360, 0, 1);
   direction.z = map(direction_.z, 0, 360, 0, 1);
 }
}
