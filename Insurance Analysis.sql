use Insurance;
show tables;

-- KPI 1-No of Invoice by Accnt Exec

select Account_Executive,count(Account_Executive) as number_of_invoices from invoice
group by Account_Executive
order by number_of_invoices desc;
 
 -- KPI 2-Yearly Meeting Count

select year(meeting_date) as years,count(year(meeting_date)) as meeting_count from meeting
group by year(meeting_date);

-- KPI 3-Target,Achive,Invoice

delimiter //
create procedure Data_by_Incomeclass (in Incomeclass varchar(20))
begin
	declare Budget_val double;
	set @Cross_Sell_Target = (select sum(Cross_sell_bugdet) from individual_budgets);
    set @New_Target = (select sum(New_Budget) from individual_budgets);
    set @Renewal_Target = (select sum(Renewal_Budget) from individual_budgets);
    
    set @Invoice_val = (select sum(Amount) from invoice where income_class = Incomeclass);
    set @Achieved_val = ((select sum(Amount) from brokerage where income_class = Incomeclass) +
    (select sum(Amount) from fees where income_class = Incomeclass));
    if Incomeclass = "Cross Sell" then set Budget_val = @Cross_Sell_Target;
     elseif Incomeclass = "New" then set Budget_val = @New_Target;
     elseif Incomeclass = "Renewal" then set Budget_val = @Renewal_Target;
     else set Budget_val = 0;
 end if;
 select Incomeclass, Budget_val as Target, @Invoice_val as Invoice, @Achieved_val as Achieved;
 end //
delimiter ; 

call Data_by_Incomeclass("New");
call Data_by_Incomeclass("Cross Sell");
call Data_by_Incomeclass("Renewal");

-- KPI 4-Stage Funnel by Revenue

select stage,sum(revenue_amount) as revenue from opportunity
group by stage;


-- KPI 5-No of meeting By Account Exe
select Account_Executive, count(*) as meetings from meeting
group by Account_Executive;

-- KPI 6-Top Open Opportunity

select opportunity_name,sum(revenue_amount) as revenue from opportunity 
group by opportunity_name
order by revenue desc limit 4;

