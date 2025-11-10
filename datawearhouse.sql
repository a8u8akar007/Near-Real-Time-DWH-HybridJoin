create database walmart_dw
use walmart_dw;

-------- Droping table if they exist --------

drop table if exists customer;
drop table if exists store;
drop table if exists supplier;
drop table if exists product;
drop table if exists date;
drop table if exists fact_Sales;


----------- Implementing Star Schema -------------

create table customer(
	customerid int primary key,
    gender char(1),
    age_range varchar(10),
    occupation int,
    city_category varchar(1),
    stay_years int,
    martial_status int
);

create table store(
	storeid int primary key,
    storeName varchar(100)
);

create table supplier(
	supplierid int primary key,
    supplierName varchar(100)
); 

create table product(
	productid varchar(100) primary key,
    productCategory varchar(280),
    price decimal(10,2),
    supplierid int,
    storeid int,
    foreign key (supplierid) references supplier(supplierid),
    foreign key (storeid) references store(storeid)
);

create table dateDim(
	dateid int primary key auto_increment,
    date Date,
    day int,
    month int,
    year int,
    weekday varchar(15),
    weekend_flag boolean,
    season varchar(15),
    half_year varchar(2)
);


