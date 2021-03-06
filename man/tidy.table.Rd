% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/base-tidiers.R
\name{tidy.table}
\alias{tidy.table}
\title{tidy a table object}
\usage{
\method{tidy}{table}(x, ...)
}
\arguments{
\item{x}{An object of class "table"}

\item{...}{Extra arguments (not used)}
}
\description{
A table, typically created by the \link{table} function, contains a
contingency table of frequencies across multiple vectors. This directly
calls the \code{\link[=as.data.frame.table]{as.data.frame.table()}} method, which melts it into a
data frame with one column for each variable and a \code{Freq} column.
}
\examples{

tab <- with(airquality, table(cut(Temp, quantile(Temp)), Month))
tidy(tab)

}
\seealso{
\code{\link[=as.data.frame.table]{as.data.frame.table()}}
}
