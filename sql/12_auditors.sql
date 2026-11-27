--12.1
UPDATE academic.Courses
SET PassingScore = 70.00
OUTPUT
    deleted.Id,
    deleted.Code,
    deleted.PassingScore AS OldPassingScore,
    inserted.PassingScore AS NewPassingScore,
    SYSUTCDATETIME() AS ChangedAtUtc,
    SUSER_SNAME() AS ChangedBy
WHERE DepartmentId = 2;

--12.2
SELECT TOP 0
    Id + 0 AS Id,
    SectionId,
    Title,
    Body,
    PublishedAtUtc,
    ExpiresAtUtc,
    CreatedByUserId,
    CreatedAtUtc,
    UpdatedAtUtc,
    Status
INTO communication.AnnouncementsArchive
FROM communication.Announcements;

select  Id + 0 AS Id,
    SectionId,
    Title,
    Body,
    PublishedAtUtc,
    ExpiresAtUtc,
    CreatedByUserId,
    CreatedAtUtc,
    UpdatedAtUtc,
    Status
    from communication.AnnouncementsArchive;

    DELETE FROM communication.Announcements
OUTPUT
    deleted.Id,
    deleted.SectionId,
    deleted.Title,
    deleted.Body,
    deleted.PublishedAtUtc,
    deleted.ExpiresAtUtc,
    deleted.CreatedByUserId,
    deleted.CreatedAtUtc,
    deleted.UpdatedAtUtc,
    deleted.Status
INTO communication.AnnouncementsArchive
WHERE ExpiresAtUtc IS NOT NULL
  AND ExpiresAtUtc < DATEADD(MONTH, -6, SYSUTCDATETIME());