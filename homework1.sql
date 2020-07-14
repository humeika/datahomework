#Homework1
#regular expressions
# 4. What are the products with a product code in the range S700_1000 to S700_1499?
select *
from products 
where substring(productCode,1,4)='S700' 
      and (cast(substring(productCode,6,4) as UNSIGNED) between 1000 and 1499);

# 5. Which customers have a digit in their name?
select *
from customers
where customerName rlike '[0-9]';

#7. List the products containing ship or boat in their product name.
select *
from products 
where productName rlike 'ship|boat';

#10. List the names of employees with non-alphabetic characters in their names.
select *
from customers
where customerName not rlike '[a-z]';

# General questions
# 1.Who is at the top of the organization (i.e.,  reports to no one).
select *
from employees
where reportsTo is null;
# 2.Who reports to William Patterson?
select *
from employees 
where reportsTo = 'Wlliam Patterson';

# 3.List all the products purchased by Herkku Gifts.
select p.productName
from customers c join orders o on c.customerNumber = o.customerNumber
                 join orderDetails od on o.orderNumber = od.orderNumber
				 join Products p on p.productCode = od.productcode
where c.customerName = 'Herkku Gifts';
# 4.Compute the commission for each sales representative, assuming the commission is 5% of the value of an order. Sort by employee last name and first name.
select e.lastName, e.firstName, sum(od.quantityOrdered*od.priceEach)*0.05 as commission
from customers c join employees e on c.salesRepEmployeeNumber = e.employeeNumber
                 join orders o on c.customerNumber = o.customerNumber
                 join orderdetails od on o.orderNumber = od.orderNumber
group by e.employeeNumber  
order by 1,2;            

# 5.What is the difference in days between the most recent and oldest order date in the Orders file?
select datediff(max(orderDate),min(orderDate))
from orders; 

# 6.Compute the average time between order date and ship date for each customer ordered by the largest difference.
select c.customerNumber, avg(datediff(o.shippedDate,o.orderDate)) as difference 
from customers c join orders o on c.customerNumber = o.customerNumber
group by c.customerNumber
order by 2 desc;

# 7.What is the value of orders shipped in August 2004? (Hint).
select sum(od.quantityOrdered*priceEach) as total_value
from orders o join orderdetails od on o.orderNumber = od.orderNumber
where o.shippedDate between '2004-08-01' and '2004-08-31';

# 8.Compute the total value ordered, total amount paid, and their difference for each customer for orders placed in 2004 
#and payments received in 2004 (Hint; Create views for the total paid and total ordered).
select c.customerNumber, sum(od.quantityOrdered*od.priceEach) as total_ordered, sum(p.amount) as total_paid
       , sum(od.quantityOrdered*od.priceEach)-sum(p.amount) as difference
from customers c left join orders o on c.customerNumber = o.customerNumber
                 left join payments p on c.customerNumber = p.customerNumber
                 left join orderDetails od on o.orderNumber = od.orderNumber
where year(p.paymentDate) = 2004 and year(o.orderDate) = 2004
group by c.customerNumber;


# 9.List the employees who report to those employees who report to Diane Murphy. 
# Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
select concat(firstName, lastName) as employee
from employees
where reportsTo = 'Diane Murphy';

# 10.What is the percentage value of each product in inventory sorted by the highest percentage first (Hint: Create a view first).
select productCode, productName, (quantityInStock*buyPrice)/(select sum(quantityInStock*buyPrice) from products) as percentage
from products
order by 3 desc;

# 11.Write a function to convert miles per gallon to liters per 100 kilometers.


# 12.Write a procedure to increase the price of a specified product category by a given percentage. You will need to create a product table with appropriate data to test your procedure. Alternatively, load the ClassicModels database on your personal machine so you have complete access. You have to change the DELIMITER prior to creating the procedure.

# 14.What is the ratio the value of payments made to orders received for each month of 2004. (i.e., divide the value of payments made by the orders received)?
# 15.What is the difference in the amount received for each month of 2004 compared to 2003?
select a.months, a.amount2004-b.amount2003 as difference
from 
(select month(paymentDate) as months, sum(amount) as amount2004
from payments
where year(paymentDate)=2004
group by 1) a join 
(select month(paymentDate) as months, sum(amount) as amount2003
from payments
where year(paymentDate)=2003
group by 1) b on a.months = b.months
order by 1;

# 16.Write a procedure to report the amount ordered in a specific month and year for customers containing a specified character string in their name.
# 17.Write a procedure to change the credit limit of all customers in a specified country by a specified percentage.
# 18.Basket of goods analysis: A common retail analytics task is to analyze each basket or order to learn what products are often purchased together. Report the names of products that appear in the same order ten or more times.
# 19.ABC reporting: Compute the revenue generated by each customer based on their orders. Also, show each customer's revenue as a percentage of total revenue. Sort by customer name.
# 20.Compute the profit generated by each customer based on their orders. Also, show each customer's profit as a percentage of total profit. Sort by profit descending.
# 21.Compute the revenue generated by each sales representative based on the orders from the customers they serve.
# 22.Compute the profit generated by each sales representative based on the orders from the customers they serve. Sort by profit generated descending.
# 23.Compute the revenue generated by each product, sorted by product name.
# 24.Compute the profit generated by each product line, sorted by profit descending.
# 25.Same as Last Year (SALY) analysis: Compute the ratio for each product of sales for 2003 versus 2004.
# 26.Compute the ratio of payments for each customer for 2003 versus 2004.
# 27.Find the products sold in 2003 but not 2004.
select p.productCode, p.productname
from products p join orderdetails od on p.productCode = od.productCode
                join orders o on od.orderNumber = o.orderNumber
where year(orderDate)=2003 and p.productCode not in 
(
select p.productCode
from products p join orderdetails od on p.productCode = od.productCode
                join orders o on od.orderNumber = o.orderNumber
where year(orderDate)=2004);


# 28.Find the customers without payments in 2003.
select c.customerNumber, c.customerName
from customers c left join payments p on c.customerNumber = p.customerNumber
where p.customerNumber is null;


