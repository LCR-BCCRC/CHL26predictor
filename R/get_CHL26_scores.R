#' Generate the CHL 26 Predictor Scores
#'
#' \code{get_CHL26_score} returns the CHL26 score 
#'
#' @param mat.norm Normalized expression matrix generated by 
#'   \code{normalizer_mat}
#' @return A two column data.frame with sampleID and scores
#' @export
#' @examples
#' normalizer <- get_normalizer(mat)
#' mat.norm <- normalize_mat(mat, normalizer)
#' get_CHL26_scores(mat.norm)
get_CHL26_scores <- function(mat.norm) {

  if (!is.matrix(mat.norm)) {
    stop("mat.norm is not a matrix. Please make sure mat.norm is matrix")
  }

  CHL26.model.coef.predictor.df <- 
    CHL26.model.coef.df[CHL26.model.coef.df$feature == "predictor", ]

  if (!all(CHL26.model.coef.predictor.df$geneName %in% rownames(mat.norm))) {
    missing.gene <- !CHL26.model.coef.predictor.df$geneName %in% rownames(mat.norm)
    stop(
      paste("Following genes missing from gene expression matrix:", 
        paste(CHL26.model.coef.predictor.df[missing.gene, "geneName"], 
              collapse = ", ")
        )
    )
  }

  model.coef <- matrix(CHL26.model.coef.predictor.df$coef, 
                       1, nrow(CHL26.model.coef.predictor.df),
                       dimnames = list(NULL, 
                                       CHL26.model.coef.predictor.df$geneName)
                       )

  scores <- model.coef %*% mat.norm[colnames(model.coef), ]
  scores.vector <- scores[1, ]

  scores.df <- data.frame(sampleID = names(scores.vector),
                          score = unname(scores.vector), 
                          stringsAsFactors = FALSE)
  scores.df
}
