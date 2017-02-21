#' Piecewise-linear spline
#'
#' @param x numeric predictor
#' @param ... numeric values of x-positions of the knots
#'
#' @return
#' A matrix with dimensionality (length(x), number-of-knots)
#'
#' @export
#'
#' @examples
#' set.seed(666)
#' d <- data.frame(
#'   x = 1:10,
#'   y = c(5:1, 2:6) + rnorm(10, 0, 0.5)
#' )
#' mod <- lm( y ~ x + plinear(x, 5), data=d)
#' d$f <- fitted(mod)
#'
#' plot(y ~ x, data=d)
#' lines(f ~ x, data=d)
#'
#' coef(mod)["x"] # Slope for 'x' in (-Inf, 5)
#' coef(mod)[3] # Slope change at knot x=5
#' coef(mod)["x"] + coef(mod)[3] # Slope for 'x' in (5, Inf)
plinear <- function(x, ...) {
  namex <- deparse(substitute(x))
  breaks <- sort(as.numeric(unlist(list(...))))
  if( is.null(names(breaks)) )
    cnames <- paste(".", namex, ">", breaks, sep="")
  else
    cnames <- names(breaks)
  makeColumn <- function(b) sapply(x, function(xx) max(0, xx-b))
  m <- sapply( breaks, makeColumn)
  colnames(m) <- cnames
  m
}
