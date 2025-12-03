-- 03_Clinic_Schema_Setup.sql
CREATE TABLE clinics (
  cid VARCHAR(64) PRIMARY KEY,
  clinic_name VARCHAR(255),
  city VARCHAR(128),
  state VARCHAR(128),
  country VARCHAR(128)
);

CREATE TABLE customer (
  uid VARCHAR(64) PRIMARY KEY,
  name VARCHAR(255),
  mobile VARCHAR(32)
);

CREATE TABLE clinic_sales (
  oid VARCHAR(64) PRIMARY KEY,
  uid VARCHAR(64),
  cid VARCHAR(64),
  amount DECIMAL(12,2),
  datetime DATETIME,
  sales_channel VARCHAR(128),
  FOREIGN KEY (uid) REFERENCES customer(uid),
  FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
  eid VARCHAR(64) PRIMARY KEY,
  cid VARCHAR(64),
  description TEXT,
  amount DECIMAL(12,2),
  datetime DATETIME,
  FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- sample inserts
INSERT INTO clinics VALUES ('cnc-0100001','XYZ clinic','lorem','ipsum','dolor');
INSERT INTO customer VALUES ('bk-09f3e-95hj','Jon Doe','97XXXXXXXX');
INSERT INTO clinic_sales VALUES ('ord-00100-00100','bk-09f3e-95hj','cnc-0100001',24999,'2021-09-23 12:03:22','sodat');
INSERT INTO expenses VALUES ('exp-0100-00100','cnc-0100001','first-aid supplies',557,'2021-09-23 07:36:48');
