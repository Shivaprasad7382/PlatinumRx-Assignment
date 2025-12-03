-- 01_Hotel_Schema_Setup.sql
-- Create tables for Hotel Management System

CREATE TABLE users (
  user_id VARCHAR(64) PRIMARY KEY,
  name VARCHAR(255),
  phone_number VARCHAR(32),
  mail_id VARCHAR(255),
  billing_address TEXT
);

CREATE TABLE bookings (
  booking_id VARCHAR(64) PRIMARY KEY,
  booking_date DATETIME,
  room_no VARCHAR(64),
  user_id VARCHAR(64),
  FOREIGN KEY(user_id) REFERENCES users(user_id)
);

CREATE TABLE items (
  item_id VARCHAR(64) PRIMARY KEY,
  item_name VARCHAR(255),
  item_rate DECIMAL(10,2)
);

CREATE TABLE booking_commercials (
  id VARCHAR(64) PRIMARY KEY,
  booking_id VARCHAR(64),
  bill_id VARCHAR(64),
  bill_date DATETIME,
  item_id VARCHAR(64),
  item_quantity DECIMAL(10,3),
  FOREIGN KEY(booking_id) REFERENCES bookings(booking_id),
  FOREIGN KEY(item_id) REFERENCES items(item_id)
);

-- Example INSERTs (use to test queries)
INSERT INTO users VALUES
('21wrcxuy-67erfn','John Doe','97XXXXXXXX','john.doe@example.com','XX, Street Y, ABC City');

INSERT INTO bookings VALUES
('bk-09f3e-95hj','2021-09-23 07:36:48','rm-bhf9-aerjn','21wrcxuy-67erfn');

INSERT INTO items VALUES
('itm-a9e8-q8fu','Tawa Paratha',18.00),
('itm-a07vh-aer8','Mix Veg',89.00);

INSERT INTO booking_commercials VALUES
('q34r-3q4o8-q34u','bk-09f3e-95hj','bl-0a87y-q340','2021-09-23 12:03:22','itm-a9e8-q8fu',3),
('q3o4-ahf32-o2u4','bk-09f3e-95hj','bl-0a87y-q340','2021-09-23 12:03:22','itm-a07vh-aer8',1);
