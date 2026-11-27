--7.1
CREATE INDEX IX_Users_Email       ON [identity].Users (Email)          INCLUDE (FirstName, LastName);
CREATE INDEX IX_Users_LastName    ON [identity].Users (LastName)       INCLUDE (FirstName, Email);
CREATE INDEX IX_Users_CreatedAtUtc ON [identity].Users (CreatedAtUtc)  INCLUDE (Email);
CREATE INDEX IX_Payments_PaidAtUtc ON finance.Payments (PaidAtUtc)   INCLUDE (InvoiceId, Amount);
CREATE INDEX IX_Invoices_Number   ON finance.Invoices (InvoiceNumber);



 SET STATISTICS IO, TIME ON 
 SELECT Id, Email
FROM [identity].Users
WHERE YEAR(CreatedAtUtc) = 2026
AND MONTH(CreatedAtUtc) = 3;

SET STATISTICS IO, TIME OFF
-- problem : year  & month function fix with SARgable

SET STATISTICS IO, TIME ON;

SELECT Id, Email
FROM [identity].Users
WHERE CreatedAtUtc >= '2026-03-01T00:00:00'
  AND CreatedAtUtc <  '2026-04-01T00:00:00';

SET STATISTICS IO, TIME OFF;

--7.2
SET STATISTICS IO, TIME ON;
SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE DATEDIFF(DAY, PaidAtUtc,
               SYSUTCDATETIME()) <= 30;
SET STATISTICS IO, TIME OFF;

--Datediff 
SET STATISTICS IO, TIME ON;
SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE PaidAtUtc >= DATEADD(DAY, -30, SYSUTCDATETIME());
SET STATISTICS IO, TIME OFF;

--7.3
SET STATISTICS IO, TIME ON;
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE LEFT(LastName, 3) = N'Abd';
SET STATISTICS IO, TIME OFF;

-- left function 
SET STATISTICS IO, TIME ON;
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE LastName LIKE N'Abd%';
SET STATISTICS IO, TIME OFF;

--7.4
SET STATISTICS IO, TIME ON;
 SELECT *
FROM operations.AuditLogs
WHERE Id + 1 = 50001;
SET STATISTICS IO, TIME OFF;

--WHERE Id + 1 = 50001;
SET STATISTICS IO, TIME ON;
SELECT *
FROM operations.AuditLogs
WHERE Id = 50000;
SET STATISTICS IO, TIME OFF;

--7.5
SET STATISTICS IO, TIME ON;
 SELECT Id, TotalAmount, PaidAmount
FROM finance.Invoices
WHERE InvoiceNumber
      = N'LAB-INV-2026-000001';
SET STATISTICS IO, TIME OFF;

-- = N'LAB-INV-2026-000001'; implicit conversion for each row
SET STATISTICS IO, TIME ON;
SELECT Id, TotalAmount, PaidAmount
FROM finance.Invoices
WHERE InvoiceNumber = 'LAB-INV-2026-000001';
SET STATISTICS IO, TIME OFF;


--7.6
SET STATISTICS IO, TIME ON;
DECLARE @Email NVARCHAR(320) = N'...';
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE UPPER(Email) = UPPER(@Email)
SET STATISTICS IO, TIME OFF;

--WHERE UPPER(Email) = UPPER(@Email) -> the upper function sql alredy case insensetive
SET STATISTICS IO, TIME ON;
-- 7.6
DECLARE @Email NVARCHAR(320) = N'...';

SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE Email = @Email;
SET STATISTICS IO, TIME OFF;


--7.7
SET STATISTICS IO, TIME ON;
DECLARE @LastName NVARCHAR(100) = N'Hassan';
SELECT Id, FirstName, Email
FROM [identity].Users
WHERE (@LastName IS NULL
OR LastName = @LastName);
SET STATISTICS IO, TIME OFF;

--WHERE (@LastName IS NULL OR LastName = @LastName); -> index scan no option 
SET STATISTICS IO, TIME ON;

DECLARE @LastName NVARCHAR(100) = N'Hassan';

SELECT Id, FirstName, Email
FROM [identity].Users
WHERE (@LastName IS NULL OR LastName = @LastName)
OPTION (RECOMPILE);
SET STATISTICS IO, TIME OFF;

--7.8
SET STATISTICS IO, TIME ON;
SELECT Id, Email, FirstName, LastName
FROM [identity].Users
WHERE Email LIKE N'%@gmail.com';
SET STATISTICS IO, TIME OFF;

-- '%' in the first prevents Index Seek
SET STATISTICS IO, TIME ON;

SELECT Id, Email, FirstName, LastName
FROM [identity].Users
WHERE Email LIKE N'rowida%';

SET STATISTICS IO, TIME OFF;