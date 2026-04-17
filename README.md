# Financial-Fraud-Detection-SQL
End-to-end SQL framework for detecting AML red flags (Structuring, Mules, Spikes) in 6M+ banking records. Optimized for RBI compliance reporting.
## **By Sonia| Math & Econ Background**

# Project Overview
I built this project to demonstrate how SQL can solve real-world banking challenges. Using the PaySim dataset (6M+ records), I applied **RBI compliance logic** to catch suspicious patterns that typical filters might miss.

# 🛠️ Project Architecture
This project simulates a real-world AML (Anti-Money Laundering) pipeline, transforming raw transactional data into actionable insights for compliance officers.
## 1. Data Source
* **Dataset:** PaySim (Synthetic Financial Dataset).
* **Size:** Over 6 million transaction records.

## 2. Processing Engine
* **Database:** SQL Server Management Studio (SSMS).
* **Techniques:** Used advanced SQL queries involving **CTEs** (Common Table Expressions) for data structuring and **Window Functions** for behavioral analysis (e.g., velocity checks).

## 3. Output
* **Delivered:** A prioritized "High-Risk" table containing flagged accounts and the specific AML rule triggered, ready for human investigation.


# What I Found through my investigation :
## 1. **The "Just-Under-Limit"** (Structuring)----
**Reason Behind:** I looked for customers who are clearly aware of the ₹50,000 PAN card reporting limit. By splitting a large sum into multiple ₹49,000 transfers, they attempt to move money without leaving a regulatory paper trail.
* **Conclusion:** *using this way many accounts bypassed mandatory tax reporting—a red flag for any AML team.*

## 2. **Money Mules**----
**Reason Behind** I tracked 'Mule' accounts that behave like pipes. They stay empty until a huge sum arrives, then they immediately flush that money out to a secondary destination. They aren't saving money; they are hiding its origin.
* **Conclusion:** *Many Accounts were found with a 100% outflow rate, which is a classic sign of the money laundering.*

## 3. **The "Transaction Spike"** (Account Takeover)----
**Reason Behind** I flagged accounts showing 'inhuman' speed. When an account suddenly makes 10 transfers in an hour, it’s rarely the customer—it's usually a hacker who has gained access to the app.
* **Conclusion:** These patterns suggest compromised credentials, putting many at risk of immediate loss.*


# Tools I used for this project:
* **Core Engine:** SQL Server Management Studio (SSMS)
* **Analytical Logic:** Math-based outlier detection & RBI Regulatory Frameworks.
* **Visualization:** Translating complex SQL tables into understandable conclusions.

Below is the SQL code I use to solve this problem:

/*
 * PROJECT: Financial Fraud Detection Engine
 * AUTHOR: Sonia
 * DATE: February 7, 2026
 * GOAL: Identify AML (Anti-Money Laundering) patterns using SQL Server (SSMS) 
 * on the PaySim dataset to flag high-risk transactions for investigation.
 */
-- I am looking for 'Smurfing' patterns here. 
-- Specifically, users trying to dodge the ₹50k PAN reporting limit (Rule 114B).
-- If a user does this more than 3 times, it is a major red flag for 'Structuring'.

SELECT nameOrig AS CustomerID, 
       COUNT(*) AS Number_of_Hits, 
       AVG(amount) AS Avg_Amount,
       SUM(amount) AS Total_Risk_Value
FROM PaySim
WHERE amount BETWEEN 48000 AND 49999
  AND type = 'TRANSFER'
GROUP BY nameOrig
HAVING COUNT(*) >= 3
ORDER BY Number_of_Hits DESC;

/*This above analysis flagged 79 accounts attempting to bypass Rule 114B (PAN requirement),
uncovering a total of ₹70 Lakhs in structured transactions designed to evade regulatory oversight.*/



-- This query catches 'Pass-through' or 'Mule' accounts.
-- These accounts act like a pipe: money comes in and flows out immediately.
-- Under RBI AML guidelines, these are top priority for 'Layering' investigations.

SELECT nameOrig AS Mule_Account_ID, 
       nameDest AS Next_Destination,
       amount AS Siphoned_Amount,
       oldbalanceOrg AS Start_Balance, 
       newbalanceOrig AS End_Balance
FROM PaySim
WHERE oldbalanceOrg = 0           -- Account was empty before
  AND newbalanceOrig = 0          -- Account is empty again
  AND amount > 100000             -- pay attention to high-value transfers (> 1 Lakh)
  AND type = 'TRANSFER'
ORDER BY amount DESC;

/*By identifying 'Pass-through' patterns, this query isolated 143 high-probability Money Mule accounts
that moved ₹146 Lakhs out of the system within minutes of receipt.*/


-- Checking for 'Transaction Velocity'.
-- If someone makes more than 5 transfers in 1 hour (one 'step'), 
-- It is likely an Account Takeover or a bot. 
-- I am flagging these for the real-time monitoring team to freeze the account.

SELECT nameOrig AS Flagged_Account, 
       step AS Transaction_Hour, 
       COUNT(*) AS Frequency_Per_Hour, 
       SUM(amount) AS Total_Hourly_Volume
FROM PaySim
GROUP BY nameOrig, step
HAVING COUNT(*) > 5       -- A Normal customers do not move money this fast
ORDER BY Frequency_Per_Hour DESC;

/*This velocity check caught 432 accounts with suspicious digital activity, 
Highlighting potential Account Takeovers that could have resulted in many Lakh in fraudulent losses.
