% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tables.R
\name{make_n_and_percent_table}
\alias{make_n_and_percent_table}
\title{Make a table showing the number (n) and percent of the population (e.g. \% of nrow())
for each value in a variable(s).}
\usage{
make_n_and_percent_table(data, columns)
}
\arguments{
\item{data}{A data.frame with the data you want to make the table from.}

\item{columns}{A string or vector of strings with the column names to make the N and \% from.}
}
\value{
A data.frame with one row for each value in the inputted variable(s) and columns
showing the N and \% for that value.
}
\description{
Make a table showing the number (n) and percent of the population (e.g. \% of nrow())
for each value in a variable(s).
}
\examples{
make_n_and_percent_table(mtcars, c("cyl", "gear"))
}
