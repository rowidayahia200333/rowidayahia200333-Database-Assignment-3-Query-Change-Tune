
  --task 13
 CREATE TABLE dbo.WebsiteCourseCatalog
(
    CourseId    INT           NOT NULL PRIMARY KEY,
    Code        NVARCHAR(50)  NOT NULL,
    Title       NVARCHAR(200) NOT NULL,
    CreditHours DECIMAL(5, 2) NOT NULL,
    IsVisible   BIT           NOT NULL DEFAULT 1
);

WITH ActiveSource AS
(
    SELECT
        Id AS CourseId,
        Code,
        Title,
        CreditHours,
        CAST(1 AS BIT) AS IsVisible
    FROM academic.Courses
    WHERE IsActive = 1
)
INSERT INTO dbo.WebsiteCourseCatalog (CourseId, Code, Title, CreditHours, IsVisible)
OUTPUT
    N'INSERTED' AS ActionType,
    inserted.CourseId,
    inserted.Code,
    inserted.Title,
    inserted.CreditHours,
    inserted.IsVisible
SELECT
    s.CourseId,
    s.Code,
    s.Title,
    s.CreditHours,
    s.IsVisible
FROM ActiveSource AS s
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.WebsiteCourseCatalog AS w
    WHERE w.CourseId = s.CourseId
);

WITH SourceCourses AS
(
    SELECT
        Id AS CourseId,
        Code,
        Title,
        CreditHours,
        CAST(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END AS BIT) AS TargetVisible
    FROM academic.Courses
)
UPDATE w
SET
    w.Code        = s.Code,
    w.Title       = s.Title,
    w.CreditHours = s.CreditHours,
    w.IsVisible   = s.TargetVisible
OUTPUT
    CASE
        WHEN inserted.IsVisible = 0 AND deleted.IsVisible = 1 THEN N'HIDDEN'
        ELSE N'UPDATED'
    END AS ActionType,
    inserted.CourseId,
    deleted.Code        AS OldCode,
    inserted.Code       AS NewCode,
    deleted.Title       AS OldTitle,
    inserted.Title      AS NewTitle,
    deleted.CreditHours AS OldCredits,
    inserted.CreditHours AS NewCredits,
    deleted.IsVisible   AS OldVisible,
    inserted.IsVisible  AS NewVisible
FROM dbo.WebsiteCourseCatalog AS w
JOIN SourceCourses AS s
    ON w.CourseId = s.CourseId
WHERE
    (
        s.TargetVisible = 1
        AND (
            w.Code <> s.Code
            OR w.Title <> s.Title
            OR w.CreditHours <> s.CreditHours
            OR w.IsVisible <> 1
        )
    )
    OR
    (
        s.TargetVisible = 0
        AND w.IsVisible <> 0
    );

UPDATE academic.Courses
SET Title = N'Programming Fundamentals Updated'
WHERE Id = 1;

UPDATE academic.Courses
SET IsActive = 0
WHERE Id = 2;

SELECT CourseId, Code, Title, CreditHours, IsVisible
FROM dbo.WebsiteCourseCatalog
WHERE CourseId IN (1, 2)
ORDER BY CourseId;