% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hal.R
\name{fit_hal}
\alias{fit_hal}
\title{HAL: The Highly Adaptive Lasso}
\usage{
fit_hal(
  X,
  Y,
  X_unpenalized = NULL,
  max_degree = 3,
  fit_type = c("glmnet", "lassi"),
  n_folds = 10,
  foldid = NULL,
  use_min = TRUE,
  reduce_basis = NULL,
  family = c("gaussian", "binomial", "cox"),
  return_lasso = TRUE,
  return_x_basis = FALSE,
  basis_list = NULL,
  lambda = NULL,
  id = NULL,
  offset = NULL,
  cv_select = TRUE,
  ...,
  yolo = TRUE
)
}
\arguments{
\item{X}{An input \code{matrix} containing observations and covariates.}

\item{Y}{A \code{numeric} vector of obervations of the outcome variable.}

\item{X_unpenalized}{An input \code{matrix} with the same format as X, that
directly get appended into the design matrix (no basis expansion). No L-1
penalization is performed on these covariates.}

\item{max_degree}{The highest order of interaction terms for which the basis
functions ought to be generated. The default (\code{NULL}) corresponds to
generating basis functions for the full dimensionality of the input matrix.}

\item{fit_type}{The specific routine to be called when fitting the Lasso
regression in a cross-validated manner. Choosing the \code{glmnet} option
will result in a call to \code{\link[glmnet]{cv.glmnet}} while \code{lassi}
will produce a (faster) call to a custom Lasso routine.}

\item{n_folds}{Integer for the number of folds to be used when splitting the
data for V-fold cross-validation. This defaults to 10.}

\item{foldid}{An optional vector of values between 1 and \code{n_folds}
identifying what fold each observation is in. If supplied, \code{n_folds}
can be missing. When supplied, this is passed to
\code{\link[glmnet]{cv.glmnet}}.}

\item{use_min}{Determines which lambda is selected from
\code{\link[glmnet]{cv.glmnet}}. \code{TRUE} corresponds to
\code{"lambda.min"} and \code{FALSE} corresponds to \code{"lambda.1se"}.}

\item{reduce_basis}{A \code{numeric} value bounded in the open interval
(0,1) indicating the minimum proportion of 1's in a basis function column
needed for the basis function to be included in the procedure to fit the
Lasso. Any basis functions with a lower proportion of 1's than the cutoff
will be removed. This argument defaults to \code{NULL}, in which case all
basis functions are used in the lasso-fitting stage of the HAL algorithm.}

\item{family}{A \code{character} corresponding to the error family for a
generalized linear model. Options are limited to "gaussian" for fitting a
standard linear model, "binomial" for penalized logistic regression,
"cox" for a penalized proportional hazards model. Note that in the case of
"binomial" and "cox" the argument fit_type is limited to "glmnet"; thus,
documentation of the glmnet package should be consulted for any errors
resulting from the Lasso fitting step in these cases.}

\item{return_lasso}{A \code{logical} indicating whether or not to return
the \code{glmnet} fit of the lasso model.}

\item{return_x_basis}{A \code{logical} indicating whether or not to return
the matrix of (possibly reduced) basis functions used in the HAL lasso fit.}

\item{basis_list}{The full set of basis functions generated from the input
data X (via a call to \code{enumerate_basis}). The dimensionality of this
structure is dim = (n * 2^(d - 1)), where n is the number of observations
and d is the number of columns in X.}

\item{lambda}{User-specified array of values of the lambda tuning parameter
of the Lasso L1 regression. If \code{NULL}, \code{\link[glmnet]{cv.glmnet}}
will be used to automatically select a CV-optimal value of this
regularization parameter. If specified, the Lasso L1 regression model will
be fit via \code{glmnet}, returning regularized coefficient values for each
value in the input array.}

\item{id}{a vector of ID values, used to generate cross-validation folds for
cross-validated selection of the regularization parameter lambda.}

\item{offset}{a vector of offset values, used in fitting.}

\item{cv_select}{A \code{logical} specifying whether the array of values
specified should be passed to \code{\link[glmnet]{cv.glmnet}} in order to
pick the optimal value (based on cross-validation) (when set to
\code{TRUE}) or to simply fit along the sequence of values (or single
value) using \code{\link[glmnet]{glmnet}} (when set to \code{FALSE}).}

\item{...}{Other arguments passed to \code{\link[glmnet]{cv.glmnet}}. Please
consult its documentation for a full list of options.}

\item{yolo}{A \code{logical} indicating whether to print one of a curated
selection of quotes from the HAL9000 computer, from the critically
acclaimed epic science-fiction film "2001: A Space Odyssey" (1968).}
}
\value{
Object of class \code{hal9001}, containing a list of basis
 functions, a copy map, coefficients estimated for basis functions, and
 timing results (for assessing computational efficiency).
}
\description{
Estimation procedure for HAL, the Highly Adaptive Lasso
}
\details{
The procedure uses a custom C++ implementation to generate a design
 matrix consisting of basis functions corresponding to covariates and
 interactions of covariates and to remove duplicate columns of indicators.
 The Lasso regression is fit to this (usually) very wide matrix using either
 a custom implementation (based on \pkg{origami}) or by a call to
 \code{\link[glmnet]{cv.glmnet}}.
}
\examples{
\donttest{
n <- 100
p <- 3
x <- xmat <- matrix(rnorm(n * p), n, p)
y_prob <- plogis(3 * sin(x[, 1]) + sin(x[, 2]))
y <- rbinom(n = n, size = 1, prob = y_prob)
ml_hal_fit <- fit_hal(X = x, Y = y, family = "binomial", yolo = FALSE)
preds <- predict(ml_hal_fit, new_data = x)
}

}
