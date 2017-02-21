#' Basis for a piecewise linear spline
#'
#' @param x numeric vector, the variable
#' @param knots numeric vector of knots positions
#' @param marginal logical, how to parametrize the spline, see Details
#' @param names character, vector of names for constructed variables
#'
#' @author
#' Based on \code{ares::lspline} from Junger & Ponce de Leon (2011)
#'
#' @references
#' Junger & Ponce de Leon (2011) "ares: Environment air
#' pollution epidemiology: a library for timeseries
#' analysis". R package version 0.7.2 retrieved from CRAN
#' archives.

lspline <- function( x, knots=NULL, marginal=FALSE, names=NULL ) {
  n <- length(x)
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
    rval <- matrix(0, nrow = n, ncol=length(knots)+1)
    rval[,1] <- pmin(x, knots[1])
    for( k in seq(along=knots)[seq(2, length(knots))] ) {
        rval[,k] <- pmax( pmin(x, knots[k]), knots[k-1]) - knots[k-1]
    }
    rval[,length(knots)+1] <- pmax(x, knots[length(knots)-1]) - knots[length(knots)-1]
  }
  rval
}



if(FALSE) {
  set.seed(666)
  d <- data.frame(
   x = 1:10,
   y = c(5:1, 2:6) + rnorm(10, 0, 0.5)
  )

}
