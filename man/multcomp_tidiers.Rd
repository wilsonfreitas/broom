% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/multcomp-tidiers.R
\name{multcomp_tidiers}
\alias{multcomp_tidiers}
\alias{tidy.glht}
\alias{tidy.confint.glht}
\alias{tidy.summary.glht}
\alias{tidy.cld}
\title{tidying methods for objects produced by \pkg{multcomp}}
\usage{
\method{tidy}{glht}(x, ...)

\method{tidy}{confint.glht}(x, ...)

\method{tidy}{summary.glht}(x, ...)

\method{tidy}{cld}(x, ...)
}
\arguments{
\item{x}{an object of class \code{glht}, \code{confint.glht},
\code{summary.glht} or \code{\link[multcomp:cld]{multcomp::cld()}}}

\item{...}{extra arguments (not used)}
}
\description{
tidying methods for objects produced by \pkg{multcomp}
}
\examples{

if (require("multcomp") && require("ggplot2")) {
    amod <- aov(breaks ~ wool + tension, data = warpbreaks)
    wht <- glht(amod, linfct = mcp(tension = "Tukey"))

    tidy(wht)
    ggplot(wht, aes(lhs, estimate)) + geom_point()

    CI <- confint(wht)
    tidy(CI)
    ggplot(CI, aes(lhs, estimate, ymin = lwr, ymax = upr)) +
       geom_pointrange()

    tidy(summary(wht))
    ggplot(mapping = aes(lhs, estimate)) +
       geom_linerange(aes(ymin = lwr, ymax = upr), data = CI) +
       geom_point(aes(size = p), data = summary(wht)) +
       scale_size(trans = "reverse")

    cld <- cld(wht)
    tidy(cld)
}
}
