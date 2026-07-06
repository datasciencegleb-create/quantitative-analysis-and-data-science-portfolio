# quantitative-analysis-and-data-science-portfolio

Hi there! I'm a student focusing on quantitative methods, statistics, and financial modeling. This repository contains a few practical projects I've built in R to solve real-world problems in finance, econometrics, and business analytics.

All scripts are self-contained and run out of the box (they'll automatically install any required packages).

## What's inside:

### 1. Macroeconomic Forecasting (VAR Model)
* **File:** `projekt1.R`
* **The Goal:** I wanted to see how monetary policy decisions impact the broader economy. I simulated 20 years of quarterly macro data (GDP, inflation, interest rates) and fitted a Vector Autoregression (VAR) model to predict where the economy goes next.
* **What I used:** Time series analysis, VAR(2) modeling, forecasting, and plotting confidence corridors.

### 2. Credit Scoring & Default Probability
* **File:** `projekt2.R`
* **The Goal:** Modeling credit risk for a retail bank. I generated a dummy dataset of 1,000 borrowers and trained a Logistic Regression model to predict defaults. Then, I mapped those probabilities into standard credit scores (300-850) and visualized how well the model separates "good" vs "bad" clients using a boxplot.
* **What I used:** Logistic regression, probability scaling, risk segmentation, and data visualization.

### 3. Portfolio Risk Optimization (GARCH + Copula)
* **File:** `projekt3.R`
* **The Goal:** A more advanced risk management model. Standard correlation often fails during market crashes because assets tend to fall together. To fix this, I modeled individual asset volatilities using GARCH(1,1) and glued them together using a Student-t Copula to capture tail dependence. Then, I ran a Monte Carlo simulation to find the 99% Value-at-Risk (VaR) and Expected Shortfall (ES).
* **What I used:** GARCH volatility modeling, Copulas, Monte Carlo simulations, VaR, and Expected Shortfall.

### 4. Sales Analytics & Inventory Optimization
* **File:** `projekt4.R`
* **The Goal:** Managing store inventory mathematically. I cleaned a raw transactional dataset and wrote a model to calculate the optimal Reorder Point (ROP) for stock replenishment. It uses the standard deviation of daily sales and normal distribution quantiles to calculate the safety stock needed for a 95% service level.
* **What I used:** Descriptive statistics, inventory management formulas, normal distribution, and data wrangling.

---
Feel free to look through the code or run the scripts directly in RStudio. If you have any questions or want to discuss a project, just let me know!
