
#Queries used for Employees Project on Tableau

#1

#Creating a visualisation that provides a breakdown between the 
#male and female employees working in the company each year starting from 1990

SELECT 

    YEAR(d.from_date) AS calendar_year,
    e.gender,     
    COUNT(e.emp_no) AS num_of_employees

FROM     
     t_employees e         
          JOIN     
     t_dept_emp d ON d.emp_no = e.emp_no

GROUP BY calendar_year, e.gender 

HAVING calendar_year >= 1990;

#2

#Comparing the number of male managers to the number of female manages from
#different departments for each year starting from 1990


select 
d.dept_name, ee.gender, dm.emp_no, dm.from_date, dm.to_date, e.calender_year,
CASE 
WHEN YEAR(dm.to_date) >= calender_year AND
YEAR(dm.from_date) <= e.calender_year THEN 1
ELSE 0
END AS active

FROM 
(SELECT 
YEAR(hire_date) AS calender_year FROM 
t_employees GROUP BY calender_year) e
CROSS JOIN
t_dept_manager dm
JOIN
t_departments d ON dm.dept_no = d.dept_no
join
t_employees ee ON dm.emp_no = ee.emp_no
order by dm.emp_no, calender_year;


#3

#Comparing the AVG(salary) of female vs male employees in the entire company until
#year 2002, and adding a filter allowing us to see that per each department. 

select
e.gender,
d.dept_name,
round(avg(s.salary),2) as salary,
YEAR(s.from_date) AS calender_year
from
t_employees e
	join
    t_salaries s ON e.emp_no = s.emp_no
    join
    t_dept_emp de ON de.emp_no = s.emp_no
    join
    t_departments d ON d.dept_no = de.dept_no
group by d.dept_no, calender_year, e.gender

having calender_year <= 2002
order by d.dept_no;


#4

#Creating a sql procedure that will allow us to obtain average male and female
#salary per department

delimiter $$
use employees_mod $$
create procedure filter_salary (IN p_min_salary FLOAT, IN p_max_salary FLOAT)
begin
select 
e.gender, d.dept_name, AVG(s.salary) as avg_salary
from
t_salaries s
JOIN
t_employees e on s.emp_no = e.emp_no
join
t_dept_emp de ON de.emp_no = e.emp_no
join
t_departments d ON d.dept_no = de.dept_no
where s.salary BETWEEN p_min_salary AND p_max_salary
group by d.dept_no, e.gender;
END$$

DELIMITER ;

call filter_salary(50000, 90000); 










