test_that("CIM works for matrices", code = {
    data(nutrimouse)
    X <- nutrimouse$lipid
    Y <- nutrimouse$gene
    cim_res <- cim(cor(X, Y), cluster = "none")
    expect_is(cim_res[[1]], "matrix")
})

test_that("CIM works for rcc", code = {
    
    data(nutrimouse)
    X <- nutrimouse$lipid
    Y <- nutrimouse$gene
    nutri.rcc <- rcc(X, Y, ncomp = 3, lambda1 = 0.064, lambda2 = 0.008)
    cim_res <- cim(nutri.rcc, xlab = "genes", ylab = "lipids", margins = c(5, 6))
    expect_is(cim_res[[1]], "matrix")
})

test_that("CIM works for spca", code = {
    data(liver.toxicity)
    X <- liver.toxicity$gene
    liver.spca <- spca(X, ncomp = 2, keepX = c(30, 30), scale = FALSE)
    dose.col <- color.mixo(as.numeric(as.factor(liver.toxicity$treatment[, 3])))
    cim_res <- cim(liver.spca, row.sideColors = dose.col, col.names = FALSE,
                   row.names = liver.toxicity$treatment[, 3],
                   clust.method = c("ward", "ward"))
    expect_is(cim_res[[1]], "matrix")
})

test_that("CIM works for spls", code = {
    data(liver.toxicity)
    X <- liver.toxicity$gene
    Y <- liver.toxicity$clinic
    liver.spls <- spls(X, Y, ncomp = 3,
                       keepX = c(2, 5, 5), keepY = c(10, 10, 10))
    cim_res <- cim(liver.spls)
    expect_is(cim_res[[1]], "matrix")
})

test_that("CIM works for spls with X mapping", code = {
    data(liver.toxicity)
    X <- liver.toxicity$gene
    Y <- liver.toxicity$clinic
    liver.spls <- spls(X, Y, ncomp = 3,
                       keepX = c(2, 5, 5), keepY = c(10, 10, 10))
    cim_res <- cim(liver.spls, mapping = "X")
    expect_is(cim_res[[1]], "matrix")
})

test_that("CIM works for multilevel", code = {
    data(liver.toxicity)
    repeat.indiv <- c(1, 2, 1, 2, 1, 2, 1, 2, 3, 3, 4, 3, 4, 3, 4, 4, 5, 6, 5, 5,
                      6, 5, 6, 7, 7, 8, 6, 7, 8, 7, 8, 8, 9, 10, 9, 10, 11, 9, 9,
                      10, 11, 12, 12, 10, 11, 12, 11, 12, 13, 14, 13, 14, 13, 14,
                      13, 14, 15, 16, 15, 16, 15, 16, 15, 16)
    design <- data.frame(sample = repeat.indiv)
    res.spls.1level <- spls(X = liver.toxicity$gene,
                            Y=liver.toxicity$clinic,
                            multilevel = design,
                            ncomp = 2,
                            keepX = c(50, 50), keepY = c(5, 5),
                            mode = 'canonical')
    
    stim.col <- c("darkblue", "purple", "green4","red3")
    cim_res <- cim(res.spls.1level, mapping="Y",
        row.sideColors = stim.col[factor(liver.toxicity$treatment[,3])], comp = 1,
        legend=list(legend = unique(liver.toxicity$treatment[,3]), col=stim.col,
                    title = "Dose", cex=0.9))
    expect_is(cim_res[[1]], "matrix")
})

test_that("cim works for block.pls", {
  data(breast.TCGA)
  X = list(miRNA = breast.TCGA$data.train$mirna,
           mRNA = breast.TCGA$data.train$mrna,
           proteomics = breast.TCGA$data.train$protein)
  
  block.pls.model <- block.pls(X, indY=3)
  
  # TESTING DIFFERENT MAPPINGS
  cim_res <- cim(block.pls.model,
                 mapping = "multiblock")
  expect_is(cim_res[[1]], "matrix")
  .expect_numerically_close(cim_res$mat[1,1], 0.159)
  
  
  cim_res <- suppressMessages(cim(block.pls.model,
                                  mapping = "XY"))
  expect_is(cim_res[[1]], "matrix")
  .expect_numerically_close(cim_res$mat[1,1], 0.543)
  
  
  cim_res <- suppressMessages(cim(block.pls.model,
                                  mapping = "X"))
  expect_is(cim_res[[1]], "matrix")
  .expect_numerically_close(cim_res$mat[1,1], 1.80)
  
  
  cim_res <- suppressMessages(cim(block.pls.model,
                                  mapping = "Y"))
  expect_is(cim_res[[1]], "matrix")
  .expect_numerically_close(cim_res$mat[1,1], 1.01)
  
  
  
  # TESTING DIFFERENT MODE
  block.pls.model <- block.pls(X, indY=3,
                               mode = "regression")
  
  cim_res <- cim(block.pls.model,
                 mapping = "multiblock")
  expect_is(cim_res[[1]], "matrix")
  .expect_numerically_close(cim_res$mat[1,1], 0.159)
  
}) 

test_that("cim works for block.spls", {
  data(breast.TCGA)
  X = list(miRNA = breast.TCGA$data.train$mirna,
           mRNA = breast.TCGA$data.train$mrna,
           proteomics = breast.TCGA$data.train$protein)
  
  block.spls.model <- block.spls(X, indY=3,
                                 keepX = list(miRNA=c(30,30),
                                              mRNA=c(30,30),
                                              proteomics=c(30,30)))
  # TESTING DIFFERENT MAPPINGS
  cim_res <- cim(block.spls.model,
                 mapping = "multiblock")
  expect_is(cim_res[[1]], "matrix")
  .expect_numerically_close(cim_res$mat[1,1], 1.00)
  
  
  cim_res <- suppressMessages(cim(block.spls.model,
                                  mapping = "XY"))
  expect_is(cim_res[[1]], "matrix")
  .expect_numerically_close(cim_res$mat[1,1], 0.752)
  
  
  cim_res <- suppressMessages(cim(block.spls.model,
                                  mapping = "X"))
  expect_is(cim_res[[1]], "matrix")
  .expect_numerically_close(cim_res$mat[1,1], 1.26)
  
  
  cim_res <- suppressMessages(cim(block.spls.model,
                                  mapping = "Y"))
  expect_is(cim_res[[1]], "matrix")
  .expect_numerically_close(cim_res$mat[1,1], 0.54)
  
  
  # TESTING DIFFERENT MODE
  block.spls.model <- block.spls(X, indY=3,
                                 keepX = list(miRNA=c(30,30),
                                              mRNA=c(30,30),
                                              proteomics=c(30,30)),
                                 mode = "regression")
  
  cim_res <- cim(block.spls.model,
                 mapping = "multiblock")
  expect_is(cim_res[[1]], "matrix")
  .expect_numerically_close(cim_res$mat[1,1], 1.003)
})

unlink(list.files(pattern = "*.pdf"))
