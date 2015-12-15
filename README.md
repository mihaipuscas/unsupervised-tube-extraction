# Unsupervised Tube Extraction using Transductive Learning and Dense Trajectories

### Introduction
Algorithm used for unsupervised action tube extraction from videos.

This repository contains a Matlab implementation of the code, and has been tested on Linux, using Matlab R2015a.

### License

The algorithm is under the MIT License, details in LICENSE

### Instructions

- extract the absolute coordinates of the trajectories throughout the video using [Improved Dense Trajectories](https://lear.inrialpes.fr/people/wang/improved_trajectories) with default parameters. 
  - to maintain a roughly constant number of trajectories in the last frames of the video, we have mirrored the last 3 frames.
- for cnn feature extraction use the [bvlc_reference_caffenet](https://github.com/BVLC/caffe/tree/master/models/bvlc_reference_caffenet) model -  fc7 features

### Requirements

1. MATLAB
2. caffe
3. [Selective Search](http://www.science.uva.nl/research/publications/2013/UijlingsIJCV2013/)
3. [liblinear](http://www.csie.ntu.edu.tw/~cjlin/liblinear/)
4. [Improved Dense Trajectories](https://lear.inrialpes.fr/people/wang/improved_trajectories)
5. [Enhanced rdir](http://it.mathworks.com/matlabcentral/fileexchange/32226-recursive-directory-listing-enhanced-rdir)

