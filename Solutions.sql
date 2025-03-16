--1. Customer Purchase Frequency & Spending Patterns

--Find total number of purchases per customer


Select customer_id, customer_name, count(order_id) as Total_purchase
from orders
group by customer_id, customer_name
order by Total_purchase desc

--Find average order value per customer

select customer_id, Round(AVG(sales),2) as Avearge_order_value
from orders
group by customer_id
order by Avearge_order_value desc

--Identify Top 10 high-spending customers

select Top 10 customer_id, customer_name, Round(sum(sales),2) as Total_spend
from orders
group by customer_id, customer_name
order by Total_spend desc

--2. Product Category Analysis

--Find most purchased product categories

select Category, count(1) as No_of_times_purchased
from Orders
group by Category
order by No_of_times_purchased desc

--Find top-selling products

select Product_id, product_name, Count(product_id) as No_of_times_sold
from orders
group by Product_id, product_name
order by No_of_times_sold desc

--Find products with highest revenue

select product_id, product_name, Round(sum(Sales), 2) as High_revenue
from orders
group by product_id, product_name
order by High_revenue desc

--3.  Impact of Discounts & Promotions

--Check how many customers buy only when discounts are available

select count(distinct customer_id) as Buy_when_discounts
from orders
where Discount > 0


select customer_id, customer_name, count(order_id) as Buy_when_discounts
from orders
where Discount > 0
group by customer_id, customer_name
order by Buy_when_discounts desc


-- Compare purchase behavior before and during sales periods

with Prev_month_sales as (
select Datepart(Month, order_date) as Month, round(sum(Sales), 2) as Total_orders
from orders
group by Datepart(Month, order_date)
), Profit_loss_analysis as (
select Month, Total_orders,
lag(Total_orders, 1, 0) over(order by month) as Prior_sales
from Prev_month_sales
)

select *, Round(Total_orders - Prior_sales, 2) as Profit_loss
from Profit_loss_analysis
order by Month

--4. Cart Abandonment & Payment Preferences
--Identify common reasons for cart abandonment (if dataset has cart abandonment data)

-- Check preferred payment methods

select r.payment_method, count(o.order_id) as Usage_count
from orders o
left join rating r on o.customer_id = r.id
group by r.payment_method


--5. Customer Reviews & Returns

--Find average customer rating per product (if ratings data is available)

select o.product_id, o.product_name, Round(avg(r.rating), 2) as Average_rating
from orders o
left join rating r on o.customer_id = r.id
group by o.product_id, o.product_name
order by Average_rating


--Find products with the highest return rates

select o.product_id, o.Product_Name, count(r.Returned) as Return_count
from orders o
left join Returns r on o.Order_ID = r.[Order ID]
where r.Returned = 'yes'
group by o.product_id, o.Product_Name
order by Return_count desc
