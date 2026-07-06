set.seed(777)
n <- 1000

age <- round(runif(n, 21, 65))
income <- round(rlnorm(n, meanlog = 10, sdlog = 0.5))
dti <- runif(n, 0.1, 0.6)
credit_history <- round(runif(n, 300, 850))

z <- -2 + 0.02 * age - 0.0001 * income + 5 * dti - 0.01 * credit_history
p <- 1 / (1 + exp(-z))
default <- rbinom(n, 1, p)

credit_data <- data.frame(age = age, income = income, dti = dti, credit_history = credit_history, default = default)

model <- glm(default ~ age + income + dti + credit_history, data = credit_data, family = binomial)

pred_prob <- predict(model, type = "response")
scores <- 600 + 50 * log((1 - pred_prob) / pred_prob)
scores[scores < 300] <- 300
scores[scores > 850] <- 850

credit_data$score <- scores

boxplot(score ~ default, data = credit_data, col = c("green", "red"),
        names = c("Non-Default", "Default"), xlab = "Group", ylab = "Credit Score",
        main = "Credit Score Distribution by Default Status")