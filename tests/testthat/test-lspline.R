context("lspline() correct coefficients")

# Data
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


test_that("fitted values are identical whatever the `marginal`", {
  expect_silent(
    m1 <- lm(y ~ lspline(x, c(5), marginal=TRUE), data=d)
  )
  expect_silent(
    m2 <- lm(y ~ lspline(x, c(5), marginal=FALSE), data=d)
  )
  expect_equal( fitted(m1), fitted(m2) )
})





context("lspline() predicting")



test_that("in-data predictions are correct", {
  expect_silent(
    m1 <- lm(y ~ lspline(x, c(5), marginal=TRUE), data=d)
  )
  expect_equivalent(
    predict(m1, data.frame(x=5:10)),
    1:6
  )
  expect_equivalent(
    predict(m1, data.frame(x=1:5)),
    5:1
  )
  expect_silent(
    m2 <- lm(y ~ lspline(x, c(5), marginal=FALSE), data=d)
  )
  expect_equivalent(
    predict(m2, data.frame(x=5:10)),
    1:6
  )
  expect_equivalent(
    predict(m2, data.frame(x=1:5)),
    5:1
  )
})
