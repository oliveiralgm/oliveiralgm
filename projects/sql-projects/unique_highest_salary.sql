-- Find the highest salary among salaries that appears only once.

-- employee

-- id: int
-- first_name: varchar
-- last_name: varchar
-- age: int
-- sex: varchar
-- employee_title: varchar
-- department: varchar
-- salary: int
-- target: int
-- bonus: int
-- email: varchar
-- city: varchar
-- address: varchar
-- manager_id: int

select
max(distinct salary)
from employee
