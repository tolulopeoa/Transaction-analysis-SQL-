SELECT * 
FROM Transactions;

-- Convert all the  GBP transactions in the amount_paid column to USD 
UPDATE Transactions
SET amount_paid = ROUND(amount_paid* 1.26802, 2)
WHERE Currency = 'GBP';

-- Drop the Currency Column-its not useful for the analysis
ALTER TABLE Transactions
DROP COLUMN Currency;

 -- Create item categories from the item_bought column
ALTER TABLE Transactions
ADD item_category VARCHAR(50);

UPDATE Transactions
SET item_category =
    CASE
        WHEN item_bought LIKE '%shoe%' OR
             item_bought LIKE '%loafer%' OR
             item_bought LIKE '%sandal%' OR
             item_bought LIKE '%heel%' OR
             item_bought LIKE '%trainer%' OR
             item_bought LIKE '%mule%' OR
             item_bought LIKE '%heel%' OR
             item_bought LIKE '%boot%' OR
             item_bought LIKE '%flat%' OR
             item_bought LIKE '%slider%' OR
             item_bought LIKE '%drivers%' OR
             item_bought LIKE '%slide%' OR
             item_bought LIKE '%sneaker%' THEN 'Shoes'
        
        WHEN item_bought LIKE '%dress%' OR
             item_bought LIKE '%playsuit%' OR
             item_bought LIKE '%jumpsuit%' OR
             item_bought LIKE '%t-shirt%' OR
             item_bought LIKE '%tshirt%' OR
             item_bought LIKE '%trouser%' OR
             item_bought LIKE '%legging%'OR
             item_bought LIKE '%shirt%' OR
             item_bought LIKE '%blazer%' OR
             item_bought LIKE '%vest%' OR
             item_bought LIKE '%jeans%' OR
             item_bought LIKE '%short%' OR
             item_bought LIKE '%lingerie%' OR
             item_bought LIKE '%sweater%' OR
             item_bought LIKE '%top%' OR
             item_bought LIKE '%jogger%' OR
             item_bought LIKE '%sweat%' OR
             item_bought LIKE '%robe%' OR
             item_bought LIKE '%bodysuit%' OR
             item_bought LIKE '%skirt%' THEN 'Clothes'
        
        WHEN item_bought LIKE '%bag%' OR
             item_bought LIKE '%tote%' THEN 'Bags'
 
        ELSE 'Other'
    END;
  
-- When was the first transaction done by the Personal Shopper?
SELECT MIN(CONVERT(DATE, Date, 101)) AS FirstTransaction
FROM Transactions
WHERE TRY_CAST(Date AS DATE) IS NOT NULL AND payment_status = 'Completed';

-- When was the lastest transaction done by the Personal Shopper?
SELECT MAX(CONVERT(DATE, Date, 101)) AS LatestTransaction
FROM Transactions
WHERE TRY_CAST(Date AS DATE) IS NOT NULL AND payment_status = 'Completed';

-- What is the total amount for all sucessful transactions made by the personal shopper from 2019-2024?
SELECT CONCAT('$', ROUND(SUM(amount_paid), 0)) AS TotalTransactions
FROM Transactions
WHERE payment_status ='Completed';

-- What is the average amount for all successful transactions made by the personal shopper?
SELECT CONCAT ('$', 
       ROUND(AVG(Amount_Paid),
       2)) AS AvgAmount
FROM transactions
WHERE payment_status ='Completed';

-- What is the most frequent store with the most purchases between 2019-2024?
SELECT TOP 1
    Store_Name,
    COUNT(*) AS PurchaseCount,
    CONCAT('$',ROUND (SUM(amount_paid),0))  AS TotalAmount
FROM
    Transactions
WHERE 
    payment_status ='Completed'
GROUP BY
    Store_Name
ORDER BY
    PurchaseCount DESC, TotalAmount DESC;

-- What is the total amount of completed transactions done for all item categories?
SELECT
    item_category,
    CONCAT('$',ROUND (SUM(amount_paid),2))  AS TotalAmount
FROM
   Transactions
WHERE payment_status ='Completed'
GROUP BY
    item_category;

-- Selecting rows where item_category is 'Other' and payment status is completed. 
SELECT item_bought, item_category
FROM Transactions
WHERE item_category = 'Other' AND payment_status = 'Completed';
