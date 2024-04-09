#              ****************************** Advanced Finance Analytics Project *********************************



# User-Defined SQL Functions

-- a. first grab customer codes for Croma india
	SELECT * FROM dim_customer WHERE customer like "%croma%" AND market="india";

-- b. Get all the sales transaction data from fact_sales_monthly table for that customer(croma: 90002002) in the fiscal_year 2021
	SELECT * FROM fact_sales_monthly 
	WHERE 
            customer_code=90002002 AND
            YEAR(DATE_ADD(date, INTERVAL 4 MONTH))=2021 
	ORDER BY date asc
	LIMIT 100000;

-- c. create a function 'get_fiscal_year' to get fiscal year by passing the date
	CREATE FUNCTION `get_fiscal_year`(calendar_date DATE) 
	RETURNS int
    	DETERMINISTIC
	BEGIN
        	DECLARE fiscal_year INT;
        	SET fiscal_year = YEAR(DATE_ADD(calendar_date, INTERVAL 4 MONTH));
        	RETURN fiscal_year;
	END

-- d. Replacing the function created in the step:b
	SELECT * FROM fact_sales_monthly 
	WHERE 
            customer_code=90002002 AND
            get_fiscal_year(date)=2021 
	ORDER BY date asc
	LIMIT 100000;

-- e. create a function 'get_fiscal_quarter' to get fiscal year by passing the date
	CREATE FUNCTION `get_fiscal_quarter`(
		cal_date date
	) RETURNS char(2) 
  	  DETERMINISTIC
	BEGIN
		declare var1 char(2);
		case
			when month(cal_date) in (9,10,11) then set var1="Q1";
   	     when month(cal_date) in (12,1,2) then set var1="Q2";
    	    when month(cal_date) in (3,4,5) then set var1="Q3";
    	    else set var1="Q4";
		end case;
	RETURN var1;
	END

# Gross Sales Report: Monthly Product Transactions

-- a. Perform joins to pull product information
	SELECT s.date, s.product_code, p.product, p.variant, s.sold_quantity 
	FROM fact_sales_monthly s
	JOIN dim_product p
        ON s.product_code=p.product_code
	WHERE 
            customer_code=90002002 AND 
    	    get_fiscal_year(date)=2021     
	LIMIT 1000000;

-- b. Performing join with 'fact_gross_price' table with the above query and generating required fields
	SELECT 
    	    s.date, 
            s.product_code, 
            p.product, 
            p.variant, 
            s.sold_quantity, 
            g.gross_price,
            ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total
	FROM fact_sales_monthly s
	JOIN dim_product p
            ON s.product_code=p.product_code
	JOIN fact_gross_price g
            ON g.fiscal_year=get_fiscal_year(s.date)
    	AND g.product_code=s.product_code
	WHERE 
    	    customer_code=90002002 AND 
            get_fiscal_year(s.date)=2021     
	LIMIT 1000000;




# Gross Sales Report: Total Sales Amount

-- Generate monthly gross sales report for Croma India for all the years
	SELECT 
            s.date, 
    	    SUM(ROUND(s.sold_quantity*g.gross_price,2)) as monthly_sales
	FROM fact_sales_monthly s
	JOIN fact_gross_price g
        ON g.fiscal_year=get_fiscal_year(s.date) AND g.product_code=s.product_code
	WHERE 
             customer_code=90002002
	GROUP BY date;



# Stored Procedures: Monthly Gross Sales Report

-- Generate monthly gross sales report for any customer using stored procedure
	CREATE PROCEDURE `get_monthly_gross_sales_for_customer`(
        	in_customer_codes TEXT
	)
	BEGIN
        	SELECT 
                    s.date, 
                    SUM(ROUND(s.sold_quantity*g.gross_price,2)) as monthly_sales
        	FROM fact_sales_monthly s
        	JOIN fact_gross_price g
               	    ON g.fiscal_year=get_fiscal_year(s.date)
                    AND g.product_code=s.product_code
        	WHERE 
                    FIND_IN_SET(s.customer_code, in_customer_codes) > 0
        	GROUP BY s.date
        	ORDER BY s.date DESC;
	END




# Stored Procedure: Market Badge

--  Write a stored proc that can retrieve market badge. i.e. if total sold quantity > 5 million that market is considered "Gold" else "Silver

        CREATE PROCEDURE `market_badge`
 	       (in in_market varchar(45),
                in in_fiscal_year year,
         	out badge varchar(45) )
	BEGIN
		with cte as (
		select c.market,sum(sold_quantity) as total_quantity
		from fact_sales_monthly s
		join dim_customer c
		on s.customer_code=c.customer_code
		where get_fy(s.date)=in_fiscal_year and c.market=in_market
		group by c.market
		)

		select *,
			case
				when total_quantity>5000000 then "Gold"
				else "Silver"
			end as badge
		from cte;
	END

# Stored procedure that takes market, fiscal_year and top n as an input and returns top n customers by net sales in that given fiscal year and market

	CREATE PROCEDURE `get_top_n_customers_by_net_sales`(
        	in_market VARCHAR(45),
        	in_fiscal_year INT,
    		in_top_n INT
	)
	BEGIN
        	select 
                     customer, 
                     round(sum(net_sales)/1000000,2) as net_sales_mln
        	from net_sales s
        	join dim_customer c
                on s.customer_code=c.customer_code
        	where 
		    s.fiscal_year=in_fiscal_year 
		    and s.market=in_market
        	group by customer
        	order by net_sales_mln desc
        	limit in_top_n;
	END

# Stored proc to get top n markets by net sales for a given year

	CREATE PROCEDURE `get_top_n_markets_by_net_sales`(
        	in_fiscal_year INT,
    		in_top_n INT
	)
	BEGIN
        	SELECT 
                     market, 
                     round(sum(net_sales)/1000000,2) as net_sales_mln
        	FROM net_sales
        	where fiscal_year=in_fiscal_year
        	group by market
        	order by net_sales_mln desc
        	limit in_top_n;
	END







































