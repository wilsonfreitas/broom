context("ordinal")

skip_if_not_installed("ordinal")
library(ordinal)

fit <- clm(rating ~ temp * contact, data = wine)
mfit <- clmm(rating ~ temp + contact + (1 | judge), data = wine)

test_that("ordinal tidier arguments", {
  check_arguments(tidy.clm)
  check_arguments(glance.clm)
  check_arguments(augment.clm)
  
  check_arguments(tidy.clmm)
  check_arguments(glance.clmm)
})

test_that("tidy.clm", {
  
  td <- tidy(fit, quick = TRUE)
  td2 <- tidy(fit, conf.int = TRUE, exponentiate = TRUE)
  
  check_tidy_output(td)
  check_tidy_output(td2)
  
  check_dims(td, 7, 3)
  check_dims(td2, 7, 8)
})

test_that("glance.clm", {
  gl <- glance(fit)
  check_glance_outputs(gl)
  check_dims(gl, 1, 5)
})

test_that("augment.clm", {
  
  check_augment_function(
    aug = augment.clm,
    model = fit,
    data = wine,
    newdata = wine
  )
})


test_that("tidy.clmm", {
  
  td <- tidy(mfit, quick = TRUE)
  td2 <- tidy(mfit, conf.int = TRUE, exponentiate = TRUE)
  
  check_tidy_output(td)
  check_tidy_output(td2)
  
  check_dims(td, 6, 3)
  check_dims(td2, 6, 8)
})

test_that("glance.clmm", {
  gl <- glance(mfit)
  check_glance_outputs(gl)
  check_dims(gl, 1, 4)
})

