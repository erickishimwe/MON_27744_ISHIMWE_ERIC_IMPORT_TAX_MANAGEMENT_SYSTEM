
📦 Import Product Tax Management System.


This project is a PL/SQL-based database solution designed to streamline the management of import product taxes. The system addresses common issues in manual tax handling such as errors, delays, and compliance challenges faced by customs agencies, import/export businesses, and tax authorities.


❗ Problem Statement


Import tax management is traditionally handled through manual processes, which are prone to errors, delays, and inefficiencies. Businesses and customs authorities face difficulties in accurately calculating duties, applying the correct tax rates, and ensuring timely compliance with trade regulations. These issues can lead to financial penalties, shipment delays, and a lack of transparency.


The Import Product Tax Management System aims to address these challenges by automating the workflow for tax calculations, transaction tracking, payment processing, and audit logging—ensuring a more reliable, efficient, and compliant import tax process.

🔍 Problem Definition

The process of managing import taxes is often manual, fragmented, and error-prone. Businesses and government agencies face numerous challenges such as:Inaccurate calculation of taxes based on product type and valuE,Difficulty maintaining organized records of importers, transactions, and payments Delays in tax payment and clearance processes due to inefficient tracking ,Limited transparency and accountability during audits and compliance check

🚀 PROJECT OBJECTIVES:
- Automated Tax Calculations based on product category and value.
- Importer and Transaction Management to track histories and ensure traceability.
- Invoice and Payment Tracking to support timely and accurate financial records.
- Audit Logging for transparency and accountability.
- Holiday Logic Integration to manage restricted dates in tax processes.


 🧩 Business Process Model (BPM)

 
The diagram below illustrates the core workflow of the Import Product Tax Management System, from product entry and tax calculation to payment processing and audit logging. It highlights the interactions between key entities such as importers, tax authorities, and system components.

![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/38936323934a3a0abbf487a7e66a059e84c1eb72/bpm.PNG) 


📌 System UML

The Import Product Tax Management System is designed to streamline and automate the management of import-related taxes. It captures key processes including importer registration, product classification, tax rate assignment, transaction processing, invoice generation, payment tracking, and audit logging. The UML diagram below provides a visual overview of the system’s structure and the interaction between its core components.
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/f7e9750aeb59097ecf3135ab9a41a820b85dcf08/capture.png) 

🗂️ Entity-Relationship Diagram (ERD):


The ERD below outlines the database structure of the Import Product Tax Management System. It shows the relationships between key entities such as Importers, Products, Taxes, Transactions, Invoices, and Payments, providing a clear view of how data is organized and interconnected within the system.

![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/38936323934a3a0abbf487a7e66a059e84c1eb72/erd.PNG) 


CREATE TABLE IMPORTER 
```sql
CREATE TABLE Importer (
    ImporterID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    ContactInfo VARCHAR2(100),
    Country VARCHAR2(50)
);
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/46935c6fe186ab07bdb52d78f504a3890b6fa99a/import.png) 

CREATE TABLE PRODUCT 
```sql
CREATE TABLE Product (
    ProductID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Category VARCHAR2(50),
    Value NUMBER(10, 2) CHECK (Value >= 0),
    Quantity NUMBER CHECK (Quantity >= 0)
);
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/175fc34c1c94f8c51dc5cce6f6a13782806bc75b/product.png)

CREATE  TABLE TAXRATE 
```sql 
CREATE TABLE TaxRate (
    TaxID NUMBER PRIMARY KEY,
    Category VARCHAR2(50) NOT NULL UNIQUE,
    RatePercentage NUMBER(5, 2) CHECK (RatePercentage >= 0 AND RatePercentage <= 100)
);


```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/175fc34c1c94f8c51dc5cce6f6a13782806bc75b/TaxRate.png)

CREATE TABLE IMPORT TRANSICTION 

