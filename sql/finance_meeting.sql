--1.1
SELECT
     Id,
InvoiceNumber,
    [StudentId],
    TotalAmount ,
    PaidAmount,
    (TotalAmount - PaidAmount) AS [Remaining Amount],
    DATEDIFF(DAY, DueAtUtc, SYSDATETIME()) AS [Days Late]
INTO  #FinanceWorkingList
FROM [finance].[Invoices]
WHERE DueAtUtc < SYSDATETIME()
  AND PaidAmount < TotalAmount;

  --1.2
SELECT
    Id,
    InvoiceNumber,
    StudentId,
    TotalAmount,
    PaidAmount,
  [Remaining Amount],
   [Days Late],
    CASE
        WHEN [Days Late] > 60 OR [Remaining Amount] > 10000 THEN 'Urgent'
        WHEN [Days Late] > 30 THEN 'Medium'
        ELSE 'Low'
    END AS Priority
FROM #FinanceWorkingList;

--1.3
AltER TABLE #FinanceWorkingList
       ADD Priority CHAR(10);

UPDATE #FinanceWorkingList
    SET Priority = CASE
     WHEN [Days Late] > 60 OR [Remaining Amount] > 10000 THEN 'Urgent'
        WHEN [Days Late] > 30 THEN 'Medium'
        ELSE 'Low'
END;

SELECT *
FROM #FinanceWorkingList
ORDER BY
    CASE Priority
        WHEN 'Urgent' THEN 1
        WHEN 'Medium' THEN 2
        ELSE 3
    END,
 [Remaining Amount] DESC;
