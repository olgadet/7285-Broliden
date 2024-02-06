# Mtg notes

## ToDo

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