```sql
CREATE TABLE ImportTransaction (
    TransactionID NUMBER PRIMARY KEY,
    ImporterID NUMBER REFERENCES Importer(ImporterID),
    ProductID NUMBER REFERENCES Product(ProductID),
    TaxID NUMBER REFERENCES TaxRate(TaxID),
    TransactionDate DATE DEFAULT SYSDATE,
    Status VARCHAR2(20)
);
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/175fc34c1c94f8c51dc5cce6f6a13782806bc75b/import%20Transaction.png)

 CREATE TABLE INVOICE 

 
```sql
CREATE TABLE Invoice (
    InvoiceID NUMBER PRIMARY KEY,
    TransactionID NUMBER UNIQUE REFERENCES ImportTransaction(TransactionID),
    PaymentDate DATE,
    PaymentMethod VARCHAR2(30),
    Status VARCHAR2(20)
);
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/0e88d7f8ab1fee45dd389ff8c42e92df576a1f3d/invoice.png).

 CREATE TABLE PAYMENT 

 
 ```sql

CREATE TABLE Payment (
    PaymentID NUMBER PRIMARY KEY,
    InvoiceID NUMBER REFERENCES Invoice(InvoiceID),
    PaymentDate DATE,
    PaymentMethod VARCHAR2(30),
    Status VARCHAR2(20)
);
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/175fc34c1c94f8c51dc5cce6f6a13782806bc75b/payment.png)

CREATE TABLE AUDIT 


```sql
CREATE TABLE AuditLog (
    LogID NUMBER PRIMARY KEY,
    UserID VARCHAR2(50),
    Action VARCHAR2(100),
    Timestamp DATE DEFAULT SYSDATE,
    TableAffected VARCHAR2(50)
);
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/175fc34c1c94f8c51dc5cce6f6a13782806bc75b/AuditLog.png)


INSERTING DATA INTO ALL TABLE 
```sql 


-- IMPORTER 
INSERT INTO Importer VALUES (1, 'Alpha Imports Ltd.', 'alpha@example.com', 'Kenya');
INSERT INTO Importer VALUES (2, 'Global Traders Inc.', 'global@example.com', 'Rwanda');
INSERT INTO Importer VALUES (3, 'East Africa Goods', 'eastafrica@example.com', 'Uganda');   
```
-- PRODUCT 
```sql
INSERT INTO Product VALUES (101, 'Laptop', 'Electronics', 1000.00, 50);
INSERT INTO Product VALUES (102, 'Sofa Set', 'Furniture', 1500.00, 20);
INSERT INTO Product VALUES (103, 'Refrigerator', 'Electronics', 800.00, 30);
```
-- TAXRATE 
``` sql
INSERT INTO TaxRate VALUES (201, 'Electronics', 18.00);
INSERT INTO TaxRate VALUES (202, 'Furniture', 12.00);
 ```

 IMPORTERTRANSACTION 
 ```sql 
 INSERT INTO ImportTransaction VALUES (301, 1, 101, 201, TO_DATE('2025-04-15', 'YYYY-MM-DD'), 'Cleared');
INSERT INTO ImportTransaction VALUES (302, 2, 102, 202, TO_DATE('2025-04-18', 'YYYY-MM-DD'), 'Pending');
INSERT INTO ImportTransaction VALUES (303, 1, 103, 201, TO_DATE('2025-04-22', 'YYYY-MM-DD'), 'Cleared');
```
INVOICES 
```sql
INSERT INTO Invoice VALUES (401, 301, TO_DATE('2025-04-16', 'YYYY-MM-DD'), 'Credit Card', 'Paid');
INSERT INTO Invoice VALUES (402, 302, TO_DATE('2025-04-19', 'YYYY-MM-DD'), 'Bank Transfer', 'Pending');
INSERT INTO Invoice VALUES (403, 303, TO_DATE('2025-04-23', 'YYYY-MM-DD'), 'Cash', 'Paid');

```
PAYMENT 
```sql 
INSERT INTO Payment VALUES (501, 401, TO_DATE('2025-04-16', 'YYYY-MM-DD'), 'Credit Card', 'Success');
INSERT INTO Payment VALUES (502, 402, TO_DATE('2025-04-19', 'YYYY-MM-DD'), 'Bank Transfer', 'Pending');
INSERT INTO Payment VALUES (503, 403, TO_DATE('2025-04-23', 'YYYY-MM-DD'), 'Cash', 'Success');
```
AUDITLOG
``` sql
INSERT INTO AuditLog VALUES (601, 'admin_user', 'INSERT INTO Importer', SYSDATE, 'Importer');
INSERT INTO AuditLog VALUES (602, 'system_audit', 'DELETE FROM Product', SYSDATE, 'Product');
```

