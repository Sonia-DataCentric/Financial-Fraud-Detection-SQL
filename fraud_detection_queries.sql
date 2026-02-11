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

