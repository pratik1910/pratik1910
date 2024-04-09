

use northwind;

# 1.Calculate average Unit Price for each CustomerId



select customerid,unitprice,
       round(avg(unitprice) over(partition by customerid ),2) avg_unit
from orders
inner join order_details
using(orderid);



/*  select customerid,
		   round(avg(unitprice),2) as avg_unit
    from orders
    inner join order_details
    using(orderid)
	group by customerid          */



# 2.Calculate average Unit Price for each group of CustomerId AND EmployeeId.

 

select customerid,unitprice,employeeid,
		round(avg(unitprice) over(partition by customerid,employeeid ),2) avg_unit
from orders
inner join order_details
using(orderid);


 
 /*  select customerid,employeeid
	        ,round(avg(unitprice),2) as avg_unit
     from orders
     inner join order_details
     using(orderid)
	 group by customerid,employeeid
     order by customerid                   */


# 3.Rank Unit Price in descending order for each CustomerId.

select customerid,unitprice,
       rank() over(partition by customerid order by unitprice desc) as rnk
from orders
inner join order_details
using(orderid);





# 4.How can you pull the previous order date’s Quantity for each ProductId.


select productid,orderdate,quantity,
       lag(quantity) over(partition by productid order by orderdate) as prev_quant
from orders
inner join order_details
using(orderid);



# 5.How can you pull the following order date’s Quantity for each ProductId.

select productid,orderdate,quantity,
       lead(quantity) over(partition by productid order by orderdate) as foll_quant
from orders
inner join order_details
using(orderid);



# 6.Pull out the very first Quantity ever ordered for each ProductId.

select productid,quantity,orderdate,
	   first_value(quantity) over(partition by productid order by orderdate) first_order_quant
from orders
inner join order_details
using(orderid);



/* select productid, quantity from
      (select productid,quantity,orderdate,
              rank() over(partition by productid order by orderdate) as rnk
	   from orders
	   inner join order_details
	   using(orderid)) x
   where rnk =1;                   */



# 7.Calculate a cumulative moving average UnitPrice for each CustomerId.

select customerid,unitprice,
       round(avg(unitprice) over(partition by customerid order by unitprice rows between unbounded preceding and current row ),2)
       as cum_mov_avg
from orders
inner join order_details
using(orderid);







/*  1. Can you define a trigger that is invoked automatically before a new row is inserted into a table?

			a trigger is a special kind of stored procedure that is automatically executed when a specific event 
occurs in the database. In the case of a trigger being automatically executed before a new row is inserted into a table
 is called a before insert trigger.
            This type of trigger is activated before the new row is inserted, allowing the trigger to perform actions such as
checking for data validity. This can help ensure that the data being inserted into the table meets certain criteria and is 
consistent with the rest of the data in the table.
SYNTAX:
  
DELIMITER //
CREATE TRIGGER trigger_name
BEFORE INSERT ON table_name
FOR EACH ROW
BEGIN
    
END;//
DELIMITER ;
  
  2. What are the different types of triggers?


(i) Before insert triggers: These are activated before a new row is inserted into a table.

(ii) After insert triggers: These are activated after a new row has been inserted into a table.

(iii) Before update triggers: These are activated before an existing row in a table is updated.

(iv) After update triggers: These are activated after an existing row in a table has been updated.

(v) Before delete triggers: These are activated before an existing row in a table is deleted.

(vi) After delete triggers: These are activated after an existing row in a table has been deleted.



    3.How is Metadata expressed and structured?

         metadata is expressed using the data dictionary, which is a set of tables and views that contain information 
about the structures and properties of the other objects in the database, such as tables, indexes, and columns. For example, the 
informaton_schema provide information about the tables, columns, and data types in a database.
		the structure of metadata is organized in a hierarchical manner, with different levels of information.
 For example, at the top level, information about the database, such as its name and the names of the tables it contains. At the
 next level, information about each table, such as its name, the names of its columns, and the data types of those columns. At the 
 next level, information about each column, such as its name, data type.

   4.Explain RDS and AWS key management services.

		Amazon Relational Database Service (RDS) is a managed database service provided by AWS that makes it easy to set up, 
operate and scale a relational database in the cloud. RDS supports a variety of popular databases, including MySQL, 
PostgreSQL, Oracle, and Microsoft SQL Server.
        AWS Key Management Service (KMS) is a managed service that makes it easy to create and control the encryption keys used 
to encrypt data in the cloud. KMS provides a central repository for encryption keys for storing, and managing these keys. 
KMS also integrates with other AWS services, allowing for seamless encryption and decryption of data within these services.



    5.What is the difference between amazon EC2 and RDS?         

          Amazon EC2 and RDS are two different services offered by Amazon Web Services (AWS).

         Amazon EC2 is a web service that provides scalable, computing service in the cloud.  EC2 is a general-purpose 
computing service. EC2 provides the flexibility to run a wide range of applications and services  EC2 provides a flexible 
and scalable platform for running applications and services in the cloud.

         Amazon RDS, is a managed database service that simplifies the process of setting up, operating, and 
scaling a relational database in the cloud. It provides a scalable and secure platform for running popular databases 
such as MySQL, sql server, and PostgreSQL. RDS makes it easy to set up, operate, and scale a database in the cloud.

         




*/