HOLYDAY
```sql 
INSERT INTO Holiday VALUES (701, TO_DATE('2025-05-01', 'YYYY-MM-DD'), 'Labor Day');
INSERT INTO Holiday VALUES (702, TO_DATE('2025-05-17', 'YYYY-MM-DD'), 'Independence Day');
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/0e88d7f8ab1fee45dd389ff8c42e92df576a1f3d/insert%201.png)


DML (DATA MANIPUATION LANGUAGE )

Update Importer's contact info


```sql
UPDATE Importer
SET ContactInfo = 'alpha_new@example.com'
WHERE ImporterID = 1;
```

Update the status of an import transaction


```sql 
UPDATE ImportTransaction
SET Status = 'Cleared'
WHERE TransactionID = 302;
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/0e88d7f8ab1fee45dd389ff8c42e92df576a1f3d/DDML.png)



Update tax rate for Furniture


``` sql 
UPDATE TaxRate
SET RatePercentage = 15.00
WHERE Category = 'Furniture';
```

Delete a payment that was marked as pending


```SQL

DELETE FROM Payment
WHERE Status = 'Pending';
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/0e88d7f8ab1fee45dd389ff8c42e92df576a1f3d/DDL.png)



 DDL (DATA DEFINITION LANGUAGE).
 Add a new column for email in the Importer table
 
```sql
ALTER TABLE Importer
ADD Email VARCHAR2(100);
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/0e88d7f8ab1fee45dd389ff8c42e92df576a1f3d/DDL.png)


 CREATING PROCEDURE IN TAX CALCULATION AND PAYMENT STATUS SUMMARY  

 
```sqL
CREATE OR REPLACE PROCEDURE get_importer_transactions (
    p_importer_id IN NUMBER
)
IS
    -- Define a cursor to fetch transactions for a specific importer
    CURSOR trans_cur IS
        SELECT 
            t.TransactionID,
            p.Name AS ProductName,
            p.Value,
            tr.RatePercentage,
            (p.Value * tr.RatePercentage / 100) AS TaxAmount,
            t.Status
        FROM 
            ImportTransaction t
            JOIN Product p ON t.ProductID = p.ProductID
            JOIN TaxRate tr ON t.TaxID = tr.TaxID
        WHERE 
            t.ImporterID = p_importer_id;

    -- Define a record variable to hold each row returned by the cursor
    trans_row trans_cur%ROWTYPE;

    -- Exception for no data found
    no_transactions EXCEPTION;
    PRAGMA EXCEPTION_INIT(no_transactions, -1403);

    v_found BOOLEAN := FALSE;

BEGIN
    OPEN trans_cur;
    LOOP
        FETCH trans_cur INTO trans_row;
        EXIT WHEN trans_cur%NOTFOUND;

        v_found := TRUE;

        DBMS_OUTPUT.PUT_LINE('Transaction ID: ' || trans_row.TransactionID);
        DBMS_OUTPUT.PUT_LINE('Product: ' || trans_row.ProductName);
        DBMS_OUTPUT.PUT_LINE('Value: $' || trans_row.Value);
        DBMS_OUTPUT.PUT_LINE('Tax Rate: ' || trans_row.RatePercentage || '%');
        DBMS_OUTPUT.PUT_LINE('Tax Amount: $' || trans_row.TaxAmount);
        DBMS_OUTPUT.PUT_LINE('Status: ' || trans_row.Status);
        DBMS_OUTPUT.PUT_LINE('----------------------------------');
    END LOOP;

    IF NOT v_found THEN
        RAISE no_transactions;
    END IF;

    CLOSE trans_cur;

EXCEPTION
    WHEN no_transactions THEN
        DBMS_OUTPUT.PUT_LINE('No transactions found for Importer ID ' || p_importer_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
```

CREATING PROCEDURE AND PACKEGE 


```sql 
CREATE OR REPLACE PACKAGE pkg_tax_summary AS
    -- Function: Calculate Tax for a product
    FUNCTION calculate_tax(p_product_id IN NUMBER) RETURN NUMBER;

    -- Procedure: Get Payment Status of a transaction
    PROCEDURE get_payment_status(p_transaction_id IN NUMBER);

    -- Procedure: Display summary for all transactions
    PROCEDURE summarize_all_transactions;

END pkg_tax_summary;
/
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/0e88d7f8ab1fee45dd389ff8c42e92df576a1f3d/DDL.png)


```SQL


