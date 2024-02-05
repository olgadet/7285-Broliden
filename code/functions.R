##----func_pca()
func_pca <- function(x = m_v2, df_meta = df_meta_v2, n_loadings = 5){
  
  # calculate pca
  pca <- prcomp(t(x), center=TRUE, scale.=FALSE)
  eigs <- pca$sdev^2
  var_exp <- eigs / sum(eigs)
  
  # prepare data frame
  df <- data.frame(PC1=pca$x[,1], PC2=pca$x[,2], PC3=pca$x[,3], PC4=pca$x[,4], PC5=pca$x[,5]) %>%
    rownames_to_column("PatID") %>%
    as_tibble() %>%
    left_join(df_meta) %>%
    mutate(pca_var_exp = round(var_exp*100, 2)) 
  
  loadings <- pca$rotation
  df_loadings <- loadings[, 1:n_loadings]
  
  
  results <- list(scores = df, loadings = df_loadings)
  
  return(results)
  
}

##----func_plot_pca
func_plot_pca <- function(pc_x = 1, pc_y = 2, df = pca_scores){
  
  var_x <- paste("PC", pc_x, sep="")
  var_y <- paste("PC", pc_y, sep="")
  lab_x <- paste(var_x, " (", round(df$pca_var_exp[pc_x], 2), "%)", sep="")
  lab_y <- paste(var_y, " (", round(df$pca_var_exp[pc_y], 2), "%)", sep="")
  
  plot <- df %>%
    ggplot(aes(x = !!ensym(var_x), y = !!ensym(var_y), label = PatID)) + 
    geom_point(shape = 21, size = 3, fill = mycols[2], alpha = 0.7) + 
    xlab(lab_x) + 
    ylab(lab_y) + 
    theme_bw()
  
  return(plot)
}



func_plot_pca_by_num <- function(pc_x = 1, pc_y = 2, cov = "age", df = pca_scores){
  
  var_x <- paste("PC", pc_x, sep="")
  var_y <- paste("PC", pc_y, sep="")
  lab_x <- paste(var_x, " (", round(df$pca_var_exp[pc_x], 2), "%)", sep="")
  lab_y <- paste(var_y, " (", round(df$pca_var_exp[pc_y], 2), "%)", sep="")
  
  plot <- df %>%
    ggplot(aes(x = !!ensym(var_x), y = !!ensym(var_y), label = PatID, fill = !!ensym(cov), size = !!ensym(cov))) + 
    geom_point(shape = 21, alpha = 0.7) + 
    xlab(lab_x) + 
    ylab(lab_y) + 
    theme_bw() + 
    guides(size = "none")
  
  return(plot)
}

func_plot_pca_by_cat <- function(pc_x = 1, pc_y = 2, cov = "BV", df = pca_scores){
  
  var_x <- paste("PC", pc_x, sep="")
  var_y <- paste("PC", pc_y, sep="")
  lab_x <- paste(var_x, " (", round(df$pca_var_exp[pc_x], 2), "%)", sep="")
  lab_y <- paste(var_y, " (", round(df$pca_var_exp[pc_y], 2), "%)", sep="")
  
  plot <- df %>%
    ggplot(aes(x = !!ensym(var_x), y = !!ensym(var_y), label = PatID, fill = !!ensym(cov))) + 
    geom_point(shape = 21, size = 3, alpha = 0.7) + 
    xlab(lab_x) + 
    ylab(lab_y) + 
    theme_bw() + 
    scale_fill_manual(values = mycols)
  
  return(plot)
}



##---func_plot_loadings
func_plot_loadings <- function(pc = 1, ntop = 10, df_loadings, db = df_ensmbl_annotated, inp.color = "#377EB8" ){
  
  pc <- paste("PC", pc, sep="")
  
  data_load <- df_loadings %>%
    as.data.frame() %>%
    rownames_to_column("ENSG") %>% 
    as_tibble() %>% 
    dplyr::select(all_of(c("ENSG", pc))) %>% #print()
    mutate(pc_abs = abs(!!ensym(pc))) %>%
    arrange(desc(pc_abs)) %>%
    slice(1:ntop) 
  
  load_annotate <- data_load %>%
    left_join(db, by = c("ENSG" = "ensembl_gene_id")) %>%
    arrange(pc_abs) %>%
    mutate(gene = factor(gene, levels = gene))
  
  
  plot <- 
    load_annotate %>%
    ggplot(aes(x=gene, y=pc_abs)) +
    geom_segment( aes(x=gene, xend=gene, y=0, yend=pc_abs), color="skyblue") +
    geom_point(color=inp.color, size=4, alpha=0.6) +
    theme_light() +
    coord_flip() +
    theme(
      panel.grid.major.y = element_blank(),
      panel.border = element_blank(),
      axis.ticks.y = element_blank()
    ) + 
    ylab("loadings") + 
    xlab("")
  
  return(plot)
  
}


##---func_estimate_disp()
func_estimate_disp <- function(df_meta = df_meta_v2, y = data_cds_v2){
  
  # select relevant columns  
  cols <- c("PatID", "E2", "P4", "BV")
  
  df_meta <- df_meta %>%
    dplyr::select(all_of(cols))
  
  # remove missing BV data (if any)
  idx_na <- which(df_meta$BV == "NA")
  if (length(idx_na) > 0){
    df_meta <- df_meta %>% slice(-idx_na)
    y <- y[, -idx_na]  
  }
  
  # define design matrix
  E2 <- df_meta$E2
  P4 <- df_meta$P4
  BV <- df_meta$BV
  design_matrix =  model.matrix(~E2 + P4 + BV)
  
  # estimate dispersion
  y <- estimateDisp(y, design_matrix, robuts = TRUE)
  
  # return edgeR, common dispertion and design matrix
  return(list(y = y, disp = y$common.dispersion, design_matrix = design_matrix))
  
  
}

##---func_summarize_degs()
func_summarize_degs <- function(fit){
  
  thr <- c(0.05, 0.01, 0.001)  
  stats_adj <- c("none", "fdr")
  
  grid <- expand.grid(thr = thr, adj_method = stats_adj)
  
  degs_overview <- matrix(data = NA, nrow = nrow(grid), ncol = 3)
  
  for (i in 1:nrow(grid)){
    tmp <- summary(decideTestsDGE(fit, adjust.method = as.character(grid[i, "adj_method"]), p.value = grid[i, "thr"]))
    
    degs_overview[i, ] <- as.numeric(tmp)
    
  }
  colnames(degs_overview) <- c("Down", "NS", "Up")
  
  out <- cbind(grid, degs_overview)
  out <- as_tibble(out) %>%
    relocate(adj_method)
  
  return(out)
  
}

##----func_E2_P4_overlap
func_E2_P4_overlap <- function(thr, col1, col2){
  
  idx <- which(col1 < thr & col2 < thr)
  return(length(idx))
  
}

