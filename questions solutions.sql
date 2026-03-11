LOAD DATA LOCAL INFILE 'D:/Zooper Insurance analytics/policy_sales_data.csv'
INTO TABLE policy_sales_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY 'n'
IGNORE 1 ROWS;


-- 1. Calculate the total premium collected during the year 2024.

SELECT 
    SUM(Premium) AS Total_Premium_2024
FROM policy_sales_data
WHERE YEAR(Policy_Purchase_Date) = 2024;

-- 2. Calculate the total claim cost for each year (2025 and 2026) with a monthly breakdown. 

SELECT
YEAR(Claim_Date) AS Year,
MONTH(Claim_Date) AS Month,
SUM(Claim_Amount) AS Total_Claim_Cost
FROM claims_data
GROUP BY Year, Month
ORDER BY Year, Month;

-- 3. Calculate the claim cost to premium ratio for each policy tenure (1, 2, 3, and 4 years). 

select p.policy_tenure,
sum(c.claim_amount)/sum(p.premium) as Claim_premium_ratio
from policy_sales_data p
left join claims_data c
on p.Vehicle_ID = c.Vehicle_ID
group by p.Policy_Tenure
order by p.Policy_Tenure;

-- 4.Calculate the claim cost to premium ratio by the month in which the policy was sold (January–December 2024). 

SELECT 
    MONTHNAME(p.Policy_Purchase_Date) AS Purchase_Month,
    SUM(p.Premium) AS Total_Premium,
    SUM(c.Claim_Amount) AS Total_Claims,
    SUM(c.Claim_Amount) / SUM(p.Premium) AS Claim_Premium_Ratio
FROM policy_sales_data p
LEFT JOIN claims_data c
ON p.Vehicle_ID = c.Vehicle_ID
WHERE YEAR(p.Policy_Purchase_Date) = 2024
GROUP BY MONTH(p.Policy_Purchase_Date), MONTHNAME(p.Policy_Purchase_Date)
ORDER BY MONTH(p.Policy_Purchase_Date);

-- 5. If every vehicle that has not yet made a claim eventually files exactly one claim during the 
-- remaining policy tenure, estimate the total potential claim liability. 

SELECT
(1000000 - COUNT(DISTINCT Vehicle_ID)) * 10000 AS Future_Claim_Liability
FROM claims_data;

-- 6. Assume daily premium = Total Premium ÷ Total Policy Tenure Days. Based on this: 
-- • Calculate the premium already earned by the company up to February 28, 2026. 
-- • Estimate the premium expected to be earned monthly for the remaining policy period 
-- (assume 46 months remaining). 




