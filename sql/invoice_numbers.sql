--3.1
CREATE SEQUENCE finance.InvoiceNumberSeq
      AS BIGINT  START WITH 1 INCREMENT BY 1;

--3.2
INSERT INTO finance.Invoices (InvoiceNumber,StudentId,  TermId,CurrencyCode,DueAtUtc,
                                 TotalAmount, PaidAmount,CreatedAtUtc,  Status)
VALUES (
    CONCAT('LAB-INV-2026-', RIGHT('000000' + CAST(NEXT VALUE FOR finance.InvoiceNumberSeq AS VARCHAR(6)), 6)),
    (SELECT TOP 1 Id FROM [identity].StudentProfiles ORDER BY Id),
    12,
    'EGP',
    DATEADD(DAY, 30, SYSDATETIME()),
    4500.00,
    0.00,
    SYSDATETIME(),
    1
);

--3.3
BEGIN TRANSACTION;
SELECT NEXT VALUE FOR finance.InvoiceNumberSeq AS NumberTakenInsideTransaction;
-- here  will be 2
ROLLBACK TRANSACTION;
SELECT NEXT VALUE FOR finance.InvoiceNumberSeq AS NextNumberAfterRollback;
--here will be 3 even rollback cause the num is taked never back
