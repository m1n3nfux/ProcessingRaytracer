PVector resolution = new PVector(800, 800); 
PVector bg_color = new PVector(150, 150, 150);

Object[] objects = new Object[3];

PImage img = createImage(int(resolution.x), int(resolution.y), RGB);

int bounces = 3;
PVector density = new PVector(2, 2);
int f = 0;
int g = 0;
public void settings(){
  size(int(resolution.x),int(resolution.y));
  //fullScreen();

  noLoop();
}

void setup() {
  
  // sphere(PVector(coordinates), radius, PVector(color), roughness, reflectivity);
  //objects[0] = new Sphere(new PVector(300, 2500, 3000), 2000, new PVector(72, 79, 84), 0.5, 0.8);
  
  //light source
  objects[2] = new Sphere(new PVector(300, -500, 1200), 500, new PVector(255, 255, 255), 0, 1);
  
  
  //small sphere
  objects[0] = new Sphere(new PVector(400, 400, 200), 150, new PVector(190, 210, 255), 0, 0.7);
  
  //big sphere (subsoil)
  objects[1] = new Plane(new PVector(400, 600, 0), new PVector(200,100,100), 0, 0.5);
  //objects[1] = new Sphere(new PVector(300,1550, 1200), 1200, new PVector(200,100,100), 0.2, 0.5);
  
  //objects[3] = new Sphere(new PVector(6000, 1000, 1200), 4000, new PVector(255,255,255), 1,1);
  //spheres[1] = new Sphere(new PVector(100, 50, 100), 50, new PVector(0, 200, 255), 0.6, 0.1);
  //spheres[2] = new Sphere(new PVector(500, 50, 100), 50, new PVector(0, 200, 255), 0.7, 0.9);
}


void draw() {
  img.loadPixels();
  
  // Sending a Ray for every pixel
  for (int x = 0; x < resolution.x; x++) {
    for (int y = 0; y < resolution.y; y++) {
      g++;
      PVector renderColor = new PVector();
      color c;
      for (int a = 0; a < density.x; a++) {
        for (int b = 0; b < density.y; b++) {
          Ray r = new Ray( new PVector(x + a/(density.x), y + b/(density.y), 0), new PVector(0, 0, 1));
          
          if(a == 0 && b==0 && r.intGet() == false){
            renderColor = PVector.mult(bg_color, density.x * density.y);
            //break;
            a = int(density.x);
            b = int(density.y);
          }
          else {
            PVector col = r.cast(null, new PVector(), 0);
            f++;
            //println(col);
            renderColor.add(col);
            
          }
        }
      }
      
      c = color(renderColor.x / (density.x * density.y), renderColor.y / (density.x * density.y), renderColor.z / (density.x * density.y));
      //println(red(c), green(c), blue(c));
      img.pixels[int(y * resolution.x) + x] = c; // Adding pixel to image
      
    }
  }
  
  /*
  Ray r = new Ray( new PVector(x + a/(density/2), y + b/(density/2), 0), new PVector(0, 0, 1));
        if(a == 0 && r.intGet() == false){
          a = density;
        }
        else {
          PVector col = r.cast(null, new PVector(), 0);
          f++;
          //println(col);
          renderColor.add(col);
          
          b++;
        }
  */
  
  // Displaying the image
  img.updatePixels();
  image(img, 0, 0);
  
  // Saving the image
  //img.save("output.jpg");
  
  // Done message with timer
  println("done [" + millis()/1000 + "s " + (millis() - (millis()/1000 * 1000)) + "ms]");
  println(g + " pixels rendered, using " + f + " rays. (" + density + " rays per pixel)");
}
