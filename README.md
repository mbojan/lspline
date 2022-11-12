
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `lspline`: Linear Splines with Convenient Parameterizations

<!-- badges: start -->

[![R-CMD-check](https://github.com/mbojan/lspline/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mbojan/lspline/actions/workflows/R-CMD-check.yaml)
[![rstudio mirror
downloads](http://cranlogs.r-pkg.org/badges/lspline?color=2ED968)](http://cranlogs.r-pkg.org/)
[![cran
version](http://www.r-pkg.org/badges/version/lspline)](https://cran.r-project.org/package=lspline)
<!-- badges: end -->

Linear splines with convenient parameterizations such that:

-   coefficients are slopes of consecutive segments
-   coefficients capture slope change at consecutive knots

Knot locations can be specified

-   manually (`lspline()`)
-   at breaks dividing the range of `x` into `q` equal-frequency
    intervals (`qlspline()`)
-   at breaks dividing the range of `x` into `n` equal-width intervals
    (`elspline()`)

Inspired by Stata command `mkspline` and function `lspline()` from
package **ares** (Junger and Ponce de Leon 2011). As such, the
implementation follows Greene (2003), chapter 7.5.2.

## Installation

From CRAN or development version using **remotes**:

``` r
remotes::install_github("mbojan/lspline", build_vignettes = TRUE)
```

## Examples

See package [homepage](https://mbojan.github.io/lspline/) and the
[vignette](https://mbojan.github.io/lspline/articles/lspline.html).

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-greene2003econometric" class="csl-entry">

Greene, William H. 2003. *Econometric Analysis*. Pearson Education.

</div>

<div id="ref-r-ares" class="csl-entry">

Junger, Washington L., and Antonio Ponce de Leon. 2011. *Ares:
Environment Air Pollution Epidemiology: A Library for Timeseries
Analysis*. R package version 0.7.2 in CRAN’s archives.

</div>

</div>