SET SERVEROUTPUT ON;
DECLARE
    v_tax NUMBER;
BEGIN
    v_tax := pkg_tax_summary.calculate_tax(101); -- Replace 101 with actual ProductId
    DBMS_OUTPUT.PUT_LINE('Tax: ' || v_tax);
END;
/
BEGIN
    pkg_tax_summary.get_payment_status(201); -- Replace 201 with actual TransactionId
END;
/
BEGIN
    pkg_tax_summary.summarize_all_transactions;
END;
/

```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/0e88d7f8ab1fee45dd389ff8c42e92df576a1f3d/DDL.png)


```SQL 
SET SERVEROUTPUT ON;

DECLARE
    v_tax NUMBER;
BEGIN
    v_tax := pkg_tax_summary.calculate_tax(101); -- Product: Laptop
    DBMS_OUTPUT.PUT_LINE('Tax for Laptop (Product 101): ' || v_tax);
END;
/
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/ede90ad1e2434ecc750d1a0a2b146e244d81fd8c/procedure%203.png)


 CREATE FUNCTION CALLED FN_CALCULATION_TAX 
```SQL 
CREATE OR REPLACE FUNCTION fn_calculate_tax(p_product_id IN NUMBER) RETURN NUMBER IS
    v_category VARCHAR2(50);
    v_value    NUMBER;
    v_rate     NUMBER;
    v_tax      NUMBER;
BEGIN
    -- Fetch product category and value
    SELECT category, value INTO v_category, v_value
    FROM Product
    WHERE productId = p_product_id;

    -- Fetch tax rate for the category
    SELECT ratePercentage INTO v_rate
    FROM TaxRate
    WHERE category = v_category;

    -- Calculate tax
    v_tax := (v_value * v_rate) / 100;
    RETURN v_tax;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Product or tax rate not found.');
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in fn_calculate_tax: ' || SQLERRM);
        RETURN NULL;
END;
/
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/ede90ad1e2434ecc750d1a0a2b146e244d81fd8c/procedure%20%26%20package%20.png)

CREATING PROCEDURE pr_get_payment_status



```SQL
CREATE OR REPLACE PROCEDURE pr_get_payment_status(p_transaction_id IN NUMBER) IS
    v_status VARCHAR2(20);
BEGIN
    SELECT status INTO v_status
    FROM Invoice
    WHERE transactionId = p_transaction_id;

    DBMS_OUTPUT.PUT_LINE('Payment Status: ' || v_status);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invoice not found for transaction ID ' || p_transaction_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in pr_get_payment_status: ' || SQLERRM);
END;
/
```

![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/adb7cb7b89d23651177a378798185c6bcb083537/procedure%202.png)


CALLING PACKEGES 

##Call Function
```sql
DECLARE
    v_tax NUMBER;
BEGIN
    v_tax := pkg_tax_mgmt.calculate_tax(101);
    DBMS_OUTPUT.PUT_LINE('Tax: ' || v_tax);
END;
/
```
![Conceptual Diagram](https://github.com/JeanRomeo250/Thus_27671_NUWOKWOKWIZERWA_IMPORT_PRODUCT_TAX_MANAGEMENT_SYSTEM/blob/96ab61e5413e51af95465febb3b821dfaf2a6f73/call%20%20function%20well.PNG)

Call Payment Status
```sql
BEGIN
    pkg_tax_mgmt.get_payment_status(201);
END;
/

```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/adb7cb7b89d23651177a378798185c6bcb083537/procedure%203.png)

Call Full Summary
```sql
BEGIN
    pkg_tax_mgmt.full_summary;
END;
/
```
![Conceptual Diagram](https://github.com/JeanRomeo250/Thus_27671_NUWOKWOKWIZERWA_IMPORT_PRODUCT_TAX_MANAGEMENT_SYSTEM/blob/952c25e975f15b819281fecaf8624d78e7b89030/trigger%20new.PNG)




Trigger to Restrict Data Changes on Weekdays & Holidays    
```sql
CREATE OR REPLACE TRIGGER trg_restrict_modification
BEFORE INSERT OR UPDATE OR DELETE ON Product
FOR EACH ROW
DECLARE
    v_day      VARCHAR2(10);
    v_count    NUMBER;
