fungus[] fungi = new fungus[1500];
food[] foods = new food[10];
float[] markx = new float[fungi.length];
float[] marky = new float[fungi.length];
int[] totals = new int[4];
float dist;
float dTemp;
int nTemp;
int ni = 0;
float nearesti;
boolean win = false;
boolean resetcheck() {
  for (int i = 0; i < foods.length; i++) {
    if (foods[i].fs > 10)
      return false;
  }
  return true;
}

void setup() {
  size(800, 800);
  for (int i = 0; i < 90; i++) {
    fungi[i] = new fungus(400, 400, i, i%3+1);
    ni++;
  }
  for (int i = 0; i < foods.length; i++) {
    foods[i] = new food((int)(Math.random()*(ni-totals[3])/10)+30);
  }
  for (int i = 0; i < markx.length; i++) {
    markx[i] = 0;
    marky[i] = 0;
  }
}
void draw() {
  background(200, 200, 200, 75);
  for (int i = 0; i < ni; i++) {
    if(fungi[i].fm == 4){
      fungi[i].show();
    }
  }
  for (int i = 0; i < foods.length; i++) {
    foods[i].show();
  }
  for (int i = 0; i < totals.length; i++) {
    totals[i] = 0;
  }
  for (int i = 0; i < ni; i++) {
    fungi[i].grow();
    fungi[i].mark();
    if (fungi[i].fm != 4) {
      fungi[i].show();
    }
    fungi[i].total();
  }
  if (resetcheck()) {
    for (int i = 0; i<ni; i++) {
      fungi[i].starve();
    }
    if (ni == 1500 && win == false) {
      win = true;
      fill(255, 255, 255, 50);
      noStroke();
      rect(0, 350, 800, 200);
      fill(0, 0, 0);
      textAlign(CENTER, CENTER);
      textSize(50);
      if (totals[0] > totals[1] && totals[0] > totals[2]) {
        text("The winner is Green!", 400, 400);
      } else if (totals[1] > totals[2] && totals[1] > totals[0]) {
        text("The winner is Blue!", 400, 400);
      } else if (totals[2] > totals[1] && totals[2] > totals[0]) {
        text("The winner is Red!", 400, 400);
      } else {
        text("What? We have a tie!", 400, 400);
      }
      textSize(30);
      text("Click to restart!", 400, 500);
      noLoop();
    }
    resetFood();
  }
  noStroke();
  fill(255, 255, 255, 50);
  rect(0, 700, 100, 100);
  fill(0, 0, 0);
  textAlign(LEFT, BOTTOM);
  textSize(15);
  text(" GREEN: " + totals[0] + "\n BLUE: " + totals[1] + "\n RED: " + totals[2] + "\n STARVED: " + totals[3], 0, 800);
}

