--5.1
SELECT
    Code AS [Course Code],
    Title AS [Course Title],
    CreditHours AS [Credit Hours]
FROM academic.Courses
ORDER BY
    CreditHours DESC,Title ;

--5.2
SELECT TOP (5) *
FROM [identity].StudentProfiles
ORDER BY NEWID();

--5.3
SELECT *
FROM [identity].Users
WHERE Email IS NOT NULL
  AND DATALENGTH(Email) <> DATALENGTH(TRIM(Email));

--5.4
SELECT *
FROM [identity].Users
WHERE Email IS NOT NULL
  AND Email <> LOWER(Email) COLLATE Latin1_General_CS_AS;

  --5.5
SELECT *
FROM [identity].Users
WHERE Email IS NULL
   OR Email NOT LIKE '%@%'
   OR CHARINDEX('@', Email) = 1
   OR CHARINDEX('.', SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email))) = 0;

   --5.6
SELECT DISTINCT
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS Provider
FROM [identity].Users
WHERE Email IS NOT NULL
  AND CHARINDEX('@', Email) > 0
ORDER BY Provider ASC;

--5.7
SELECT *
FROM [identity].Users
ORDER BY
    CASE WHEN LastLoginAtUtc IS NULL THEN 1 ELSE 0 END ASC,
    LastLoginAtUtc DESC;
    
--5.8
SELECT *
FROM finance.Payments
WHERE PaidAtUtc >= '2026-10-01T00:00:00'
  AND PaidAtUtc <  '2026-11-01T00:00:00';

  --5.9
SELECT
    *,
    CAST(PaidAtUtc AT TIME ZONE 'UTC' AT TIME ZONE 'Egypt Standard Time' AS datetime2(0)) AS PaidAtCairo
FROM finance.Payments
WHERE PaidAtUtc IS NOT NULL
  AND DATEPART(HOUR, PaidAtUtc AT TIME ZONE 'UTC' AT TIME ZONE 'Egypt Standard Time') BETWEEN 0 AND 4;

  --5.10
SELECT *
FROM attendance.AttendanceSessions
WHERE DATENAME(WEEKDAY, SessionDate) = 'Friday';

--5.11
SELECT *
FROM [identity].Users
WHERE PhoneNumber IS NOT NULL
  AND LEN(PhoneNumber) = 13
  AND  PhoneNumber LIKE '+201[0125][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]';
  
  --5.12
SELECT
    Id,
    PhoneNumber AS OriginalPhoneNumber,
    CASE
        WHEN PhoneNumber IS NULL THEN NULL
        WHEN LEN(PhoneNumber) <= 5 THEN PhoneNumber
        ELSE LEFT(PhoneNumber, 3)
             + REPLICATE('*', LEN(PhoneNumber) - 5)
             + RIGHT(PhoneNumber, 2)
    END AS MaskedPhoneNumber
FROM [identity].Users;

-- 5.13
SELECT
    *,
    TRY_CAST(
        RIGHT(InvoiceNumber, CHARINDEX('-', REVERSE(InvoiceNumber)) - 1)
        AS BIGINT
    ) AS RunningNumber
FROM finance.Invoices
WHERE CHARINDEX('-', InvoiceNumber) > 0
  AND TRY_CAST(RIGHT(InvoiceNumber, CHARINDEX('-', REVERSE(InvoiceNumber)) - 1) AS BIGINT) IS NOT NULL
ORDER BY RunningNumber;

--5.14
SELECT
    Id,
    Title,
    EstimatedMinutes,
    CASE
        WHEN EstimatedMinutes IS NULL THEN 'Not set'
        ELSE CONCAT(EstimatedMinutes / 60, ' h ', EstimatedMinutes % 60, ' min')
    END AS FormattedLength
FROM content.Lessons;

--5.15
SELECT *
FROM communication.Announcements
WHERE Title LIKE '%[%]%'
   OR Body LIKE '%[%]%';

--5.16
SELECT TOP (5) WITH TIES *
FROM finance.Invoices
ORDER BY TotalAmount DESC;

--5.17
SELECT TOP (10) PERCENT *
FROM finance.Payments
ORDER BY Amount DESC;

--5.18
SELECT *
FROM delivery.Sections
WHERE Location IS NULL
   OR Location <> 'Hall A';

-- 5.19
SELECT
    Id,
    InvoiceNumber,
    TotalAmount,
    PaidAmount,
    (TotalAmount - PaidAmount) AS AmountOwed,
    CASE
        WHEN PaidAmount <= 0 THEN 'Not paid'
        ELSE 'Partially paid'
    END AS PaymentStatus,
    CASE
        WHEN DueAtUtc IS NOT NULL AND DueAtUtc < SYSUTCDATETIME() THEN 'Overdue'
        ELSE 'Not overdue'
    END AS OverdueStatus,
    CAST(
        COALESCE((PaidAmount * 100.0) / NULLIF(TotalAmount, 0), 0.0)
        AS DECIMAL(5, 1)
    ) AS PercentagePaid
FROM finance.Invoices
WHERE (TotalAmount - PaidAmount) > 0
ORDER BY AmountOwed DESC;

--5.20
DECLARE @pageSize INT = 20;
DECLARE @pageNumber INT =3;

SELECT *
FROM [identity].Users
ORDER BY CreatedAtUtc DESC, Id DESC
OFFSET ((@pageNumber-1)*@pageSize) ROWS 
FETCH NEXT @pageSize ROWS ONLY;


--5.21
DECLARE @LastId BIGINT = 11; 

SELECT TOP (50) *
FROM operations.AuditLogs
WHERE Id > @LastId
ORDER BY Id ASC;


--5.22
-- Answer:no cause without ORDER BY SQL Server does not guarantee returning the latest 10 payments

SELECT TOP (10) *
FROM finance.Payments
ORDER BY PaidAtUtc DESC, Id DESC;


-- 5.23
SELECT DISTINCT TOP (10)
    UPPER(TRIM(Title)) AS LessonTitle,
    LEN(UPPER(TRIM(Title))) AS TitleLength,
    CASE
        WHEN EstimatedMinutes IS NULL THEN 'Not set'
        WHEN EstimatedMinutes <= 15 THEN 'Quick'
        WHEN EstimatedMinutes <= 45 THEN 'Standard'
        ELSE 'Long'
    END AS DurationCategory
FROM content.Lessons
WHERE IsPublished = 1
  AND Title IS NOT NULL
  AND LEN(UPPER(TRIM(Title))) > 40
ORDER BY TitleLength DESC, LessonTitle ASC;


--5.24
SELECT TOP (12)
    CONVERT(VARCHAR(7), DueAtUtc, 23) AS DueMonth,
    CurrencyCode,
    CASE
        WHEN PaidAmount <= 0 THEN 'Not paid'
        ELSE 'Partially paid'
    END AS PaymentState,
    COUNT(*) AS InvoiceCount,
    SUM(TotalAmount - PaidAmount) AS TotalOwed
FROM finance.Invoices
WHERE DueAtUtc IS NOT NULL
  AND DueAtUtc < SYSUTCDATETIME()
  AND (TotalAmount - PaidAmount) > 0
GROUP BY
    CONVERT(VARCHAR(7), DueAtUtc, 23),
    CurrencyCode,
    CASE
        WHEN PaidAmount <= 0 THEN 'Not paid'
        ELSE 'Partially paid'
    END
ORDER BY
    DueMonth DESC,
    CurrencyCode ASC,
    PaymentState ASC;
