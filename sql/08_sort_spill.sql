-- task 8
SET STATISTICS IO, TIME ON;

DECLARE @TargetDate DATETIME2 = '2020-01-01';

SELECT
    i.Id,
    i.InvoiceNumber,
    i.StudentId,
    i.TotalAmount,
    i.PaidAmount,
    i.DueAtUtc,
    i.CreatedAtUtc,
    i.Status
FROM finance.Invoices AS i
WHERE i.DueAtUtc > @TargetDate
ORDER BY i.TotalAmount DESC, i.DueAtUtc DESC, i.InvoiceNumber DESC;

SET STATISTICS IO, TIME OFF;

-- use variable @TargetDate تقدير اقل من الحقيقي في المساحة المستخدمة و ال sort في order by بكذا اوبشن في حين ان ممكن نخيرة بدل كدا باستخدام option(recomile)

SET STATISTICS IO, TIME ON;

DECLARE @TargetDate DATETIME2 = '2020-01-01';

SELECT
    i.Id,
    i.InvoiceNumber,
    i.StudentId,
    i.TotalAmount,
    i.PaidAmount,
    i.DueAtUtc,
    i.CreatedAtUtc,
    i.Status
FROM finance.Invoices AS i
WHERE i.DueAtUtc > @TargetDate
ORDER BY i.TotalAmount DESC, i.DueAtUtc DESC, i.InvoiceNumber DESC
OPTION (RECOMPILE);

SET STATISTICS IO, TIME OFF;