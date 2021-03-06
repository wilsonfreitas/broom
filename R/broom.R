#' @title Convert Statistical Analysis Objects into Tidy Data Frames
#' @name broom
#' @description Convert statistical analysis objects from R into tidy tibbles,
#' so that they can more easily be combined, reshaped and otherwise processed
#' with tools like dplyr, tidyr and ggplot2. The package provides three S3
#' generics: tidy, which summarizes a model's statistical findings such as
#' coefficients of a regression; augment, which adds columns to the original
#' data such as predictions, residuals and cluster assignments; and glance,
#' which provides a one-row summary of model-level statistics.
#'
#' @importFrom stats AIC BIC coef confint fitted logLik model.frame 
#' @importFrom stats predict qnorm qt residuals setNames var na.omit
#' @importFrom stats model.response
#'
#' @importFrom utils head
#'
#' @docType package
#' @aliases broom broom-package
NULL

#' Augment data according to a tidied model
#'
#' Given an R statistical model or other non-tidy object, add columns to the
#' original dataset such as predictions, residuals and cluster assignments.
#'
#' Note that by convention the first argument is almost always `data`,
#' which specifies the original data object. This is not part of the S3
#' signature, partly because it prevents [rowwise_df_tidiers] from
#' taking a column name as the first argument. 
#'
#' @details This generic originated in the ggplot2 package, where it was called
#' `fortify`.
#'
#' @seealso [augment.lm()]
#' @param x Model object or other R object with information to append to
#'   observations.
#' @param ... Addition arguments to augment method.
#' @return A [tibble::tibble()] with information about data points.
#' @export
augment <- function(x, ...) UseMethod("augment")

#' Turn a model object into a tidy tibble
#'
#' @param x An object to be converted into a tidy [tibble::tibble()].
#' @param ... Additional arguments to tidying method.
#' @return A [tibble::tibble()] with information about model components.
#'
#' @export
tidy <- function(x, ...) UseMethod("tidy")

#' Construct a single row summary "glance" of a model, fit, or other
#' object
#'
#' glance methods always return either a one-row data frame (except on NULL, which
#' returns an empty data frame)
#'
#' @param x model or other R object to convert to single-row data frame
#' @param ... other arguments passed to methods
#' @export
glance <- function(x, ...) UseMethod("glance")



