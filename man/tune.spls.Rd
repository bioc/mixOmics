% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tune.spls.R
\name{tune.spls}
\alias{tune.spls}
\title{Tuning functions for sPLS and PLS functions}
\usage{
tune.spls(
  X,
  Y,
  test.keepX = NULL,
  test.keepY = NULL,
  ncomp,
  validation = c("Mfold", "loo"),
  nrepeat = 1,
  folds,
  mode = c("regression", "canonical", "classic"),
  measure = NULL,
  BPPARAM = SerialParam(),
  progressBar = FALSE,
  limQ2 = 0.0975,
  ...
)
}
\arguments{
\item{X}{numeric matrix of predictors with the rows as individual
observations. missing values (\code{NA}s) are allowed.}

\item{Y}{numeric matrix of response(s) with the rows as individual
observations matching \code{X}. missing values (\code{NA}s) are allowed.}

\item{test.keepX}{numeric vector for the different number of variables to
test from the \eqn{X} data set.}

\item{test.keepY}{numeric vector for the different number of variables to
test from the \eqn{Y} data set. Default to \code{ncol(Y)}.}

\item{ncomp}{Positive Integer. The number of components to include in the
model. Default to 2.}

\item{validation}{character.  What kind of (internal) validation to use,
matching one of \code{"Mfold"} or \code{"loo"} (Leave-One-out). Default is
\code{"Mfold"}.}

\item{nrepeat}{Positive integer. Number of times the Cross-Validation process
should be repeated. \code{nrepeat > 2} is required for robust tuning. See
details.}

\item{folds}{Positive Integer, The folds in the Mfold cross-validation.}

\item{mode}{Character string indicating the type of PLS algorithm to use. One
of \code{"regression"}, \code{"canonical"}, \code{"invariant"} or \code{"classic"}. See Details.}

\item{measure}{The tuning measure to use. See details.}

\item{BPPARAM}{A \linkS4class{BiocParallelParam} object indicating the type
of parallelisation. See examples in \code{?tune.spca}.}

\item{progressBar}{Logical. If \code{TRUE} a progress bar is shown as the
computation completes. Default to \code{FALSE}.}

\item{limQ2}{Q2 threshold for recommending optimal \code{ncomp}.}

\item{...}{Optional parameters passed to \code{\link{spls}}}
}
\value{
A list that contains: \item{cor.pred}{The correlation of predicted vs
  actual components from X (t) and Y (u) for each
  component}\item{RSS.pred}{The Residual Sum of Squares of predicted vs
  actual components from X (t) and Y (u) for each component}
  \item{choice.keepX}{returns the number of variables selected for X (optimal
  keepX) on each component.} \item{choice.keepY}{returns the number of
  variables selected for Y (optimal keepY) on each component.}
  \item{choice.ncomp}{returns the optimal number of components for the model
  fitted with \code{$choice.keepX} and \code{$choice.keepY} } \item{call}{The
  functioncal call including the parameteres used.}
}
\description{
This function uses repeated cross-validation to tune hyperparameters such as
the number of features to select and possibly the number of components to
extract.
}
\section{folds}{
 
During a cross-validation (CV), data are randomly split into \code{M}
subgroups (folds). \code{M-1} subgroups are then used to train submodels
which would be used to predict prediction accuracy statistics for the
held-out (test) data. All subgroups are used as the test data exactly once.
If \code{validation = "loo"}, leave-one-out CV is used where each group
consists of exactly one sample and hence \code{M == N} where N is the number
of samples.
}

\section{nrepeat}{
 
The cross-validation process is repeated \code{nrepeat} times and the
accuracy measures are averaged across repeats. If \code{validation = "loo"},
the process does not need to be repeated as there is only one way to split N
samples into N groups and hence nrepeat is forced to be 1.
}

