# Mtg notes

## 2025-05-28

Current:

- move EDA new parts to diffExp
- run 3 models: as before, including DMPA as covariate, subset excluding DMPAs
- Venn diagram, compare the three
- Boxplots
- Heatmaps
  - overall expression, 3 BVs groups, add DMPs annotations
  - overall expression, 2 BVs groups, add DMPs annotations
  - overall expression adjusting for DMPA if there is effect, 3 and 2 BVs
  - overall expression excluding DMPAs, 3 and 2 BVs groups

Comments

- we have been adjusting for age before, so kept it for now, but can easily remove and re-run 


Mtg with Alexandra (Zoom)

- let's focus on wrapping things up, by looking at BV2 vs. BV0, in V3, as there were no differences in V2
- The lack of differences in V2 makes sense now, should be an interesting to report too (AS)
- To wrap-up the study, we need
  - check V3 for effect of contraceptives
  - visualize results in heatmap
  - run gene set enrichment (to be discussed later)

ToDo
  
- send clinical file name to double check we are using the same
- re-run differential expression for V3
  - exclude HIVp samples, and adjust for contraceptives group
  - exclude HIVp samples, and exclude contraceptives samples

## 2024-05-07

- (done) refresh what has been done

- re-run all scripts by including data sent from AA to account for issues with NAs...and for addressing no DEGs in V2 by including hormones, fix adding hormones as covariates to V3 model

- for V2, compare DMPA vs. no HC including age and time in sex work as covariates
 
- (done) share code for hormone project, .R files only
- BV project: double-check hormone coding (why I have so many missing data?)(found a typo)
- check and potentially merge data from Alexandra
- Re-run analyses with hormones (double check EDA, group comparisons scripts, were they affected?). Re-run group comparisons with hormones.
- Try analysis with hormonones, with and without imputing missing data with knnimupte(); which columns to take to impute? need to think
- Share .csv with results with AA
- Check with Alexandra via email to continue working on the downstream analyses
- Analyses discussed: calling genotypes from RNA-seq data

## 2024-03-27

- Check: It is suspicious that there is nothing significant in V2 and there is in V3 (adj p-values < 0.05, lfc = 0)
- V2 was sampled first, then 2 weeks of no sex break, prior V3 sampling
- Double-check code
- See if findings from V3 hold in V2; fit model only using DEGs from V3, check top plots, check logFC summary stats
- Already in the meeting tried accounting for E2 and P4, both should be elevated in V2 (did not help, but double-check this)
- Send Alexandra link to box for the hormone project
- Send Alexandra link to explanation about BH correction method
- Next steps would be to make heatmaps, functional enrichment
- Further: paired design BV 0 - 2 (n = 3) and BV 2 - 0 (n = 8)

## 2024-02-20

- Remove PatID 3943, has Chlamydia
- Prepare data sets separately for V2, V3 and paired V2 and V3
- Add HIV status (positive and negative) to EDA. Ca. 10% of subjects are HIV positive. We may want to exclude them depending on the PCA.
  - comment: only relevant for V2, no HIVpos for V3 after matching with available RNA-seq data and excluding samples with missing BVs
- For V2 and V3, done separately: compare BV 0 vs. 2, 0 vs. 1, 1 vs. 2; number of DEGs, heatmaps  
- For paired V2 and V3: count how many samples we have depending on the change, i.e. stay the same/improve/deteriorate
  
## Questions

- missing data: just BV diagnosis or also Nugent scores?
- we cannot compare V2 vs. V3 because it is confounded with batch

## Notes

- mixed effect models: add batch or time-point as covariate, compare groups ok based from talking to Eva

## TODO

- EDA: normalized counts by BV, V2 and V3 separately (age, Nugent score)
- EDA: normalized counts V2 and V3, together, by RNA-seq batch
- think about batch effect? do I need to account for days passed in models? Or enough as two time points V2 and V3?

- (done): EDA: BV, Nugent Score, age, by V2 and V3 and change from V3 (T1) and V2 (T2)
- (done) samples by BV and available count data
- (done) load clinical data, check V2 and V3 overlapp, all, complete data for age and BV

## Questions

- any other clinical covariates we should look into during EDA?
- what about one sample that we are missing Nugent score but have BV category? Keep or remove?

## 2023-01-23, Kristina, Alexandra

- BV project background
- main goal: how the change in BV between V2 and V3 reflects on the transcriptome?
- start by identifying paired samples between V2 and V3, with complete BV scores (should be n = 107)
- re-run processing

- EDA with PCA
  - separate for V2 and V3, color-coded by groups (healthy, intermediate, BV), Nudget scores), potentially recoded (healthy .vs BV excluding intermediate)
  - summary stats of BV at V2 and V3, how many stay the same, how many change groups etc.
  - think about the statistical models (check with Eva)
- Later on: statistical modelling and heatmap

RNA-seq data analysis to investigate changes in transcriptome in women with bacterial vaginosis

- Data preparations, i.e. selecting relevant samples, processing of raw RNA-seq counts
- Exploratory data analysis with a focus on BV
- Statistical modelling
- Putting results in the biological context
- Visualization or the results, report