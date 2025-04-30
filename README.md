# UK EQ5D-Mapping-Calculator

UK EQ5D-Mapping-Calculator
This repository provides a user-friendly tool for mapping between the EQ-5D-5L and EQ-5D-3L health utility instruments using UK value sets. This tool is based on the [EQ-5D mapping algorithms published by the NICE Decision Support Unit](https://www.sheffield.ac.uk/nice-dsu/methods-development/mapping-eq-5d).

### 🔗 Online Calculator

Access the live Shiny web application here:
👉 [UK EQ5D Mapping Calculator](https://yourenchou.shinyapps.io/UK_EQ-5D_Mapping_Tool/)

### 📂 Repository Contents
EQ-5D Mapping Tool.R – R script for the core mapping functionality.

Table3v5.csv – Conversion matrix for mapping from EQ-5D-3L to 5L.

Table5v5.csv – Conversion matrix for mapping from EQ-5D-5L to 3L.

README.md – Documentation for users and contributors.

### 📖 Description
The calculator enables mapping of EQ-5D health states to either EQ-5D-3L or EQ-5D-5L equivalents using validated transition matrices. This is particularly useful when studies use mixed or legacy datasets, and consistency in utility scores is required for cost-utility analysis.

### 🧠 Methodology
The mapping approach is based on:

Hernández Alava, M., Pudney, S., & Wailoo, A. (2022). Estimating the Relationship Between EQ-5D-5L and EQ-5D-3L: Results from a UK Population Study. PharmacoEconomics.
DOI: [10.1007/s40273-022-01218-7](https://link.springer.com/article/10.1007/s40273-022-01218-7)


### 📈 Output
Utility values before and after mapping

Histograms for visual comparison
