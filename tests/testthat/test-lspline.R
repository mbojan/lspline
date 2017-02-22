context("Testing lspline()")

# Data
set.seed(666)
d <- data.frame(
  x = 1:10,
  y = c(5:1, 2:6)
)


test_that("it works for marginal=TRUE", {
  expect_silent(
    m1 <- lm(y ~ lspline(x, c(5), marginal=TRUE), data=d)
    )
  expect_equivalent( coef(m1), c(6, -1, 2) )
})


test_that("it works for marginal=FALSE", {
  expect_silent(
    m2 <- lm(y ~ lspline(x, c(5), marginal=FALSE), data=d)
  )
  expect_equivalent(coef(m2), c(6, -1, 1) )
})

