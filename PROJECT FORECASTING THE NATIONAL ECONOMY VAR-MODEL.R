if(!require(vars)) install.packages("vars", dependencies=TRUE)
library(vars)

set.seed(42)
n <- 80

gdp_shocks <- rnorm(n, mean = 0, sd = 1)
inf_shocks <- rnorm(n, mean = 0, sd = 0.5)
rate_shocks <- rnorm(n, mean = 0, sd = 0.3)

gdp <- numeric(n)   # GDP Growth (%)
inf <- numeric(n)   # Inflation Rate (%)
rate <- numeric(n)  # Central Bank Policy Interest Rate (%) 

gdp[1] <- 2.0; inf[1] <- 1.5; rate[1] <- 2.5
gdp[2] <- 2.2; inf[2] <- 1.6; rate[2] <- 2.6

for (t in 3:n) {
  gdp[t] <- 0.5 * gdp[t-1] - 0.2 * rate[t-1] + gdp_shocks[t] + 1
  inf[t] <- 0.3 * gdp[t-1] + 0.4 * inf[t-1] + inf_shocks[t] + 0.5
  rate[t] <- 0.6 * inf[t-1] + 0.5 * rate[t-1] + rate_shocks[t] + 0.2
}

macro_data <- cbind(GDP_Growth = gdp, Inflation = inf, Policy_Rate = rate)

var_model <- VAR(macro_data, p = 2, type = "const")

predictions <- predict(var_model, n.ahead = 4, ci = 0.95)

plot(predictions, names = "GDP_Growth", main = "GDP growth forecast (%)")
plot(predictions, names = "Inflation", main = "Inflation Forecast (%)")
plot(predictions, names = "Policy_Rate", main = "Central Bank Interest Rate Forecast (%)")