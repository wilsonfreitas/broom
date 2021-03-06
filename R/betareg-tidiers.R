#' Tidy betareg objects from the betareg package
#'
#' Tidy beta regression objects into summarized coefficients, add their fitted values
#' and residuals, or find their model parameters.
#'
#' @param x A "betareg" object
#' @param conf.int whether to include a confidence interval
#' @param conf.level confidence level of the interval, used only if
#' `conf.int=TRUE`
#'
#' @name betareg_tidiers
#'
#' @template boilerplate
#'
#' @return tidy returns a data.frame with one row for each term used to predict
#' the mean, along with at least one term used to predict phi (the inverse of
#' the variance). It starts with the column `component` containing either
#' "mean" or "precision" to describe which is being modeled, then has the same
#' columns as tidied linear models or glm's (see [lm_tidiers()]).
#'
#' @examples
#'
#' if (require("betareg", quietly = TRUE)) {
#'   data("GasolineYield", package = "betareg")
#'
#'   mod <- betareg(yield ~ batch + temp, data = GasolineYield)
#'
#'   mod
#'   tidy(mod)
#'   tidy(mod, conf.int = TRUE)
#'   tidy(mod, conf.int = TRUE, conf.level = .99)
#'
#'   head(augment(mod))
#'
#'   glance(mod)
#' }
#'
#' @export
tidy.betareg <- function(x, conf.int = FALSE, conf.level = .95, ...) {
  ret <- purrr::map_df(
    coef(summary(x)),
    fix_data_frame,
    newnames = c("estimate", "std.error", "statistic", "p.value"),
    .id = "component")

  if (conf.int) {
    conf <- unrowname(confint(x, level = conf.level))
    colnames(conf) <- c("conf.low", "conf.high")
    ret <- cbind(ret, conf)
  }
  
  as_tibble(ret)
}


#' @rdname betareg_tidiers
#'
#' @param data Original data frame the regression was fit on
#' @param newdata New data frame to use for prediction
#' @param type.predict Type of predictions to calculate
#' @param type.residuals Type of residuals to calculate
#'
#' @return augment returns the original data, along with new columns describing
#' each observation:
#'   \item{.fitted}{Fitted values of model}
#'   \item{.resid}{Residuals}
#'   \item{.cooksd}{Cooks distance, [cooks.distance()]}
#'
#' @export
augment.betareg <- function(x, data = stats::model.frame(x), newdata = NULL,
                            type.predict, type.residuals, ...) {
  validate_augment_input(x, data, newdata)
  
  as_tibble(
    augment_columns(
      x, data, newdata,
      type.predict = type.predict,
      type.residuals = type.residuals
    )
  )
}


#' @rdname betareg_tidiers
#'
#' @param ... Extra arguments, not used
#'
#' @return `glance` returns a one-row data.frame with the columns
#'   \item{pseudo.r.squared}{the deviance of the null model}
#'   \item{logLik}{the data's log-likelihood under the model}
#'   \item{AIC}{the Akaike Information Criterion}
#'   \item{BIC}{the Bayesian Information Criterion}
#'   \item{df.residual}{residual degrees of freedom}
#'   \item{df.null}{degrees of freedom under the null}
#'
#' @export
glance.betareg <- function(x, ...) {
  s <- summary(x)
  ret <- unrowname(as.data.frame(s[c("pseudo.r.squared")]))
  ret <- finish_glance(ret, x)
  ret$df.null <- s$df.null
  as_tibble(ret)
}
