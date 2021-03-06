#' create map and QTL effects
#'
#' @param map map information (Chromosome and Position)
#' @param nLoci the number of markers and QTL
#' @param nMarkers the number of markers, which is used especially for genomic selection
#' @param nQTL the number of QTLs controlling the target trait
#' @param propDomi the probability of dominant QTL among the all QTL
#' @param interactionMean the expected number of epistatic loci for each effect
#' @param varEffects variance of QTL effects
#'
#' @return The simulation results (The output data was saved as BSLoutput.RData. After you load the data in R, you can find the data named as BSLoutput.)
#'
#' @export
makeMap <- function(map, nLoci, nMarkers, nQTL, propDomi, interactionMean, varEffects = 1){
  nEffectiveLoci <- 1 + rpois(n = nQTL, lambda = interactionMean)
  posEffectiveLoci <- sample(1:nLoci, sum(nEffectiveLoci))
  actionType <- rbinom(sum(nEffectiveLoci), 1, propDomi)
  effectID <- NULL
  for(i in 1:nQTL){
    effectID <- c(effectID, rep(i, nEffectiveLoci[i]))
  } # i
  if(length(varEffects) == 1){
    vEffect <- varEffects
  }else{
    vEffect <- varEffects[1]
  }
  effect <- rnorm(nQTL, 0, sqrt(varEffects))
  effects <- as.matrix(effect, nQTL, 1)
  rownames(effects) <- 1:nQTL
  colnames(effects) <- "trait1"
  if(nLoci - length(posEffectiveLoci) < nMarkers) print("Warning: Number of markers is not enough!")
  mrkPos <- sort(sample((1:nLoci)[-posEffectiveLoci], nMarkers, replace = F))
  return(list(map = map, markerPos = mrkPos, effectID = effectID, effectivePos = posEffectiveLoci, actionType = actionType, effects = effects))
}
