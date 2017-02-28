context("Testing qlspline")

# Data
d <- data.frame(
  x = 0:10,
  y = c(6:1, 2:6)
)


test_that("qlspline() works for integer input", {
  expect_silent(
    m1 <- lm(y ~ qlspline(x, 2, marginal=FALSE), data=d)
  )
  expect_equivalent( coef(m1), c(6, -1, 1) )
})
