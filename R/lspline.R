#' Basis for a piecewise linear spline with meaningful coefficients
#'
#' These functions compute the basis of piecewise-linear spline such that,
#' depending on the argument \code{marginal}, the coefficients can be
#' interpreted as (1) slopes of consecutive spline segments, or (2) slope change
#' at consecutive knots.
#'
#' @param x numeric vector, the variable
#' @param knots numeric vector of knot positions
#' @param marginal logical, how to parametrize the spline, see Details
#' @param names character, vector of names for constructed variables
#'
#' @details
#' If \code{marginal} is \code{FALSE} (default) the coefficients of the spline
#' correspond to slopes of the consecutive segments. If it is \code{TRUE} the
#' first coefficient correspond to the slope of the first segment. The
#' consecutive coefficients correspond to the change in slope as compared to the
#' previous segment.
#'
#' @seealso
#' See the package vignette.
#'
#' @author
#' This function is inspired by Stata command \code{mkspline}
#' and function \code{ares::lspline} from Junger & Ponce de
#' Leon (2011). As such, the implementation follows Greene
#' (2003), chapter 7.2.5
#'
#' @references
#'
#' \itemize{
#' \item Poirier, Dale J., and Steven G. Garber. (1974) "The Determinants of Aerospace Profit Rates 1951-1971." Southern Economic Journal: 228-238.
#' \item Greene, William H. (2003) Econometric analysis. Pearson Education
#' \item Junger & Ponce de Leon (2011) "ares: Environment air pollution epidemiology: a library for timeseries analysis". R package version 0.7.2 retrieved from CRAN archives.
#' }
#'
#' @examples
#' # Data from a quadratic polynomial
#' set.seed(666)
#' x <- rnorm(100, 5, 2)
#' y <- (x-5)^2 + rnorm(100)
#' plot(x, y)
#'
#' # -- Marginal and non-marginal parametrisations
#' m.nonmarginal <- lm(y ~ lspline(x, 5))
#' m.marginal <- lm(y ~ lspline(x, 5, marginal=TRUE))
#' # Slope of consecutive segments
#' coef(m.nonmarginal)
#' # Slope change and consecutive knots
#' coef(m.marginal)
#' # Identical predicted values
#' identical( fitted(m.nonmarginal), fitted(m.marginal))
#'
#'
#' # -- Different ways to place knots
#' # Manually: knots at x=4 and x=6
#' m1 <- lm(y ~ lspline(x, c(4, 6)))
#' # 2 knots at terciles of 'x'
#' m2 <- lm(y ~ qlspline(x, 3))
#' # 3 knots dividing range of 'x' into 4 equal-width intervals
#' m3 <- lm(y ~ elspline(x, 4))
#'
#' # Graphically
#' ox <- seq(min(x), max(x), length=100)
#' lines(ox, predict(m1, data.frame(x=ox)), col="red")
#' lines(ox, predict(m2, data.frame(x=ox)), col="blue")
#' lines(ox, predict(m3, data.frame(x=ox)), col="green")
#' legend("topright",
#'   legend=c("m1: lspline", "m2: qlspline", "m3: elspline"),
#'   col=c("red", "blue", "green"),
#'   bty="n", lty=1)
#'
#'
#'
#'
#'
#' @export


lspline <- function( x, knots=NULL, marginal=FALSE, names=NULL ) {
  if(!is.null(names)) {
    .NotYetUsed("names")
  }
  n <- length(x)
  nvars <- length(knots) + 1
  # if( length(knots) > n/2)
  #   stop("too many knots")
  namex <- deparse(substitute(x))
  knots <- sort(knots)
  if(marginal) {
    rval <- cbind(
      x,
      sapply(knots, function(k) ifelse((x - k) > 0, x-k, 0) )
    )
  } else {
    rval <- matrix(0, nrow = n, ncol=nvars)
    rval[,1] <- pmin(x, knots[1])
    rval[,nvars] <- pmax(x, knots[length(knots)]) - knots[length(knots)]
    if(nvars > 2) {
      for(i in seq(2, nvars-1)) {
        rval[,i] <- pmax(  pmin(x, knots[i]), knots[i-1] ) - knots[i-1]
      }
    }
  }
  colnames(rval) <- seq(1, ncol(rval))
  structure(
    rval,
    knots = knots,
    marginal = marginal,
    class = c("lspline", "matrix")
  )
}




#' @rdname lspline
#'
#' @param q numeric, a single scalar greater or equal to 2 for a number of
#'   equal-frequency intervals along \code{x} or a vector of numbers in (0; 1) specifying
#'   the quantiles explicitely.
#' @param na.rm logical, whether \code{NA} should be removed when calculating
#'   quantiles, passed to \code{na.rm} of \code{\link{quantile}}.
#' @param ... other arguments passed to \code{lspline}
#'
#' @details
#' Function \code{qlspline} wraps \code{lspline} and calculates the knot
#' positions to be at quantiles of \code{x}. If \code{q} is a numerical scalar
#' greater or equal to 2, the quantiles are computed at \code{seq(0, 1,
#' length.out = q + 1)[-c(1, q+1)]}, i.e. knots are at \code{q}-tiles of the
#' distribution of \code{x}. Alternatively, \code{q} can be a vector of values
#' in [0; 1] specifying the quantile probabilities directly (the vector is
#' passed to argument \code{probs} of \code{\link{quantile}}).
#'
#' @importFrom stats quantile
#'
#' @export
qlspline <- function(x, q, na.rm=FALSE, ...) {
  if(length(q) == 1 && q >= 2) {
    q <- seq(0, 1, length.out = q + 1)[-c(1, q+1)]
  } else {
    stopifnot(all(q > 0 & q < 1))
  }
  k <- quantile(x, probs = q, na.rm=na.rm)
  lspline(x=x, knots=k, ...)
}






#' @rdname lspline
#'
#' @param n integer greater than 2, knots are computed such that they cut
#'   \code{n} equally-spaced intervals along the range of \code{x}
#'
#' @details
#' Function \code{elspline} wraps \code{lspline} and computes the knot positions
#' such that they cut the range of \code{x} into \code{n} equal-width intervals.
#'
#' @export
elspline <- function(x, n, ...) {
  stopifnot(n >= 2)
  k <- seq(min(x, na.rm = TRUE), max(x, na.rm=TRUE), length.out = n+1)[-c(1, n+1)]
  lspline(x, knots = k, ...)
}



#' @importFrom stats makepredictcall
#' @method makepredictcall lspline
#' @export
makepredictcall.lspline <- function(var, call) {
  if( !grepl("lspline$", as.character(call)[1L]) )
    return(call)
  at <- attributes(var)[c("knots", "marginal")]
  xxx <- call[1L:2L]
  xxx[names(at)] <- at
  xxx[1] <- quote(lspline())
  xxx
}

#' @importFrom stats predict
#' @method predict lspline
#' @export
predict.lspline <- function (object, newx, ...) {
  if (missing(newx))
    return(object)
  a <- c(list(x = newx), attributes(object)[c("knots", "marginal")])
  do.call("lspline", a)
}
