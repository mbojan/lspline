context("Testing lspline()")

# Data
set.seed(666)
d <- data.frame(
  x = 1:10,
  y = c(5:1, 2:6)
)


test_that("it works", {
  m1 <- lm(y ~ lspline(x, c(5), marginal=TRUE), data=d)
  m2 <- lm(y ~ lspline(x, c(5), marginal=FALSE), data=d)
})
