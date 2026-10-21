data("nutrimouse")
X <- data.matrix(nutrimouse$gene, rownames.force = TRUE)
# PLS2 uses multi-response Y
Y <- data.matrix(nutrimouse$lipid, rownames.force = TRUE)
# PLS1
y <- Y[, "C18.0"]

## ----- perf sPLS1
spls1.liver <- spls(X = X, Y = y, ncomp = 4, keepX = rep(10, 4))

set.seed(30)
perf.spls1.liver  = perf(spls1.liver, validation = 'Mfold', 
                         folds = 3, nrepeat = 3, progressBar = FALSE)

names(perf.spls1.liver$measures)
plot(perf.spls1.liver , criterion = 'Q2')
plot(perf.spls1.liver , criterion = 'MSEP')

## ----- perf sPLS2
spls2.liver <- spls(X = X, Y = Y, ncomp = 4, keepX = rep(10, 4), keepY = rep(10, 4))

set.seed(30)
perf.spls2.liver  = perf(spls2.liver, validation = 'Mfold', 
                         folds = 3, nrepeat = 3, progressBar = FALSE)
names(perf.spls2.liver$measures)
plot(perf.spls2.liver , criterion = 'Q2')
plot(perf.spls2.liver , criterion = 'Q2.total')
# correlation of cross-validated components with
# those of the full model
plot(perf.spls2.liver , criterion = 'cor.tpred')
