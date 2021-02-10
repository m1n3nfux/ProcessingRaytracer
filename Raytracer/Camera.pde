class Camera {
  PVector origin;
  PVector direction;
  float FOV;
  float aspectratio;
  int frameWidth;
  int frameHeight;
  PVector resolution;
  PVector density;
  float u;
  Camera(PVector origin_, PVector direction_, float FOV_, float aspectratio_, int frameWidth_, PVector density_){
    u = frameWidth_ / scale;
    origin = PVector.mult(origin_, u);
    
    direction = direction_;
    FOV = map(FOV_, 0, 90, 0, 1); // Converting FOV from degrees to 0, 1
    aspectratio = aspectratio_;
    frameWidth = frameWidth_;
    frameHeight = int(frameWidth / aspectratio);
    resolution = new PVector(frameWidth, frameHeight); 
    density = density_;
  }
}