class fungus {
  float fx, fy, fr, ft;
  int fn, fc, fm;
  boolean carry, carried;
  fungus(float x, float y, int n) {
    fx = x;
    fy = y;
    fn = n;
    ft = 0.05;
    carry = false;
    carried = false;
    fm = (int)(Math.random()*3+1);
    if (fm == 1) {
      fc = color(80 + (float)(Math.random()*50), 200 + (float)(Math.random()*50), 100 + (float)(Math.random()*50));
    } else if (fm == 2) {
      fc = color(100 + (float)(Math.random()*50), 80 + (float)(Math.random()*50), 200 + (float)(Math.random()*50));
    } else if (fm == 3) {
      fc = color(200 + (float)(Math.random()*50), 100 + (float)(Math.random()*50), 80 + (float)(Math.random()*50));
    }
    fr = (float)(Math.random()*TWO_PI);
  }
  fungus(float x, float y, int n, int t) {
    fx = x;
    fy = y;
    fn = n;
    ft = 0.05;
    carry = false;
    fm = t;
    if (fm == 1) {
      fc = color(80 + (float)(Math.random()*50), 200 + (float)(Math.random()*50), 100 + (float)(Math.random()*50));
    } else if (fm == 2) {
      fc = color(100 + (float)(Math.random()*50), 80 + (float)(Math.random()*50), 200 + (float)(Math.random()*50));
    } else if (fm == 3) {
      fc = color(200 + (float)(Math.random()*50), 100 + (float)(Math.random()*50), 80 + (float)(Math.random()*50));
    }
    fr = (float)(Math.random()*TWO_PI);
  }
  void grow() {
    if (fm == 1) {
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
            fx += (markx[nTemp]-fx)*0.01;
            fy += (marky[nTemp]-fy)*0.01;
          } else {
            fx += (markx[nTemp]-fx)*0.001;
            fy += (marky[nTemp]-fy)*0.001;
          }
        }
      } else {
        fx += (Math.random()*6)-3+(400-fx)*0.005;
        fy += (Math.random()*6)-3+(400-fy)*0.005;
      }
    } else if (fm == 2) {
      if (carry == false) {
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
          fx += (markx[nTemp]-fx)/Math.abs(markx[nTemp]-fx)*(Math.random()+0.5);
          fy += (marky[nTemp]-fy)/Math.abs(marky[nTemp]-fy)*(Math.random()+0.5);
        } else {
          fx += (Math.random()*6)-3;
          fy += (Math.random()*6)-3;
        }
      } else {
        fx += (400-fx)/Math.abs(400-fx)*(Math.random()+0.5);
        fy += (400-fy)/Math.abs(400-fy)*(Math.random()+0.5);
      }
    } else if (fm ==3) {
      if (carry == false) {
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
        if (nTemp != 999999 && dTemp < 250) {
          fx += (markx[nTemp]-fx)/Math.abs(markx[nTemp]-fx)*(Math.random()+0.5);
          fy += (marky[nTemp]-fy)/Math.abs(marky[nTemp]-fy)*(Math.random()+0.5);
        } else {
          fx += cos(fr)*ft;
          fy += sin(fr)*ft;
          fr+= 0.01;
          if (ft<2.5) {
            ft += 0.0025;
          }
        }
      } else {
        fx += (400-fx)/Math.abs(400-fx)*(Math.random()+0.5);
        fy += (400-fy)/Math.abs(400-fy)*(Math.random()+0.5);
      }
    }
  }
  void mark() {
    if (carry == false) {
      for (int i = 0; i < foods.length; i++) {
        distance(fx, fy, foods[i].fx, foods[i].fy);
        if (dist < foods[i].fs*1.5) {
          if (dist < foods[i].fs*0.75) {
            carry = true;
            carried = true;
            foods[i].fs -= 1;
          }
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
        ft = 0.05;
        fr = (float)(Math.random()*TWO_PI);
        if (ni < fungi.length) {
          fungi[ni] = new fungus(400, 400, ni, fm);
          ni++;
        }
      }
    }
  }
  void starve() {
    if (carried == false) {
      fm = 4;
    }
  }
  void total() {
    totals[fm-1] ++;
  }
  void show() {
    if (fm != 4) {
      stroke(fc-025025025);
      fill(fc);
      ellipse(fx, fy, 15, 15);
    } else {
      stroke(150, 150, 150, 25);
      fill(200, 200, 200, 25);
      ellipse(fx, fy, 15, 15);
      textAlign(CENTER, CENTER);
      fill(0, 0, 0, 25);
      textSize(15);
      text("RIP", fx, fy);
    }
  }
}
class food {
  float fx, fy, fs;
  food(float s) {
    fx = 0;
    fy = 0;
    dist = 400;
    while (dist > 350) {
      if (Math.random() < 0.5) {
        fx = 400+((float)(Math.random()*250)+100);
      } else {
        fx = 400-((float)(Math.random()*250)+100);
      }
      if (Math.random() < 0.5) {
        fy = 400+((float)(Math.random()*250)+100);
      } else {
        fy = 400-((float)(Math.random()*250)+100);
      }
      distance(fx, fy, 400, 400);
    }
    fs = s;
  }
  void show() {
    if (fs>10) {
      noStroke();
      fill(0, 0, 0);
      rect(fx-fs-2, fy-fs/10-2, fs*2+4, fs/5+4);
      ellipse(fx-fs, fy-fs/10, fs*3/10+4, fs*3/10+4);
      ellipse(fx-fs, fy+fs/10, fs*3/10+4, fs*3/10+4);
      ellipse(fx+fs, fy-fs/10, fs*3/10+4, fs*3/10+4);
      ellipse(fx+fs, fy+fs/10, fs*3/10+4, fs*3/10+4);
      ellipse(fx-fs*3/10, fy, fs+4, fs+4);
      ellipse(fx+fs*3/10, fy, fs+4, fs+4);
      fill(255, 255, 255);
      rect(fx-fs, fy-fs/10, fs*2, fs/5);
      ellipse(fx-fs, fy-fs/10, fs*3/10, fs*3/10);
      ellipse(fx-fs, fy+fs/10, fs*3/10, fs*3/10);
      ellipse(fx+fs, fy-fs/10, fs*3/10, fs*3/10);
      ellipse(fx+fs, fy+fs/10, fs*3/10, fs*3/10);
      fill(200, 150, 85);
      ellipse(fx-fs*3/10, fy, fs, fs);
      ellipse(fx+fs*3/10, fy, fs, fs);
    }
  }
}
void distance(float x1, float y1, float x2, float y2) {
  dist = (float)(Math.sqrt(Math.pow(x1-x2, 2)+Math.pow(y1-y2, 2)));
}

void resetFood() {
  for (int i = 0; i < foods.length; i++) {
    foods[i] = new food((int)(Math.random()*(ni-totals[3])/10)+30);
  }
  for (int i = 0; i < markx.length; i++) {
    markx[i] = 0;
    marky[i] = 0;
  }
}

void mousePressed() {
  if (win == true) {
    win = false;
    ni = 0;
    for (int i = 0; i < 90; i++) {
      fungi[i] = new fungus(400, 400, i, i%3+1);
      ni++;
    }
    totals[3] = 0;
    resetFood();
    loop();
  }
}
