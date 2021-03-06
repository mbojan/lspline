% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lspline.R
\name{lspline}
\alias{lspline}
\alias{qlspline}
\alias{elspline}
\title{Basis for a piecewise linear spline with meaningful coefficients}
\usage{
lspline(x, knots = NULL, marginal = FALSE, names = NULL)

qlspline(x, q, na.rm = FALSE, ...)

elspline(x, n, ...)
}
\arguments{
\item{x}{numeric vector, the variable}

\item{knots}{numeric vector of knot positions}

\item{marginal}{logical, how to parametrize the spline, see Details}

\item{names}{character, vector of names for constructed variables}

\item{q}{numeric, a single scalar greater or equal to 2 for a number of
equal-frequency intervals along \code{x} or a vector of numbers in (0; 1) specifying
the quantiles explicitely.}

\item{na.rm}{logical, whether \code{NA} should be removed when calculating
quantiles, passed to \code{na.rm} of \code{\link{quantile}}.}

\item{...}{other arguments passed to \code{lspline}}

\item{n}{integer greater than 2, knots are computed such that they cut
\code{n} equally-spaced intervals along the range of \code{x}}
}
\description{
These functions compute the basis of piecewise-linear spline such that,
depending on the argument \code{marginal}, the coefficients can be
interpreted as (1) slopes of consecutive spline segments, or (2) slope change
at consecutive knots.
}
\details{
If \code{marginal} is \code{FALSE} (default) the coefficients of the spline
correspond to slopes of the consecutive segments. If it is \code{TRUE} the
first coefficient correspond to the slope of the first segment. The
consecutive coefficients correspond to the change in slope as compared to the
previous segment.

Function \code{qlspline} wraps \code{lspline} and calculates the knot
positions to be at quantiles of \code{x}. If \code{q} is a numerical scalar
greater or equal to 2, the quantiles are computed at \code{seq(0, 1,
length.out = q + 1)[-c(1, q+1)]}, i.e. knots are at \code{q}-tiles of the
distribution of \code{x}. Alternatively, \code{q} can be a vector of values
in [0; 1] specifying the quantile probabilities directly (the vector is
passed to argument \code{probs} of \code{\link{quantile}}).

Function \code{elspline} wraps \code{lspline} and computes the knot positions
such that they cut the range of \code{x} into \code{n} equal-width intervals.
}
\examples{
# Data from a quadratic polynomial
set.seed(666)
x <- rnorm(100, 5, 2)
y <- (x-5)^2 + rnorm(100)
plot(x, y)

# -- Marginal and non-marginal parametrisations
m.nonmarginal <- lm(y ~ lspline(x, 5))
m.marginal <- lm(y ~ lspline(x, 5, marginal=TRUE))
# Slope of consecutive segments
coef(m.nonmarginal)
# Slope change and consecutive knots
coef(m.marginal)
# Identical predicted values
identical( fitted(m.nonmarginal), fitted(m.marginal))


# -- Different ways to place knots
# Manually: knots at x=4 and x=6
m1 <- lm(y ~ lspline(x, c(4, 6)))
# 2 knots at terciles of 'x'
m2 <- lm(y ~ qlspline(x, 3))
# 3 knots dividing range of 'x' into 4 equal-width intervals
m3 <- lm(y ~ elspline(x, 4))

# Graphically
ox <- seq(min(x), max(x), length=100)
lines(ox, predict(m1, data.frame(x=ox)), col="red")
lines(ox, predict(m2, data.frame(x=ox)), col="blue")
lines(ox, predict(m3, data.frame(x=ox)), col="green")
legend("topright",
  legend=c("m1: lspline", "m2: qlspline", "m3: elspline"),
  col=c("red", "blue", "green"),
  bty="n", lty=1)





}
\references{
\itemize{
\item Poirier, Dale J., and Steven G. Garber. (1974) "The Determinants of Aerospace Profit Rates 1951-1971." Southern Economic Journal: 228-238.
\item Greene, William H. (2003) Econometric analysis. Pearson Education
\item Junger & Ponce de Leon (2011) "ares: Environment air pollution epidemiology: a library for timeseries analysis". R package version 0.7.2 retrieved from CRAN archives.
}
}
\seealso{
See the package vignette.
}
\author{
This function is inspired by Stata command \code{mkspline}
and function \code{ares::lspline} from Junger & Ponce de
Leon (2011). As such, the implementation follows Greene
(2003), chapter 7.2.5
}
