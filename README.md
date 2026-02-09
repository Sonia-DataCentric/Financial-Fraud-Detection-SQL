### Financial-Fraud-Detection-SQL
Detecting AML (Anti-Money Laundering) patterns and fraudulent transactions using SQL Server (SSMS).
**By Sonia| Math & Econ Background**

## Project Overview
I built this project to demonstrate how SQL can solve real-world banking challenges. Using the PaySim dataset (6M+ records), I applied **RBI compliance logic** to catch suspicious patterns that typical filters might miss.



## What I Found through my investigation :

#1. **The "Just-Under-Limit"** (Structuring)----
**Reason Behind:** I looked for customers who are clearly aware of the ₹50,000 PAN card reporting limit. By splitting a large sum into multiple ₹49,000 transfers, they attempt to move money without leaving a regulatory paper trail.
* **Conclusion:** *using this way many accounts bypassed mandatory tax reporting—a red flag for any AML team.*

#2. **Money Mules**----
**Reason Behind** I tracked 'Mule' accounts that behave like pipes. They stay empty until a huge sum arrives, then they immediately flush that money out to a secondary destination. They aren't saving money; they are hiding its origin.
* **Conclusion:** *Many Accounts were found with a 100% outflow rate, which is a classic sign of the money laundering.*

#3. **The "Transaction Spike"** (Account Takeover)----
**Reason Behind** I flagged accounts showing 'inhuman' speed. When an account suddenly makes 10 transfers in an hour, it’s rarely the customer—it's usually a hacker who has gained access to the app.
* **Conclusion:** These patterns suggest compromised credentials, putting many at risk of immediate loss.*



## Tools I used for this project:
* **Core Engine:** SQL Server Management Studio (SSMS)
* **Analytical Logic:** Math-based outlier detection & RBI Regulatory Frameworks.
* **Visualization:** Translating complex SQL tables into understandable conclusions.
