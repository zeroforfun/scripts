#!/usr/bin/python3
import cv2
import numpy
import sys
imgi = cv2.imread(sys.argv[1]);
imgo = numpy.zeros(imgi.shape, numpy.uint8);
for i in range(0, imgi.shape[0]):
  for j in range(0, imgi.shape[1]):
    imgo[i, j] = imgi[i, j];
cv2.imwrite(sys.argv[2], imgo);
