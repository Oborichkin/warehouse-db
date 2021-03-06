BEGIN;

--
-- Create model Customer
--
CREATE TABLE "wh_customer" (
    "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
    "first_name" varchar(128) NOT NULL,
    "last_name" varchar(128) NOT NULL
);

--
-- Create model Product
--
CREATE TABLE "wh_product" (
    "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" varchar(200) NOT NULL UNIQUE,
    "cost" decimal NOT NULL,
    "amount" integer unsigned NOT NULL CHECK ("amount" >= 0),
    "units" varchar(2) NOT NULL
);

--
-- Create model ProductType
--
CREATE TABLE "wh_producttype" (
    "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" varchar(200) NOT NULL UNIQUE
);

--
-- Create model SalesItem
--
CREATE TABLE "wh_salesitem" (
    "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
    "amount" integer unsigned NOT NULL CHECK ("amount" >= 0),
    "product_id" integer NOT NULL REFERENCES "wh_product" ("id") DEFERRABLE INITIALLY DEFERRED
);

--
-- Create model Transaction
--
CREATE TABLE "wh_transaction" (
    "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
    "delivery_cost" decimal NOT NULL,
    "date" datetime NOT NULL,
    "total_cost" decimal NOT NULL,
    "buyer_id" integer NOT NULL REFERENCES "wh_customer" ("id") DEFERRABLE INITIALLY DEFERRED,
    "certificate_id" integer NULL UNIQUE REFERENCES "wh_salesitem" ("id") DEFERRABLE INITIALLY DEFERRED
);

--
-- Add field transaction to salesitem
--
CREATE TABLE "new__wh_salesitem" (
    "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
    "amount" integer unsigned NOT NULL CHECK ("amount" >= 0),
    "product_id" integer NOT NULL REFERENCES "wh_product" ("id") DEFERRABLE INITIALLY DEFERRED,
    "transaction_id" integer NOT NULL REFERENCES "wh_transaction" ("id") DEFERRABLE INITIALLY DEFERRED
);

INSERT INTO
    "new__wh_salesitem" ("id", "amount", "product_id", "transaction_id")
SELECT
    "id",
    "amount",
    "product_id",
    NULL
FROM
    "wh_salesitem";

DROP TABLE "wh_salesitem";

ALTER TABLE
    "new__wh_salesitem" RENAME TO "wh_salesitem";

CREATE INDEX "wh_transaction_buyer_id_4b70a88b" ON "wh_transaction" ("buyer_id");

CREATE INDEX "wh_salesitem_product_id_c78d36c2" ON "wh_salesitem" ("product_id");

CREATE INDEX "wh_salesitem_transaction_id_31433f27" ON "wh_salesitem" ("transaction_id");

--
-- Create index wh_productt_name_81ad03_idx on field(s) name of model producttype
--
CREATE INDEX "wh_productt_name_81ad03_idx" ON "wh_producttype" ("name");

--
-- Add field type to product
--
CREATE TABLE "new__wh_product" (
    "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" varchar(200) NOT NULL UNIQUE,
    "cost" decimal NOT NULL,
    "amount" integer unsigned NOT NULL CHECK ("amount" >= 0),
    "units" varchar(2) NOT NULL,
    "type_id" integer NOT NULL REFERENCES "wh_producttype" ("id") DEFERRABLE INITIALLY DEFERRED
);

INSERT INTO
    "new__wh_product" (
        "id",
        "name",
        "cost",
        "amount",
        "units",
        "type_id"
    )
SELECT
    "id",
    "name",
    "cost",
    "amount",
    "units",
    NULL
FROM
    "wh_product";

DROP TABLE "wh_product";

ALTER TABLE
    "new__wh_product" RENAME TO "wh_product";

CREATE INDEX "wh_product_type_id_6bfe5eba" ON "wh_product" ("type_id");

--
-- Create index wh_customer_first_n_41eb34_idx on field(s) first_name, last_name of model customer
--
CREATE INDEX "wh_customer_first_n_41eb34_idx" ON "wh_customer" ("first_name", "last_name");

--
-- Create index wh_customer_last_na_445c72_idx on field(s) last_name of model customer
--
CREATE INDEX "wh_customer_last_na_445c72_idx" ON "wh_customer" ("last_name");

--
-- Create index wh_product_name_c1b2fc_idx on field(s) name of model product
--
CREATE INDEX "wh_product_name_c1b2fc_idx" ON "wh_product" ("name");

COMMIT;