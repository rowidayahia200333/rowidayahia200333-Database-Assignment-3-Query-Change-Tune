--2.1
INSERT INTO academic.Departments (Code, Name,IsActive, CreatedAtUtc, IsDeleted)
VALUES (
    'DSAI',
    'Data Science & Artificial Intelligence', 
    1,
    SYSDATETIME(),
    0
);

--2.2
INSERT INTO  [academic].[Courses]  ( DepartmentId,Code,Title,CreditHours,PassingScore,IsActive,CreatedAtUtc)
VALUES ((SELECT Id FROM academic.Departments WHERE Code = 'DSAI'),
    'DSAI-101',
    'Introduction to Data Analysis',
    3,
    60,
    1,
   SYSDATETIME()
);

--2.3
INSERT INTO delivery.AcademicTerms (AcademicYear, TermCode,Name,
                                  StartDate, EndDate, 
                                  RegistrationStartDate,RegistrationEndDate,Status)
VALUES (
    2027,
    'SUM2027',
    'Summer 2027',
    '2027-06-15',
    '2027-08-31',
    '2027-05-01',
    '2027-06-10',
    1
);

--2.4
INSERT INTO communication.Announcements (Title, Body, CreatedByUserId, CreatedAtUtc,
                                          UpdatedAtUtc, Status)
VALUES (   
    'Summer 2027 Registration Opens on 1 May',
    'Registration for the Summer 2027 term opens on 1 May for all students.',
    (SELECT TOP 1 Id FROM [identity].Users ORDER BY Id),
   SYSDATETIME(),
    SYSDATETIME(),
    1
);

--2.5
INSERT INTO [identity].Roles (Code, Name, IsSystem, IsDeleted)
VALUES (
    'TA',
    'Teaching Assistant',
    0,
    0
);
