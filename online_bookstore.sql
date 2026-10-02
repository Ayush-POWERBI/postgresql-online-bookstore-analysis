/*
=========================================
   ONLINE BOOKS STORE DATABASE PROJECT
=========================================   
*/  

--CREATE DATABASE 
 CREATE DATABASE onlinebookstore;

--SWITCH TO THE DATABASE 
\c onlinebookstore;

--CREATE TABLES
 DROP TABLE IF  EXISTS Books;
--Books
 CREATE TABLE Books (
  "Books_id" SERIAL PRIMARY KEY,
  "Title" VARCHAR(100),
  "Author" VARCHAR(100),
  "Genre" VARCHAR(50),
  "Published_Year" INT,
  "Price" NUMERIC(10,2),
  "Stock" INT 
);

--Customers
 DROP TABLE IF EXISTS Customers

 CREATE TABLE Customers(
  "Customer_ID" SERIAL PRIMARY KEY,
  "Name" VARCHAR(100),
  "Email" VARCHAR(100),
  "Phone" VARCHAR(15),
  "City" VARCHAR(50),
  "Country" VARCHAR(150)
);  

--Orders
 DROP TABLE IF EXISTS Orders

 CREATE TABLE Orders(
  "Order_ID" SERIAL PRIMARY KEY,
  "Customer_ID" INT REFERENCES Customers("Customer_ID"),
  "Book_ID" INT REFERENCES Books("Books_id"),
  "Order_Date" DATE,
  "Quantity" INT,
  "Total_Amount" NUMERIC (10,2)
);  

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

/*
==============================================================================
 onlineBookStore Database Project
 Dataset (Books,Customers,Orders) were sourced from CSV files and suucessfully 
 loaded into postgreSQL for data cleaning,transformation and business analysis.

 DATA IMPORT MEHTHOD: Direct Data Load 
============================================================================== 
*/ 

===============================
--ANALTICS & REPORTING QUERIES 
=============================== 

--1) Retrieve all books in the "Fiction" genre:
  SELECT * FROM Books
  WHERE "Genre" = 'Fiction';

--2) Find books Published after the year 1950:
  SELECT * FROM Books 
  WHERE "Published_Year" > 1950;

--3) List all Customers from the Canada:
 SELECT * FROM Customers
 WHERE "Country" = 'Canada'; 

--4) Show Order placed in November 2023:
 SELECT * FROM Orders 
 WHERE "Order_Date" BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the Total Stock of books available:
 SELECT SUM("Stock") as "Total_stock"
 from Books;

--6) Find the detail of most Expensive book:
 SELECT * FROM Books as Expensive_book
 ORDER BY "Price" DESC
 LIMIT 1;

--7)Show all customers who ordered more than 1 Quantity of book:
 SELECT * FROM Orders
 WHERE "Quantity" > 1;

--8)Retrieve all orders where the Total_Amount exceeds $20;
 SELECT * FROM Orders
 WHERE "Total_Amount" > 20;

--9)List all the Genre Avialble in the books table:
 SELECT DISTINCT "Genre" FROM Books;

--10)Find the Books with the Lowest Stock:
 SELECT * FROM Books ORDER BY "Stock" ASC;

--11)Calculate the Total generated from all Orders:
 SELECT SUM("Total_Amount")
 AS "Revenue" FROM Orders;

=====================
--ADVANCE QUERIES 
=====================

--1) Retrieve the Total Number of Books sold for each Genre:
 SELECT B."Genre",
 SUM (O."Quantity") AS "Total_Books_Sold"
 FROM Orders O
 JOIN 
 Books B
 ON O."Book_ID" = B."Books_id"
 GROUP BY B."Genre";

--2) Find the Average Price of books in the "FANTASY" Genre:
  SELECT AVG("Price") AS Average_Price 
  FROM Books
  WHERE "Genre" = 'Fantasy';

--3) List Customers who have placed at least 2 Orders:
  SELECT  C."Name",
  O."Customer_ID",COUNT(O."Order_ID") as "Order_Count"
  FROM Orders O
  JOIN 
  Customers C 
  ON O."Customer_ID" = C."Customer_ID"
  GROUP BY O."Customer_ID",C."Name"
  HAVING COUNT("Order_ID") >= 2;

--4)Find the most Frequently Ordered Book:
  SELECT B."Books_id",COUNT("Order_ID") AS "Order_count",
  O."Order_ID"
  FROM Books B
  JOIN 
  Orders O
  ON B."Books_id" = O."Book_ID"
  GROUP BY B."Books_id",O."Order_ID"
  ORDER BY "Order_count" DESC 
  LIMIT 1;

--5)Show the top 3 expensive books of 'Fantasy' Genre:
  SELECT * FROM Books
  WHERE "Genre" = 'Fantasy'
  ORDER BY "Price" DESC LIMIT 3;

--6)Retrieve the total quantity of books sold by each author:
  SELECT B."Author",
  SUM(O."Quantity") AS "Total_Books_sold"
  FROM Books B
  JOIN 
  Orders O
  ON B."Books_id" = O."Book_ID"
  Group BY B."Author"

--7)List the cities where customers who spent over $30 are located:
  SELECT DISTINCT C."City", 
  O."Total_Amount"
  FROM  orders O
  JOIN
  Customers C
  ON C."Customer_ID" = O."Customer_ID"
  WHERE O."Total_Amount" > 30;

--8)Find the customers who spend the most on orders:
  SELECT C."Customer_ID",C."Name",
  SUM(O."Total_Amount") AS "Total_Spent"
  FROM Customers C
  JOIN
  Orders  O
  ON C."Customer_ID" = O."Customer_ID"
  GROUP BY C."Customer_ID",C."Name"
  ORDER BY "Total_Spent" DESC;

--9)Calculate the stock remaining after fulfilling all orders:
  SELECT B."Books_id",B."Title",B."Stock",COALESCE(SUM("Quantity"),0) AS "Order_Quantity",
  B."Stock"-COALESCE(SUM("Quantity"),0) AS "Remaining_Quantity"
  FROM  Books B
  LEFT JOIN 
  Orders O
  ON B."Books_id" = O."Book_ID"
  GROUP BY B."Books_id"
  ORDER BY B."Books_id" ASC