--- 1) the-pads

SELECT CONCAT(NAME, '(', LEFT(OCCUPATION,1), ')')
FROM OCCUPATIONS
ORDER BY NAME;

SELECT CONCAT('There are a total of ', CNT, ' ', L_OCCUPATION, 's.')
FROM (
SELECT LOWER(OCCUPATION) AS L_OCCUPATION, COUNT(*) AS CNT
FROM OCCUPATIONS
GROUP BY LOWER(OCCUPATION)
) A 
ORDER BY CNT, L_OCCUPATION;

--- 2) PRIME NUMBER 

declare @n int
declare @div int
declare @cnt int
declare @res as varchar(1000)
declare @len_res as int

set @n = 2
set @res = ''  

while @n <= 1000
    begin
    
        set @cnt = 0
        set @div = 1
        
        while @div <= @n
            begin
                if @n % @div = 0
                    set @cnt = @cnt + 1
                if @cnt > 2
                    break;
                    
                set @div = @div + 1
            end
        
        if @cnt = 2
            set @res = concat(@res, @n, '&')
        set @n = @n + 1
    end

set @len_res = len(@res) - 1
print(substring(@res, 1, @len_res))
    
        
--- MEDIAN (weather-observation-station-20)

declare @n as int
set @n = (select top 1 rank() over(order by lat_n asc) as rank from station order by rank desc)

if @n % 2 <> 0
    select cast(lat_n as decimal(18,4))
    from (select lat_n, rank() over(order by lat_n asc) as rank from station) as a
    where rank = (@n+1)/2 
else
    select cast(sum(lat_n)/2 as decimal(18,4))
    from (select lat_n, rank() over(order by lat_n asc) as rank from station) as a
    where rank = (@n/2) or rank = (@n/2) + 1

--- the-company

select company.company_code, 
company.founder, 
cnt_lead_manager,
cnt_srn_manager,
cnt_manager,
cnt_employee

from Company
join (select  company_code, count(distinct lead_manager_code) as cnt_lead_manager
     from Lead_Manager
      group by company_code
     ) AS A
ON A.company_code = company.company_code
join (
    select company_code, count(distinct senior_manager_code) as cnt_srn_manager
    from Senior_Manager
    group by company_code
) as B
on B.company_code = company.company_code
join (
    select company_code, count(distinct manager_code) as cnt_manager
    from Manager
    group by company_code
) C
on C.company_code = company.company_code
join (
    select company_code, count(distinct employee_code) as cnt_employee
    from employee
    group by company_code  
) D
on D.company_code = company.company_code
ORDER BY company.company_code ASC