BEGIN
    -- Get current day of the week
    SELECT TO_CHAR(SYSDATE, 'DAY') INTO v_day FROM dual;

    -- Check if today is a holiday
    SELECT COUNT(*) INTO v_count
    FROM Holidays
    WHERE TRUNC(holiday_date) = TRUNC(SYSDATE);

    IF v_day IN ('MONDAY   ', 'TUESDAY  ', 'WEDNESDAY', 'THURSDAY ', 'FRIDAY   ') OR v_count > 0 THEN
        -- Log attempt
        INSERT INTO AuditLog(username, operation, object_name, operation_time, status, reason)
        VALUES (USER, ORA_SYSEVENT, 'Product', SYSTIMESTAMP, 'BLOCKED', 'Modification not allowed on weekday or holiday');

        RAISE_APPLICATION_ERROR(-20001, 'Modifications are restricted on weekdays and holidays.');
    ELSE
        -- Log allowed action
        INSERT INTO AuditLog(username, operation, object_name, operation_time, status, reason)
        VALUES (USER, ORA_SYSEVENT, 'Product', SYSTIMESTAMP, 'ALLOWED', 'Modification allowed');
    END IF;
END;
/
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/adb7cb7b89d23651177a378798185c6bcb083537/Trigger.png)




CREATING PACKAGE OF PROCUDURE AND FUNCTION 
``` SQL
CREATE OR REPLACE PACKAGE tax_pkg IS
    FUNCTION calculate_tax(p_product_id IN NUMBER) RETURN NUMBER;
    PROCEDURE show_payment_status(p_transaction_id IN NUMBER);
END tax_pkg;
/
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/ede90ad1e2434ecc750d1a0a2b146e244d81fd8c/procedure%203.png)

CREATING PACKAGE BOY FOR CALLING 
``` sql  
CREATE OR REPLACE PACKAGE BODY tax_pkg IS

    FUNCTION calculate_tax(p_product_id IN NUMBER) RETURN NUMBER IS
        v_category Product.category%TYPE;
        v_value    Product.value%TYPE;
        v_rate     TaxRate.ratePercentage%TYPE;
        v_tax      NUMBER := 0;
    BEGIN
        -- Get product category and value
        SELECT category, value
        INTO v_category, v_value
        FROM Product
        WHERE productId = p_product_id;

        -- Get tax rate based on category
        SELECT ratePercentage
        INTO v_rate
        FROM TaxRate
        WHERE category = v_category;

        -- Calculate tax
        v_tax := (v_value * v_rate) / 100;
        RETURN v_tax;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Product or Tax rate not found.');
            RETURN NULL;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
            RETURN NULL;
    END calculate_tax;

    PROCEDURE show_payment_status(p_transaction_id IN NUMBER) IS
        v_status Invoice.status%TYPE;
    BEGIN
        SELECT status
        INTO v_status
        FROM Invoice
        WHERE transactionId = p_transaction_id;

        DBMS_OUTPUT.PUT_LINE('Payment Status: ' || v_status);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Invoice not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
    END show_payment_status;

END tax_pkg;
/
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/adb7cb7b89d23651177a378798185c6bcb083537/procedure%20%26%20package%20.png)



Anonymous block to test
```sql 
DECLARE
    v_tax NUMBER;
BEGIN
    -- Call the function to calculate tax
    v_tax := tax_pkg.calculate_tax(1);
    DBMS_OUTPUT.PUT_LINE('Calculated Tax: ' || v_tax);

    -- Call the procedure to display payment status
    tax_pkg.show_payment_status(101);
END;
/
```
![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/adb7cb7b89d23651177a378798185c6bcb083537/procedure%203.png)

*Oracle Enterprise Manager (OEM)
is Oracle’s main tool for monitoring, managing, and tuning Oracle databases and servers.


![Conceptual Diagram](https://github.com/erickishimwe/MON_27744_ISHIMWE_ERIC_IMPORT_TAX_MANAGEMENT_SYSTEM/blob/2d53030833bbc48399987ce0850fe7a41da3e1bd/file.png)








