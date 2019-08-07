function betaHat = LeastSqure(X,y)
%This function is meant for th lest square regression

betaHat = (X' * X) \ (X' * y);

end

