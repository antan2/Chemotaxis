fungus[] fungi = new fungus[1000];
food[] foods = new food[10];
float[] markx = new float[fungi.length];
float[] marky = new float[fungi.length];
float dist;
float dTemp;
int nTemp;
float nearesti;
boolean resetcheck() {
  for (int i = 0; i < foods.length; i++) {
    if (foods[i].fs > 10)
      return false;
  }
  return true;
}

void setup() {
  size(800, 800);
  for (int i = 0; i < fungi.length; i++) {
    fungi[i] = new fungus(400, 400, i);
  }
  for (int i = 0; i < foods.length; i++) {
    foods[i] = new food((int)(Math.random()*150)+50);
  }
  for (int i = 0; i < markx.length; i++) {
    markx[i] = 0;
    marky[i] = 0;
  }
}
void draw() {
  background(200, 200, 200, 75);
  for (int i = 0; i < foods.length; i++) {
    foods[i].show();
  }
  for (int i = 0; i < fungi.length; i++) {
    fungi[i].grow();
    fungi[i].mark();
    fungi[i].show();
  }
  if (resetcheck()) {
    resetFood();
  }
}

class fungus {
  float fx, fy;
  int fn, fc;
  boolean carry;
  fungus(float x, float y, int n) {
    fx = x;
    fy = y;
    fc = color(80 + (float)(Math.random()*50), 200 + (float)(Math.random()*50), 100 + (float)(Math.random()*50));
    fn = n;
    carry = false;
  }
  void grow() {
    if (carry == false) {
      fx += (Math.random()*8)-4;
      fy += (Math.random()*8)-4;
      dTemp = 999999;
      nTemp = 999999;
      for (int i = 0; i < markx.length; i++) {
        if (markx[i] != 0 && marky[i] != 0) {
          distance(fx, fy, markx[i], marky[i]);
          if (dTemp > dist) {
            dTemp = dist;
            nTemp = i;
          }
        }
      }
      if (nTemp != 999999) {
        if (dTemp < 250) {
          fx += (markx[nTemp]-fx)*0.005;
          fy += (marky[nTemp]-fy)*0.005;
        } else {
          fx += (markx[nTemp]-fx)*0.0005;
          fy += (marky[nTemp]-fy)*0.0005;
        }
      }
    } else {
      fx += (Math.random()*6)-3+(400-fx)*0.005;
      fy += (Math.random()*6)-3+(400-fy)*0.005;
    }
  }
  void mark() {
    if (carry == false) {
      for (int i = 0; i < foods.length; i++) {
        distance(fx, fy, foods[i].fx, foods[i].fy);
        if (dist < foods[i].fs/2) {
          carry = true;
          foods[i].fs -= 1;
          markx[fn] = foods[i].fx;
          marky[fn] = foods[i].fy;
          if (foods[i].fs <= 10) {
            for (int j = 0; j < markx.length; j++) {
              if (markx[j] == foods[i].fx && marky[j] == foods[i].fy) {
                markx[j] = 0;
                marky[j] = 0;
              }
            }
          }
        }
      }
    } else {
      distance(fx, fy, 400, 400);
      if (dist < 15) {
        carry = false;
      }
    }
  }
  void show() {
    stroke(fc-025025025);
    fill(fc);
    ellipse(fx, fy, 15, 15);
  }
}
class food {
  float fx, fy, fs;
  food(float s) {
    if (Math.random() < 0.5) {
      fx = 400+((float)(Math.random()*300)+100);
    } else {
      fx = 400-((float)(Math.random()*300)+100);
    }
    if (Math.random() < 0.5) {
      fy = 400+((float)(Math.random()*300)+100);
    } else {
      fy = 400-((float)(Math.random()*300)+100);
    }
    fs = s;
  }
  void show() {
    if (fs>10) {
      noStroke();
      fill(0, 0, 0);
      rect(fx-fs/2-2, fy-fs/20-2, fs+4, fs/10+4);
      ellipse(fx-fs/2, fy-fs/20, fs*3/20+4, fs*3/20+4);
      ellipse(fx-fs/2, fy+fs/20, fs*3/20+4, fs*3/20+4);
      ellipse(fx+fs/2, fy-fs/20, fs*3/20+4, fs*3/20+4);
      ellipse(fx+fs/2, fy+fs/20, fs*3/20+4, fs*3/20+4);
      ellipse(fx-fs*3/20, fy, fs/2+4, fs/2+4);
      ellipse(fx+fs*3/20, fy, fs/2+4, fs/2+4);
      fill(255, 255, 255);
      rect(fx-fs/2, fy-fs/20, fs, fs/10);
      ellipse(fx-fs/2, fy-fs/20, fs*3/20, fs*3/20);
      ellipse(fx-fs/2, fy+fs/20, fs*3/20, fs*3/20);
      ellipse(fx+fs/2, fy-fs/20, fs*3/20, fs*3/20);
      ellipse(fx+fs/2, fy+fs/20, fs*3/20, fs*3/20);
      fill(200, 150, 85);
      ellipse(fx-fs*3/20, fy, fs/2, fs/2);
      ellipse(fx+fs*3/20, fy, fs/2, fs/2);
    }
  }
}
void distance(float x1, float y1, float x2, float y2) {
  dist = (float)(Math.sqrt(Math.pow(x1-x2, 2)+Math.pow(y1-y2, 2)));
}

void resetFood() {
  for (int i = 0; i < foods.length; i++) {
    foods[i] = new food((int)(Math.random()*150)+50);
  }
  for (int i = 0; i < markx.length; i++) {
    markx[i] = 0;
    marky[i] = 0;
  }
}



