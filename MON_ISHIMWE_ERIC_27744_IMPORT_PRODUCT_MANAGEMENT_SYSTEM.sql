-- CREATE TABLE IMPORTER 

CREATE TABLE Importer (
    ImporterID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    ContactInfo VARCHAR2(100),
    Country VARCHAR2(50)
);

-- CREATE TABLE PRODUCT 

CREATE TABLE Product (
    ProductID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Category VARCHAR2(50),
    Value NUMBER(10, 2) CHECK (Value >= 0),
    Quantity NUMBER CHECK (Quantity >= 0)
);

-- CREATE  TABLE TAXRATE 

CREATE TABLE TaxRate (
    TaxID NUMBER PRIMARY KEY,
    Category VARCHAR2(50) NOT NULL UNIQUE,
    RatePercentage NUMBER(5, 2) CHECK (RatePercentage >= 0 AND RatePercentage <= 100)
);

-- CREATE TABLE IMPORT TRANSICTION 
CREATE TABLE ImportTransaction (
    TransactionID NUMBER PRIMARY KEY,
    ImporterID NUMBER REFERENCES Importer(ImporterID),
    ProductID NUMBER REFERENCES Product(ProductID),
    TaxID NUMBER REFERENCES TaxRate(TaxID),
    TransactionDate DATE DEFAULT SYSDATE,
    Status VARCHAR2(20)
);

-- CREATE TABLE INVOICE 

CREATE TABLE Invoice (
    InvoiceID NUMBER PRIMARY KEY,
    TransactionID NUMBER UNIQUE REFERENCES ImportTransaction(TransactionID),
    PaymentDate DATE,
    PaymentMethod VARCHAR2(30),
    Status VARCHAR2(20)
);
 -- CREATE TABLE PAYMENT 
CREATE TABLE Payment (
    PaymentID NUMBER PRIMARY KEY,
    InvoiceID NUMBER REFERENCES Invoice(InvoiceID),
    PaymentDate DATE,
    PaymentMethod VARCHAR2(30),
    Status VARCHAR2(20)
);

-- CREATE TABLE AUDIT 

CREATE TABLE AuditLog (
    LogID NUMBER PRIMARY KEY,
    UserID VARCHAR2(50),
    Action VARCHAR2(100),
    Timestamp DATE DEFAULT SYSDATE,
    TableAffected VARCHAR2(50)
);

CREATE TABLE AuditLog (
    log_id        NUMBER GENERATED ALWAYS AS IDENTITY,
    username      VARCHAR2(30),
    operation     VARCHAR2(10),
    object_name   VARCHAR2(50),
    operation_time TIMESTAMP,
    status        VARCHAR2(20),
    reason        VARCHAR2(100)
);
-- CREATE TABLE HOLYDAY 

CREATE TABLE Holidays (
    holiday_date DATE PRIMARY KEY,
    description  VARCHAR2(100)
);



--- INSERTING DATA INTO ALL TABLE  


-- IMPORTER 
INSERT INTO Importer VALUES (1, 'Alpha Imports Ltd.', 'alpha@example.com', 'Kenya');
INSERT INTO Importer VALUES (2, 'Global Traders Inc.', 'global@example.com', 'Rwanda');
INSERT INTO Importer VALUES (3, 'East Africa Goods', 'eastafrica@example.com', 'Uganda');   

-- PRODUCT 
INSERT INTO Product VALUES (101, 'Laptop', 'Electronics', 1000.00, 50);
INSERT INTO Product VALUES (102, 'Sofa Set', 'Furniture', 1500.00, 20);
INSERT INTO Product VALUES (103, 'Refrigerator', 'Electronics', 800.00, 30);

-- TAXRATE 

INSERT INTO TaxRate VALUES (201, 'Electronics', 18.00);
INSERT INTO TaxRate VALUES (202, 'Furniture', 12.00);
 
 -- IMPORTERTRANSACTION 
 
 INSERT INTO ImportTransaction VALUES (301, 1, 101, 201, TO_DATE('2025-04-15', 'YYYY-MM-DD'), 'Cleared');
INSERT INTO ImportTransaction VALUES (302, 2, 102, 202, TO_DATE('2025-04-18', 'YYYY-MM-DD'), 'Pending');
INSERT INTO ImportTransaction VALUES (303, 1, 103, 201, TO_DATE('2025-04-22', 'YYYY-MM-DD'), 'Cleared');

-- INVOICES 

INSERT INTO Invoice VALUES (401, 301, TO_DATE('2025-04-16', 'YYYY-MM-DD'), 'Credit Card', 'Paid');
INSERT INTO Invoice VALUES (402, 302, TO_DATE('2025-04-19', 'YYYY-MM-DD'), 'Bank Transfer', 'Pending');
INSERT INTO Invoice VALUES (403, 303, TO_DATE('2025-04-23', 'YYYY-MM-DD'), 'Cash', 'Paid');


-- PAYMENT 

