--11.1
UPDATE academic.Courses
SET PassingScore = 65
WHERE Code LIKE N'DSAI%';

--11.2
UPDATE delivery.Enrollments
SET FinalGrade =
    CASE
        WHEN FinalScore >= 90 THEN N'A'
        WHEN FinalScore >= 80 THEN N'B'
        WHEN FinalScore >= 70 THEN N'C'
        WHEN FinalScore >= 60 THEN N'D'
        ELSE N'F'
    END
WHERE FinalScore IS NOT NULL
  AND EnrollmentStatusId IN (4, 5, 6, 7);

  --11.3
SELECT *
FROM [identity].Roles
WHERE Name LIKE N'%Teaching Assistant%' OR Code LIKE N'%TA%';

DELETE FROM [identity].[Roles]
WHERE Id = 6;

--11.4

CREATE TABLE finance.PaymentsStaging
(
    PaymentId      INT            NOT NULL,
    InvoiceId      INT            NOT NULL,
    Amount         DECIMAL(18, 2) NOT NULL,
    PaidAtUtc      DATETIME2(7)   NOT NULL,
    PaymentMethod  NVARCHAR(50)   NOT NULL
);


INSERT INTO finance.PaymentsStaging (PaymentId, InvoiceId, Amount, PaidAtUtc, PaymentMethod)
VALUES
    (1, 101, 500.00, SYSUTCDATETIME(), N'Card'),
    (2, 102, 750.00, SYSUTCDATETIME(), N'BankTransfer'),
    (3, 103, 300.00, SYSUTCDATETIME(), N'Cash');

    select PaymentId,InvoiceId,Amount,PaidAtUtc,PaymentMethod from finance.PaymentsStaging;
TRUNCATE TABLE finance.PaymentsStaging;

--11.5
DROP TABLE IF EXISTS finance.PaymentsStaging;