#' Basis for a piecewise linear spline
#'
#' @param x numeric vector, the variable
#' @param knots numeric vector of knot positions
#' @param marginal logical, how to parametrize the spline, see Details
#' @param names character, vector of names for constructed variables
#'
#' @details
#' If \code{marginal} is \code{FALSE} the coefficients of the spline correspond
#' to slopes of the consecutive segments. If it is \code{TRUE} the first
#' coefficient correspond to the slope of the first segment. The consecutive
#' coefficients correspond to the change in slope as compared to the previous
#' segment.
#'
#' @author
#' This function is inspired by Stata command \code{mkspline} and function
#' \code{ares::lspline} from Junger & Ponce de Leon (2011).
#'
#' @references
#' Junger & Ponce de Leon (2011) "ares: Environment air pollution epidemiology:
#' a library for timeseries analysis". R package version 0.7.2 retrieved from
#' CRAN archives.
#'
#' @export

lspline <- function( x, knots=NULL, marginal=FALSE, names=NULL ) {
  n <- length(x)
  nvars <- length(knots) + 1
  if( length(knots) > n/2)
    stop("too many knots")
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
  rval
}