INSERT INTO Payment VALUES (501, 401, TO_DATE('2025-04-16', 'YYYY-MM-DD'), 'Credit Card', 'Success');
INSERT INTO Payment VALUES (502, 402, TO_DATE('2025-04-19', 'YYYY-MM-DD'), 'Bank Transfer', 'Pending');
INSERT INTO Payment VALUES (503, 403, TO_DATE('2025-04-23', 'YYYY-MM-DD'), 'Cash', 'Success');

-- AUDITLOG

INSERT INTO AuditLog VALUES (601, 'admin_user', 'INSERT INTO Importer', SYSDATE, 'Importer');
INSERT INTO AuditLog VALUES (602, 'system_audit', 'DELETE FROM Product', SYSDATE, 'Product');


-- HOLYDAY

INSERT INTO Holiday VALUES (701, TO_DATE('2025-05-01', 'YYYY-MM-DD'), 'Labor Day');
INSERT INTO Holiday VALUES (702, TO_DATE('2025-05-17', 'YYYY-MM-DD'), 'Independence Day');



---- DDML 

-- Update Importer's contact info
UPDATE Importer
SET ContactInfo = 'alpha_new@example.com'
WHERE ImporterID = 1;

-- Update the status of an import transaction
UPDATE ImportTransaction
SET Status = 'Cleared'
WHERE TransactionID = 302;

-- Update tax rate for Furniture
UPDATE TaxRate
SET RatePercentage = 15.00
WHERE Category = 'Furniture';

-- Delete a payment that was marked as pending
DELETE FROM Payment
WHERE Status = 'Pending';



--- DDL 
-- Add a new column for email in the Importer table
ALTER TABLE Importer
ADD Email VARCHAR2(100);

-- Modify the size of the Category column in the Product table
ALTER TABLE Product
MODIFY Category VARCHAR2(100);
-- Drop the AuditLog table completely
DROP TABLE AuditLog;

-- Drop a column (if supported in your Oracle version)
ALTER TABLE Importer
DROP COLUMN Email;

-- Drop a constraint (example: unique constraint from TaxRate)
ALTER TABLE TaxRate
DROP CONSTRAINT unique_category;



-- CREATING PROCEDURE IN TAX CALCULATION AND PAYMENT STATUS SUMMARY  

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

---  CREATING PROCEDURE AND PACKEGE 

CREATE OR REPLACE PACKAGE pkg_tax_summary AS
    -- Function: Calculate Tax for a product
    FUNCTION calculate_tax(p_product_id IN NUMBER) RETURN NUMBER;

    -- Procedure: Get Payment Status of a transaction
    PROCEDURE get_payment_status(p_transaction_id IN NUMBER);

    -- Procedure: Display summary for all transactions
    PROCEDURE summarize_all_transactions;

END pkg_tax_summary;
/

-- PACKEGE BODY 

CREATE OR REPLACE PACKAGE BODY pkg_tax_summary AS

    -- Function: Calculate tax based on product category and value
    FUNCTION calculate_tax(p_product_id IN NUMBER) RETURN NUMBER IS
        v_category         VARCHAR2(50);
        v_value            NUMBER;
        v_rate             NUMBER;
        v_tax              NUMBER;
    BEGIN
        -- Get product details
        SELECT category, value INTO v_category, v_value
        FROM Product
        WHERE ProductId = p_product_id;

        -- Get tax rate
        SELECT RatePercentage INTO v_rate
        FROM TaxRate
        WHERE Category = v_category;

        -- Calculate tax
        v_tax := (v_value * v_rate) / 100;
        RETURN v_tax;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Product or Tax Rate not found.');
            RETURN NULL;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error in calculate_tax: ' || SQLERRM);
            RETURN NULL;
    END calculate_tax;

    -- Procedure: Get payment status of a transaction
    PROCEDURE get_payment_status(p_transaction_id IN NUMBER) IS
        v_status VARCHAR2(20);
    BEGIN
        SELECT Status INTO v_status
        FROM Invoice
        WHERE TransactionId = p_transaction_id;

        IF v_status = 'Paid' THEN
            DBMS_OUTPUT.PUT_LINE('Payment Status: Paid');
        ELSIF v_status = 'Pending' THEN
            DBMS_OUTPUT.PUT_LINE('Payment Status: Pending');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Unknown payment status.');
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No invoice found for transaction ID ' || p_transaction_id);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in get_payment_status: ' || SQLERRM);
    END get_payment_status;

    -- Procedure: Summary for all transactions
    PROCEDURE summarize_all_transactions IS
        CURSOR trans_cur IS
            SELECT TransactionId, ProductId
            FROM ImportTransaction;

        v_tax NUMBER;
    BEGIN
        FOR rec IN trans_cur LOOP
            DBMS_OUTPUT.PUT_LINE('--- Transaction ID: ' || rec.TransactionId || ' ---');

            -- Calculate tax using function
            v_tax := calculate_tax(rec.ProductId);
            IF v_tax IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE('Calculated Tax: ' || v_tax);
            END IF;

            -- Get payment status
            get_payment_status(rec.TransactionId);
            DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in summarize_all_transactions: ' || SQLERRM);
    END summarize_all_transactions;

END pkg_tax_summary;
/

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



SET SERVEROUTPUT ON;

