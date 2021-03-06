#' Tidying methods for a factor analysis
#'
#' These methods tidy the factor loadings of a factor analysis, conducted via
#' [factanal()], into a summary, augment the original data with factor
#' scores, and construct a one-row glance of the model's statistics.
#'
#' @return All tidying methods return a [tibble::tibble()] without
#'   rownames.
#'
#' @name factanal_tidiers
#'
#' @param x [factanal()] object
#' @param data Original data
#' @param ... Additional arguments, not used
#'
#' @examples
#'
#' mod <- factanal(mtcars, 3, scores = "regression")
#'
#' glance(mod)
#' tidy(mod)
#' augment(mod)
#' augment(mod, mtcars)  # Must include original data if desired
#'
NULL

#' @rdname factanal_tidiers
#'
#' @return `tidy.factanal` returns one row for each variable used in the
#'   analysis and the following columns:
#'   \item{variable}{The variable being estimated in the factor analysis}
#'   \item{uniqueness}{Proportion of residual, or unexplained variance}
#'   \item{flX}{Factor loading of term on factor X. There will be as many columns
#'   of this format as there were factors fitted.}
#'
#' @export
tidy.factanal <- function(x, ...) {
  # Convert to format that we can work with
  loadings <- stats::loadings(x)
  class(loadings) <- "matrix"

  # Place relevant values into a tidy data frame
  tidy_df <- data.frame(
    variable = rownames(loadings),
    uniqueness = x$uniquenesses,
    data.frame(loadings)
  ) %>%
    as_tibble()

  tidy_df$variable <- as.character(tidy_df$variable)

  # Remove row names and clean column names
  colnames(tidy_df) <- gsub("Factor", "fl", colnames(tidy_df))

  tidy_df
}

#' @rdname factanal_tidiers
#'
#' @return When `data` is not supplied `augment.factanal` returns one
#'   row for each observation, with a factor score column added for each factor
#'   X, (`.fsX`). This is because [factanal()], unlike other
#'   stats methods like [lm()], does not retain the original data.
#'
#' When `data` is supplied, `augment.factanal` returns one row for
#' each observation, with a factor score column added for each factor X,
#' (`.fsX`).
#'
#' @export

augment.factanal <- function(x, data, ...) {
  scores <- x$scores

  # Check scores were computed
  if (is.null(scores)) {
    stop(
      "Cannot augment factanal objects fit with `scores = 'none'`.",
      call. = FALSE
      )
  }

  # Place relevant values into a tidy data frame
  tidy_df <- data.frame(.rownames = rownames(scores), data.frame(scores)) %>%
    as_tibble()

  colnames(tidy_df) <- gsub("Factor", ".fs", colnames(tidy_df))

  # Check if original data provided
  if (missing(data)) {
    return(tidy_df)
  }

  # Bind to data
  data$.rownames <- rownames(data)
  tidy_df <- tidy_df %>% right_join(data, by = ".rownames")

  tidy_df %>% select(
    .rownames, everything(),
    -matches("\\.fs[0-9]*"), matches("\\.fs[0-9]*")
  )
}

#' @rdname factanal_tidiers
#'
#' @return `glance.factanal` returns a one-row data.frame with the columns:
#'   \item{n.factors}{The number of fitted factors}
#'   \item{total.variance}{Total cumulative proportion of variance accounted for by all factors}
#'   \item{statistic}{Significance-test statistic}
#'   \item{p.value}{p-value from the significance test, describing whether the
#'   covariance matrix estimated from the factors is significantly different
#'   from the observed covariance matrix}
#'   \item{df}{Degrees of freedom used by the factor analysis}
#'   \item{n}{Sample size used in the analysis}
#'   \item{method}{The estimation method; always Maximum Likelihood, "mle"}
#'   \item{converged}{Whether the factor analysis converged}
#'
#' @export
glance.factanal <- function(x, ...) {

  # Compute total variance accounted for by all factors
  loadings <- stats::loadings(x)
  class(loadings) <- "matrix"
  total.variance <- sum(apply(loadings, 2, function(i) sum(i^2) / length(i)))

  # Results as single-row data frame
  data_frame(
    n.factors = x$factors,
    total.variance = total.variance,
    statistic = unname(x$STATISTIC),
    p.value = unname(x$PVAL),
    df = x$dof,
    n = x$n.obs,
    method = x$method,
    converged = x$converged
  )
}
