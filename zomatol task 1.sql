create database zomato;
use zomato;
SELECT * FROM zomato.zomato;

-- Creating Staging Tables
-- 1. Staging table for main restaurant data
create table stg_main as
select *
from zomato;

-- 2. Staging table for countries
create table stg_country as
select distinct CountryCode, NameCountry
from zomato
where NameCountry is not null;

-- 3. Staging table for currency
create table stg_currency as
select distinct Currency
from zomato
where Currency is not null;

-- 4. Staging table for dates
create table stg_date as
select distinct Year_Opening, Month_Opening
from zomato
where Year_Opening is not null and Month_Opening is not null;

-- Clean Field Types in Staging
alter table stg_main
modify column Year_Opening int,
modify column Month_Opening int,
modify column Average_Cost_for_two decimal(10,2),
modify column rating decimal(3,2);

-- Create Production Tables
create table resturants(
      RestaurantID int auto_increment primary key,
      RestaurantName varchar(255),
      CountryCode int,
      City varchar(100),
      Address text,
      Locality varchar(150),
      Cuisines varchar(500),
      Average_Cost_for_two decimal(10,2),
      Currency varchar(50),
      Rating decimal(3,2),
      Votes int,
      Year_Opening int,
      Month_Opening int
);

-- Countries
create table countries (
      CountryCode int auto_increment primary key,
      NameCountry varchar(100)
);

-- Currencies
create table currencies (
	CountryCode int auto_increment primary key,
    Currency varchar(50)
);

-- Insert Countries
insert into countries(NameCountry)
select distinct NameCountry
from stg_country;

-- Insert Currencies
insert into currencies (Currency)
select distinct Currency
from stg_currency;

-- Insert Restaurant data
CREATE TABLE restaurants (
  RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
  RestaurantName VARCHAR(255),
  CountryCode VARCHAR(10),
  NameCountry VARCHAR(100),
  City VARCHAR(100),
  Address TEXT,
  Locality VARCHAR(150),
  Cuisines VARCHAR(500),
  Votes INT,
  Average_Cost_for_two DECIMAL(10,2),
  Year_Opening INT,
  Month_Opening INT
);

INSERT INTO resturants (
    RestaurantName, CountryCode, City, Address, Locality, Cuisines,
    Average_Cost_for_two, Currency, Rating, Votes, Year_Opening, Month_Opening
)
SELECT 
    s.RestaurantName,
    sc.CountryCode,
    s.City,
    s.Address,
    s.Locality,
    s.Cuisines,
    CAST(s.Average_Cost_for_two AS DECIMAL(10,2)),
    s.Currency,
    CAST(s.Rating AS DECIMAL(3,2)),
    s.Votes,
    CAST(s.Year_Opening AS SIGNED),
    CAST(s.Month_Opening AS SIGNED)
FROM stg_main s
JOIN stg_country sc 
    ON s.CountryCode = sc.CountryCode;

-- select count(*) from resturants;
-- select count(*) from countries;
-- select count(*) from currencies;
-- select * from resturants limit 5;





















    







      



