DECLARE
    v_tax NUMBER;
BEGIN
    v_tax := pkg_tax_summary.calculate_tax(101); -- Product: Laptop
    DBMS_OUTPUT.PUT_LINE('Tax for Laptop (Product 101): ' || v_tax);
END;
/




--- CREATE FUNCTION CALLED FN_CALCULATION_TAX 

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


-- CREATING PROCEDURE pr_get_payment_status

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
--  CREATING PACKEGE INCLUDING BOTH FUNCTION AND PROCEDURE 

CREATE OR REPLACE PACKAGE pkg_tax_mgmt AS
    FUNCTION calculate_tax(p_product_id IN NUMBER) RETURN NUMBER;
    PROCEDURE get_payment_status(p_transaction_id IN NUMBER);
    PROCEDURE full_summary;
END pkg_tax_mgmt;
/

-- PACKEGE BODY 

CREATE OR REPLACE PACKAGE BODY pkg_tax_mgmt AS

    -- Function to calculate tax
    FUNCTION calculate_tax(p_product_id IN NUMBER) RETURN NUMBER IS
        v_category VARCHAR2(50);
        v_value    NUMBER;
        v_rate     NUMBER;
        v_tax      NUMBER;
    BEGIN
        SELECT category, value INTO v_category, v_value
        FROM Product
        WHERE productId = p_product_id;

        SELECT ratePercentage INTO v_rate
        FROM TaxRate
        WHERE category = v_category;

        v_tax := (v_value * v_rate) / 100;
        RETURN v_tax;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Product or tax rate not found.');
            RETURN NULL;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in calculate_tax: ' || SQLERRM);
            RETURN NULL;
    END calculate_tax;

    -- Procedure to get payment status
    PROCEDURE get_payment_status(p_transaction_id IN NUMBER) IS
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
            DBMS_OUTPUT.PUT_LINE('Error in get_payment_status: ' || SQLERRM);
    END get_payment_status;

    -- Procedure for full summary
    PROCEDURE full_summary IS
        CURSOR c_trans IS
            SELECT transactionId, productId FROM ImportTransaction;
        v_tax NUMBER;
    BEGIN
        FOR rec IN c_trans LOOP
            DBMS_OUTPUT.PUT_LINE('--- Transaction ID: ' || rec.transactionId || ' ---');

            v_tax := calculate_tax(rec.productId);
            IF v_tax IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE('Calculated Tax: ' || v_tax);
            END IF;

            get_payment_status(rec.transactionId);
            DBMS_OUTPUT.PUT_LINE('-----------------------------------');
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in full_summary: ' || SQLERRM);
    END full_summary;

END pkg_tax_mgmt;
/

-- CALLING PACKEGES 

-- Call Function
DECLARE
    v_tax NUMBER;
BEGIN
    v_tax := pkg_tax_mgmt.calculate_tax(101);
    DBMS_OUTPUT.PUT_LINE('Tax: ' || v_tax);
END;
/

-- Call Payment Status
BEGIN
    pkg_tax_mgmt.get_payment_status(201);
END;
/

-- Call Full Summary
BEGIN
    pkg_tax_mgmt.full_summary;
END;
/



--- Trigger to Restrict Data Changes on Weekdays & Holidays    

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

---  Package with Function and Procedure (Recap)


-- Package Spec
CREATE OR REPLACE PACKAGE tax_pkg IS
    FUNCTION calculate_tax(p_product_id IN NUMBER) RETURN NUMBER;
    PROCEDURE get_payment_status(p_transaction_id IN NUMBER);
END tax_pkg;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY tax_pkg IS

    FUNCTION calculate_tax(p_product_id IN NUMBER) RETURN NUMBER IS
        v_category VARCHAR2(50);
        v_value    NUMBER;
        v_rate     NUMBER;
        v_tax      NUMBER;
    BEGIN
        SELECT category, value INTO v_category, v_value
        FROM Product
        WHERE productId = p_product_id;

        SELECT ratePercentage INTO v_rate
        FROM TaxRate
        WHERE category = v_category;

        v_tax := (v_value * v_rate) / 100;
        RETURN v_tax;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;

    PROCEDURE get_payment_status(p_transaction_id IN NUMBER) IS
        v_status VARCHAR2(20);
    BEGIN
        SELECT status INTO v_status
        FROM Invoice
        WHERE transactionId = p_transaction_id;

        DBMS_OUTPUT.PUT_LINE('Payment Status: ' || v_status);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Transaction not found.');
    END;

END tax_pkg;
/

-- Try to modify Product on weekday or holiday
BEGIN
    UPDATE Product
    SET value = value + 100
    WHERE productId = 1;
END;
/

-- Check audit log
SELECT * FROM AuditLog ORDER BY operation_time DESC;

-- Run tax calculation and payment status





CREATE OR REPLACE PACKAGE tax_pkg IS
    FUNCTION calculate_tax(p_product_id IN NUMBER) RETURN NUMBER;
    PROCEDURE show_payment_status(p_transaction_id IN NUMBER);
END tax_pkg;
/

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

-- Anonymous block to test
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






