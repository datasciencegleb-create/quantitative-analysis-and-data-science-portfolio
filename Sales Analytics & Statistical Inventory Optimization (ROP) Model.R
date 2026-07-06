set.seed(777)
n <- 1000

dates <- seq(as.Date("2023-01-01"), by = "day", length.out = 100)
transaction_dates <- sample(dates, n, replace = TRUE)
product_ids <- sample(paste0("Prod_", 1:5), n, replace = TRUE)
quantities <- sample(1:10, n, replace = TRUE)

prices_map <- c("Prod_1" = 15, "Prod_2" = 30, "Prod_3" = 50, "Prod_4" = 10, "Prod_5" = 100)
costs_map <- c("Prod_1" = 8, "Prod_2" = 18, "Prod_3" = 35, "Prod_4" = 4, "Prod_5" = 65)

price <- prices_map[product_ids]
cost <- costs_map[product_ids]
customer_ids <- sample(paste0("Cust_", 1:20), n, replace = TRUE)
status <- sample(c("Paid", "Unpaid", "Delayed"), n, replace = TRUE, prob = c(0.85, 0.1, 0.05))

sales_data <- data.frame(
  date = transaction_dates,
  product = product_ids,
  quantity = quantities,
  price = price,
  cost = cost,
  customer = customer_ids,
  status = status
)

sales_data$revenue <- sales_data$quantity * sales_data$price
sales_data$total_cost <- sales_data$quantity * sales_data$cost
sales_data$profit <- sales_data$revenue - sales_data$total_cost

agg_products <- aggregate(cbind(revenue, profit) ~ product, data = sales_data, sum)
agg_products$margin <- agg_products$profit / agg_products$revenue

daily_sales <- aggregate(quantity ~ date + product, data = sales_data, sum)

mean_daily <- aggregate(quantity ~ product, data = daily_sales, mean)
sd_daily <- aggregate(quantity ~ product, data = daily_sales, sd)

inventory_stats <- merge(mean_daily, sd_daily, by = "product", suffixes = c("_mean", "_sd"))

lead_time <- 5
z_score <- 1.65

inventory_stats$safety_stock <- round(z_score * inventory_stats$quantity_sd * sqrt(lead_time))
inventory_stats$reorder_point <- round((inventory_stats$quantity_mean * lead_time) + inventory_stats$safety_stock)

customer_payment <- table(sales_data$customer, sales_data$status)
customer_reliability <- prop.table(customer_payment, 1)

layout(matrix(c(1, 2), nrow = 1, ncol = 2))
barplot(agg_products$margin * 100, names.arg = agg_products$product, col = "skyblue",
        xlab = "Product", ylab = "Profit Margin (%)", main = "Product Profitability")
barplot(inventory_stats$reorder_point, names.arg = inventory_stats$product, col = "salmon",
        xlab = "Product", ylab = "Units", main = "Reorder Points (ROP)")