\section{measure}{
 
\itemize{
\item \bold{For PLS2} Two measures of accuracy are available: Correlation
(\code{cor}, used as default), as well as the Residual Sum of Squares
(\code{RSS}). For \code{cor}, the parameters which would maximise the
correlation between the predicted and the actual components are chosen. The
\code{RSS} measure tries to predict the held-out data by matrix
reconstruction and seeks to minimise the error between actual and predicted
values. For \code{mode='canonical'}, The X matrix is used to calculate the
\code{RSS}, while for others modes the \code{Y} matrix is used. This measure
gives more weight to any large errors and is thus sensitive to outliers. It
also intrinsically selects less number of features on the \code{Y} block
compared to \code{measure='cor'}. 
\item \bold{For PLS1} Four measures of accuracy are available: Mean Absolute
Error (\code{MAE}), Mean Square Error (\code{MSE}, used as default),
\code{Bias} and \code{R2}. Both MAE and MSE average the model prediction
error. MAE measures the average magnitude of the errors without considering
their direction. It is the average over the fold test samples of the absolute
differences between the Y predictions and the actual Y observations. The MSE
also measures the average magnitude of the error. Since the errors are
squared before they are averaged, the MSE tends to give a relatively high
weight to large errors. The Bias is the average of the differences between
the Y predictions and the actual Y observations and the R2 is the correlation
between the predictions and the observations.
}
}

\section{Optimisation Process}{
 
The optimisation process is data-driven and similar to the process detailed
in (Rohart et al., 2016), where one-sided t-tests assess whether there is a
gain in performance when incrementing the number of features or components in
the model. However, it will assess all the provided grid through pair-wise
comparisons as the performance criteria do not always change linearly with
respect to the added number of features or components.
}

\section{more}{

See also \code{?perf} for more details.
}

\examples{

\dontrun{
data(liver.toxicity)
X <- liver.toxicity$gene
Y <- liver.toxicity$clinic
set.seed(42)
tune.res = tune.spls( X, Y, ncomp = 3,
                  test.keepX = c(5, 10, 15),
                  test.keepY = c(3, 6, 8), measure = "cor",
                  folds = 5, nrepeat = 3, progressBar = TRUE)
tune.res$choice.ncomp
tune.res$choice.keepX
tune.res$choice.keepY
# plot the results
plot(tune.res)
}
}
\references{
mixOmics article:

Rohart F, Gautier B, Singh A, Lê Cao K-A. mixOmics: an R package for 'omics
feature selection and multiple data integration. PLoS Comput Biol 13(11):
e1005752

PLS and PLS citeria for PLS regression: Tenenhaus, M. (1998). La regression
PLS: theorie et pratique. Paris: Editions Technic.

Chavent, Marie and Patouille, Brigitte (2003). Calcul des coefficients de
regression et du PRESS en regression PLS1. Modulad n, 30 1-11. (this is the
formula we use to calculate the Q2 in perf.pls and perf.spls)

Mevik, B.-H., Cederkvist, H. R. (2004). Mean Squared Error of Prediction
(MSEP) Estimates for Principal Component Regression (PCR) and Partial Least
Squares Regression (PLSR). Journal of Chemometrics 18(9), 422-429.

sparse PLS regression mode:

Lê Cao, K. A., Rossouw D., Robert-Granie, C. and Besse, P. (2008). A sparse
PLS for variable selection when integrating Omics data. Statistical
Applications in Genetics and Molecular Biology 7, article 35.

One-sided t-tests (suppl material):

Rohart F, Mason EA, Matigian N, Mosbergen R, Korn O, Chen T, Butcher S,
Patel J, Atkinson K, Khosrotehrani K, Fisk NM, Lê Cao K-A&, Wells CA&
(2016). A Molecular Classification of Human Mesenchymal Stromal Cells. PeerJ
4:e1845.
}
\seealso{
\code{\link{splsda}}, \code{\link{predict.splsda}} and
http://www.mixOmics.org for more details.
}
\author{
Kim-Anh Lê Cao, Al J Abadi, Benoit Gautier, Francois Bartolo,
Florian Rohart,
}
\keyword{multivariate}
\keyword{regression}
