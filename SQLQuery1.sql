create database CompanyDB;

use CompanyDB;


create table Employee(
ID int identity(1,1) primary key,
name varchar(100),
department varchar(50),
salary decimal(10,2)
);


insert into Employee(Name, Department, Salary)
values
('John','IT',50000),
('Sam','Operations',30000),
('Sarah','Finance',55000);


select * from Employee;



CREATE PROCEDURE GetAllEmployees
AS
BEGIN
	Select * from Employee;
END;

exec GetAllEmployees;


CREATE PROCEDURE GetEmployeeById
	@Id INT
AS
BEGIN
	Select *
	from Employee
	where Id = @Id;
END;


exec GetEmployeeById @Id = 2;



/*	AddEmployee	*/



CREATE PROCEDURE AddEmployee
	@Name VARCHAR(100),
	@Department VARCHAR(50),
	@Salary DECIMAL(10,2)
AS
BEGIN
	INSERT into Employee
	(
	 Name,
	 Department,
	 Salary
	)

	VALUES
	( 
	@Name,
	@Department,
	@Salary
	);
END;


EXEC AddEmployee
    'Samuel',
    'Trainer',
    40000;



SELECT * FROM Employee;



/*	Update Employee	*/


CREATE PROCEDURE UpdateEmployeeSalary
	@Id INT,
	@Salary DECIMAL(10,2)
AS
BEGIN
	Update Employee
	SET Salary = @Salary
	where Id = @Id;
END;


exec UpdateEmployeeSalary 1,70000;


select * from Employee;



/*	Update Employee Name */




CREATE PROCEDURE UpdateEmployeeName
	@Id INT,
	@Name varchar(30)
AS
BEGIN
	UPDATE Employee
	SET Name = @Name
	where Id = @Id;
END;


EXEC UpdateEmployeeName 1,'Rohan';


select * from Employee;



CREATE PROCEDURE DeleteEmployee
	@Id int
AS
BEGIN
	Delete from Employee
	where Id = @Id;
END;

EXEC DeleteEmployee @Id = 4;



select * from Employee;





/*	Get Employee Count	*/


CREATE PROCEDURE GetEmployeeCount
	@TotalEmployees INT OUTPUT
AS
BEGIN
	Select @TotalEmployees = COUNT(*)
	FROM Employee;
END;



DECLARE @Count INT;

EXEC GetEmployeeCount
	@TotalEmployees = @Count OUTPUT;

Select @Count as TotalEmployee;



/*	Stored Procedure with IF ELSE	*/

CREATE PROCEDURE CheckSalary
	@Id INT
AS
BEGIN


	DECLARE @Salary Decimal(10,2);

	SELECT @Salary = Salary
	FROM Employee
	WHERE Id = @Id;

	IF @Salary > 50000
		PRINT 'High Salary';
	ELSE
		PRINT 'Normal Salary';

END;



EXEC CheckSalary 1;



/*	Alter Stored Procedure	*/

ALTER PROCEDURE GetAllEmployees
AS
BEGIN
	SELECT
	Id,
	Name,
	Department
From Employee;
END;


/*	Drop Stored Procedure	*/



/*	DROP PROCEDURE GetAllEmployees;	*/




/*	To See all created Procedures in Database	*/

SELECT name, create_date, modify_date 
FROM sys.procedures;
