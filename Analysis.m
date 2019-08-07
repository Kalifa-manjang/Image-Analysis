function [L, a, b] = Analysis(R,G,B)
% This function takes in a color image RGB values and calculate the CIELab values 
% for color comparison. The function is not meant to take the entire image 
%pixel as arguement but rather the point we want to use for color
%measurement pixel is taken since the spectrophotometer we used measured spot color. We
%manually picked the point in the larger picture we want to measure and
%passed it as an arguement. 




% % We take the pictures RGB values.
% 
% R = I(:,:,1);
% G = I(:,:,2);
% B = I(:,:,3);

% This is the standard xrite 24 color chart values
R_standard = [115,194,98,87,133,103,214,80,193,94,157,224,56,...
    70,175,231,187,8,243,200,160,122,85,52];
G_standard = [82,150,122,108,128,189,126,91,90,60,188,163,...
    61,148,54,199,86,133,243,200,160,122,85,52];
B_standard = [68,130,157,67,177,170,44,166,99,108,64,46,150,...
    73,60,31,149,161,242,200,160,121,85,52];

% Restimated, that is we used the standard values to estimate the values of
% R
tall = zeros(24,6);
tall(:,1) = R_standard;
tall(:,2)= G_standard;
tall(:,3) = B_standard;
tall(:,4) = R_standard.^2;
tall(:,5)= G_standard.^2;
tall(:,6) = B_standard.^2;
y = tall(:,1);

% We used least square regression to derive the values of the alpha's
Restimated = LeastSqure(tall,y);

% Gestimated
tall1 = zeros(24,6);
tall1(:,1) = R_standard;
tall1(:,2)= G_standard;
tall1(:,3) = B_standard;
tall1(:,4) = R_standard.^2;
tall1(:,5)= G_standard.^2;
tall1(:,6) = B_standard.^2;
y1 = tall1(:,2);

% We used least square regression to derive the values of the beta's
Gestimated = LeastSqure(tall1,y1);

% Bestimated
tall2 = zeros(24,6);
tall2(:,1) = R_standard;
tall2(:,2)= G_standard;
tall2(:,3) = B_standard;
tall2(:,4) = R_standard.^2;
tall2(:,5)= G_standard.^2;
tall2(:,6) = B_standard.^2;
y2 = tall2(:,3);

% We used least square regression to derive the values of the gamma's
Bestimated = LeastSqure(tall2,y2);

% We apply the values to every pixels of the photos. 

EstimatedR =  Restimated(1)*R + Restimated(2)*G ...
     +  Restimated(3)*B + Restimated(4)*R.^2 + Restimated(5)*G.^2 + Restimated(6)*B.^2;

EstimatedG =  Gestimated(1)*R + Gestimated(2)*G ...
      +  Gestimated(3)*B + Gestimated(4)*R.^2 + Gestimated(5)*G.^2 + Gestimated(6)*B.^2;

EstimatedB =  Bestimated(1)*R + Bestimated(2)*G ...
      +  Bestimated(3)*B + Bestimated(4)*R.^2 + Bestimated(5)*G.^2 + Bestimated(6)*B.^2;


% EstimatedRGB(:,:,1) = R;
% EstimatedRGB(:,:,2) = G;
% EstimatedRGB(:,:,3) = B;
EstimatedRGB = cat(3, EstimatedR, EstimatedG, EstimatedB);

% We convert from the sRGB color space to XYZ color space

Sr = EstimatedRGB(:,:,1);
Sg = EstimatedRGB(:,:,2);
Sb = EstimatedRGB(:,:,3);

% color conversion equations. 
v_Red = double(Sr) / 255;
v_Green = double(Sg) / 255;
v_Blue = double(Sb) /255;


if v_Red > 0.04045
    v_Red = ((v_Red + 0.055) / 1.055).^2.4;
else
    v_Red = v_Red / 12.92;
end
if v_Green > 0.04045
    v_Green = ((v_Green + 0.055) / 1.055).^2.4;
else
    v_Green = v_Green / 12.92; 
end

if v_Blue > 0.04045
    v_Blue = ((v_Blue + 0.055) / 1.055).^2.4;
else
    v_Blue = v_Blue / 12.92;
    
end

v_Red = v_Red .*100;
v_Green = v_Green .* 100;
v_Blue = v_Blue .* 100;

X = v_Red .* 0.4124 + v_Green .* 0.3576 + v_Blue .* 0.1805;
Y = v_Red .* 0.2126 + v_Green .* 0.7152 + v_Blue .* 0.0722;
Z = v_Red .* 0.0193 + v_Green .* 0.1192 + v_Blue .* 0.9505;

% We also convert from XYZ color space to CIE L* a* b* color space

% This is our reference values
Ref_X = 96.720 ;
Ref_Y = 100.0;
Ref_Z = 81.427;

% Converstion equations. 
v_X = X / Ref_X;
v_Y = Y / Ref_Y;
v_Z = Z / Ref_Z;

if  v_X > 0.008856 
    v_X = v_X .^ ( 1/3 );
else
    v_X = ( 7.787 .* v_X ) + ( 16 ./ 116 );
end
if v_Y > 0.008856 
    v_Y = v_Y .^ ( 1/3 );
else
    v_Y = ( 7.787 .* v_Y ) + ( 16 ./ 116 );
end
if v_Z > 0.008856 
    v_Z = v_Z .^ ( 1/3 );
else
    v_Z = ( 7.787 .* v_Z ) + ( 16 ./ 116 );
end

CIE_L = ( 116 .* v_Y ) - 16;
CIE_a = 500 .* ( v_X - v_Y );
CIE_b = 200 .* ( v_Y - v_Z );

% We take the mean to derive the L* , a* and b* values. 
L = mean(CIE_L(:));
a = mean(CIE_a(:));
b = mean(CIE_b(:));




