if(!require(rugarch)) install.packages("rugarch", dependencies=TRUE)
if(!require(copula)) install.packages("copula", dependencies=TRUE)
if(!require(fGarch)) install.packages("fGarch", dependencies=TRUE)
library(fGarch)
library(rugarch)
library(copula)

set.seed(42)
n <- 1000

sim_garch <- function(n, omega, alpha, beta) {
  h <- numeric(n)
  r <- numeric(n)
  h[1] <- omega / (1 - alpha - beta)
  r[1] <- rnorm(1, 0, sqrt(h[1]))
  for (t in 2:n) {
    h[t] <- omega + alpha * r[t-1]^2 + beta * h[t-1]
    r[t] <- rnorm(1, 0, sqrt(h[t]))
  }
  return(r)
}

r1 <- sim_garch(n, 0.05, 0.1, 0.8)
r2 <- sim_garch(n, 0.04, 0.15, 0.75)
r3 <- sim_garch(n, 0.03, 0.05, 0.9)

returns_matrix <- cbind(Asset1 = r1, Asset2 = r2, Asset3 = r3)

spec <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
                   mean.model = list(armaOrder = c(0, 0), include.mean = FALSE),
                   distribution.model = "std")

fit1 <- ugarchfit(spec, r1)
fit2 <- ugarchfit(spec, r2)
fit3 <- ugarchfit(spec, r3)

res1 <- as.numeric(residuals(fit1, standardize = TRUE))
res2 <- as.numeric(residuals(fit2, standardize = TRUE))
res3 <- as.numeric(residuals(fit3, standardize = TRUE))

u1 <- pobs(res1)
u2 <- pobs(res2)
u3 <- pobs(res3)
u_matrix <- cbind(u1, u2, u3)

t_copula <- tCopula(dim = 3)
fit_cop <- fitCopula(t_copula, u_matrix, method = "ml")

sim_copula <- rCopula(10000, fit_cop@copula)

df1 <- coef(fit1)["shape"]
df2 <- coef(fit2)["shape"]
df3 <- coef(fit3)["shape"]

sim_res1 <- qstd(sim_copula[, 1], mean = 0, sd = 1, nu = df1)
sim_res2 <- qstd(sim_copula[, 2], mean = 0, sd = 1, nu = df2)
sim_res3 <- qstd(sim_copula[, 3], mean = 0, sd = 1, nu = df3)

sig1 <- as.numeric(ugarchforecast(fit1, n.ahead = 1)@forecast$sigmaFor)
sig2 <- as.numeric(ugarchforecast(fit2, n.ahead = 1)@forecast$sigmaFor)
sig3 <- as.numeric(ugarchforecast(fit3, n.ahead = 1)@forecast$sigmaFor)

sim_r1 <- sim_res1 * sig1
sim_r2 <- sim_res2 * sig2
sim_r3 <- sim_res3 * sig3

sim_portfolio_returns <- 0.33 * sim_r1 + 0.33 * sim_r2 + 0.33 * sim_r3
portfolio_losses <- -sim_portfolio_returns

alpha <- 0.99
var_99 <- quantile(portfolio_losses, alpha)
es_99 <- mean(portfolio_losses[portfolio_losses >= var_99])

print(var_99)
print(es_99)

layout(matrix(c(1, 2), nrow = 1, ncol = 2))
plot(sim_r1, sim_r2, col = rgb(0,0,1,0.2), pch = 19,
     xlab = "Asset 1 Return", ylab = "Asset 2 Return",
     main = "Copula Joint Returns")
hist(portfolio_losses, breaks = 50, col = "lightgray", border = "darkgray",
     xlab = "Portfolio Loss", main = "Loss Distribution & Risk")
abline(v = var_99, col = "blue", lwd = 2, lty = 2)
abline(v = es_99, col = "red", lwd = 2, lty = 2)