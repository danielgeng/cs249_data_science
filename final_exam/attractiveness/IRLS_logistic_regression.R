# Iteratively Reweighted Least Squares implementation of Logistic Regression
# This simple implementation assumes there are no missing values,
#   and all y values are either 0 or 1.

# Below, the variable 'p' is often referred to as 'mu'  (mean of the link function).
# Also, 'yhat' is often referred to as 'eta' (link function).

logistic_regression = function( formula, dataset, tolerance=1.0e-6 ) {
   initial.model = model.frame( formula, dataset )
   X = model.matrix( formula, data = dataset )
   y = model.response( initial.model, "numeric" )  # y values should be 0 and 1
   p = ifelse( y==0, 0.25, 0.75 )   # initial values; all y values are 0 or 1
   yhat = log(p/(1-p))
   prev_deviance = 0
   deviance = 2*sum( y*log(1/p) + (1-y)*log(1/(1-p)) )
   while (abs(deviance - prev_deviance) > tolerance) {
      w = p * (1-p)
      ynew = yhat + (y-p)/w
      model = lm( ynew ~ X - 1,  weights = w )   #  weighted least squares
      yhat = model$fit
      p = 1/(1 + exp(-yhat))
      prev_deviance = deviance
      deviance = 2 * sum( y*log(1/p) + (1-y)*log(1/(1-p)) )
   }
   rss = sum( residuals( model, type="pearson")^2 )  #  weighted RSS
   dispersion = rss / model$df.residual
   return(list( coef = coef(model),  stderr = sqrt( diag(vcov(model)) ) / sqrt(dispersion)  ))
}

demo = function() {
   data(iris)
   zero_one_iris = transform( iris,  Species = ifelse( unclass(Species)==2, 0, 1 ) )
   logistic_regression( Species ~ ., zero_one_iris )
}
