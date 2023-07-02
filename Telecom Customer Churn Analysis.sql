use telecom;

#Data cleaning and preparation
#Change column name into proper format
ALTER TABLE customers
RENAME COLUMN `Customer ID` to Customer_id;

#Check for duplicates
SELECT customer_id,COUNT(customer_id) 
FROM customers
GROUP BY customer_id
HAVING count(customer_id)>1;
#There is no duplicates. Customer_id is the primary key of this table.

#Get the total number of customers
SELECT COUNT(customer_id) as Total_customers
FROM customers;
#There are totally 4835 customers.

#Calculate total churn rate
SELECT SUM(IF (customer_status="Churned",1,0))/COUNT(*) AS Churn_Rate
FROM customers;

#Calculate average tenure
SELECT ceiling(avg(Tenure_in_months)) as average_tenure
FROM customers;

#Calculate ARPU
SELECT ROUND(AVG(total_revenue/tenure_in_months),0) AS ARPU
FROM customers;

#Number of Dependents Distribution
SELECT number_of_dependents,count(*)as Numbers
FROM customers
GROUP BY number_of_dependents
ORDER BY numbers DESC;

#Offer Distribution
SELECT offer,count(*)as Numbers
FROM customers
GROUP BY offer
ORDER BY numbers DESC;

#Exploratory Analysis
#How much revenue had been lost due to churned customers?
SELECT customer_status,
COUNT(customer_id) AS Number_of_customer,
ROUND(SUM(total_revenue),0) AS Revenue,
ROUND(SUM(total_revenue)*100/SUM(SUM(total_revenue))OVER(),2) AS revenue_percentage
FROM customers
GROUP BY customer_status;

#How about the typical tenure for churned customers?
SELECT COUNT(customer_id) as Number_of_Churned_customers,
	CASE 
		WHEN tenure_in_months<=6 THEN "<6 Months"
        WHEN tenure_in_months<=12 THEN "<1 Year"
        WHEN tenure_in_months<=24 THEN "<2 Years"
        ELSE '>2 Years'
        END AS Tenure,
ROUND(COUNT(customer_id)*100/SUM(COUNT(customer_id)) OVER(),2) AS Percentage
FROM customers
WHERE customer_status="Churned"
GROUP BY tenure
ORDER BY Number_of_Churned_customers DESC;

#Which cities had the highest churned rates?
SELECT City, ROUND(SUM(IF(customer_status="Churned",1,0))*100/COUNT(Customer_id),2) AS Churned_rate
FROM customers
GROUP BY City
HAVING COUNT(customer_id)>30 AND
SUM(IF(customer_status="Churned",1,0))>0
ORDER BY churned_rate DESC
LIMIT 5;

#What are the general reason for churn?
SELECT Churn_category,ROUND(SUM(total_revenue),2)AS Total_Churned_Revenue,
ROUND(COUNT(customer_id)*100/SUM(COUNT(customer_id)) OVER(),2) AS Percentage
FROM customers
WHERE customer_status="churned"
GROUP BY Churn_category
ORDER BY Percentage DESC;

## Specific Reasons for Churn
SELECT Churn_category,Churn_reason,
COUNT(Customer_id) As Number_of_Churned_Customers,
ROUND(COUNT(customer_id)*100/SUM(COUNT(customer_id)) OVER(),2) AS Percentage
FROM customers
WHERE customer_status="churned"
GROUP BY Churn_category,Churn_reason
ORDER BY Percentage DESC
LIMIT 8;

##What offers did churned customers have?
SELECT offer,
ROUND(COUNT(customer_id)*100/SUM(COUNT(customer_id)) OVER(),2) AS Percentage
FROM customers
WHERE customer_status="churned"
GROUP BY offer
ORDER BY Percentage DESC;

##What internet type did churned customers have?
SELECT internet_type,
COUNT(customer_id) as Number_of_Churned_Customers,
ROUND(COUNT(customer_id)*100/SUM(COUNT(customer_id)) OVER(),2) AS Percentage
FROM customers
WHERE customer_status="churned"
GROUP BY Internet_type
ORDER BY Percentage DESC;

##What type of internet type did churned customers with Competitor reason have?
SELECT internet_type,
churn_category,
COUNT(customer_id) as Number_of_Churned_Customers,
ROUND(COUNT(customer_id)*100/SUM(COUNT(customer_id)) OVER(),2) AS Percentage
FROM customers
WHERE customer_status="churned" 
AND churn_category="Competitor"
GROUP BY Internet_type
ORDER BY Percentage DESC;

## Did churned customer have premium tech support?
SELECT Premium_Tech_Support,
COUNT(customer_id) as Number_of_Churned_Customers,
ROUND(COUNT(customer_id)*100/SUM(COUNT(customer_id)) OVER(),2) AS Percentage
FROM customers
WHERE customer_status="churned" 
GROUP BY Premium_Tech_Support
ORDER BY Percentage DESC;

##What contract were churned customer on?
SELECT contract,
COUNT(customer_id) as Number_of_Churned_Customers,
ROUND(COUNT(customer_id)*100/SUM(COUNT(customer_id)) OVER(),2) AS Percentage
FROM customers
WHERE customer_status="churned" 
GROUP BY contract
ORDER BY Percentage DESC;