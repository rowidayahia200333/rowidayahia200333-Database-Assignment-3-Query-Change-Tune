--TASK 4
INSERT INTO delivery.Sections ( CourseId, TermId, SectionCode, Capacity,
                           CreatedAtUtc, DeliveryMode,Status)
SELECT
    CourseId,
    13 AS TermId,
    SectionCode,
    Capacity,
    SYSDATETIME() AS CreatedAtUtc,
    DeliveryMode,
    Status
FROM delivery.Sections
WHERE TermId = 12;


SELECT *
FROM delivery.Sections
WHERE TermId = 13
ORDER BY Id DESC;