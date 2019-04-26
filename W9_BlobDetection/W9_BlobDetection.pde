import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

BlobDetection blobDetect = new BlobDetection();
PImage test_img;
PImage img2;
List<TreeSet<Integer>> labelsEquivalences= new ArrayList<TreeSet<Integer>>();

class BlobDetection {
  PImage findConnectedComponents(PImage input, boolean onlyBiggest){
    // First pass: label the pixels and store labels' equivalences
    int [] labels= new int [input.width*input.height];
    for(int z=0; z<input.width*input.height; z++) labels[z] = -1;
    int currentLabel=1;
    for(int i = 0; i < input.width*input.height ; i++){
      //assuming that all the three channels have the same value
      if(brightness(input.pixels[i]) == 255 && i == 0){
        labels[i] = currentLabel;
        currentLabel++;
        continue;
      }
      if(brightness(input.pixels[i]) == 255){
        // first line
        if(i < input.width){
          if(labels[i-1] < currentLabel && labels[i-1]>0){
            labels[i] = labels[i- 1];
          }
          else{
            labels[i] = currentLabel;
            currentLabel++;
          }
        }
        // first column
        else if((i+1)%input.width == 1){
          int minLabel = currentLabel;
          boolean foundLabel = false;
          for(int j=0; j<2; j++){
            if(labels[i-input.width+j] < minLabel && labels[i-input.width+j]>0){
              foundLabel = true;
              minLabel = labels[i-input.width+j];
            }
          }
          if(foundLabel){
            labels[i] = minLabel;
            for(int j=0; j<2; j++){
              if(labels[i-input.width+j] > minLabel){
                boolean treeContainsElmts = false;
                for(int el = 0; el < labelsEquivalences.size(); el++){
                  if(labelsEquivalences.get(el).contains(minLabel) && labelsEquivalences.get(el).contains(labels[i-input.width+j])) treeContainsElmts = true;
                }
                if(!treeContainsElmts){
                  TreeSet newTreeset = new TreeSet();
                  newTreeset.add(minLabel);
                  newTreeset.add(labels[i-input.width+j]);
                  labelsEquivalences.add(newTreeset);
                }
              }
            }
          }
          else{
            labels[i] = minLabel;
            currentLabel++;
          }
        }
        // last column
        else if((i+1)%input.width == 0){
          int minLabel = currentLabel;
          boolean foundLabel = false;
          if(labels[i- 1] <= minLabel  && labels[i-1]>0){
            minLabel = labels[i- 1];
            foundLabel = true;
          }
          for(int j=0; j<2; j++){
            if(labels[i-input.width-1+j] <= minLabel && labels[i-input.width-1+j]>0){
              foundLabel = true;
              minLabel = labels[i-input.width-1+j];
            }
          }
          if(foundLabel){
            labels[i] = minLabel;
            if(labels[i- 1] > minLabel){
                boolean treeContainsElmts = false;
                for(int el = 0; el < labelsEquivalences.size(); el++){
                  if(labelsEquivalences.get(el).contains(minLabel) && labelsEquivalences.get(el).contains(labels[i-1])) treeContainsElmts = true;
                }
                if(!treeContainsElmts){
                  TreeSet newTreeset = new TreeSet();
                  newTreeset.add(minLabel);
                  newTreeset.add(labels[i-1]);
                  labelsEquivalences.add(newTreeset);
                }
            }
            for(int j=0; j<2; j++){
              if(labels[i-input.width-1+j] > minLabel){
                boolean treeContainsElmts = false;
                for(int el = 0; el < labelsEquivalences.size(); el++){
                  if(labelsEquivalences.get(el).contains(minLabel) && labelsEquivalences.get(el).contains(labels[i-input.width-1+j])) treeContainsElmts = true;
                }
                if(!treeContainsElmts){
                  TreeSet newTreeset = new TreeSet();
                  newTreeset.add(minLabel);
                  newTreeset.add(labels[i-input.width-1+j]);
                  labelsEquivalences.add(newTreeset);
                }
              }
            }
          }
          else{
            labels[i] = currentLabel;
            currentLabel ++;
          }
        }
        // main pixels
        else{
          int minLabel = currentLabel;
          boolean foundLabel = false;
          if(labels[i- 1] <= minLabel && labels[i-1]>0){
            minLabel = labels[i- 1];
            foundLabel = true;
          }
          for(int j=0; j<3; j++){
            if(labels[i-input.width-1+j] < minLabel && labels[i-input.width-1+j]>0){
              foundLabel = true;
              minLabel = labels[i-input.width-1+j];
            }
          }
          if(foundLabel){
            labels[i] = minLabel;
            
            if(labels[i- 1] > minLabel){
              boolean treeContainsElmts = false;
              for(int el = 0; el < labelsEquivalences.size(); el++){
                if(labelsEquivalences.get(el).contains(minLabel) && labelsEquivalences.get(el).contains(labels[i-1])) treeContainsElmts = true;
              }
              if(!treeContainsElmts){
                TreeSet newTreeset = new TreeSet();
                newTreeset.add(minLabel);
                newTreeset.add(labels[i-1]);
                labelsEquivalences.add(newTreeset);
              }
            }
            for(int j=0; j<3; j++){
              if(labels[i-input.width-1+j] > minLabel){
                boolean treeContainsElmts = false;
                for(int el = 0; el < labelsEquivalences.size(); el++){
                  if(labelsEquivalences.get(el).contains(minLabel) && labelsEquivalences.get(el).contains(labels[i-input.width-1+j])) treeContainsElmts = true;
                }
                if(!treeContainsElmts){
                  TreeSet newTreeset = new TreeSet();
                  newTreeset.add(minLabel);
                  newTreeset.add(labels[i-input.width-1+j]);
                  labelsEquivalences.add(newTreeset);
                }
              }
            }
          }
          else{
            labels[i] = currentLabel;
            currentLabel ++;
          }          
        }
      }
      else labels[i] = -1;
    }
    // Second pass: re-label the pixels by their equivalent class
    for(int el = 0; el < labelsEquivalences.size(); el++){
      for(int i=0; i< input.width*input.height; i++){  
        if(labels[i] == labelsEquivalences.get(el).last()) labels[i] = labelsEquivalences.get(el).first();
      }
    }
    // if onlyBiggest==true, count the number of pixels for each label
    if(onlyBiggest){
      int blockToKeep = -1;
      int sum1 = 0;
      int sum2 = 0;
      for(int label = 1; label < currentLabel; label++){
        for(int i=0; i< input.width*input.height; i++){  
          if(labels[i] == label) sum1++;
        }
        if(sum2<sum1){
          sum2 = sum1;
          blockToKeep = label;
        }
        sum1 = 0;
      }
      for(int i=0; i< input.width*input.height; i++){
        if(labels[i] != blockToKeep) labels[i] = -1;
        else labels[i] = 1;
      }
    }
    // Finally,
    // if onlyBiggest==false, output an image with each blob colored in one uniform color
    // if onlyBiggest==true, output an image with the biggest blob colored in white and the others in black
    
    PImage result = createImage(input.width, input.height, RGB);
    
    color[] colorEquivalences = new color[currentLabel];
    for(int c=0; c<currentLabel;c++){
      color randomColor = (int)((Math.random() + 10) * 0x1000000);
      colorEquivalences[c] = randomColor;
    }

    
    for(int i = 0; i < result.width*result.height ; i++){
      //assuming that all the three channels have the same value
      if(labels[i] != -1 ) result.pixels[i] = colorEquivalences[labels[i]];
      else result.pixels[i] = color(0,0,0);
    }
    
    return result;
  }
}
void settings() {
  size(800, 600);
}
void setup() {
  test_img = loadImage("BlobDetection_Test.png");
  img2 = test_img.copy();//make a deep copy
  img2.loadPixels();
  img2 = blobDetect.findConnectedComponents(test_img, false);
  img2.updatePixels();//update pixels
}

void draw() {
  image(test_img, 0, 0);//show image
  
  image(img2, img2.width + 20, 0, img2.width*3, img2.height*3);
  //println(labelsEquivalences);
}
