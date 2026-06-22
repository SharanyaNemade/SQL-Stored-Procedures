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




<<<<<<< HEAD




/*	Get Employee By Department	*/


CREATE PROCEDURE GetEmployeeByDept
	@Department VARCHAR(50)
AS
BEGIN
	Select *
	from Employee
	where Department = @Department;
END;


exec GetEmployeeByDept 'IT';



/*	Get Employee Count By Dept	*/

CREATE PROCEDURE GetDepartmentEmployeeCount
    @Department VARCHAR(50),
    @EmployeeCount INT OUTPUT
AS
BEGIN
    SELECT @EmployeeCount = COUNT(*)
    FROM Employee
    WHERE Department = @Department;
END;


DECLARE @Count INT;

EXEC GetDepartmentEmployeeCount 'Trainer', @Count OUTPUT;

select @Count as TotalEmpCount;




/*	Employee Exists or Not	*/

CREATE PROCEDURE CheckEmployeeExits
	@Id INT
AS
BEGIN
	
	IF EXISTS
	(
		SELECT 3
		FROM Employee
		where Id = @Id
	)

	PRINT 'Employee Exists'
	ELSE
	PRINT 'Employee Not Found';

END;

drop procedure CheckEmployeeExits;



exec CheckEmployeeExits 4;




/*	Give incremented Salary	*/


CREATE PROCEDURE IncreaseSalary
	@Id INT,
	@Percentage DECIMAL(5,2)
AS
BEGIN
	UPDATE Employee
	SET Salary = Salary + (Salary * @Percentage / 100)
	where Id = @Id;
END;

EXEC IncreaseSalary 1,20;



/*	Give Decremented Salary	*/



CREATE PROCEDURE DecreaseSalary
	@Id INT,
	@Percentage DECIMAL(5,2)
AS
BEGIN
	Update Employee
	Set Salary = Salary - (Salary * @Percentage / 100)
	where Id = @Id;
END;


EXEC DecreaseSalary 1,20;
select * from Employee;




/*	Highest Salary	Employee  */



CREATE PROCEDURE GetHighestSalEmp
AS
BEGIN
	Select TOP 1 *
	from Employee
	Order By Salary desc;
END;

drop procedure GetHighestSalEmp;

exec GetHighestSalEmp;



/*	Employees Above a Salary  */


CREATE PROCEDURE GetEmployeesAboveSalary
	@Salary DECIMAL(10,2)
AS
BEGIN
	Select * 
	from Employee
	where Salary > @Salary;
END;

exec GetEmployeesAboveSalary 50000;




/*	Return Total Salary Expense  */


CREATE PROCEDURE TotalExpenseSal
AS
BEGIN
	Select SUM(Salary) as TotalSalary
	from Employee;
END;


EXEC TotalExpenseSal;





/*	TRY CATCH ERROR HANDLING  */


CREATE PROCEDURE SafeInsertEmployee
    @Name VARCHAR(100),
    @Department VARCHAR(50),
    @Salary DECIMAL(10,2)
AS
BEGIN

    BEGIN TRY

        INSERT INTO Employee
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

        PRINT 'Inserted Successfully';

    END TRY

    BEGIN CATCH

        PRINT ERROR_MESSAGE();

    END CATCH

END;



/*	Transaction	 */




CREATE PROCEDURE TransferBonus
    @FromEmployee INT,
    @ToEmployee INT,
    @Amount DECIMAL(10,2)
AS
BEGIN

    BEGIN TRANSACTION;

    BEGIN TRY

        UPDATE Employee
        SET Salary = Salary - @Amount
        WHERE Id = @FromEmployee;

        UPDATE Employee
        SET Salary = Salary + @Amount
        WHERE Id = @ToEmployee;

        COMMIT TRANSACTION;

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;

        PRINT ERROR_MESSAGE();

    END CATCH

END;



/*	Return Value  */



CREATE PROCEDURE EmployeeExists
    @Id INT
AS
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM Employee
        WHERE Id = @Id
    )
        RETURN 1;

    RETURN 0;

END;



DECLARE @Result INT;

EXEC @Result = EmployeeExists 1;

SELECT @Result;



/* Single Procedure For CRUD  */



CREATE PROCEDURE EmployeeCRUD
(
    @Action VARCHAR(10),
    @Id INT = NULL,
    @Name VARCHAR(100) = NULL,
    @Department VARCHAR(50) = NULL,
    @Salary DECIMAL(10,2) = NULL
)
AS
BEGIN

    IF @Action = 'INSERT'
    BEGIN

        INSERT INTO Employee
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

    END

    ELSE IF @Action = 'UPDATE'
    BEGIN

        UPDATE Employee
        SET
            Name = @Name,
            Department = @Department,
            Salary = @Salary
        WHERE Id = @Id;

    END

    ELSE IF @Action = 'DELETE'
    BEGIN

        DELETE FROM Employee
        WHERE Id = @Id;

    END

    ELSE IF @Action = 'SELECT'
    BEGIN

        SELECT *
        FROM Employee;

    END

END;





/*	To See all created Procedures in Database	*/

SELECT name, create_date, modify_date 
FROM sys.procedures;
