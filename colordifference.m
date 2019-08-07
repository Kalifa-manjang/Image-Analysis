function euclidean = colordifference(l1,l2,a1,a2,b1,b2)
% The function takes in the CIELab values for the references
% spectrophotometer values and the image color measurement values using the
% digital camera image CIELab values and calculate the color difference between them.

% Euclidean 
euclidean = sqrt((l1 - l2)^2 + (a1 - a2)^2 + (b1 - b2)^2);
disp(euclidean)




