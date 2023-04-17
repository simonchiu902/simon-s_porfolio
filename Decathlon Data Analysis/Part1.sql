--make sure the code can run multiple times by droping tables
DROP TABLE IF EXISTS "Transaction Detail";
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS temp_transaction_detail;
--create test tables (this part is just for clearer demonstration, not necessary)
CREATE TABLE "Transaction Detail" (
    the_transaction_id SERIAL PRIMARY KEY,
    the_date_transaction DATE,
    sku_idr_sku INTEGER,
    but_name_business_unit VARCHAR(50),
    ctm_customer_id VARCHAR(50),
    the_to_type VARCHAR(10),
    f_qty_item INTEGER,
    f_to_tax_in INTEGER
);

INSERT INTO "Transaction Detail" (the_date_transaction, sku_idr_sku, but_name_business_unit, ctm_customer_id, the_to_type, f_qty_item, f_to_tax_in)
VALUES 
    ('2022-01-01', 1001, 'Store A', '1234567890', 'in-store', 2, 100),
    ('2022-01-02', 1002, 'Store B', '2345678901', 'in-store', 1, 50),
    ('2022-01-03', 1003, 'Store C', 'NA', 'in-store', 3, 200),
    ('2022-01-04', 1004, 'Website', '3456789012', 'online', 2, 150),
    ('2022-01-05', 1005, 'Website', 'NA', 'online', 1, 75);

CREATE TABLE Customer (
    loyalty_card_num VARCHAR(50) PRIMARY KEY,
    Birthdate DATE
);

INSERT INTO Customer (loyalty_card_num, Birthdate)
VALUES 
    ('1234567890', '2000-01-01'),
    ('2345678901', '1990-02-01'),
    ('3456789012', '1980-03-01'),
    ('4567890123', NULL);

--my answer for part1 is below
--If ctm_customer_id cannot match with loyalty_card_num, then the birthdate, age and age_range will be null
CREATE TEMP TABLE temp_transaction_detail AS
SELECT td.*, c.birthdate AS birthdate, 
	DATE_PART('year', CURRENT_DATE) - DATE_PART('year', birthdate) AS age,
    CASE 
		WHEN birthdate IS NULL THEN NULL
        WHEN DATE_PART('year', CURRENT_DATE) - DATE_PART('year', c.Birthdate) < 20 THEN 'Teens'
        WHEN DATE_PART('year', CURRENT_DATE) - DATE_PART('year', c.Birthdate) >= 20 AND DATE_PART('year', CURRENT_DATE) - DATE_PART('year', c.Birthdate) < 40 THEN 'Young Adults'
        WHEN DATE_PART('year', CURRENT_DATE) - DATE_PART('year', c.Birthdate) >= 40 AND DATE_PART('year', CURRENT_DATE) - DATE_PART('year', c.Birthdate) < 60 THEN 'Adults'
        ELSE 'Seniors'
    END AS age_range
FROM "Transaction Detail" td
LEFT JOIN Customer c ON td.ctm_customer_id = c.loyalty_card_num;



--view temp_transaction_detail
SELECT *
FROM temp_transaction_detail;
