
 CREATE DATABASE SMEMS;
 GO 

USE SMEMS;
GO 

-- DEPARTMENTS


CREATE TABLE Departments
(
    DepartmentId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(100) NOT NULL UNIQUE,

    Description NVARCHAR(500),

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

-- ROLES


CREATE TABLE Roles
(
    RoleId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(50) NOT NULL UNIQUE,

    Description NVARCHAR(300),

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

-- PERMISSIONS


CREATE TABLE Permissions
(
    PermissionId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(100) NOT NULL UNIQUE,

    Module NVARCHAR(100),

    Description NVARCHAR(500),

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- ROLE PERMISSIONS


CREATE TABLE RolePermissions
(
    RolePermissionId INT PRIMARY KEY IDENTITY(1,1),

    RoleId INT NOT NULL
        REFERENCES Roles(RoleId),

    PermissionId INT NOT NULL
        REFERENCES Permissions(PermissionId),

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

-- USERS


CREATE TABLE Users
(
    UserId INT PRIMARY KEY IDENTITY(1,1),

    FullName NVARCHAR(150) NOT NULL,

    Username NVARCHAR(100) NOT NULL UNIQUE,

    Email NVARCHAR(200) NOT NULL UNIQUE,

    Phone NVARCHAR(50),

    PasswordHash NVARCHAR(500) NOT NULL,

    Avatar NVARCHAR(300),

    Position NVARCHAR(100),

    RoleId INT NOT NULL
        REFERENCES Roles(RoleId),

    DepartmentId INT NULL
        REFERENCES Departments(DepartmentId),

    IsActive BIT NOT NULL DEFAULT 1,

    LastLoginAt DATETIME2,

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- PASSWORD RESET TOKENS


CREATE TABLE PasswordResetTokens
(
    TokenId INT PRIMARY KEY IDENTITY(1,1),

    UserId INT NOT NULL
        REFERENCES Users(UserId),

    Token NVARCHAR(300) NOT NULL,

    ExpiresAt DATETIME2 NOT NULL,

    IsUsed BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- MANUFACTURERS


CREATE TABLE Manufacturers
(
    ManufacturerId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(150) NOT NULL UNIQUE,

    ContactPerson NVARCHAR(150),

    Email NVARCHAR(150),

    Phone NVARCHAR(50),

    Address NVARCHAR(300),

    Website NVARCHAR(200),

    Notes NVARCHAR(MAX),

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- SUPPLIERS


CREATE TABLE Suppliers
(
    SupplierId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(150) NOT NULL UNIQUE,

    ContactPerson NVARCHAR(150),

    Email NVARCHAR(150),

    Phone NVARCHAR(50),

    Address NVARCHAR(300),

    Website NVARCHAR(200),

    Notes NVARCHAR(MAX),

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

-- DEVICE STATUSES


CREATE TABLE DeviceStatuses
(
    StatusId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(100) NOT NULL UNIQUE,

    CssClass NVARCHAR(50)
);


-- RISK LEVELS


CREATE TABLE RiskLevels
(
    RiskLevelId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(100) NOT NULL UNIQUE,

    CssClass NVARCHAR(50)
);


-- DEVICES


CREATE TABLE Devices
(
    DeviceId INT PRIMARY KEY IDENTITY(1,1),

    DeviceCode NVARCHAR(50) NOT NULL UNIQUE,

    Name NVARCHAR(200) NOT NULL,

    ModelNumber NVARCHAR(100),

    SerialNumber NVARCHAR(100) NOT NULL UNIQUE,

    ManufacturerId INT NULL
        REFERENCES Manufacturers(ManufacturerId),

    SupplierId INT NULL
        REFERENCES Suppliers(SupplierId),

    DepartmentId INT NOT NULL
        REFERENCES Departments(DepartmentId),

    StatusId INT NOT NULL
        REFERENCES DeviceStatuses(StatusId),

    RiskLevelId INT NOT NULL
        REFERENCES RiskLevels(RiskLevelId),

    Location NVARCHAR(200),

    PurchaseDate DATE,

    WarrantyExpiry DATE,

    ExpectedLifespan NVARCHAR(100),

    FailureCount INT NOT NULL DEFAULT 0,

    NextMaintenanceDate DATE,

    Notes NVARCHAR(MAX),

    CreatedByUserId INT NULL
        REFERENCES Users(UserId),

    UpdatedByUserId INT NULL
        REFERENCES Users(UserId),

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- ACCESSORIES


CREATE TABLE Accessories
(
    AccessoryId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(150) NOT NULL UNIQUE,

    Description NVARCHAR(500),

    QuantityInStock INT NOT NULL DEFAULT 0,

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- DEVICE ACCESSORIES


CREATE TABLE DeviceAccessories
(
    DeviceAccessoryId INT PRIMARY KEY IDENTITY(1,1),

    DeviceId INT NOT NULL
        REFERENCES Devices(DeviceId),

    AccessoryId INT NOT NULL
        REFERENCES Accessories(AccessoryId),

    Quantity INT NOT NULL DEFAULT 1,

    Notes NVARCHAR(500),

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- MAINTENANCE TYPES


CREATE TABLE MaintenanceTypes
(
    TypeId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(100) NOT NULL UNIQUE
);


-- MAINTENANCE STATUSES


CREATE TABLE MaintenanceStatuses
(
    StatusId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(100) NOT NULL UNIQUE,

    CssClass NVARCHAR(50)
);


-- MAINTENANCE REQUESTS


CREATE TABLE MaintenanceRequests
(
    RequestId INT PRIMARY KEY IDENTITY(1,1),

    RequestCode NVARCHAR(50) NOT NULL UNIQUE,

    DeviceId INT NOT NULL
        REFERENCES Devices(DeviceId),

    ReportedByUserId INT NOT NULL
        REFERENCES Users(UserId),

    AssignedEngineerUserId INT NULL
        REFERENCES Users(UserId),

    MaintenanceTypeId INT NULL
        REFERENCES MaintenanceTypes(TypeId),

    StatusId INT NOT NULL
        REFERENCES MaintenanceStatuses(StatusId),

    RiskLevelId INT NOT NULL
        REFERENCES RiskLevels(RiskLevelId),

    IssueTitle NVARCHAR(300) NOT NULL,

    IssueDescription NVARCHAR(MAX),

    EngineerNotes NVARCHAR(MAX),

    CompletionNotes NVARCHAR(MAX),

    HasAlternative BIT NOT NULL DEFAULT 0,

    RequestDate DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    StartedAt DATETIME2,

    CompletedAt DATETIME2,

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- MAINTENANCE LOGS


CREATE TABLE MaintenanceLogs
(
    LogId INT PRIMARY KEY IDENTITY(1,1),

    DeviceId INT NOT NULL
        REFERENCES Devices(DeviceId),

    RequestId INT NULL
        REFERENCES MaintenanceRequests(RequestId),

    MaintenanceTypeId INT NOT NULL
        REFERENCES MaintenanceTypes(TypeId),

    PerformedByUserId INT NULL
        REFERENCES Users(UserId),

    MaintenanceDate DATE NOT NULL,

    Details NVARCHAR(MAX),

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- PARTS


CREATE TABLE Parts
(
    PartId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(150) NOT NULL,

    PartNumber NVARCHAR(100),

    ManufacturerId INT NULL
        REFERENCES Manufacturers(ManufacturerId),

    QuantityInStock INT NOT NULL DEFAULT 0,

    UnitPrice DECIMAL(18,2),

    MinimumStockLevel INT DEFAULT 0,

    Notes NVARCHAR(MAX),

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- MAINTENANCE PARTS


CREATE TABLE MaintenanceParts
(
    MaintenancePartId INT PRIMARY KEY IDENTITY(1,1),

    MaintenanceRequestId INT NOT NULL
        REFERENCES MaintenanceRequests(RequestId),

    PartId INT NOT NULL
        REFERENCES Parts(PartId),

    QuantityUsed INT NOT NULL DEFAULT 1,

    UnitPrice DECIMAL(18,2),

    Notes NVARCHAR(500),

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

-- FILES


CREATE TABLE Files
(
    FileId INT PRIMARY KEY IDENTITY(1,1),

    FileName NVARCHAR(255) NOT NULL,

    OriginalFileName NVARCHAR(255),

    FilePath NVARCHAR(500) NOT NULL,

    Extension NVARCHAR(20),

    ContentType NVARCHAR(100),

    FileSize BIGINT,

    UploadedByUserId INT NULL
        REFERENCES Users(UserId),

    UploadedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    IsDeleted BIT NOT NULL DEFAULT 0
);


-- DEVICE FILES


CREATE TABLE DeviceFiles
(
    DeviceFileId INT PRIMARY KEY IDENTITY(1,1),

    DeviceId INT NOT NULL
        REFERENCES Devices(DeviceId),

    FileId INT NOT NULL
        REFERENCES Files(FileId),

    FileType NVARCHAR(100),

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- MAINTENANCE ATTACHMENTS


CREATE TABLE MaintenanceAttachments
(
    AttachmentId INT PRIMARY KEY IDENTITY(1,1),

    MaintenanceRequestId INT NOT NULL
        REFERENCES MaintenanceRequests(RequestId),

    FileId INT NOT NULL
        REFERENCES Files(FileId),

    Description NVARCHAR(500),

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- DEVICE WARRANTIES


CREATE TABLE DeviceWarranties
(
    WarrantyId INT PRIMARY KEY IDENTITY(1,1),

    DeviceId INT NOT NULL
        REFERENCES Devices(DeviceId),

    StartDate DATE NOT NULL,

    EndDate DATE NOT NULL,

    WarrantyProvider NVARCHAR(150),

    Terms NVARCHAR(MAX),

    FileId INT NULL
        REFERENCES Files(FileId),

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

-- NOTIFICATION TYPES


CREATE TABLE NotificationTypes
(
    TypeId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(100) NOT NULL UNIQUE,

    Icon NVARCHAR(50)
);

-- NOTIFICATION PRIORITY LEVELS


CREATE TABLE NotificationPriorityLevels
(
    LevelId INT PRIMARY KEY IDENTITY(1,1),

    Name NVARCHAR(50) NOT NULL UNIQUE,

    CssClass NVARCHAR(50)
);

-- NOTIFICATIONS


CREATE TABLE Notifications
(
    NotificationId INT PRIMARY KEY IDENTITY(1,1),

    Title NVARCHAR(200) NOT NULL,

    Message NVARCHAR(1000) NOT NULL,

    TypeId INT NOT NULL
        REFERENCES NotificationTypes(TypeId),

    PriorityLevelId INT NULL
        REFERENCES NotificationPriorityLevels(LevelId),

    RelatedEntityType NVARCHAR(100),

    RelatedEntityId INT,

    IsGlobal BIT NOT NULL DEFAULT 0,

    IsDeleted BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- USER NOTIFICATIONS


CREATE TABLE UserNotifications
(
    UserNotificationId INT PRIMARY KEY IDENTITY(1,1),

    UserId INT NOT NULL
        REFERENCES Users(UserId),

    NotificationId INT NOT NULL
        REFERENCES Notifications(NotificationId),

    IsRead BIT NOT NULL DEFAULT 0,

    ReadAt DATETIME2,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- REPORTS


CREATE TABLE Reports
(
    ReportId INT PRIMARY KEY IDENTITY(1,1),

    Title NVARCHAR(200) NOT NULL,

    ReportType NVARCHAR(100),

    Format NVARCHAR(50),

    Parameters NVARCHAR(MAX),

    GeneratedByUserId INT NOT NULL
        REFERENCES Users(UserId),

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- REPORT FILES


CREATE TABLE ReportFiles
(
    ReportFileId INT PRIMARY KEY IDENTITY(1,1),

    ReportId INT NOT NULL
        REFERENCES Reports(ReportId),

    FileId INT NOT NULL
        REFERENCES Files(FileId),

    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- AUDIT LOGS


CREATE TABLE AuditLogs
(
    AuditLogId INT PRIMARY KEY IDENTITY(1,1),

    UserId INT NULL
        REFERENCES Users(UserId),

    Action NVARCHAR(100) NOT NULL,

    EntityType NVARCHAR(100) NOT NULL,

    EntityId INT,

    OldValues NVARCHAR(MAX),

    NewValues NVARCHAR(MAX),

    IpAddress NVARCHAR(100),

    UserAgent NVARCHAR(500),

    OccurredAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- SYSTEM LOGS


CREATE TABLE SystemLogs
(
    SystemLogId INT PRIMARY KEY IDENTITY(1,1),

    Level NVARCHAR(50) NOT NULL,

    Source NVARCHAR(200),

    Message NVARCHAR(MAX),

    Exception NVARCHAR(MAX),

    UserId INT NULL
        REFERENCES Users(UserId),

    IpAddress NVARCHAR(100),

    OccurredAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);


-- INDEXES


CREATE INDEX IX_Devices_DepartmentId ON Devices(DepartmentId);
CREATE INDEX IX_Devices_StatusId ON Devices(StatusId);
CREATE INDEX IX_Devices_RiskLevelId ON Devices(RiskLevelId);

CREATE INDEX IX_MaintenanceRequests_DeviceId ON MaintenanceRequests(DeviceId);
CREATE INDEX IX_MaintenanceRequests_StatusId ON MaintenanceRequests(StatusId);

CREATE INDEX IX_Notifications_TypeId ON Notifications(TypeId);

CREATE INDEX IX_AuditLogs_UserId ON AuditLogs(UserId);

CREATE INDEX IX_SystemLogs_Level ON SystemLogs(Level);





-- Departments
INSERT INTO Departments (Name, Description)
VALUES
(N'Radiology', N'Medical imaging and diagnostic services'),
(N'ICU', N'Critical intensive care unit'),
(N'Emergency', N'Emergency and trauma response'),
(N'Cardiology', N'Heart and cardiovascular treatment'),
(N'Laboratory', N'Diagnostic and pathology laboratory'),
(N'Surgery', N'Operating rooms and surgical care'),
(N'Pediatrics', N'Child healthcare services'),
(N'NICU', N'Neonatal intensive care'),
(N'Oncology', N'Cancer treatment center'),
(N'Dialysis', N'Renal dialysis treatment'),
(N'Respiratory Therapy', N'Respiratory support services'),
(N'Internal Medicine', N'General medical care'),
(N'Sterilization', N'Medical equipment sterilization'),
(N'Biomedical Engineering', N'Medical equipment maintenance'),
(N'Pharmacy', N'Medication dispensing services');


-- Roles
INSERT INTO Roles (Name, Description)
VALUES
(N'Administrator', N'System administration'),
(N'BiomedicalEngineer', N'Biomedical equipment engineer'),
(N'MedicalStaff', N'Doctors and nurses');



-- Permissions
INSERT INTO Permissions (Name, Module, Description)
VALUES
(N'VIEW_DEVICES', N'System', N'VIEW DEVICES permission'),
(N'CREATE_DEVICE', N'System', N'CREATE DEVICE permission'),
(N'UPDATE_DEVICE', N'System', N'UPDATE DEVICE permission'),
(N'DELETE_DEVICE', N'System', N'DELETE DEVICE permission'),
(N'VIEW_MAINTENANCE', N'System', N'VIEW MAINTENANCE permission'),
(N'CREATE_MAINTENANCE', N'System', N'CREATE MAINTENANCE permission'),
(N'ASSIGN_ENGINEER', N'System', N'ASSIGN ENGINEER permission'),
(N'COMPLETE_MAINTENANCE', N'System', N'COMPLETE MAINTENANCE permission'),
(N'VIEW_REPORTS', N'System', N'VIEW REPORTS permission'),
(N'GENERATE_REPORTS', N'System', N'GENERATE REPORTS permission'),
(N'VIEW_USERS', N'System', N'VIEW USERS permission'),
(N'CREATE_USERS', N'System', N'CREATE USERS permission'),
(N'UPDATE_USERS', N'System', N'UPDATE USERS permission'),
(N'DELETE_USERS', N'System', N'DELETE USERS permission'),
(N'VIEW_NOTIFICATIONS', N'System', N'VIEW NOTIFICATIONS permission'),
(N'MANAGE_FILES', N'System', N'MANAGE FILES permission'),
(N'VIEW_LOGS', N'System', N'VIEW LOGS permission'),
(N'VIEW_PARTS', N'System', N'VIEW PARTS permission'),
(N'MANAGE_PARTS', N'System', N'MANAGE PARTS permission'),
(N'VIEW_DASHBOARD', N'System', N'VIEW DASHBOARD permission');





-- RolePermissions
INSERT INTO RolePermissions (RoleId, PermissionId)
VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(1,6),
(1,7),
(1,8),
(1,9),
(1,10),
(1,11),
(1,12),
(1,13),
(1,14),
(1,15),
(1,16),
(1,17),
(1,18),
(1,19),
(1,20),

(2,1),
(2,2),
(2,3),
(2,5),
(2,6),
(2,7),
(2,8),
(2,9),
(2,10),
(2,15),
(2,16),
(2,18),
(2,19),
(2,20),

(3,1),
(3,5),
(3,9),
(3,15),
(3,20);










INSERT INTO Users (FullName, Username, Email, Phone, PasswordHash, Position, RoleId, DepartmentId, LastLoginAt) VALUES 
(N'Heba Nasser', N'heba.nasser1', N'heba.nasser1@smems.jo', N'+962795416585', N'$2a$11$3euPcmQFCiblsZeEu5s7p.9KQ2eX6pYQjM0f4b5v6d7n8o9p0q1r2', N'Hospital System Administrator', 1, 6, DATEADD(day,-30,GETUTCDATE())),
(N'Heba Saleh', N'heba.saleh2', N'heba.saleh2@smems.jo', N'+962792870522', N'$2a$11$3euPcmQFCiblsZeEu5s7p.9KQ2eX6pYQjM0f4b5v6d7n8o9p0q1r2', N'Hospital System Administrator', 1, 8, DATEADD(day,-28,GETUTCDATE())),
(N'Noor Almasri', N'noor.almasri3', N'noor.almasri3@smems.jo', N'+962786172235', N'$2a$11$3euPcmQFCiblsZeEu5s7p.9KQ2eX6pYQjM0f4b5v6d7n8o9p0q1r2', N'Hospital System Administrator', 1, 2, DATEADD(day,-8,GETUTCDATE())),
(N'Mohammad Hamdan', N'mohammad.hamdan4', N'mohammad.hamdan4@smems.jo', N'+962791262161', N'$2a$11$3euPcmQFCiblsZeEu5s7p.9KQ2eX6pYQjM0f4b5v6d7n8o9p0q1r2', N'Hospital System Administrator', 1, 13, DATEADD(day,-7,GETUTCDATE())),
(N'Samer Nasser', N'samer.nasser5', N'samer.nasser5@smems.jo', N'+962796848961', N'$2a$11$3euPcmQFCiblsZeEu5s7p.9KQ2eX6pYQjM0f4b5v6d7n8o9p0q1r2', N'Hospital System Administrator', 1, 6, DATEADD(day,-13,GETUTCDATE())),
(N'Sarah Mustafa', N'sarah.mustafa6', N'sarah.mustafa6@smems.jo', N'+962787973495', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 12, DATEADD(day,-26,GETUTCDATE())),
(N'Khaled Nasser', N'khaled.nasser7', N'khaled.nasser7@smems.jo', N'+962779639838', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 7, DATEADD(day,-21,GETUTCDATE())),
(N'Fadi AbuZaid', N'fadi.abuzaid8', N'fadi.abuzaid8@smems.jo', N'+962772551103', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Maintenance Engineer', 2, 15, DATEADD(day,-5,GETUTCDATE())),
(N'Dana AbuZaid', N'dana.abuzaid9', N'dana.abuzaid9@smems.jo', N'+962781862764', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 15, DATEADD(day,-18,GETUTCDATE())),
(N'Khaled Khalil', N'khaled.khalil10', N'khaled.khalil10@smems.jo', N'+962795036849', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Maintenance Engineer', 2, 15, DATEADD(day,-29,GETUTCDATE())),
(N'Omar Saleh', N'omar.saleh11', N'omar.saleh11@smems.jo', N'+962794733382', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 4, DATEADD(day,-23,GETUTCDATE())),
(N'Omar Qudah', N'omar.qudah12', N'omar.qudah12@smems.jo', N'+962776938339', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 4, DATEADD(day,-26,GETUTCDATE())),
(N'Omar Shraim', N'omar.shraim13', N'omar.shraim13@smems.jo', N'+962781946296', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 13, DATEADD(day,-3,GETUTCDATE())),
(N'Mohammad Haddad', N'mohammad.haddad14', N'mohammad.haddad14@smems.jo', N'+962792676491', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Maintenance Engineer', 2, 8, DATEADD(day,-19,GETUTCDATE())),
(N'Ahmad Mustafa', N'ahmad.mustafa15', N'ahmad.mustafa15@smems.jo', N'+962771418115', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Clinical Engineer', 2, 6, DATEADD(day,-19,GETUTCDATE())),
(N'Sarah Saleh', N'sarah.saleh16', N'sarah.saleh16@smems.jo', N'+962799561026', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Maintenance Engineer', 2, 14, DATEADD(day,-8,GETUTCDATE())),
(N'Dana Khalil', N'dana.khalil17', N'dana.khalil17@smems.jo', N'+962795644388', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Maintenance Engineer', 2, 5, DATEADD(day,-12,GETUTCDATE())),
(N'Omar Shraim', N'omar.shraim18', N'omar.shraim18@smems.jo', N'+962774303220', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 9, DATEADD(day,-25,GETUTCDATE())),
(N'Lina Saleh', N'lina.saleh19', N'lina.saleh19@smems.jo', N'+962788145161', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 9, DATEADD(day,-11,GETUTCDATE())),
(N'Lina Khalil', N'lina.khalil20', N'lina.khalil20@smems.jo', N'+962785340953', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 12, DATEADD(day,-16,GETUTCDATE())),
(N'Dana AbuZaid', N'dana.abuzaid21', N'dana.abuzaid21@smems.jo', N'+962793126068', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 1, DATEADD(day,-21,GETUTCDATE())),
(N'Omar Hamdan', N'omar.hamdan22', N'omar.hamdan22@smems.jo', N'+962789495400', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 6, DATEADD(day,-11,GETUTCDATE())),
(N'Noor Qudah', N'noor.qudah23', N'noor.qudah23@smems.jo', N'+962776279793', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Maintenance Engineer', 2, 5, DATEADD(day,-7,GETUTCDATE())),
(N'Khaled Saleh', N'khaled.saleh24', N'khaled.saleh24@smems.jo', N'+962790571686', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Clinical Engineer', 2, 6, DATEADD(day,-5,GETUTCDATE())),
(N'Dana Hamdan', N'dana.hamdan25', N'dana.hamdan25@smems.jo', N'+962777064297', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Clinical Engineer', 2, 12, DATEADD(day,-24,GETUTCDATE())),
(N'Sarah AbuZaid', N'sarah.abuzaid26', N'sarah.abuzaid26@smems.jo', N'+962798666426', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Clinical Engineer', 2, 5, DATEADD(day,-14,GETUTCDATE())),
(N'Yousef Shraim', N'yousef.shraim27', N'yousef.shraim27@smems.jo', N'+962774400300', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Maintenance Engineer', 2, 11, DATEADD(day,-7,GETUTCDATE())),
(N'Maya Haddad', N'maya.haddad28', N'maya.haddad28@smems.jo', N'+962794186553', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Clinical Engineer', 2, 13, DATEADD(day,-7,GETUTCDATE())),
(N'Rana Hamdan', N'rana.hamdan29', N'rana.hamdan29@smems.jo', N'+962798732953', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Clinical Engineer', 2, 4, DATEADD(day,-4,GETUTCDATE())),
(N'Heba Khalil', N'heba.khalil30', N'heba.khalil30@smems.jo', N'+962785870810', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Biomedical Engineer', 2, 3, DATEADD(day,-13,GETUTCDATE())),
(N'Dana Khalil', N'dana.khalil31', N'dana.khalil31@smems.jo', N'+962799973181', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Maintenance Engineer', 2, 9, DATEADD(day,-17,GETUTCDATE())),
(N'Fadi AbuZaid', N'fadi.abuzaid32', N'fadi.abuzaid32@smems.jo', N'+962796351400', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Clinical Engineer', 2, 5, DATEADD(day,-8,GETUTCDATE())),
(N'Rana Shraim', N'rana.shraim33', N'rana.shraim33@smems.jo', N'+962771600858', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Clinical Engineer', 2, 2, DATEADD(day,-22,GETUTCDATE())),
(N'Yousef Almasri', N'yousef.almasri34', N'yousef.almasri34@smems.jo', N'+962777229883', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Clinical Engineer', 2, 8, DATEADD(day,-26,GETUTCDATE())),
(N'Samer Haddad', N'samer.haddad35', N'samer.haddad35@smems.jo', N'+962785094622', N'$2a$11$8kP7M2x6M6L0Y0M8uTt1ye7XbHfTzV1d1sX9m0Y2q8jR4uE1zT8lK', N'Maintenance Engineer', 2, 6, DATEADD(day,-8,GETUTCDATE())),
(N'Sarah AbuZaid', N'sarah.abuzaid36', N'sarah.abuzaid36@smems.jo', N'+962788802227', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'ICU Nurse', 3, 6, DATEADD(day,-0,GETUTCDATE())),
(N'Lina Haddad', N'lina.haddad37', N'lina.haddad37@smems.jo', N'+962781780641', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 10, DATEADD(day,-18,GETUTCDATE())),
(N'Samer Mustafa', N'samer.mustafa38', N'samer.mustafa38@smems.jo', N'+962775856551', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'ICU Nurse', 3, 6, DATEADD(day,-10,GETUTCDATE())),
(N'Samer Mustafa', N'samer.mustafa39', N'samer.mustafa39@smems.jo', N'+962786357575', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 15, DATEADD(day,-2,GETUTCDATE())),
(N'Lina Shraim', N'lina.shraim40', N'lina.shraim40@smems.jo', N'+962779614135', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 11, DATEADD(day,-30,GETUTCDATE())),
(N'Yousef Khalil', N'yousef.khalil41', N'yousef.khalil41@smems.jo', N'+962791494319', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'ICU Nurse', 3, 7, DATEADD(day,-20,GETUTCDATE())),
(N'Noor Shraim', N'noor.shraim42', N'noor.shraim42@smems.jo', N'+962783581918', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Registered Nurse', 3, 2, DATEADD(day,-5,GETUTCDATE())),
(N'Sarah Nasser', N'sarah.nasser43', N'sarah.nasser43@smems.jo', N'+962780518712', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'ICU Nurse', 3, 11, DATEADD(day,-9,GETUTCDATE())),
(N'Fadi Qudah', N'fadi.qudah44', N'fadi.qudah44@smems.jo', N'+962790313348', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 5, DATEADD(day,-28,GETUTCDATE())),
(N'Dana AbuZaid', N'dana.abuzaid45', N'dana.abuzaid45@smems.jo', N'+962795095208', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 7, DATEADD(day,-5,GETUTCDATE())),
(N'Yousef Almasri', N'yousef.almasri46', N'yousef.almasri46@smems.jo', N'+962774195643', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 11, DATEADD(day,-8,GETUTCDATE())),
(N'Fadi Haddad', N'fadi.haddad47', N'fadi.haddad47@smems.jo', N'+962777065606', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 7, DATEADD(day,-3,GETUTCDATE())),
(N'Mohammad Haddad', N'mohammad.haddad48', N'mohammad.haddad48@smems.jo', N'+962799483976', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 9, DATEADD(day,-1,GETUTCDATE())),
(N'Ahmad Hamdan', N'ahmad.hamdan49', N'ahmad.hamdan49@smems.jo', N'+962787581944', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Registered Nurse', 3, 2, DATEADD(day,-8,GETUTCDATE())),
(N'Noor Khalil', N'noor.khalil50', N'noor.khalil50@smems.jo', N'+962772829016', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 5, DATEADD(day,-7,GETUTCDATE())),
(N'Omar Qudah', N'omar.qudah51', N'omar.qudah51@smems.jo', N'+962784869996', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 3, DATEADD(day,-16,GETUTCDATE())),
(N'Maya Khalil', N'maya.khalil52', N'maya.khalil52@smems.jo', N'+962770958693', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Registered Nurse', 3, 11, DATEADD(day,-11,GETUTCDATE())),
(N'Maya AbuZaid', N'maya.abuzaid53', N'maya.abuzaid53@smems.jo', N'+962798999120', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 8, DATEADD(day,-27,GETUTCDATE())),
(N'Rana Qudah', N'rana.qudah54', N'rana.qudah54@smems.jo', N'+962788406125', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 3, DATEADD(day,-30,GETUTCDATE())),
(N'Fadi Mustafa', N'fadi.mustafa55', N'fadi.mustafa55@smems.jo', N'+962775940363', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 11, DATEADD(day,-23,GETUTCDATE())),
(N'Samer Shraim', N'samer.shraim56', N'samer.shraim56@smems.jo', N'+962784595418', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'ICU Nurse', 3, 15, DATEADD(day,-11,GETUTCDATE())),
(N'Dana Mustafa', N'dana.mustafa57', N'dana.mustafa57@smems.jo', N'+962777621165', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Registered Nurse', 3, 8, DATEADD(day,-9,GETUTCDATE())),
(N'Sarah Hamdan', N'sarah.hamdan58', N'sarah.hamdan58@smems.jo', N'+962778717677', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 5, DATEADD(day,-0,GETUTCDATE())),
(N'Ahmad Mustafa', N'ahmad.mustafa59', N'ahmad.mustafa59@smems.jo', N'+962797359605', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 6, DATEADD(day,-9,GETUTCDATE())),
(N'Dana Mustafa', N'dana.mustafa60', N'dana.mustafa60@smems.jo', N'+962770279075', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 13, DATEADD(day,-15,GETUTCDATE())),
(N'Khaled Almasri', N'khaled.almasri61', N'khaled.almasri61@smems.jo', N'+962795698306', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 13, DATEADD(day,-9,GETUTCDATE())),
(N'Noor Nasser', N'noor.nasser62', N'noor.nasser62@smems.jo', N'+962796735077', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Registered Nurse', 3, 9, DATEADD(day,-11,GETUTCDATE())),
(N'Omar Hamdan', N'omar.hamdan63', N'omar.hamdan63@smems.jo', N'+962799600447', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 7, DATEADD(day,-7,GETUTCDATE())),
(N'Yousef Hamdan', N'yousef.hamdan64', N'yousef.hamdan64@smems.jo', N'+962797797392', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 4, DATEADD(day,-8,GETUTCDATE())),
(N'Mohammad Hamdan', N'mohammad.hamdan65', N'mohammad.hamdan65@smems.jo', N'+962790982358', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 9, DATEADD(day,-24,GETUTCDATE())),
(N'Heba Shraim', N'heba.shraim66', N'heba.shraim66@smems.jo', N'+962797097718', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'ICU Nurse', 3, 5, DATEADD(day,-20,GETUTCDATE())),
(N'Fadi Mustafa', N'fadi.mustafa67', N'fadi.mustafa67@smems.jo', N'+962797139114', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'ICU Nurse', 3, 7, DATEADD(day,-6,GETUTCDATE())),
(N'Maya Haddad', N'maya.haddad68', N'maya.haddad68@smems.jo', N'+962776120569', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 5, DATEADD(day,-3,GETUTCDATE())),
(N'Samer Saleh', N'samer.saleh69', N'samer.saleh69@smems.jo', N'+962790727559', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 5, DATEADD(day,-22,GETUTCDATE())),
(N'Noor Saleh', N'noor.saleh70', N'noor.saleh70@smems.jo', N'+962776301168', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'ICU Nurse', 3, 1, DATEADD(day,-4,GETUTCDATE())),
(N'Ahmad Mustafa', N'ahmad.mustafa71', N'ahmad.mustafa71@smems.jo', N'+962770742589', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 2, DATEADD(day,-9,GETUTCDATE())),
(N'Khaled Khalil', N'khaled.khalil72', N'khaled.khalil72@smems.jo', N'+962793997993', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 12, DATEADD(day,-0,GETUTCDATE())),
(N'Omar Haddad', N'omar.haddad73', N'omar.haddad73@smems.jo', N'+962775056105', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Registered Nurse', 3, 8, DATEADD(day,-6,GETUTCDATE())),
(N'Sarah Hamdan', N'sarah.hamdan74', N'sarah.hamdan74@smems.jo', N'+962780454778', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 6, DATEADD(day,-14,GETUTCDATE())),
(N'Fadi Almasri', N'fadi.almasri75', N'fadi.almasri75@smems.jo', N'+962781081305', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Registered Nurse', 3, 14, DATEADD(day,-24,GETUTCDATE())),
(N'Yousef Almasri', N'yousef.almasri76', N'yousef.almasri76@smems.jo', N'+962778942376', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Radiology Technician', 3, 2, DATEADD(day,-17,GETUTCDATE())),
(N'Dana Khalil', N'dana.khalil77', N'dana.khalil77@smems.jo', N'+962776448903', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'ICU Nurse', 3, 14, DATEADD(day,-12,GETUTCDATE())),
(N'Maya Almasri', N'maya.almasri78', N'maya.almasri78@smems.jo', N'+962774092350', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 7, DATEADD(day,-24,GETUTCDATE())),
(N'Dana Nasser', N'dana.nasser79', N'dana.nasser79@smems.jo', N'+962794750386', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Registered Nurse', 3, 4, DATEADD(day,-14,GETUTCDATE())),
(N'Fadi Haddad', N'fadi.haddad80', N'fadi.haddad80@smems.jo', N'+962787486527', N'$2a$11$w3JxV7nC9eR2L0aXbM8pQu3fV9sYkR5tD1uB6mN7pQ2zL4xT5vK7e', N'Consultant Physician', 3, 8, DATEADD(day,-12,GETUTCDATE()));




-- PASSWORD RESET TOKENS
INSERT INTO PasswordResetTokens (UserId, Token, ExpiresAt, IsUsed)
VALUES
(37, NEWID(), DATEADD(hour,65,GETUTCDATE()), 0),
(66, NEWID(), DATEADD(hour,72,GETUTCDATE()), 1),
(30, NEWID(), DATEADD(hour,70,GETUTCDATE()), 0),
(73, NEWID(), DATEADD(hour,49,GETUTCDATE()), 1),
(40, NEWID(), DATEADD(hour,29,GETUTCDATE()), 0),
(72, NEWID(), DATEADD(hour,34,GETUTCDATE()), 1),
(9,  NEWID(), DATEADD(hour,14,GETUTCDATE()), 1),
(35, NEWID(), DATEADD(hour,68,GETUTCDATE()), 0),
(21, NEWID(), DATEADD(hour,28,GETUTCDATE()), 0),
(56, NEWID(), DATEADD(hour,61,GETUTCDATE()), 0),
(49, NEWID(), DATEADD(hour,31,GETUTCDATE()), 1),
(11, NEWID(), DATEADD(hour,53,GETUTCDATE()), 1),
(8,  NEWID(), DATEADD(hour,46,GETUTCDATE()), 1),
(22, NEWID(), DATEADD(hour,2,GETUTCDATE()), 0),
(59, NEWID(), DATEADD(hour,15,GETUTCDATE()), 1),
(60, NEWID(), DATEADD(hour,2,GETUTCDATE()), 1),
(48, NEWID(), DATEADD(hour,13,GETUTCDATE()), 1),
(63, NEWID(), DATEADD(hour,5,GETUTCDATE()), 1);







INSERT INTO Manufacturers (Name, ContactPerson, Email, Phone, Address, Website, Notes) VALUES 
(N'GE Healthcare', N'Michelle Velez', N'contact@gehealthcare.com', N'+1-897-6236326', N'69531 Hawkins Pine New Emily, AK 16177', N'https://www.gehealthcare.com', N'Authorized medical equipment manufacturer'),
(N'Siemens Healthineers', N'Tracey Brown', N'contact@siemenshealthineers.com', N'+1-530-3661058', N'PSC 4203, Box 2529 APO AP 00501', N'https://www.siemenshealthineers.com', N'Authorized medical equipment manufacturer'),
(N'Philips Medical', N'Matthew Brown', N'contact@philipsmedical.com', N'+1-844-1707762', N'27897 Steven Summit Apt. 718 New Robertchester, IA 76873', N'https://www.philipsmedical.com', N'Authorized medical equipment manufacturer'),
(N'Drager', N'Logan Brown', N'contact@drager.com', N'+1-962-9739692', N'54489 Suzanne Mews Kennethton, OR 99004', N'https://www.drager.com', N'Authorized medical equipment manufacturer'),
(N'Mindray', N'Christina Flores', N'contact@mindray.com', N'+1-325-5249882', N'USS Williams FPO AA 23208', N'https://www.mindray.com', N'Authorized medical equipment manufacturer'),
(N'Medtronic', N'James Knapp', N'contact@medtronic.com', N'+1-692-6013251', N'32654 Williams Green Port Eric, MA 67232', N'https://www.medtronic.com', N'Authorized medical equipment manufacturer'),
(N'Fujifilm Healthcare', N'Dr. Robert Butler', N'contact@fujifilmhealthcare.com', N'+1-403-7046955', N'61149 Young Meadows Suite 803 New Benjamin, WA 16591', N'https://www.fujifilmhealthcare.com', N'Authorized medical equipment manufacturer'),
(N'Canon Medical', N'Melinda Farrell', N'contact@canonmedical.com', N'+1-253-4653880', N'38149 Stephen Mountain Apt. 889 Joshuamouth, DE 64559', N'https://www.canonmedical.com', N'Authorized medical equipment manufacturer'),
(N'Baxter', N'Ruth Green', N'contact@baxter.com', N'+1-315-4958849', N'34588 Michael Port Christopherberg, WY 75582', N'https://www.baxter.com', N'Authorized medical equipment manufacturer'),
(N'Welch Allyn', N'Justin Velez', N'contact@welchallyn.com', N'+1-848-8284023', N'2075 Amanda Run West Samantha, NM 81894', N'https://www.welchallyn.com', N'Authorized medical equipment manufacturer'),
(N'Nihon Kohden', N'Jacob Turner', N'contact@nihonkohden.com', N'+1-532-1252794', N'88387 Sarah Hill Suite 823 Krystalhaven, NM 52165', N'https://www.nihonkohden.com', N'Authorized medical equipment manufacturer'),
(N'B. Braun', N'Samantha Spencer', N'contact@bbraun.com', N'+1-371-5632190', N'51403 Rios Centers Port Devin, AK 41436', N'https://www.bbraun.com', N'Authorized medical equipment manufacturer'),
(N'Abbott Diagnostics', N'Victor Roberts', N'contact@abbottdiagnostics.com', N'+1-798-3007387', N'822 Sharp Ville Apt. 781 North David, WY 24002', N'https://www.abbottdiagnostics.com', N'Authorized medical equipment manufacturer'),
(N'Olympus Medical', N'William Alexander', N'contact@olympusmedical.com', N'+1-605-5078362', N'0275 Reed Row Apt. 377 Clarktown, TN 66812', N'https://www.olympusmedical.com', N'Authorized medical equipment manufacturer'),
(N'Stryker', N'Krystal Garrett DVM', N'contact@stryker.com', N'+1-209-1704531', N'3907 Guerrero Villages Lake Natalie, IN 70387', N'https://www.stryker.com', N'Authorized medical equipment manufacturer'),
(N'Zimmer Biomet', N'Robin Bentley', N'contact@zimmerbiomet.com', N'+1-795-8973718', N'65346 Nicholas Street East Josemouth, DC 64699', N'https://www.zimmerbiomet.com', N'Authorized medical equipment manufacturer'),
(N'Hitachi Medical', N'Chad Harvey', N'contact@hitachimedical.com', N'+1-904-3600333', N'582 Aaron Vista Richardshire, NV 19586', N'https://www.hitachimedical.com', N'Authorized medical equipment manufacturer'),
(N'Carestream', N'Sean Carr', N'contact@carestream.com', N'+1-580-2501223', N'USNV Smith FPO AA 66307', N'https://www.carestream.com', N'Authorized medical equipment manufacturer'),
(N'Masimo', N'Kristen Salas', N'contact@masimo.com', N'+1-454-3645741', N'951 Edwards Fields Nicoleburgh, IL 29070', N'https://www.masimo.com', N'Authorized medical equipment manufacturer'),
(N'Hamilton Medical', N'Deanna Payne', N'contact@hamiltonmedical.com', N'+1-711-2533463', N'40472 Logan Heights Michelleberg, DC 99327', N'https://www.hamiltonmedical.com', N'Authorized medical equipment manufacturer');



INSERT INTO Suppliers (Name, ContactPerson, Email, Phone, Address, Website, Notes) VALUES 
(N'Jordan Medical Supply 1', N'Michael James', N'sales1@jmsupply.jo', N'+96266677780', N'Amman Jordan', N'https://www.jmsupply1.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 2', N'Billy Wilkinson', N'sales2@jmsupply.jo', N'+96262007511', N'Amman Jordan', N'https://www.jmsupply2.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 3', N'Shaun Haynes', N'sales3@jmsupply.jo', N'+96262002860', N'Amman Jordan', N'https://www.jmsupply3.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 4', N'Mr. Daniel Thomas', N'sales4@jmsupply.jo', N'+96266964596', N'Amman Jordan', N'https://www.jmsupply4.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 5', N'Deanna Ortiz', N'sales5@jmsupply.jo', N'+96263582322', N'Amman Jordan', N'https://www.jmsupply5.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 6', N'Paul Phillips DVM', N'sales6@jmsupply.jo', N'+96269998515', N'Amman Jordan', N'https://www.jmsupply6.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 7', N'Shawn Guzman', N'sales7@jmsupply.jo', N'+96262801733', N'Amman Jordan', N'https://www.jmsupply7.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 8', N'Jennifer Key', N'sales8@jmsupply.jo', N'+96263111034', N'Amman Jordan', N'https://www.jmsupply8.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 9', N'Kristie Yang', N'sales9@jmsupply.jo', N'+96269184645', N'Amman Jordan', N'https://www.jmsupply9.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 10', N'Matthew Davis', N'sales10@jmsupply.jo', N'+96264903632', N'Amman Jordan', N'https://www.jmsupply10.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 11', N'Laura Richardson', N'sales11@jmsupply.jo', N'+96266314007', N'Amman Jordan', N'https://www.jmsupply11.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 12', N'Kimberly Smith', N'sales12@jmsupply.jo', N'+96266827024', N'Amman Jordan', N'https://www.jmsupply12.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 13', N'Erin Travis', N'sales13@jmsupply.jo', N'+96268360481', N'Amman Jordan', N'https://www.jmsupply13.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 14', N'Nathan Jennings', N'sales14@jmsupply.jo', N'+96264237420', N'Amman Jordan', N'https://www.jmsupply14.jo', N'Authorized regional healthcare supplier'),
(N'Jordan Medical Supply 15', N'Miguel Long', N'sales15@jmsupply.jo', N'+96261358241', N'Amman Jordan', N'https://www.jmsupply15.jo', N'Authorized regional healthcare supplier')




-- DeviceStatuses
INSERT INTO DeviceStatuses (Name, CssClass) VALUES 
(N'Operational', N'success'),
(N'Under Maintenance', N'warning'),
(N'Out of Service', N'danger'),
(N'Pending Inspection', N'info');

-- RiskLevels
INSERT INTO RiskLevels (Name, CssClass) VALUES 
(N'Low', N'secondary'),
(N'Medium', N'info'),
(N'High', N'warning'),
(N'Critical', N'danger');



INSERT INTO Devices (DeviceCode, Name, ModelNumber, SerialNumber, ManufacturerId, SupplierId, DepartmentId, StatusId, RiskLevelId, Location, PurchaseDate, WarrantyExpiry, ExpectedLifespan, FailureCount, NextMaintenanceDate, Notes, CreatedByUserId, UpdatedByUserId) VALUES 
(N'DEV-1001', N'Anesthesia Machine', N'MDL-466', N'SN8595871', 5, 5, 6, 1, 4, N'Floor 1 - Room 348', '2022-12-15', '2027-09-10', N'15 Years', 5, '2026-09-07', N'Equipment inspected and operating within manufacturer specifications.', 10, 3),
(N'DEV-1002', N'Incubator', N'MDL-456', N'SN4394032', 15, 5, 8, 1, 3, N'Floor 5 - Room 568', '2022-09-06', '2027-02-17', N'9 Years', 3, '2026-08-27', N'Equipment inspected and operating within manufacturer specifications.', 5, 9),
(N'DEV-1003', N'Blood Gas Analyzer', N'MDL-564', N'SN1007543', 17, 7, 5, 1, 3, N'Floor 2 - Room 552', '2022-01-20', '2027-06-25', N'10 Years', 2, '2026-11-03', N'Equipment inspected and operating within manufacturer specifications.', 9, 7),
(N'DEV-1004', N'Defibrillator', N'MDL-636', N'SN8164124', 16, 13, 3, 1, 4, N'Floor 5 - Room 178', '2022-10-10', '2027-06-14', N'12 Years', 0, '2026-06-17', N'Equipment inspected and operating within manufacturer specifications.', 2, 1),
(N'DEV-1005', N'Ventilator', N'MDL-282', N'SN1327925', 7, 2, 2, 1, 4, N'Floor 4 - Room 198', '2022-02-02', '2027-10-21', N'13 Years', 5, '2026-09-17', N'Equipment inspected and operating within manufacturer specifications.', 10, 10),
(N'DEV-1006', N'ECG Monitor', N'MDL-150', N'SN4841506', 8, 10, 4, 1, 2, N'Floor 1 - Room 106', '2022-04-21', '2027-08-27', N'8 Years', 3, '2026-12-21', N'Equipment inspected and operating within manufacturer specifications.', 1, 6),
(N'DEV-1007', N'Incubator', N'MDL-861', N'SN5361587', 12, 13, 8, 1, 3, N'Floor 1 - Room 521', '2022-10-09', '2027-09-02', N'8 Years', 2, '2026-06-07', N'Equipment inspected and operating within manufacturer specifications.', 9, 2),
(N'DEV-1008', N'CT Scanner', N'MDL-842', N'SN3422398', 18, 7, 1, 3, 3, N'Floor 2 - Room 198', '2022-09-22', '2027-04-19', N'9 Years', 4, '2026-11-18', N'Equipment inspected and operating within manufacturer specifications.', 7, 2),
(N'DEV-1009', N'Dialysis Machine', N'MDL-466', N'SN8072569', 15, 12, 10, 1, 3, N'Floor 4 - Room 552', '2022-02-06', '2027-03-18', N'13 Years', 4, '2026-08-22', N'Equipment inspected and operating within manufacturer specifications.', 3, 9),
(N'DEV-1010', N'Dialysis Machine', N'MDL-553', N'SN46943810', 11, 9, 10, 1, 3, N'Floor 3 - Room 532', '2022-06-14', '2027-11-14', N'12 Years', 4, '2026-07-19', N'Equipment inspected and operating within manufacturer specifications.', 9, 4),
(N'DEV-1011', N'Anesthesia Machine', N'MDL-884', N'SN67696711', 9, 6, 6, 1, 4, N'Floor 4 - Room 329', '2022-07-01', '2027-12-02', N'11 Years', 4, '2026-06-17', N'Equipment inspected and operating within manufacturer specifications.', 3, 5),
(N'DEV-1012', N'MRI Scanner', N'MDL-407', N'SN33266512', 7, 14, 1, 3, 3, N'Floor 3 - Room 111', '2022-12-27', '2027-05-18', N'15 Years', 4, '2026-10-19', N'Equipment inspected and operating within manufacturer specifications.', 3, 2),
(N'DEV-1013', N'MRI Scanner', N'MDL-571', N'SN47293213', 5, 3, 1, 3, 3, N'Floor 3 - Room 287', '2022-10-08', '2027-04-09', N'11 Years', 0, '2026-10-13', N'Equipment inspected and operating within manufacturer specifications.', 10, 4),
(N'DEV-1014', N'CT Scanner', N'MDL-840', N'SN44046414', 16, 3, 1, 3, 3, N'Floor 4 - Room 522', '2022-12-23', '2027-10-27', N'8 Years', 4, '2026-11-10', N'Equipment inspected and operating within manufacturer specifications.', 1, 10),
(N'DEV-1015', N'Anesthesia Machine', N'MDL-180', N'SN91801715', 2, 15, 6, 1, 4, N'Floor 3 - Room 278', '2022-07-14', '2027-02-28', N'10 Years', 5, '2026-11-28', N'Equipment inspected and operating within manufacturer specifications.', 10, 1),
(N'DEV-1016', N'Anesthesia Machine', N'MDL-155', N'SN41958816', 17, 1, 6, 1, 4, N'Floor 3 - Room 376', '2022-10-05', '2027-06-17', N'10 Years', 1, '2026-06-22', N'Equipment inspected and operating within manufacturer specifications.', 7, 8),
(N'DEV-1017', N'Dialysis Machine', N'MDL-689', N'SN62924717', 3, 4, 10, 1, 3, N'Floor 4 - Room 248', '2022-07-05', '2027-03-11', N'8 Years', 3, '2026-10-24', N'Equipment inspected and operating within manufacturer specifications.', 1, 9),
(N'DEV-1018', N'Anesthesia Machine', N'MDL-368', N'SN18921118', 13, 9, 6, 1, 4, N'Floor 4 - Room 496', '2022-12-05', '2027-03-16', N'15 Years', 1, '2026-09-13', N'Equipment inspected and operating within manufacturer specifications.', 10, 4),
(N'DEV-1019', N'Incubator', N'MDL-730', N'SN87140319', 17, 4, 8, 1, 3, N'Floor 2 - Room 136', '2022-05-25', '2027-07-11', N'8 Years', 0, '2026-11-14', N'Equipment inspected and operating within manufacturer specifications.', 7, 6),
(N'DEV-1020', N'Blood Gas Analyzer', N'MDL-295', N'SN43631820', 12, 10, 5, 1, 3, N'Floor 1 - Room 494', '2022-05-06', '2027-06-20', N'14 Years', 4, '2026-07-15', N'Equipment inspected and operating within manufacturer specifications.', 1, 4),
(N'DEV-1021', N'Defibrillator', N'MDL-801', N'SN49197921', 5, 13, 3, 1, 4, N'Floor 1 - Room 157', '2022-12-02', '2027-04-20', N'9 Years', 2, '2026-06-11', N'Equipment inspected and operating within manufacturer specifications.', 2, 5),
(N'DEV-1022', N'Infusion Pump', N'MDL-582', N'SN12385322', 11, 4, 2, 1, 2, N'Floor 5 - Room 208', '2022-04-18', '2027-09-25', N'11 Years', 4, '2026-09-20', N'Equipment inspected and operating within manufacturer specifications.', 3, 1),
(N'DEV-1023', N'Anesthesia Machine', N'MDL-696', N'SN79575923', 17, 1, 6, 1, 4, N'Floor 3 - Room 187', '2022-01-10', '2027-04-26', N'11 Years', 0, '2026-09-21', N'Equipment inspected and operating within manufacturer specifications.', 1, 2),
(N'DEV-1024', N'Anesthesia Machine', N'MDL-776', N'SN38448924', 12, 14, 6, 1, 4, N'Floor 1 - Room 109', '2022-05-28', '2027-11-13', N'10 Years', 3, '2026-10-23', N'Equipment inspected and operating within manufacturer specifications.', 2, 6),
(N'DEV-1025', N'Infusion Pump', N'MDL-987', N'SN72611125', 18, 2, 2, 1, 2, N'Floor 2 - Room 201', '2022-09-15', '2027-09-23', N'7 Years', 0, '2026-07-17', N'Equipment inspected and operating within manufacturer specifications.', 5, 6),
(N'DEV-1026', N'Infusion Pump', N'MDL-502', N'SN88055026', 6, 1, 2, 1, 2, N'Floor 3 - Room 450', '2022-06-12', '2027-11-10', N'10 Years', 4, '2026-08-26', N'Equipment inspected and operating within manufacturer specifications.', 1, 5),
(N'DEV-1027', N'Anesthesia Machine', N'MDL-934', N'SN13089727', 18, 5, 6, 1, 4, N'Floor 2 - Room 177', '2022-06-13', '2027-11-05', N'8 Years', 5, '2026-09-17', N'Equipment inspected and operating within manufacturer specifications.', 10, 4),
(N'DEV-1028', N'Anesthesia Machine', N'MDL-346', N'SN70072728', 5, 7, 6, 1, 4, N'Floor 3 - Room 565', '2022-10-11', '2027-08-18', N'9 Years', 1, '2026-11-05', N'Equipment inspected and operating within manufacturer specifications.', 10, 9),
(N'DEV-1029', N'Defibrillator', N'MDL-983', N'SN24481829', 10, 12, 3, 1, 4, N'Floor 5 - Room 565', '2022-03-14', '2027-03-21', N'9 Years', 2, '2026-06-18', N'Equipment inspected and operating within manufacturer specifications.', 9, 2),
(N'DEV-1030', N'Ventilator', N'MDL-425', N'SN98030330', 5, 12, 2, 1, 4, N'Floor 1 - Room 491', '2022-06-14', '2027-07-10', N'14 Years', 5, '2026-12-21', N'Equipment inspected and operating within manufacturer specifications.', 5, 3),
(N'DEV-1031', N'Defibrillator', N'MDL-209', N'SN23793531', 6, 1, 3, 1, 4, N'Floor 5 - Room 415', '2022-05-20', '2027-10-20', N'10 Years', 4, '2026-07-08', N'Equipment inspected and operating within manufacturer specifications.', 1, 6),
(N'DEV-1032', N'CT Scanner', N'MDL-804', N'SN91770732', 16, 3, 1, 3, 3, N'Floor 5 - Room 533', '2022-10-16', '2027-12-21', N'12 Years', 1, '2026-12-13', N'Equipment inspected and operating within manufacturer specifications.', 8, 8),
(N'DEV-1033', N'Ventilator', N'MDL-267', N'SN30264733', 8, 1, 2, 1, 4, N'Floor 4 - Room 491', '2022-01-09', '2027-07-08', N'10 Years', 1, '2026-06-06', N'Equipment inspected and operating within manufacturer specifications.', 8, 10),
(N'DEV-1034', N'Infusion Pump', N'MDL-804', N'SN44067734', 15, 15, 2, 1, 2, N'Floor 2 - Room 318', '2022-07-25', '2027-01-20', N'13 Years', 5, '2026-08-13', N'Equipment inspected and operating within manufacturer specifications.', 10, 10),
(N'DEV-1035', N'Dialysis Machine', N'MDL-649', N'SN65074435', 2, 9, 10, 1, 3, N'Floor 1 - Room 331', '2022-08-27', '2027-01-08', N'15 Years', 4, '2026-09-24', N'Equipment inspected and operating within manufacturer specifications.', 1, 9),
(N'DEV-1036', N'Anesthesia Machine', N'MDL-628', N'SN90232836', 2, 4, 6, 1, 4, N'Floor 3 - Room 325', '2022-07-10', '2027-05-15', N'9 Years', 3, '2026-08-20', N'Equipment inspected and operating within manufacturer specifications.', 1, 9),
(N'DEV-1037', N'Ventilator', N'MDL-574', N'SN97020637', 15, 2, 2, 1, 4, N'Floor 5 - Room 157', '2022-03-25', '2027-10-23', N'15 Years', 1, '2026-09-14', N'Equipment inspected and operating within manufacturer specifications.', 6, 8),
(N'DEV-1038', N'MRI Scanner', N'MDL-283', N'SN57571838', 19, 15, 1, 3, 3, N'Floor 2 - Room 551', '2022-08-03', '2027-05-11', N'9 Years', 5, '2026-11-04', N'Equipment inspected and operating within manufacturer specifications.', 2, 2),
(N'DEV-1039', N'Infusion Pump', N'MDL-749', N'SN48057339', 3, 9, 2, 1, 2, N'Floor 4 - Room 472', '2022-09-20', '2027-03-13', N'15 Years', 3, '2026-06-25', N'Equipment inspected and operating within manufacturer specifications.', 3, 6),
(N'DEV-1040', N'Dialysis Machine', N'MDL-992', N'SN79156740', 5, 3, 10, 1, 3, N'Floor 2 - Room 191', '2022-12-02', '2027-07-10', N'11 Years', 5, '2026-12-15', N'Equipment inspected and operating within manufacturer specifications.', 5, 3),
(N'DEV-1041', N'CT Scanner', N'MDL-234', N'SN31270541', 1, 10, 1, 3, 3, N'Floor 3 - Room 106', '2022-08-16', '2027-08-18', N'7 Years', 4, '2026-09-08', N'Equipment inspected and operating within manufacturer specifications.', 4, 10),
(N'DEV-1042', N'Infusion Pump', N'MDL-564', N'SN53007442', 15, 2, 2, 1, 2, N'Floor 5 - Room 407', '2022-01-08', '2027-09-09', N'15 Years', 1, '2026-06-06', N'Equipment inspected and operating within manufacturer specifications.', 3, 1),
(N'DEV-1043', N'Blood Gas Analyzer', N'MDL-137', N'SN25243643', 2, 11, 5, 1, 3, N'Floor 5 - Room 529', '2022-10-10', '2027-06-03', N'7 Years', 0, '2026-09-06', N'Equipment inspected and operating within manufacturer specifications.', 3, 5),
(N'DEV-1044', N'Dialysis Machine', N'MDL-776', N'SN82510444', 20, 10, 10, 1, 3, N'Floor 5 - Room 190', '2022-08-24', '2027-10-12', N'7 Years', 0, '2026-12-10', N'Equipment inspected and operating within manufacturer specifications.', 6, 6),
(N'DEV-1045', N'Anesthesia Machine', N'MDL-939', N'SN17095345', 14, 14, 6, 1, 4, N'Floor 5 - Room 133', '2022-05-16', '2027-03-04', N'11 Years', 2, '2026-10-14', N'Equipment inspected and operating within manufacturer specifications.', 9, 4),
(N'DEV-1046', N'Defibrillator', N'MDL-726', N'SN16101046', 4, 10, 3, 1, 4, N'Floor 5 - Room 144', '2022-08-24', '2027-12-20', N'11 Years', 3, '2026-10-28', N'Equipment inspected and operating within manufacturer specifications.', 6, 5),
(N'DEV-1047', N'Incubator', N'MDL-688', N'SN75351847', 12, 15, 8, 1, 3, N'Floor 2 - Room 414', '2022-10-16', '2027-09-24', N'14 Years', 3, '2026-12-06', N'Equipment inspected and operating within manufacturer specifications.', 10, 4),
(N'DEV-1048', N'ECG Monitor', N'MDL-298', N'SN10165748', 4, 1, 4, 1, 2, N'Floor 4 - Room 420', '2022-02-24', '2027-04-26', N'13 Years', 3, '2026-06-11', N'Equipment inspected and operating within manufacturer specifications.', 6, 9),
(N'DEV-1049', N'Defibrillator', N'MDL-111', N'SN77173649', 7, 12, 3, 1, 4, N'Floor 3 - Room 230', '2022-02-10', '2027-05-17', N'15 Years', 2, '2026-12-01', N'Equipment inspected and operating within manufacturer specifications.', 2, 6),
(N'DEV-1050', N'Blood Gas Analyzer', N'MDL-505', N'SN85958450', 19, 10, 5, 1, 3, N'Floor 1 - Room 526', '2022-03-07', '2027-06-27', N'12 Years', 5, '2026-09-16', N'Equipment inspected and operating within manufacturer specifications.', 1, 3),
(N'DEV-1051', N'Infusion Pump', N'MDL-259', N'SN75766751', 15, 15, 2, 1, 2, N'Floor 5 - Room 558', '2022-06-15', '2027-07-24', N'7 Years', 4, '2026-08-19', N'Equipment inspected and operating within manufacturer specifications.', 6, 9),
(N'DEV-1052', N'Incubator', N'MDL-119', N'SN31837952', 19, 11, 8, 1, 3, N'Floor 3 - Room 509', '2022-06-03', '2027-03-09', N'7 Years', 2, '2026-09-21', N'Equipment inspected and operating within manufacturer specifications.', 9, 3),
(N'DEV-1053', N'Dialysis Machine', N'MDL-720', N'SN50848953', 6, 10, 10, 1, 3, N'Floor 1 - Room 542', '2022-05-23', '2027-06-23', N'7 Years', 2, '2026-09-03', N'Equipment inspected and operating within manufacturer specifications.', 8, 4),
(N'DEV-1054', N'Blood Gas Analyzer', N'MDL-562', N'SN96974954', 10, 4, 5, 1, 3, N'Floor 5 - Room 254', '2022-03-04', '2027-06-26', N'7 Years', 1, '2026-06-15', N'Equipment inspected and operating within manufacturer specifications.', 9, 1),
(N'DEV-1055', N'Infusion Pump', N'MDL-612', N'SN26156255', 7, 6, 2, 1, 2, N'Floor 4 - Room 475', '2022-09-10', '2027-06-05', N'8 Years', 4, '2026-11-05', N'Equipment inspected and operating within manufacturer specifications.', 4, 1),
(N'DEV-1056', N'Infusion Pump', N'MDL-496', N'SN84834456', 17, 2, 2, 1, 2, N'Floor 1 - Room 259', '2022-01-22', '2027-10-28', N'8 Years', 2, '2026-09-02', N'Equipment inspected and operating within manufacturer specifications.', 2, 9),
(N'DEV-1057', N'ECG Monitor', N'MDL-123', N'SN70561557', 10, 11, 4, 1, 2, N'Floor 2 - Room 264', '2022-04-07', '2027-05-09', N'15 Years', 2, '2026-12-15', N'Equipment inspected and operating within manufacturer specifications.', 2, 5),
(N'DEV-1058', N'Ventilator', N'MDL-261', N'SN38692958', 4, 1, 2, 1, 4, N'Floor 5 - Room 386', '2022-09-04', '2027-04-18', N'12 Years', 4, '2026-08-09', N'Equipment inspected and operating within manufacturer specifications.', 3, 5),
(N'DEV-1059', N'Dialysis Machine', N'MDL-350', N'SN27959459', 3, 5, 10, 1, 3, N'Floor 5 - Room 556', '2022-06-18', '2027-08-02', N'9 Years', 0, '2026-09-22', N'Equipment inspected and operating within manufacturer specifications.', 1, 2),
(N'DEV-1060', N'Anesthesia Machine', N'MDL-155', N'SN19030260', 14, 7, 6, 1, 4, N'Floor 2 - Room 460', '2022-10-19', '2027-11-27', N'14 Years', 4, '2026-08-10', N'Equipment inspected and operating within manufacturer specifications.', 6, 4),
(N'DEV-1061', N'Incubator', N'MDL-180', N'SN89245361', 15, 10, 8, 1, 3, N'Floor 2 - Room 147', '2022-12-15', '2027-02-15', N'11 Years', 5, '2026-11-23', N'Equipment inspected and operating within manufacturer specifications.', 8, 8),
(N'DEV-1062', N'Defibrillator', N'MDL-329', N'SN25070362', 20, 5, 3, 1, 4, N'Floor 3 - Room 300', '2022-03-23', '2027-11-11', N'12 Years', 3, '2026-09-01', N'Equipment inspected and operating within manufacturer specifications.', 2, 8),
(N'DEV-1063', N'CT Scanner', N'MDL-459', N'SN60190363', 15, 14, 1, 3, 3, N'Floor 2 - Room 244', '2022-06-20', '2027-10-05', N'15 Years', 0, '2026-09-27', N'Equipment inspected and operating within manufacturer specifications.', 2, 6),
(N'DEV-1064', N'Incubator', N'MDL-765', N'SN17436964', 10, 9, 8, 1, 3, N'Floor 4 - Room 305', '2022-10-14', '2027-04-20', N'10 Years', 4, '2026-07-16', N'Equipment inspected and operating within manufacturer specifications.', 7, 2),
(N'DEV-1065', N'Blood Gas Analyzer', N'MDL-313', N'SN95345265', 19, 7, 5, 1, 3, N'Floor 4 - Room 390', '2022-06-18', '2027-12-08', N'9 Years', 5, '2026-11-03', N'Equipment inspected and operating within manufacturer specifications.', 10, 8),
(N'DEV-1066', N'CT Scanner', N'MDL-706', N'SN72503066', 15, 6, 1, 3, 3, N'Floor 5 - Room 149', '2022-08-06', '2027-05-13', N'8 Years', 4, '2026-06-22', N'Equipment inspected and operating within manufacturer specifications.', 10, 7),
(N'DEV-1067', N'Blood Gas Analyzer', N'MDL-606', N'SN77632067', 2, 2, 5, 1, 3, N'Floor 2 - Room 518', '2022-03-19', '2027-11-26', N'7 Years', 1, '2026-11-05', N'Equipment inspected and operating within manufacturer specifications.', 8, 9),
(N'DEV-1068', N'ECG Monitor', N'MDL-499', N'SN74547468', 19, 8, 4, 1, 2, N'Floor 2 - Room 205', '2022-11-11', '2027-05-19', N'11 Years', 3, '2026-11-12', N'Equipment inspected and operating within manufacturer specifications.', 2, 10),
(N'DEV-1069', N'MRI Scanner', N'MDL-726', N'SN63521869', 13, 14, 1, 3, 3, N'Floor 2 - Room 536', '2022-05-02', '2027-06-18', N'7 Years', 0, '2026-11-18', N'Equipment inspected and operating within manufacturer specifications.', 6, 2),
(N'DEV-1070', N'ECG Monitor', N'MDL-986', N'SN13269970', 8, 7, 4, 1, 2, N'Floor 5 - Room 301', '2022-11-11', '2027-12-13', N'13 Years', 3, '2026-09-18', N'Equipment inspected and operating within manufacturer specifications.', 4, 3),
(N'DEV-1071', N'Infusion Pump', N'MDL-242', N'SN29737071', 18, 7, 2, 1, 2, N'Floor 3 - Room 530', '2022-07-05', '2027-05-28', N'9 Years', 1, '2026-06-03', N'Equipment inspected and operating within manufacturer specifications.', 1, 3),
(N'DEV-1072', N'Infusion Pump', N'MDL-773', N'SN55794972', 5, 2, 2, 1, 2, N'Floor 2 - Room 428', '2022-07-28', '2027-08-26', N'13 Years', 4, '2026-07-15', N'Equipment inspected and operating within manufacturer specifications.', 9, 7),
(N'DEV-1073', N'Incubator', N'MDL-939', N'SN57190773', 13, 6, 8, 1, 3, N'Floor 2 - Room 195', '2022-07-20', '2027-01-19', N'14 Years', 5, '2026-07-23', N'Equipment inspected and operating within manufacturer specifications.', 9, 5),
(N'DEV-1074', N'Anesthesia Machine', N'MDL-659', N'SN70434974', 12, 1, 6, 1, 4, N'Floor 1 - Room 390', '2022-08-23', '2027-06-04', N'14 Years', 5, '2026-06-05', N'Equipment inspected and operating within manufacturer specifications.', 9, 5),
(N'DEV-1075', N'Infusion Pump', N'MDL-629', N'SN18203475', 17, 15, 2, 1, 2, N'Floor 5 - Room 145', '2022-04-16', '2027-11-24', N'8 Years', 5, '2026-11-18', N'Equipment inspected and operating within manufacturer specifications.', 10, 5),
(N'DEV-1076', N'Dialysis Machine', N'MDL-154', N'SN46023476', 18, 13, 10, 1, 3, N'Floor 1 - Room 340', '2022-08-17', '2027-08-19', N'12 Years', 3, '2026-08-26', N'Equipment inspected and operating within manufacturer specifications.', 5, 5),
(N'DEV-1077', N'Ventilator', N'MDL-136', N'SN82881377', 20, 12, 2, 1, 4, N'Floor 3 - Room 472', '2022-10-09', '2027-01-21', N'14 Years', 4, '2026-07-19', N'Equipment inspected and operating within manufacturer specifications.', 1, 5),
(N'DEV-1078', N'Dialysis Machine', N'MDL-127', N'SN40074878', 16, 2, 10, 1, 3, N'Floor 2 - Room 358', '2022-02-28', '2027-05-09', N'9 Years', 4, '2026-08-09', N'Equipment inspected and operating within manufacturer specifications.', 5, 1),
(N'DEV-1079', N'CT Scanner', N'MDL-718', N'SN28309579', 19, 12, 1, 3, 3, N'Floor 2 - Room 437', '2022-08-12', '2027-03-09', N'10 Years', 3, '2026-07-26', N'Equipment inspected and operating within manufacturer specifications.', 9, 1),
(N'DEV-1080', N'Blood Gas Analyzer', N'MDL-186', N'SN25211780', 20, 15, 5, 1, 3, N'Floor 2 - Room 528', '2022-08-25', '2027-07-25', N'13 Years', 1, '2026-11-15', N'Equipment inspected and operating within manufacturer specifications.', 3, 4),
(N'DEV-1081', N'Dialysis Machine', N'MDL-851', N'SN98272581', 12, 1, 10, 1, 3, N'Floor 3 - Room 486', '2022-02-02', '2027-03-15', N'13 Years', 3, '2026-08-16', N'Equipment inspected and operating within manufacturer specifications.', 9, 4),
(N'DEV-1082', N'Anesthesia Machine', N'MDL-799', N'SN83988382', 13, 8, 6, 1, 4, N'Floor 3 - Room 174', '2022-09-28', '2027-07-01', N'11 Years', 3, '2026-09-22', N'Equipment inspected and operating within manufacturer specifications.', 6, 9),
(N'DEV-1083', N'MRI Scanner', N'MDL-199', N'SN65710183', 12, 14, 1, 3, 3, N'Floor 4 - Room 412', '2022-11-28', '2027-05-11', N'11 Years', 2, '2026-12-04', N'Equipment inspected and operating within manufacturer specifications.', 5, 10),
(N'DEV-1084', N'Anesthesia Machine', N'MDL-572', N'SN91070784', 8, 12, 6, 1, 4, N'Floor 5 - Room 494', '2022-04-17', '2027-06-22', N'9 Years', 2, '2026-10-01', N'Equipment inspected and operating within manufacturer specifications.', 1, 2),
(N'DEV-1085', N'MRI Scanner', N'MDL-521', N'SN20244485', 17, 2, 1, 3, 3, N'Floor 4 - Room 279', '2022-04-24', '2027-05-09', N'10 Years', 0, '2026-06-20', N'Equipment inspected and operating within manufacturer specifications.', 2, 1),
(N'DEV-1086', N'Dialysis Machine', N'MDL-772', N'SN97604286', 7, 10, 10, 1, 3, N'Floor 1 - Room 462', '2022-02-03', '2027-10-05', N'13 Years', 5, '2026-12-21', N'Equipment inspected and operating within manufacturer specifications.', 10, 3),
(N'DEV-1087', N'CT Scanner', N'MDL-812', N'SN29321387', 9, 5, 1, 3, 3, N'Floor 4 - Room 438', '2022-02-21', '2027-08-09', N'13 Years', 5, '2026-11-25', N'Equipment inspected and operating within manufacturer specifications.', 6, 5),
(N'DEV-1088', N'Ventilator', N'MDL-899', N'SN17759188', 9, 13, 2, 1, 4, N'Floor 1 - Room 295', '2022-07-11', '2027-01-09', N'11 Years', 1, '2026-09-03', N'Equipment inspected and operating within manufacturer specifications.', 8, 4),
(N'DEV-1089', N'Dialysis Machine', N'MDL-502', N'SN28711089', 16, 2, 10, 1, 3, N'Floor 2 - Room 376', '2022-07-07', '2027-10-21', N'8 Years', 3, '2026-11-09', N'Equipment inspected and operating within manufacturer specifications.', 2, 1),
(N'DEV-1090', N'CT Scanner', N'MDL-172', N'SN69909890', 9, 13, 1, 3, 3, N'Floor 4 - Room 109', '2022-08-05', '2027-11-21', N'7 Years', 0, '2026-11-13', N'Equipment inspected and operating within manufacturer specifications.', 5, 3),
(N'DEV-1091', N'Blood Gas Analyzer', N'MDL-500', N'SN70255391', 1, 9, 5, 1, 3, N'Floor 4 - Room 344', '2022-07-13', '2027-12-25', N'8 Years', 4, '2026-07-01', N'Equipment inspected and operating within manufacturer specifications.', 7, 8),
(N'DEV-1092', N'CT Scanner', N'MDL-680', N'SN66130792', 12, 6, 1, 3, 3, N'Floor 3 - Room 305', '2022-01-21', '2027-11-03', N'12 Years', 4, '2026-12-11', N'Equipment inspected and operating within manufacturer specifications.', 2, 8),
(N'DEV-1093', N'ECG Monitor', N'MDL-763', N'SN31298793', 6, 9, 4, 1, 2, N'Floor 1 - Room 595', '2022-07-22', '2027-04-10', N'13 Years', 0, '2026-11-23', N'Equipment inspected and operating within manufacturer specifications.', 6, 8),
(N'DEV-1094', N'CT Scanner', N'MDL-747', N'SN55925994', 7, 3, 1, 3, 3, N'Floor 1 - Room 198', '2022-01-24', '2027-10-08', N'14 Years', 3, '2026-06-26', N'Equipment inspected and operating within manufacturer specifications.', 9, 5),
(N'DEV-1095', N'Infusion Pump', N'MDL-646', N'SN97477495', 15, 1, 2, 1, 2, N'Floor 1 - Room 273', '2022-01-11', '2027-12-02', N'13 Years', 0, '2026-07-26', N'Equipment inspected and operating within manufacturer specifications.', 9, 8),
(N'DEV-1096', N'Incubator', N'MDL-252', N'SN87704896', 19, 4, 8, 1, 3, N'Floor 1 - Room 118', '2022-12-05', '2027-08-21', N'7 Years', 3, '2026-10-02', N'Equipment inspected and operating within manufacturer specifications.', 4, 3),
(N'DEV-1097', N'MRI Scanner', N'MDL-276', N'SN76339397', 2, 15, 1, 3, 3, N'Floor 3 - Room 520', '2022-02-15', '2027-10-06', N'8 Years', 0, '2026-06-16', N'Equipment inspected and operating within manufacturer specifications.', 10, 10),
(N'DEV-1098', N'Defibrillator', N'MDL-164', N'SN94353098', 7, 7, 3, 1, 4, N'Floor 3 - Room 515', '2022-12-22', '2027-07-11', N'8 Years', 5, '2026-10-18', N'Equipment inspected and operating within manufacturer specifications.', 3, 6),
(N'DEV-1099', N'Defibrillator', N'MDL-882', N'SN14780099', 19, 3, 3, 1, 4, N'Floor 3 - Room 132', '2022-02-09', '2027-03-25', N'13 Years', 1, '2026-11-12', N'Equipment inspected and operating within manufacturer specifications.', 9, 3),
(N'DEV-1100', N'Infusion Pump', N'MDL-349', N'SN710256100', 2, 3, 2, 1, 2, N'Floor 1 - Room 505', '2022-11-20', '2027-07-25', N'9 Years', 0, '2026-09-03', N'Equipment inspected and operating within manufacturer specifications.', 1, 1),
(N'DEV-1101', N'Ventilator', N'MDL-191', N'SN841071101', 19, 15, 2, 1, 4, N'Floor 3 - Room 313', '2022-12-26', '2027-08-23', N'9 Years', 1, '2026-07-21', N'Equipment inspected and operating within manufacturer specifications.', 5, 9),
(N'DEV-1102', N'Infusion Pump', N'MDL-521', N'SN350875102', 6, 10, 2, 1, 2, N'Floor 1 - Room 405', '2022-03-23', '2027-08-20', N'8 Years', 5, '2026-12-26', N'Equipment inspected and operating within manufacturer specifications.', 5, 6),
(N'DEV-1103', N'Anesthesia Machine', N'MDL-104', N'SN684801103', 8, 4, 6, 1, 4, N'Floor 1 - Room 371', '2022-02-20', '2027-06-28', N'15 Years', 4, '2026-07-15', N'Equipment inspected and operating within manufacturer specifications.', 4, 5),
(N'DEV-1104', N'MRI Scanner', N'MDL-298', N'SN218152104', 5, 11, 1, 3, 3, N'Floor 4 - Room 354', '2022-03-06', '2027-11-02', N'7 Years', 5, '2026-08-10', N'Equipment inspected and operating within manufacturer specifications.', 4, 7),
(N'DEV-1105', N'ECG Monitor', N'MDL-442', N'SN746781105', 15, 1, 4, 1, 2, N'Floor 1 - Room 479', '2022-01-18', '2027-03-06', N'7 Years', 3, '2026-10-04', N'Equipment inspected and operating within manufacturer specifications.', 2, 4),
(N'DEV-1106', N'Infusion Pump', N'MDL-706', N'SN707924106', 11, 7, 2, 1, 2, N'Floor 2 - Room 482', '2022-11-11', '2027-04-25', N'8 Years', 2, '2026-07-04', N'Equipment inspected and operating within manufacturer specifications.', 4, 7),
(N'DEV-1107', N'Defibrillator', N'MDL-484', N'SN331381107', 3, 8, 3, 1, 4, N'Floor 5 - Room 348', '2022-01-14', '2027-03-07', N'14 Years', 1, '2026-09-12', N'Equipment inspected and operating within manufacturer specifications.', 3, 8),
(N'DEV-1108', N'Defibrillator', N'MDL-747', N'SN476009108', 9, 4, 3, 1, 4, N'Floor 3 - Room 165', '2022-01-23', '2027-10-02', N'11 Years', 1, '2026-06-28', N'Equipment inspected and operating within manufacturer specifications.', 8, 8),
(N'DEV-1109', N'Anesthesia Machine', N'MDL-275', N'SN897273109', 11, 4, 6, 1, 4, N'Floor 3 - Room 409', '2022-03-26', '2027-11-20', N'9 Years', 4, '2026-10-28', N'Equipment inspected and operating within manufacturer specifications.', 4, 2),
(N'DEV-1110', N'Anesthesia Machine', N'MDL-977', N'SN647114110', 16, 14, 6, 1, 4, N'Floor 2 - Room 402', '2022-08-27', '2027-08-09', N'7 Years', 5, '2026-09-24', N'Equipment inspected and operating within manufacturer specifications.', 4, 4),
(N'DEV-1111', N'Blood Gas Analyzer', N'MDL-544', N'SN707615111', 8, 15, 5, 1, 3, N'Floor 5 - Room 584', '2022-03-19', '2027-01-14', N'7 Years', 0, '2026-09-24', N'Equipment inspected and operating within manufacturer specifications.', 9, 1),
(N'DEV-1112', N'Anesthesia Machine', N'MDL-643', N'SN513474112', 16, 13, 6, 1, 4, N'Floor 1 - Room 331', '2022-08-08', '2027-02-18', N'7 Years', 5, '2026-11-14', N'Equipment inspected and operating within manufacturer specifications.', 4, 3),
(N'DEV-1113', N'Blood Gas Analyzer', N'MDL-402', N'SN350675113', 3, 1, 5, 1, 3, N'Floor 4 - Room 442', '2022-05-06', '2027-12-15', N'7 Years', 3, '2026-09-25', N'Equipment inspected and operating within manufacturer specifications.', 3, 7),
(N'DEV-1114', N'Ventilator', N'MDL-908', N'SN488414114', 15, 12, 2, 1, 4, N'Floor 1 - Room 540', '2022-11-03', '2027-07-23', N'12 Years', 4, '2026-06-10', N'Equipment inspected and operating within manufacturer specifications.', 7, 5),
(N'DEV-1115', N'Dialysis Machine', N'MDL-655', N'SN703171115', 7, 13, 10, 1, 3, N'Floor 1 - Room 417', '2022-06-24', '2027-01-17', N'12 Years', 0, '2026-06-13', N'Equipment inspected and operating within manufacturer specifications.', 6, 8),
(N'DEV-1116', N'Dialysis Machine', N'MDL-141', N'SN483329116', 12, 3, 10, 1, 3, N'Floor 5 - Room 460', '2022-02-18', '2027-12-25', N'10 Years', 1, '2026-08-08', N'Equipment inspected and operating within manufacturer specifications.', 9, 2),
(N'DEV-1117', N'Infusion Pump', N'MDL-855', N'SN888819117', 19, 14, 2, 1, 2, N'Floor 2 - Room 485', '2022-12-25', '2027-04-11', N'12 Years', 2, '2026-10-22', N'Equipment inspected and operating within manufacturer specifications.', 7, 5),
(N'DEV-1118', N'MRI Scanner', N'MDL-164', N'SN490923118', 12, 8, 1, 3, 3, N'Floor 4 - Room 356', '2022-09-27', '2027-02-16', N'15 Years', 5, '2026-12-18', N'Equipment inspected and operating within manufacturer specifications.', 5, 8),
(N'DEV-1119', N'Dialysis Machine', N'MDL-476', N'SN938759119', 3, 4, 10, 1, 3, N'Floor 4 - Room 144', '2022-02-13', '2027-03-10', N'8 Years', 0, '2026-07-09', N'Equipment inspected and operating within manufacturer specifications.', 2, 3),
(N'DEV-1120', N'Infusion Pump', N'MDL-254', N'SN314178120', 17, 11, 2, 1, 2, N'Floor 1 - Room 250', '2022-07-22', '2027-09-05', N'14 Years', 2, '2026-09-15', N'Equipment inspected and operating within manufacturer specifications.', 1, 5);




-- ACCESSORIES
INSERT INTO Accessories (Name, Description, QuantityInStock)
VALUES
(N'ECG Lead Set', N'Replacement ECG monitoring leads', 50),
(N'Ultrasound Probe', N'High-frequency ultrasound imaging probe', 9),
(N'Defibrillator Pads', N'Adult disposable defibrillator pads', 33),
(N'Ventilator Circuit', N'Disposable ventilator breathing circuit', 15),
(N'SpO2 Sensor', N'Reusable oxygen saturation sensor', 114),
(N'Infusion Pump Battery', N'Rechargeable infusion pump battery', 73),
(N'MRI Coil', N'MRI head imaging coil', 104),
(N'CT Contrast Injector', N'Automated contrast media injector', 92),
(N'Anesthesia Breathing Circuit', N'Reusable anesthesia circuit', 35),
(N'Patient Monitor Cable', N'Multi-parameter monitor cable', 7),
(N'Fetal Monitor Belt', N'Elastic fetal monitoring belt', 17),
(N'Syringe Pump Clamp', N'Adjustable syringe fixation clamp', 69),
(N'Dialysis Tubing Set', N'Dialysis blood tubing', 58),
(N'XRay Detector Plate', N'Digital X-Ray imaging detector', 11),
(N'Blood Pressure Cuff', N'Adult reusable NIBP cuff', 70);


-- DEVICE ACCESSORIES
INSERT INTO DeviceAccessories (DeviceId, AccessoryId, Quantity, Notes)
VALUES
(103, 15, 3, N'Accessory installed and verified during equipment inspection.'),
(43, 14, 5, N'Accessory installed and verified during equipment inspection.'),
(99, 9, 6, N'Accessory installed and verified during equipment inspection.'),
(52, 3, 1, N'Accessory installed and verified during equipment inspection.'),
(42, 10, 2, N'Accessory installed and verified during equipment inspection.'),
(97, 3, 2, N'Accessory installed and verified during equipment inspection.'),
(54, 6, 1, N'Accessory installed and verified during equipment inspection.'),
(31, 1, 4, N'Accessory installed and verified during equipment inspection.'),
(84, 13, 2, N'Accessory installed and verified during equipment inspection.'),
(44, 4, 5, N'Accessory installed and verified during equipment inspection.'),
(52, 11, 1, N'Accessory installed and verified during equipment inspection.'),
(31, 8, 3, N'Accessory installed and verified during equipment inspection.'),
(61, 15, 4, N'Accessory installed and verified during equipment inspection.'),
(40, 5, 4, N'Accessory installed and verified during equipment inspection.'),
(99, 5, 3, N'Accessory installed and verified during equipment inspection.'),
(18, 10, 1, N'Accessory installed and verified during equipment inspection.'),
(60, 9, 6, N'Accessory installed and verified during equipment inspection.'),
(79, 3, 2, N'Accessory installed and verified during equipment inspection.'),
(84, 10, 5, N'Accessory installed and verified during equipment inspection.'),
(30, 2, 3, N'Accessory installed and verified during equipment inspection.'),
(35, 1, 5, N'Accessory installed and verified during equipment inspection.'),
(45, 2, 2, N'Accessory installed and verified during equipment inspection.'),
(25, 11, 3, N'Accessory installed and verified during equipment inspection.'),
(62, 11, 3, N'Accessory installed and verified during equipment inspection.'),
(105, 5, 5, N'Accessory installed and verified during equipment inspection.'),
(17, 5, 5, N'Accessory installed and verified during equipment inspection.'),
(4, 9, 2, N'Accessory installed and verified during equipment inspection.'),
(9, 15, 3, N'Accessory installed and verified during equipment inspection.'),
(33, 11, 5, N'Accessory installed and verified during equipment inspection.'),
(25, 13, 6, N'Accessory installed and verified during equipment inspection.'),
(82, 15, 3, N'Accessory installed and verified during equipment inspection.'),
(57, 6, 2, N'Accessory installed and verified during equipment inspection.'),
(29, 9, 6, N'Accessory installed and verified during equipment inspection.'),
(82, 8, 6, N'Accessory installed and verified during equipment inspection.'),
(32, 5, 2, N'Accessory installed and verified during equipment inspection.'),
(47, 6, 4, N'Accessory installed and verified during equipment inspection.'),
(120, 15, 5, N'Accessory installed and verified during equipment inspection.'),
(2, 7, 5, N'Accessory installed and verified during equipment inspection.'),
(117, 15, 3, N'Accessory installed and verified during equipment inspection.'),
(29, 11, 1, N'Accessory installed and verified during equipment inspection.'),
(112, 13, 6, N'Accessory installed and verified during equipment inspection.'),
(43, 5, 3, N'Accessory installed and verified during equipment inspection.'),
(7, 9, 1, N'Accessory installed and verified during equipment inspection.'),
(107, 13, 6, N'Accessory installed and verified during equipment inspection.'),
(73, 5, 1, N'Accessory installed and verified during equipment inspection.'),
(104, 12, 5, N'Accessory installed and verified during equipment inspection.'),
(107, 10, 5, N'Accessory installed and verified during equipment inspection.'),
(120, 9, 2, N'Accessory installed and verified during equipment inspection.'),
(11, 3, 3, N'Accessory installed and verified during equipment inspection.'),
(63, 9, 5, N'Accessory installed and verified during equipment inspection.'),
(60, 10, 5, N'Accessory installed and verified during equipment inspection.'),
(33, 5, 1, N'Accessory installed and verified during equipment inspection.'),
(54, 14, 1, N'Accessory installed and verified during equipment inspection.'),
(102, 8, 5, N'Accessory installed and verified during equipment inspection.'),
(44, 3, 6, N'Accessory installed and verified during equipment inspection.'),
(85, 2, 6, N'Accessory installed and verified during equipment inspection.'),
(109, 2, 2, N'Accessory installed and verified during equipment inspection.'),
(76, 8, 4, N'Accessory installed and verified during equipment inspection.'),
(26, 1, 2, N'Accessory installed and verified during equipment inspection.'),
(39, 5, 2, N'Accessory installed and verified during equipment inspection.'),
(10, 15, 2, N'Accessory installed and verified during equipment inspection.'),
(27, 1, 2, N'Accessory installed and verified during equipment inspection.'),
(42, 8, 3, N'Accessory installed and verified during equipment inspection.'),
(107, 15, 6, N'Accessory installed and verified during equipment inspection.'),
(100, 15, 4, N'Accessory installed and verified during equipment inspection.'),
(13, 3, 1, N'Accessory installed and verified during equipment inspection.'),
(87, 10, 5, N'Accessory installed and verified during equipment inspection.'),
(110, 7, 6, N'Accessory installed and verified during equipment inspection.'),
(73, 4, 2, N'Accessory installed and verified during equipment inspection.'),
(19, 14, 3, N'Accessory installed and verified during equipment inspection.'),
(33, 9, 5, N'Accessory installed and verified during equipment inspection.'),
(107, 7, 4, N'Accessory installed and verified during equipment inspection.'),
(70, 7, 1, N'Accessory installed and verified during equipment inspection.'),
(47, 1, 5, N'Accessory installed and verified during equipment inspection.'),
(68, 12, 6, N'Accessory installed and verified during equipment inspection.'),
(70, 4, 1, N'Accessory installed and verified during equipment inspection.'),
(102, 4, 3, N'Accessory installed and verified during equipment inspection.'),
(116, 1, 2, N'Accessory installed and verified during equipment inspection.'),
(114, 3, 3, N'Accessory installed and verified during equipment inspection.'),
(107, 11, 3, N'Accessory installed and verified during equipment inspection.'),
(19, 8, 4, N'Accessory installed and verified during equipment inspection.'),
(4, 10, 3, N'Accessory installed and verified during equipment inspection.'),
(78, 2, 6, N'Accessory installed and verified during equipment inspection.'),
(85, 15, 4, N'Accessory installed and verified during equipment inspection.'),
(16, 9, 1, N'Accessory installed and verified during equipment inspection.'),
(104, 4, 1, N'Accessory installed and verified during equipment inspection.'),
(39, 5, 4, N'Accessory installed and verified during equipment inspection.'),
(120, 9, 3, N'Accessory installed and verified during equipment inspection.'),
(30, 14, 4, N'Accessory installed and verified during equipment inspection.'),
(69, 8, 5, N'Accessory installed and verified during equipment inspection.'),
(57, 1, 6, N'Accessory installed and verified during equipment inspection.'),
(46, 5, 4, N'Accessory installed and verified during equipment inspection.'),
(103, 3, 1, N'Accessory installed and verified during equipment inspection.'),
(55, 6, 3, N'Accessory installed and verified during equipment inspection.'),
(59, 10, 1, N'Accessory installed and verified during equipment inspection.'),
(5, 2, 6, N'Accessory installed and verified during equipment inspection.'),
(28, 14, 1, N'Accessory installed and verified during equipment inspection.'),
(3, 8, 2, N'Accessory installed and verified during equipment inspection.'),
(12, 10, 1, N'Accessory installed and verified during equipment inspection.');






-- MaintenanceTypes
INSERT INTO MaintenanceTypes (Name) VALUES 
(N'Preventive Maintenance'),
(N'Corrective Maintenance'),
(N'Calibration'),
(N'Software Update'),
(N'Inspection');

-- MaintenanceStatuses
INSERT INTO MaintenanceStatuses (Name, CssClass) VALUES 
(N'Pending', N'warning'),
(N'In Progress', N'info'),
(N'Completed', N'success'),
(N'Cancelled', N'danger');





INSERT INTO MaintenanceRequests (RequestCode, DeviceId, ReportedByUserId, AssignedEngineerUserId, MaintenanceTypeId, StatusId, RiskLevelId, IssueTitle, IssueDescription, EngineerNotes, CompletionNotes, HasAlternative, RequestDate, StartedAt, CompletedAt) VALUES 
(N'MR-5001', 107, 73, 26, 3, 1, 3, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-03-16', '2026-01-01', NULL),
(N'MR-5002', 39, 76, 10, 3, 3, 2, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-02-16', '2026-05-27', '2026-05-15'),
(N'MR-5003', 19, 62, 15, 4, 2, 2, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-05-10', '2026-03-25', NULL),
(N'MR-5004', 21, 55, 9, 1, 1, 3, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-09', '2026-02-27', NULL),
(N'MR-5005', 86, 60, 17, 2, 2, 3, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-06', '2026-02-07', NULL),
(N'MR-5006', 99, 49, 20, 3, 3, 2, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-05-17', '2026-03-04', '2026-01-13'),
(N'MR-5007', 97, 76, 27, 2, 2, 4, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-03-23', '2026-03-16', NULL),
(N'MR-5008', 87, 75, 9, 3, 1, 2, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-27', '2026-04-02', NULL),
(N'MR-5009', 42, 43, 25, 2, 1, 4, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-03-07', '2026-04-12', NULL),
(N'MR-5010', 87, 45, 22, 4, 1, 2, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-03-20', '2026-01-18', NULL),
(N'MR-5011', 92, 67, 17, 4, 3, 3, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-03-12', '2026-05-02', '2026-03-13'),
(N'MR-5012', 28, 68, 29, 4, 2, 3, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-02-26', '2026-03-15', NULL),
(N'MR-5013', 19, 53, 15, 4, 3, 4, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-01-19', '2026-04-24', '2026-04-05'),
(N'MR-5014', 82, 57, 19, 2, 2, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-25', '2026-01-01', NULL),
(N'MR-5015', 38, 75, 21, 1, 1, 3, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-18', '2026-02-06', NULL),
(N'MR-5016', 20, 56, 15, 4, 3, 2, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-04-06', '2026-04-08', '2026-01-26'),
(N'MR-5017', 98, 57, 21, 1, 2, 4, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-16', '2026-02-01', NULL),
(N'MR-5018', 89, 47, 17, 5, 3, 4, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-03-06', '2026-04-28', '2026-03-21'),
(N'MR-5019', 46, 50, 7, 3, 3, 3, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-03-02', '2026-01-05', '2026-03-15'),
(N'MR-5020', 66, 52, 30, 2, 2, 2, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-05-11', '2026-03-17', NULL),
(N'MR-5021', 13, 74, 24, 3, 2, 2, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-02-17', '2026-03-09', NULL),
(N'MR-5022', 53, 61, 35, 2, 2, 2, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-02-17', '2026-03-25', NULL),
(N'MR-5023', 54, 69, 35, 1, 1, 2, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-01-16', '2026-02-26', NULL),
(N'MR-5024', 18, 68, 34, 5, 2, 4, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-02-23', '2026-03-23', NULL),
(N'MR-5025', 29, 48, 33, 2, 2, 4, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-03-05', '2026-01-24', NULL),
(N'MR-5026', 89, 47, 8, 1, 1, 3, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-07', '2026-02-03', NULL),
(N'MR-5027', 61, 47, 35, 3, 1, 2, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-03-22', '2026-01-26', NULL),
(N'MR-5028', 118, 78, 12, 5, 1, 2, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-03-01', '2026-01-26', NULL),
(N'MR-5029', 75, 62, 17, 2, 1, 4, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-05-19', '2026-02-28', NULL),
(N'MR-5030', 68, 53, 28, 2, 1, 3, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-05-01', '2026-01-27', NULL),
(N'MR-5031', 47, 77, 11, 4, 3, 4, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-02-27', '2026-01-07', '2026-05-28'),
(N'MR-5032', 66, 54, 19, 1, 2, 3, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-04', '2026-04-14', NULL),
(N'MR-5033', 72, 42, 8, 3, 3, 3, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-04-10', '2026-02-16', '2026-03-23'),
(N'MR-5034', 88, 68, 13, 5, 2, 3, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-07', '2026-05-24', NULL),
(N'MR-5035', 23, 40, 27, 4, 1, 4, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-15', '2026-04-22', NULL),
(N'MR-5036', 89, 77, 9, 2, 3, 2, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-02-11', '2026-01-04', '2026-02-13'),
(N'MR-5037', 16, 54, 32, 4, 1, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-03-25', '2026-05-28', NULL),
(N'MR-5038', 46, 70, 27, 5, 3, 3, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-05-09', '2026-05-19', '2026-03-25'),
(N'MR-5039', 33, 71, 21, 2, 1, 4, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-01-04', '2026-04-04', NULL),
(N'MR-5040', 23, 64, 25, 3, 3, 2, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-05-20', '2026-01-27', '2026-01-16'),
(N'MR-5041', 102, 69, 12, 3, 1, 4, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-17', '2026-01-22', NULL),
(N'MR-5042', 98, 42, 19, 1, 2, 3, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-03-28', '2026-05-11', NULL),
(N'MR-5043', 5, 51, 23, 3, 2, 4, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-14', '2026-04-15', NULL),
(N'MR-5044', 63, 47, 24, 4, 1, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-18', '2026-03-23', NULL),
(N'MR-5045', 34, 71, 24, 4, 1, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-03-11', '2026-05-02', NULL),
(N'MR-5046', 17, 63, 17, 5, 1, 2, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-04', '2026-01-19', NULL),
(N'MR-5047', 45, 43, 27, 2, 2, 2, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-03-19', '2026-03-12', NULL),
(N'MR-5048', 15, 61, 11, 1, 1, 4, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-15', '2026-01-28', NULL),
(N'MR-5049', 3, 70, 24, 1, 3, 3, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-05-13', '2026-04-19', '2026-05-14'),
(N'MR-5050', 13, 53, 16, 4, 2, 4, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-02-20', '2026-05-04', NULL),
(N'MR-5051', 64, 80, 33, 1, 2, 4, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-03-09', '2026-03-14', NULL),
(N'MR-5052', 103, 54, 25, 1, 1, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-05-11', '2026-03-19', NULL),
(N'MR-5053', 55, 53, 17, 1, 2, 4, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-26', '2026-01-19', NULL),
(N'MR-5054', 26, 66, 18, 3, 2, 4, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-06', '2026-04-22', NULL),
(N'MR-5055', 74, 71, 12, 4, 1, 3, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-24', '2026-05-28', NULL),
(N'MR-5056', 19, 55, 10, 3, 3, 3, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-03-28', '2026-01-17', '2026-02-12'),
(N'MR-5057', 35, 58, 26, 2, 1, 3, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-08', '2026-02-28', NULL),
(N'MR-5058', 32, 59, 20, 4, 1, 4, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-21', '2026-02-07', NULL),
(N'MR-5059', 18, 41, 14, 3, 1, 4, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-01-24', '2026-02-06', NULL),
(N'MR-5060', 41, 78, 15, 1, 2, 3, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-13', '2026-01-02', NULL),
(N'MR-5061', 67, 77, 30, 5, 3, 3, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-01-08', '2026-02-08', '2026-01-19'),
(N'MR-5062', 104, 55, 35, 4, 3, 2, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-01-06', '2026-01-25', '2026-03-11'),
(N'MR-5063', 33, 77, 7, 4, 1, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-11', '2026-03-15', NULL),
(N'MR-5064', 47, 70, 28, 3, 3, 3, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-05-02', '2026-04-16', '2026-02-09'),
(N'MR-5065', 40, 80, 28, 3, 3, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-05-28', '2026-01-23', '2026-02-09'),
(N'MR-5066', 117, 65, 35, 3, 1, 3, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-02-10', '2026-04-13', NULL),
(N'MR-5067', 113, 66, 31, 1, 1, 3, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-16', '2026-02-15', NULL),
(N'MR-5068', 113, 46, 32, 2, 3, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-05-03', '2026-04-27', '2026-03-23'),
(N'MR-5069', 59, 41, 30, 1, 2, 4, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-26', '2026-04-20', NULL),
(N'MR-5070', 41, 76, 8, 1, 3, 2, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-05-23', '2026-02-01', '2026-04-07'),
(N'MR-5071', 102, 60, 20, 4, 3, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-03-06', '2026-02-28', '2026-05-22'),
(N'MR-5072', 26, 45, 19, 3, 3, 2, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-04-27', '2026-05-27', '2026-03-26'),
(N'MR-5073', 117, 45, 20, 2, 3, 3, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-01-13', '2026-02-01', '2026-01-18'),
(N'MR-5074', 48, 50, 24, 1, 3, 2, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-04-27', '2026-04-20', '2026-03-05'),
(N'MR-5075', 25, 57, 15, 4, 3, 3, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-04-28', '2026-04-04', '2026-02-23'),
(N'MR-5076', 94, 52, 19, 2, 1, 3, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-01-10', '2026-05-07', NULL),
(N'MR-5077', 117, 55, 17, 5, 2, 4, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-01', '2026-02-20', NULL),
(N'MR-5078', 89, 65, 27, 2, 2, 4, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-24', '2026-02-28', NULL),
(N'MR-5079', 7, 61, 35, 2, 3, 3, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-05-22', '2026-03-03', '2026-01-18'),
(N'MR-5080', 39, 65, 27, 3, 3, 2, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-05-06', '2026-01-01', '2026-03-17'),
(N'MR-5081', 120, 61, 34, 4, 2, 2, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-03-23', '2026-02-17', NULL),
(N'MR-5082', 6, 48, 21, 3, 3, 4, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-04-10', '2026-04-05', '2026-03-04'),
(N'MR-5083', 67, 60, 19, 2, 2, 3, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-02-18', '2026-05-27', NULL),
(N'MR-5084', 30, 51, 7, 4, 3, 3, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-04-14', '2026-04-02', '2026-02-05'),
(N'MR-5085', 46, 75, 21, 4, 1, 3, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-02-04', '2026-04-02', NULL),
(N'MR-5086', 24, 50, 29, 5, 2, 3, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-05-01', '2026-01-07', NULL),
(N'MR-5087', 99, 71, 27, 1, 3, 3, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-03-22', '2026-05-06', '2026-04-03'),
(N'MR-5088', 108, 60, 10, 1, 3, 2, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-04-15', '2026-01-13', '2026-03-19'),
(N'MR-5089', 84, 79, 20, 3, 3, 4, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-02-28', '2026-03-20', '2026-01-11'),
(N'MR-5090', 96, 44, 23, 5, 1, 3, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-09', '2026-03-11', NULL),
(N'MR-5091', 12, 41, 33, 2, 1, 2, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-10', '2026-02-25', NULL),
(N'MR-5092', 95, 59, 34, 5, 3, 2, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-01-27', '2026-02-04', '2026-03-16'),
(N'MR-5093', 58, 64, 21, 3, 2, 4, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-25', '2026-05-07', NULL),
(N'MR-5094', 56, 80, 19, 1, 2, 2, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-22', '2026-03-20', NULL),
(N'MR-5095', 38, 69, 19, 1, 1, 3, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-02-05', '2026-02-16', NULL),
(N'MR-5096', 38, 76, 7, 5, 3, 2, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-05-04', '2026-03-27', '2026-02-17'),
(N'MR-5097', 46, 56, 24, 1, 3, 4, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-01-24', '2026-04-14', '2026-01-15'),
(N'MR-5098', 6, 45, 19, 3, 3, 3, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-04-20', '2026-04-06', '2026-02-27'),
(N'MR-5099', 28, 51, 8, 5, 2, 3, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-18', '2026-03-28', NULL),
(N'MR-5100', 2, 50, 26, 4, 1, 3, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-24', '2026-01-13', NULL),
(N'MR-5101', 89, 65, 31, 3, 2, 2, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-02-01', '2026-03-20', NULL),
(N'MR-5102', 90, 52, 33, 1, 1, 2, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-02-21', '2026-01-27', NULL),
(N'MR-5103', 12, 59, 30, 4, 1, 2, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-01', '2026-04-27', NULL),
(N'MR-5104', 63, 70, 6, 4, 1, 4, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-02-10', '2026-02-05', NULL),
(N'MR-5105', 81, 67, 19, 4, 3, 4, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-01-16', '2026-04-02', '2026-03-01'),
(N'MR-5106', 30, 43, 22, 1, 2, 3, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-03', '2026-04-17', NULL),
(N'MR-5107', 64, 79, 26, 3, 2, 3, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-06', '2026-04-16', NULL),
(N'MR-5108', 57, 54, 22, 2, 2, 4, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-28', '2026-02-16', NULL),
(N'MR-5109', 54, 63, 31, 4, 3, 2, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-03-23', '2026-04-05', '2026-03-24'),
(N'MR-5110', 26, 50, 25, 4, 3, 2, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-04-10', '2026-01-22', '2026-04-05'),
(N'MR-5111', 3, 62, 34, 3, 1, 3, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-02-27', '2026-02-18', NULL),
(N'MR-5112', 15, 79, 13, 1, 3, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-04-09', '2026-01-26', '2026-01-11'),
(N'MR-5113', 99, 75, 14, 2, 2, 4, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-01-15', '2026-03-25', NULL),
(N'MR-5114', 106, 75, 7, 5, 2, 2, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-01-28', '2026-01-04', NULL),
(N'MR-5115', 91, 68, 30, 5, 1, 3, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-02-21', '2026-03-06', NULL),
(N'MR-5116', 16, 52, 20, 4, 2, 2, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-11', '2026-03-27', NULL),
(N'MR-5117', 35, 63, 28, 4, 2, 3, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-02-25', '2026-05-06', NULL),
(N'MR-5118', 53, 66, 34, 4, 3, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-01-15', '2026-04-26', '2026-02-05'),
(N'MR-5119', 11, 61, 16, 4, 1, 2, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-13', '2026-01-23', NULL),
(N'MR-5120', 81, 73, 15, 4, 1, 3, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-03-12', '2026-02-19', NULL),
(N'MR-5121', 90, 65, 20, 2, 1, 4, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-03-26', '2026-03-17', NULL),
(N'MR-5122', 5, 74, 16, 4, 3, 4, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-05-18', '2026-04-25', '2026-02-10'),
(N'MR-5123', 67, 61, 30, 2, 2, 2, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-05-19', '2026-02-03', NULL),
(N'MR-5124', 93, 67, 22, 1, 2, 4, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-03-09', '2026-02-27', NULL),
(N'MR-5125', 58, 59, 24, 1, 3, 3, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-02-26', '2026-05-12', '2026-01-02'),
(N'MR-5126', 45, 59, 15, 5, 3, 4, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-04-17', '2026-05-19', '2026-05-28'),
(N'MR-5127', 106, 63, 20, 1, 3, 2, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-04-03', '2026-02-04', '2026-03-17'),
(N'MR-5128', 61, 53, 20, 1, 1, 3, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-18', '2026-01-14', NULL),
(N'MR-5129', 82, 67, 20, 4, 3, 4, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-02-05', '2026-04-28', '2026-03-19'),
(N'MR-5130', 89, 53, 20, 4, 3, 2, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-05-12', '2026-02-16', '2026-04-05'),
(N'MR-5131', 15, 47, 17, 5, 1, 3, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-05-05', '2026-05-28', NULL),
(N'MR-5132', 39, 58, 21, 1, 1, 2, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-05-14', '2026-03-10', NULL),
(N'MR-5133', 24, 71, 6, 1, 1, 4, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-28', '2026-03-10', NULL),
(N'MR-5134', 73, 68, 34, 3, 1, 3, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-05-05', '2026-04-16', NULL),
(N'MR-5135', 98, 68, 27, 4, 1, 2, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-26', '2026-05-21', NULL),
(N'MR-5136', 44, 74, 7, 4, 3, 4, N'Software update needed', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-01-28', '2026-05-14', '2026-04-08'),
(N'MR-5137', 72, 47, 26, 5, 1, 2, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-05-18', '2026-01-19', NULL),
(N'MR-5138', 65, 41, 9, 5, 3, 2, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-03-26', '2026-01-19', '2026-05-07'),
(N'MR-5139', 11, 74, 25, 3, 1, 3, N'Image quality degradation', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-28', '2026-02-27', NULL),
(N'MR-5140', 54, 41, 33, 5, 1, 3, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-03-03', '2026-03-14', NULL),
(N'MR-5141', 37, 49, 11, 3, 1, 2, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-03-14', '2026-01-18', NULL),
(N'MR-5142', 4, 43, 15, 4, 3, 2, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-02-14', '2026-02-02', '2026-05-11'),
(N'MR-5143', 7, 52, 13, 5, 2, 4, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 0, '2026-04-17', '2026-03-13', NULL),
(N'MR-5144', 60, 75, 19, 1, 3, 3, N'Power supply instability', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-04-21', '2026-04-04', '2026-03-02'),
(N'MR-5145', 32, 75, 26, 2, 1, 3, N'Battery replacement required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-03', '2026-01-09', NULL),
(N'MR-5146', 101, 55, 23, 4, 3, 4, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 1, '2026-01-01', '2026-05-07', '2026-02-12'),
(N'MR-5147', 1, 43, 35, 4, 2, 3, N'Sensor malfunction', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-04-12', '2026-05-10', NULL),
(N'MR-5148', 21, 74, 24, 1, 3, 3, N'Calibration required', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', N'Maintenance completed successfully after full operational testing.', 0, '2026-04-23', '2026-02-19', '2026-05-10'),
(N'MR-5149', 113, 67, 12, 5, 1, 4, N'Preventive maintenance overdue', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-03-21', '2026-02-24', NULL),
(N'MR-5150', 85, 60, 16, 2, 2, 3, N'Touchscreen unresponsive', N'Technical issue identified during daily operational inspection.', N'Engineer assigned and diagnostic procedures initiated.', NULL, 1, '2026-01-23', '2026-04-09', NULL);







-- MAINTENANCE LOGS
INSERT INTO MaintenanceLogs
(DeviceId, RequestId, MaintenanceTypeId, PerformedByUserId, MaintenanceDate, Details)
VALUES
(64, 32, 3, 19, DATEADD(day,-668,GETUTCDATE()), N'Performed preventive maintenance and calibrated pressure sensors.'),
(103, 2, 5, 12, DATEADD(day,-463,GETUTCDATE()), N'Performed battery health diagnostics and replaced battery module.'),
(67, 110, 1, 13, DATEADD(day,-605,GETUTCDATE()), N'Performed battery health diagnostics and replaced battery module.'),
(79, 115, 2, 34, DATEADD(day,-501,GETUTCDATE()), N'Performed battery health diagnostics and replaced battery module.'),
(46, 103, 4, 24, DATEADD(day,-696,GETUTCDATE()), N'Replaced damaged touchscreen panel and recalibrated controls.'),
(89, 150, 2, 15, DATEADD(day,-151,GETUTCDATE()), N'Inspected electrical grounding and leakage current measurements.'),
(83, 69, 1, 12, DATEADD(day,-600,GETUTCDATE()), N'Performed battery health diagnostics and replaced battery module.'),
(19, 90, 1, 20, DATEADD(day,-154,GETUTCDATE()), N'Conducted operational safety inspection and functionality testing.'),
(66, 20, 4, 25, DATEADD(day,-296,GETUTCDATE()), N'Performed preventive maintenance and calibrated pressure sensors.'),
(29, 136, 1, 14, DATEADD(day,-167,GETUTCDATE()), N'Performed preventive maintenance and calibrated pressure sensors.'),
(98, 82, 1, 8, DATEADD(day,-79,GETUTCDATE()), N'Replaced damaged touchscreen panel and recalibrated controls.'),
(120, 143, 1, 12, DATEADD(day,-697,GETUTCDATE()), N'Inspected electrical grounding and leakage current measurements.'),
(67, 30, 3, 30, DATEADD(day,-406,GETUTCDATE()), N'Replaced damaged touchscreen panel and recalibrated controls.'),
(18, 143, 2, 11, DATEADD(day,-568,GETUTCDATE()), N'Replaced damaged touchscreen panel and recalibrated controls.'),
(75, 149, 5, 8, DATEADD(day,-26,GETUTCDATE()), N'Replaced damaged touchscreen panel and recalibrated controls.'),
(16, 99, 5, 13, DATEADD(day,-248,GETUTCDATE()), N'Updated firmware to latest manufacturer-approved version.'),
(56, 130, 2, 18, DATEADD(day,-446,GETUTCDATE()), N'Performed battery health diagnostics and replaced battery module.'),
(61, 122, 4, 6, DATEADD(day,-283,GETUTCDATE()), N'Performed battery health diagnostics and replaced battery module.'),
(37, 40, 4, 13, DATEADD(day,-671,GETUTCDATE()), N'Conducted operational safety inspection and functionality testing.'),
(23, 17, 3, 25, DATEADD(day,-93,GETUTCDATE()), N'Replaced faulty cooling fan and tested thermal stability.'),
(57, 19, 1, 34, DATEADD(day,-29,GETUTCDATE()), N'Updated firmware to latest manufacturer-approved version.'),
(30, 148, 3, 20, DATEADD(day,-128,GETUTCDATE()), N'Inspected electrical grounding and leakage current measurements.'),
(21, 139, 4, 6, DATEADD(day,-636,GETUTCDATE()), N'Replaced damaged touchscreen panel and recalibrated controls.'),
(103, 77, 2, 35, DATEADD(day,-567,GETUTCDATE()), N'Performed preventive maintenance and calibrated pressure sensors.'),
(32, 129, 2, 29, DATEADD(day,-178,GETUTCDATE()), N'Inspected electrical grounding and leakage current measurements.'),
(11, 74, 1, 13, DATEADD(day,-499,GETUTCDATE()), N'Performed preventive maintenance and calibrated pressure sensors.'),
(31, 128, 2, 29, DATEADD(day,-225,GETUTCDATE()), N'Replaced damaged touchscreen panel and recalibrated controls.'),
(37, 14, 3, 19, DATEADD(day,-410,GETUTCDATE()), N'Replaced damaged touchscreen panel and recalibrated controls.'),
(95, 1, 5, 28, DATEADD(day,-402,GETUTCDATE()), N'Replaced damaged touchscreen panel and recalibrated controls.'),
(92, 65, 4, 6, DATEADD(day,-436,GETUTCDATE()), N'Performed battery health diagnostics and replaced battery module.'),
(104, 22, 1, 29, DATEADD(day,-204,GETUTCDATE()), N'Performed battery health diagnostics and replaced battery module.'),
(118, 34, 2, 28, DATEADD(day,-543,GETUTCDATE()), N'Replaced damaged touchscreen panel and recalibrated controls.'),
(26, 66, 3, 23, DATEADD(day,-391,GETUTCDATE()), N'Performed battery health diagnostics and replaced battery module.'),
(78, 68, 1, 15, DATEADD(day,-111,GETUTCDATE()), N'Inspected electrical grounding and leakage current measurements.'),
(57, 52, 4, 20, DATEADD(day,-35,GETUTCDATE()), N'Replaced faulty cooling fan and tested thermal stability.'),
(92, 116, 4, 12, DATEADD(day,-479,GETUTCDATE()), N'Replaced faulty cooling fan and tested thermal stability.'),
(45, 52, 3, 23, DATEADD(day,-120,GETUTCDATE()), N'Updated firmware to latest manufacturer-approved version.'),
(13, 146, 4, 28, DATEADD(day,-205,GETUTCDATE()), N'Performed preventive maintenance and calibrated pressure sensors.'),
(21, 125, 5, 9, DATEADD(day,-303,GETUTCDATE()), N'Replaced faulty cooling fan and tested thermal stability.'),
(116, 59, 3, 17, DATEADD(day,-345,GETUTCDATE()), N'Performed preventive maintenance and calibrated pressure sensors.');




-- PARTS
INSERT INTO Parts 
(Name, PartNumber, ManufacturerId, QuantityInStock, UnitPrice, MinimumStockLevel, Notes)
VALUES
(N'Cooling Fan Module', N'FAN-CT-210', 2, 145, 637.00, 18, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Power Supply Unit', N'PSU-MRI-88', 8, 139, 1142.00, 23, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Touchscreen Display', N'LCD-VNT-44', 13, 30, 2363.00, 17, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Battery Pack', N'BAT-INF-990', 4, 66, 2391.00, 19, N'Approved spare part compatible with hospital equipment inventory.'),
(N'ECG Sensor Module', N'ECG-MOD-120', 8, 12, 1555.00, 13, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Oxygen Flow Sensor', N'OXY-SNS-774', 2, 102, 2039.00, 5, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Pressure Valve Kit', N'PVK-550', 1, 29, 2079.00, 12, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Infusion Pump Motor', N'MTR-INF-210', 17, 171, 1479.00, 9, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Defibrillator Capacitor', N'DFC-700', 5, 193, 357.00, 17, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Ultrasound Probe Cable', N'UPC-930', 7, 84, 1145.00, 22, N'Approved spare part compatible with hospital equipment inventory.'),
(N'MRI RF Coil', N'RFC-111', 6, 83, 1396.00, 10, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Dialysis Pump Rotor', N'DPR-422', 8, 106, 2264.00, 15, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Ventilator Air Filter', N'VAF-333', 2, 188, 105.00, 16, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Blood Pressure Sensor', N'BPS-821', 7, 115, 2313.00, 24, N'Approved spare part compatible with hospital equipment inventory.'),
(N'Temperature Sensor', N'TMP-440', 4, 61, 2500.00, 21, N'Approved spare part compatible with hospital equipment inventory.');

-- MAINTENANCE PARTS
INSERT INTO MaintenanceParts (MaintenanceRequestId, PartId, QuantityUsed, UnitPrice, Notes)
VALUES
(6, 6, 1, 2500.00, N'Replacement component installed during corrective maintenance procedure.'),
(24, 2, 1, 2133.00, N'Replacement component installed during corrective maintenance procedure.'),
(48, 13, 1, 1178.00, N'Replacement component installed during corrective maintenance procedure.'),
(44, 1, 4, 1276.00, N'Replacement component installed during corrective maintenance procedure.'),
(56, 8, 3, 1425.00, N'Replacement component installed during corrective maintenance procedure.'),
(35, 14, 3, 1593.00, N'Replacement component installed during corrective maintenance procedure.'),
(13, 2, 2, 2346.00, N'Replacement component installed during corrective maintenance procedure.'),
(63, 10, 2, 1265.00, N'Replacement component installed during corrective maintenance procedure.'),
(71, 15, 4, 845.00, N'Replacement component installed during corrective maintenance procedure.'),
(85, 2, 3, 655.00, N'Replacement component installed during corrective maintenance procedure.'),
(102, 15, 4, 253.00, N'Replacement component installed during corrective maintenance procedure.'),
(37, 2, 2, 2342.00, N'Replacement component installed during corrective maintenance procedure.'),
(87, 13, 4, 725.00, N'Replacement component installed during corrective maintenance procedure.'),
(90, 8, 2, 118.00, N'Replacement component installed during corrective maintenance procedure.'),
(36, 5, 2, 398.00, N'Replacement component installed during corrective maintenance procedure.'),
(82, 8, 3, 2234.00, N'Replacement component installed during corrective maintenance procedure.'),
(98, 1, 4, 116.00, N'Replacement component installed during corrective maintenance procedure.'),
(32, 6, 4, 425.00, N'Replacement component installed during corrective maintenance procedure.'),
(84, 10, 4, 525.00, N'Replacement component installed during corrective maintenance procedure.'),
(66, 5, 1, 1452.00, N'Replacement component installed during corrective maintenance procedure.'),
(135, 1, 4, 481.00, N'Replacement component installed during corrective maintenance procedure.'),
(85, 9, 4, 353.00, N'Replacement component installed during corrective maintenance procedure.'),
(99, 7, 3, 593.00, N'Replacement component installed during corrective maintenance procedure.'),
(57, 3, 3, 668.00, N'Replacement component installed during corrective maintenance procedure.'),
(9, 13, 1, 2318.00, N'Replacement component installed during corrective maintenance procedure.'),
(7, 9, 2, 501.00, N'Replacement component installed during corrective maintenance procedure.'),
(111, 5, 1, 2323.00, N'Replacement component installed during corrective maintenance procedure.'),
(108, 12, 4, 1010.00, N'Replacement component installed during corrective maintenance procedure.'),
(10, 11, 2, 591.00, N'Replacement component installed during corrective maintenance procedure.'),
(89, 6, 1, 1239.00, N'Replacement component installed during corrective maintenance procedure.'),
(89, 15, 1, 1759.00, N'Replacement component installed during corrective maintenance procedure.'),
(29, 11, 2, 630.00, N'Replacement component installed during corrective maintenance procedure.'),
(37, 3, 4, 587.00, N'Replacement component installed during corrective maintenance procedure.'),
(105, 13, 1, 260.00, N'Replacement component installed during corrective maintenance procedure.'),
(137, 9, 3, 1511.00, N'Replacement component installed during corrective maintenance procedure.'),
(125, 13, 3, 602.00, N'Replacement component installed during corrective maintenance procedure.'),
(69, 13, 2, 1025.00, N'Replacement component installed during corrective maintenance procedure.'),
(55, 9, 3, 219.00, N'Replacement component installed during corrective maintenance procedure.'),
(10, 9, 2, 1168.00, N'Replacement component installed during corrective maintenance procedure.'),
(115, 9, 2, 815.00, N'Replacement component installed during corrective maintenance procedure.'),
(18, 3, 1, 2257.00, N'Replacement component installed during corrective maintenance procedure.'),
(11, 3, 3, 857.00, N'Replacement component installed during corrective maintenance procedure.'),
(150, 5, 4, 207.00, N'Replacement component installed during corrective maintenance procedure.'),
(88, 3, 2, 2360.00, N'Replacement component installed during corrective maintenance procedure.'),
(8, 4, 2, 1088.00, N'Replacement component installed during corrective maintenance procedure.'),
(41, 10, 1, 2461.00, N'Replacement component installed during corrective maintenance procedure.'),
(121, 8, 4, 1675.00, N'Replacement component installed during corrective maintenance procedure.'),
(97, 11, 3, 684.00, N'Replacement component installed during corrective maintenance procedure.'),
(71, 8, 2, 2274.00, N'Replacement component installed during corrective maintenance procedure.'),
(16, 7, 3, 239.00, N'Replacement component installed during corrective maintenance procedure.'),
(12, 3, 2, 1046.00, N'Replacement component installed during corrective maintenance procedure.'),
(25, 14, 2, 250.00, N'Replacement component installed during corrective maintenance procedure.'),
(137, 7, 1, 1263.00, N'Replacement component installed during corrective maintenance procedure.'),
(73, 13, 4, 2198.00, N'Replacement component installed during corrective maintenance procedure.'),
(42, 15, 1, 2435.00, N'Replacement component installed during corrective maintenance procedure.'),
(81, 1, 3, 1628.00, N'Replacement component installed during corrective maintenance procedure.'),
(65, 12, 4, 1517.00, N'Replacement component installed during corrective maintenance procedure.'),
(107, 6, 1, 2270.00, N'Replacement component installed during corrective maintenance procedure.'),
(55, 15, 1, 1410.00, N'Replacement component installed during corrective maintenance procedure.'),
(123, 15, 4, 1508.00, N'Replacement component installed during corrective maintenance procedure.'),
(7, 3, 1, 2230.00, N'Replacement component installed during corrective maintenance procedure.'),
(125, 2, 2, 373.00, N'Replacement component installed during corrective maintenance procedure.'),
(74, 1, 2, 741.00, N'Replacement component installed during corrective maintenance procedure.'),
(56, 12, 2, 2149.00, N'Replacement component installed during corrective maintenance procedure.'),
(39, 11, 1, 2028.00, N'Replacement component installed during corrective maintenance procedure.'),
(136, 8, 1, 2456.00, N'Replacement component installed during corrective maintenance procedure.'),
(16, 13, 3, 549.00, N'Replacement component installed during corrective maintenance procedure.'),
(115, 13, 1, 734.00, N'Replacement component installed during corrective maintenance procedure.'),
(42, 11, 1, 1342.00, N'Replacement component installed during corrective maintenance procedure.'),
(99, 5, 1, 1290.00, N'Replacement component installed during corrective maintenance procedure.'),
(65, 12, 4, 1150.00, N'Replacement component installed during corrective maintenance procedure.'),
(78, 4, 1, 271.00, N'Replacement component installed during corrective maintenance procedure.'),
(57, 6, 1, 2400.00, N'Replacement component installed during corrective maintenance procedure.'),
(24, 14, 4, 1528.00, N'Replacement component installed during corrective maintenance procedure.'),
(87, 15, 4, 224.00, N'Replacement component installed during corrective maintenance procedure.'),
(52, 5, 4, 84.00, N'Replacement component installed during corrective maintenance procedure.'),
(61, 10, 2, 1238.00, N'Replacement component installed during corrective maintenance procedure.'),
(13, 12, 1, 2027.00, N'Replacement component installed during corrective maintenance procedure.'),
(77, 14, 4, 1659.00, N'Replacement component installed during corrective maintenance procedure.'),
(51, 13, 2, 1380.00, N'Replacement component installed during corrective maintenance procedure.');



INSERT INTO Files (
    FileName,
    OriginalFileName,
    FilePath,
    Extension,
    ContentType,
    FileSize,
    UploadedByUserId
)
VALUES
(N'1_Ultrasound_Probe_Testing_Report.pdf', N'Ultrasound_Probe_Testing_Report.pdf', N'/uploads/documents/1_Ultrasound_Probe_Testing_Report.pdf', N'.pdf', N'application/pdf', 7215759, 71),
(N'2_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/2_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 8557757, 51),
(N'3_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/3_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 1694346, 35),
(N'4_DialysisMachine_Warranty.pdf', N'DialysisMachine_Warranty.pdf', N'/uploads/documents/4_DialysisMachine_Warranty.pdf', N'.pdf', N'application/pdf', 6959005, 46),
(N'5_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/5_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 5040560, 26),
(N'6_DialysisMachine_Warranty.pdf', N'DialysisMachine_Warranty.pdf', N'/uploads/documents/6_DialysisMachine_Warranty.pdf', N'.pdf', N'application/pdf', 5035493, 34),
(N'7_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/7_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 2618273, 54),
(N'8_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/8_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 6698383, 58),
(N'9_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/9_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 3942936, 20),
(N'10_Defibrillator_Service_Log.pdf', N'Defibrillator_Service_Log.pdf', N'/uploads/documents/10_Defibrillator_Service_Log.pdf', N'.pdf', N'application/pdf', 4329364, 58),
(N'11_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/11_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 5158683, 51),
(N'12_Ultrasound_Probe_Testing_Report.pdf', N'Ultrasound_Probe_Testing_Report.pdf', N'/uploads/documents/12_Ultrasound_Probe_Testing_Report.pdf', N'.pdf', N'application/pdf', 1655376, 28),
(N'13_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/13_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 5132474, 57),
(N'14_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/14_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 8969864, 39),
(N'15_Ventilator_Calibration_2026.pdf', N'Ventilator_Calibration_2026.pdf', N'/uploads/documents/15_Ventilator_Calibration_2026.pdf', N'.pdf', N'application/pdf', 4690982, 17),
(N'16_Defibrillator_Service_Log.pdf', N'Defibrillator_Service_Log.pdf', N'/uploads/documents/16_Defibrillator_Service_Log.pdf', N'.pdf', N'application/pdf', 7681773, 76),
(N'17_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/17_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 981145, 67),
(N'18_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/18_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 2247420, 21),
(N'19_DialysisMachine_Warranty.pdf', N'DialysisMachine_Warranty.pdf', N'/uploads/documents/19_DialysisMachine_Warranty.pdf', N'.pdf', N'application/pdf', 6111983, 13),
(N'20_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/20_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 7938968, 15),
(N'21_DialysisMachine_Warranty.pdf', N'DialysisMachine_Warranty.pdf', N'/uploads/documents/21_DialysisMachine_Warranty.pdf', N'.pdf', N'application/pdf', 4091692, 52),
(N'22_Ventilator_Calibration_2026.pdf', N'Ventilator_Calibration_2026.pdf', N'/uploads/documents/22_Ventilator_Calibration_2026.pdf', N'.pdf', N'application/pdf', 5128035, 54),
(N'23_Defibrillator_Service_Log.pdf', N'Defibrillator_Service_Log.pdf', N'/uploads/documents/23_Defibrillator_Service_Log.pdf', N'.pdf', N'application/pdf', 4674985, 22),
(N'24_Ultrasound_Probe_Testing_Report.pdf', N'Ultrasound_Probe_Testing_Report.pdf', N'/uploads/documents/24_Ultrasound_Probe_Testing_Report.pdf', N'.pdf', N'application/pdf', 8886102, 3),
(N'25_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/25_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 5312608, 79),
(N'26_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/26_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 2835725, 62),
(N'27_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/27_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 8837736, 8),
(N'28_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/28_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 1763293, 32),
(N'29_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/29_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 910114, 54),
(N'30_DialysisMachine_Warranty.pdf', N'DialysisMachine_Warranty.pdf', N'/uploads/documents/30_DialysisMachine_Warranty.pdf', N'.pdf', N'application/pdf', 1045844, 70),
(N'31_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/31_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 7096977, 23),
(N'32_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/32_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 5143950, 9),
(N'33_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/33_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 5592474, 73),
(N'34_Ventilator_Calibration_2026.pdf', N'Ventilator_Calibration_2026.pdf', N'/uploads/documents/34_Ventilator_Calibration_2026.pdf', N'.pdf', N'application/pdf', 7329920, 69),
(N'35_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/35_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 2351122, 48),
(N'36_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/36_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 1887537, 73),
(N'37_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/37_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 89605, 55),
(N'38_Defibrillator_Service_Log.pdf', N'Defibrillator_Service_Log.pdf', N'/uploads/documents/38_Defibrillator_Service_Log.pdf', N'.pdf', N'application/pdf', 161050, 48),
(N'39_Ultrasound_Probe_Testing_Report.pdf', N'Ultrasound_Probe_Testing_Report.pdf', N'/uploads/documents/39_Ultrasound_Probe_Testing_Report.pdf', N'.pdf', N'application/pdf', 159899, 20),
(N'40_CTScanner_UserManual.pdf', N'CTScanner_UserManual.pdf', N'/uploads/documents/40_CTScanner_UserManual.pdf', N'.pdf', N'application/pdf', 2889176, 8),
(N'41_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/41_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 6566742, 30),
(N'42_DialysisMachine_Warranty.pdf', N'DialysisMachine_Warranty.pdf', N'/uploads/documents/42_DialysisMachine_Warranty.pdf', N'.pdf', N'application/pdf', 917731, 38),
(N'43_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/43_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 787147, 59),
(N'44_Ventilator_Calibration_2026.pdf', N'Ventilator_Calibration_2026.pdf', N'/uploads/documents/44_Ventilator_Calibration_2026.pdf', N'.pdf', N'application/pdf', 4231548, 15),
(N'45_DialysisMachine_Warranty.pdf', N'DialysisMachine_Warranty.pdf', N'/uploads/documents/45_DialysisMachine_Warranty.pdf', N'.pdf', N'application/pdf', 3542752, 35),
(N'46_CTScanner_UserManual.pdf', N'CTScanner_UserManual.pdf', N'/uploads/documents/46_CTScanner_UserManual.pdf', N'.pdf', N'application/pdf', 5373902, 19),
(N'47_Ultrasound_Probe_Testing_Report.pdf', N'Ultrasound_Probe_Testing_Report.pdf', N'/uploads/documents/47_Ultrasound_Probe_Testing_Report.pdf', N'.pdf', N'application/pdf', 6426513, 80),
(N'48_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/48_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 7018461, 63),
(N'49_CTScanner_UserManual.pdf', N'CTScanner_UserManual.pdf', N'/uploads/documents/49_CTScanner_UserManual.pdf', N'.pdf', N'application/pdf', 7543313, 35),
(N'50_Ventilator_Calibration_2026.pdf', N'Ventilator_Calibration_2026.pdf', N'/uploads/documents/50_Ventilator_Calibration_2026.pdf', N'.pdf', N'application/pdf', 223186, 24),
(N'51_Defibrillator_Service_Log.pdf', N'Defibrillator_Service_Log.pdf', N'/uploads/documents/51_Defibrillator_Service_Log.pdf', N'.pdf', N'application/pdf', 626411, 5),
(N'52_Ventilator_Calibration_2026.pdf', N'Ventilator_Calibration_2026.pdf', N'/uploads/documents/52_Ventilator_Calibration_2026.pdf', N'.pdf', N'application/pdf', 3261914, 6),
(N'53_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/53_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 5919148, 29),
(N'54_DialysisMachine_Warranty.pdf', N'DialysisMachine_Warranty.pdf', N'/uploads/documents/54_DialysisMachine_Warranty.pdf', N'.pdf', N'application/pdf', 8665127, 41),
(N'55_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/55_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 2150183, 73),
(N'56_CTScanner_UserManual.pdf', N'CTScanner_UserManual.pdf', N'/uploads/documents/56_CTScanner_UserManual.pdf', N'.pdf', N'application/pdf', 6137859, 70),
(N'57_DialysisMachine_Warranty.pdf', N'DialysisMachine_Warranty.pdf', N'/uploads/documents/57_DialysisMachine_Warranty.pdf', N'.pdf', N'application/pdf', 7637323, 46),
(N'58_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/58_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 4091630, 28),
(N'59_CTScanner_UserManual.pdf', N'CTScanner_UserManual.pdf', N'/uploads/documents/59_CTScanner_UserManual.pdf', N'.pdf', N'application/pdf', 7418036, 64),
(N'60_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/60_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 4771412, 59),
(N'61_Ventilator_Calibration_2026.pdf', N'Ventilator_Calibration_2026.pdf', N'/uploads/documents/61_Ventilator_Calibration_2026.pdf', N'.pdf', N'application/pdf', 7584519, 80),
(N'62_Ultrasound_Probe_Testing_Report.pdf', N'Ultrasound_Probe_Testing_Report.pdf', N'/uploads/documents/62_Ultrasound_Probe_Testing_Report.pdf', N'.pdf', N'application/pdf', 7355762, 60),
(N'63_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/63_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 3410573, 49),
(N'64_Ventilator_Calibration_2026.pdf', N'Ventilator_Calibration_2026.pdf', N'/uploads/documents/64_Ventilator_Calibration_2026.pdf', N'.pdf', N'application/pdf', 2058806, 39),
(N'65_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/65_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 4693702, 32),
(N'66_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/66_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 6523272, 33),
(N'67_NICU_Incubator_Certificate.pdf', N'NICU_Incubator_Certificate.pdf', N'/uploads/documents/67_NICU_Incubator_Certificate.pdf', N'.pdf', N'application/pdf', 5729554, 62),
(N'68_CTScanner_UserManual.pdf', N'CTScanner_UserManual.pdf', N'/uploads/documents/68_CTScanner_UserManual.pdf', N'.pdf', N'application/pdf', 4576111, 37),
(N'69_Defibrillator_Service_Log.pdf', N'Defibrillator_Service_Log.pdf', N'/uploads/documents/69_Defibrillator_Service_Log.pdf', N'.pdf', N'application/pdf', 5792334, 44),
(N'70_Defibrillator_Service_Log.pdf', N'Defibrillator_Service_Log.pdf', N'/uploads/documents/70_Defibrillator_Service_Log.pdf', N'.pdf', N'application/pdf', 8690104, 51),
(N'71_CTScanner_UserManual.pdf', N'CTScanner_UserManual.pdf', N'/uploads/documents/71_CTScanner_UserManual.pdf', N'.pdf', N'application/pdf', 6163897, 44),
(N'72_CTScanner_UserManual.pdf', N'CTScanner_UserManual.pdf', N'/uploads/documents/72_CTScanner_UserManual.pdf', N'.pdf', N'application/pdf', 580499, 15),
(N'73_InfusionPump_Inspection_Report.pdf', N'InfusionPump_Inspection_Report.pdf', N'/uploads/documents/73_InfusionPump_Inspection_Report.pdf', N'.pdf', N'application/pdf', 6450191, 79),
(N'74_DialysisMachine_Warranty.pdf', N'DialysisMachine_Warranty.pdf', N'/uploads/documents/74_DialysisMachine_Warranty.pdf', N'.pdf', N'application/pdf', 1880528, 64),
(N'75_Ultrasound_Probe_Testing_Report.pdf', N'Ultrasound_Probe_Testing_Report.pdf', N'/uploads/documents/75_Ultrasound_Probe_Testing_Report.pdf', N'.pdf', N'application/pdf', 6017060, 80),
(N'76_Ultrasound_Probe_Testing_Report.pdf', N'Ultrasound_Probe_Testing_Report.pdf', N'/uploads/documents/76_Ultrasound_Probe_Testing_Report.pdf', N'.pdf', N'application/pdf', 1802712, 41),
(N'77_CTScanner_UserManual.pdf', N'CTScanner_UserManual.pdf', N'/uploads/documents/77_CTScanner_UserManual.pdf', N'.pdf', N'application/pdf', 450642, 42),
(N'78_MRI_Preventive_Maintenance_Report.pdf', N'MRI_Preventive_Maintenance_Report.pdf', N'/uploads/documents/78_MRI_Preventive_Maintenance_Report.pdf', N'.pdf', N'application/pdf', 8569727, 31),
(N'79_Ventilator_Calibration_2026.pdf', N'Ventilator_Calibration_2026.pdf', N'/uploads/documents/79_Ventilator_Calibration_2026.pdf', N'.pdf', N'application/pdf', 8221207, 38),
(N'80_Ventilator_Calibration_2026.pdf', N'Ventilator_Calibration_2026.pdf', N'/uploads/documents/80_Ventilator_Calibration_2026.pdf', N'.pdf', N'application/pdf', 7621335, 28);





-- DEVICE FILES
INSERT INTO DeviceFiles (DeviceId, FileId, FileType)
VALUES
(6, 7, N'Inspection Report'),
(70, 19, N'User Manual'),
(52, 27, N'User Manual'),
(114, 52, N'Maintenance Report'),
(106, 67, N'User Manual'),
(40, 77, N'Calibration Certificate'),
(30, 9, N'Inspection Report'),
(113, 8, N'User Manual'),
(93, 37, N'Inspection Report'),
(89, 14, N'User Manual'),
(102, 27, N'Calibration Certificate'),
(35, 77, N'Calibration Certificate'),
(90, 19, N'Calibration Certificate'),
(13, 50, N'Maintenance Report'),
(97, 3, N'Maintenance Report'),
(105, 17, N'User Manual'),
(83, 80, N'Calibration Certificate'),
(98, 68, N'Inspection Report'),
(104, 34, N'User Manual'),
(15, 4, N'Inspection Report'),
(111, 40, N'Calibration Certificate'),
(78, 5, N'Maintenance Report'),
(37, 74, N'Maintenance Report'),
(67, 25, N'Maintenance Report'),
(109, 77, N'Calibration Certificate'),
(96, 10, N'User Manual'),
(36, 34, N'Calibration Certificate'),
(10, 19, N'Maintenance Report'),
(36, 6, N'User Manual'),
(6, 52, N'Maintenance Report'),
(84, 27, N'Inspection Report'),
(107, 3, N'Calibration Certificate'),
(72, 44, N'Maintenance Report'),
(49, 30, N'Calibration Certificate'),
(56, 56, N'Calibration Certificate'),
(79, 42, N'Maintenance Report'),
(39, 56, N'Calibration Certificate'),
(70, 57, N'Calibration Certificate'),
(39, 32, N'Maintenance Report'),
(7, 62, N'Calibration Certificate');


-- MAINTENANCE ATTACHMENTS
INSERT INTO MaintenanceAttachments (MaintenanceRequestId, FileId, Description)
VALUES
(88, 40, N'Attached diagnostic and maintenance documentation for engineering review.'),
(139, 15, N'Attached diagnostic and maintenance documentation for engineering review.'),
(14, 59, N'Attached diagnostic and maintenance documentation for engineering review.'),
(74, 77, N'Attached diagnostic and maintenance documentation for engineering review.'),
(3, 31, N'Attached diagnostic and maintenance documentation for engineering review.'),
(67, 80, N'Attached diagnostic and maintenance documentation for engineering review.'),
(55, 24, N'Attached diagnostic and maintenance documentation for engineering review.'),
(135, 37, N'Attached diagnostic and maintenance documentation for engineering review.'),
(58, 68, N'Attached diagnostic and maintenance documentation for engineering review.'),
(136, 72, N'Attached diagnostic and maintenance documentation for engineering review.'),
(51, 68, N'Attached diagnostic and maintenance documentation for engineering review.'),
(43, 61, N'Attached diagnostic and maintenance documentation for engineering review.'),
(16, 17, N'Attached diagnostic and maintenance documentation for engineering review.'),
(65, 33, N'Attached diagnostic and maintenance documentation for engineering review.'),
(56, 70, N'Attached diagnostic and maintenance documentation for engineering review.'),
(7, 80, N'Attached diagnostic and maintenance documentation for engineering review.'),
(39, 76, N'Attached diagnostic and maintenance documentation for engineering review.'),
(135, 15, N'Attached diagnostic and maintenance documentation for engineering review.'),
(123, 44, N'Attached diagnostic and maintenance documentation for engineering review.'),
(146, 79, N'Attached diagnostic and maintenance documentation for engineering review.'),
(134, 65, N'Attached diagnostic and maintenance documentation for engineering review.'),
(43, 62, N'Attached diagnostic and maintenance documentation for engineering review.'),
(32, 43, N'Attached diagnostic and maintenance documentation for engineering review.'),
(39, 55, N'Attached diagnostic and maintenance documentation for engineering review.'),
(83, 27, N'Attached diagnostic and maintenance documentation for engineering review.'),
(21, 3, N'Attached diagnostic and maintenance documentation for engineering review.'),
(13, 23, N'Attached diagnostic and maintenance documentation for engineering review.'),
(78, 75, N'Attached diagnostic and maintenance documentation for engineering review.'),
(61, 76, N'Attached diagnostic and maintenance documentation for engineering review.'),
(93, 41, N'Attached diagnostic and maintenance documentation for engineering review.'),
(46, 56, N'Attached diagnostic and maintenance documentation for engineering review.'),
(113, 56, N'Attached diagnostic and maintenance documentation for engineering review.'),
(89, 30, N'Attached diagnostic and maintenance documentation for engineering review.'),
(150, 53, N'Attached diagnostic and maintenance documentation for engineering review.'),
(123, 59, N'Attached diagnostic and maintenance documentation for engineering review.'),
(87, 44, N'Attached diagnostic and maintenance documentation for engineering review.'),
(21, 78, N'Attached diagnostic and maintenance documentation for engineering review.'),
(135, 3, N'Attached diagnostic and maintenance documentation for engineering review.'),
(24, 3, N'Attached diagnostic and maintenance documentation for engineering review.'),
(119, 77, N'Attached diagnostic and maintenance documentation for engineering review.'),
(2, 26, N'Attached diagnostic and maintenance documentation for engineering review.'),
(68, 40, N'Attached diagnostic and maintenance documentation for engineering review.'),
(6, 45, N'Attached diagnostic and maintenance documentation for engineering review.'),
(82, 45, N'Attached diagnostic and maintenance documentation for engineering review.'),
(97, 56, N'Attached diagnostic and maintenance documentation for engineering review.'),
(83, 59, N'Attached diagnostic and maintenance documentation for engineering review.'),
(42, 31, N'Attached diagnostic and maintenance documentation for engineering review.'),
(110, 48, N'Attached diagnostic and maintenance documentation for engineering review.'),
(72, 31, N'Attached diagnostic and maintenance documentation for engineering review.'),
(75, 51, N'Attached diagnostic and maintenance documentation for engineering review.'),
(87, 44, N'Attached diagnostic and maintenance documentation for engineering review.'),
(90, 27, N'Attached diagnostic and maintenance documentation for engineering review.'),
(42, 52, N'Attached diagnostic and maintenance documentation for engineering review.'),
(136, 33, N'Attached diagnostic and maintenance documentation for engineering review.'),
(108, 48, N'Attached diagnostic and maintenance documentation for engineering review.'),
(124, 20, N'Attached diagnostic and maintenance documentation for engineering review.'),
(123, 29, N'Attached diagnostic and maintenance documentation for engineering review.'),
(67, 46, N'Attached diagnostic and maintenance documentation for engineering review.'),
(37, 71, N'Attached diagnostic and maintenance documentation for engineering review.'),
(33, 44, N'Attached diagnostic and maintenance documentation for engineering review.');




-- DEVICE WARRANTIES
INSERT INTO DeviceWarranties
(DeviceId, StartDate, EndDate, WarrantyProvider, Terms, FileId)
VALUES
(97, '2023-01-01', '2026-12-31', N'Drager', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 44),
(61, '2024-01-01', '2027-12-31', N'GE Healthcare', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 23),
(64, '2022-01-01', '2025-12-31', N'Drager', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 15),
(87, '2025-01-01', '2028-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 63),
(30, '2024-01-01', '2027-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 59),
(30, '2025-01-01', '2028-12-31', N'Mindray', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 37),
(7, '2022-01-01', '2025-12-31', N'Philips Medical', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 44),
(4, '2024-01-01', '2027-12-31', N'Mindray', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 50),
(8, '2025-01-01', '2028-12-31', N'Mindray', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 76),
(32, '2024-01-01', '2027-12-31', N'Mindray', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 75),
(18, '2024-01-01', '2027-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 9),
(1, '2024-01-01', '2027-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 55),
(30, '2024-01-01', '2027-12-31', N'Mindray', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 47),
(6, '2023-01-01', '2026-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 58),
(13, '2024-01-01', '2027-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 66),
(4, '2024-01-01', '2027-12-31', N'Drager', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 62),
(48, '2022-01-01', '2025-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 44),
(27, '2025-01-01', '2028-12-31', N'GE Healthcare', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 17),
(39, '2024-01-01', '2027-12-31', N'GE Healthcare', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 12),
(96, '2024-01-01', '2027-12-31', N'Mindray', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 5),
(107, '2022-01-01', '2025-12-31', N'GE Healthcare', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 2),
(2, '2023-01-01', '2026-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 44),
(27, '2025-01-01', '2028-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 13),
(100, '2022-01-01', '2025-12-31', N'Mindray', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 34),
(110, '2023-01-01', '2026-12-31', N'Philips Medical', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 28),
(100, '2023-01-01', '2026-12-31', N'GE Healthcare', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 66),
(35, '2025-01-01', '2028-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 30),
(39, '2024-01-01', '2027-12-31', N'Siemens Healthineers', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 11),
(46, '2024-01-01', '2027-12-31', N'Philips Medical', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 30),
(52, '2023-01-01', '2026-12-31', N'Philips Medical', N'Comprehensive manufacturer warranty covering replacement parts, labor, and certified service maintenance.', 48);



-- REPORT FILES
INSERT INTO ReportFiles (ReportId, FileId)
VALUES
(16, 1),
(20, 67),
(35, 53),
(13, 7),
(6, 8),
(33, 5),
(17, 50),
(6, 63),
(1, 7),
(35, 39),
(8, 12),
(12, 66),
(14, 66),
(24, 33),
(37, 33),
(39, 49),
(9, 49),
(2, 8),
(32, 40),
(5, 37),
(13, 36),
(31, 6),
(26, 19),
(7, 51),
(6, 50),
(22, 27),
(9, 32),
(25, 45),
(6, 28),
(40, 3),
(15, 76),
(38, 5),
(2, 30),
(18, 3),
(27, 54),
(1, 35),
(38, 47),
(38, 14),
(13, 12),
(38, 17);




-- SAMPLE COMPLETE INSERTS

INSERT INTO NotificationTypes (Name, Icon)
VALUES
(N'Maintenance Alert', N'fa-tools'),
(N'Warranty Warning', N'fa-shield-alt'),
(N'Device Offline', N'fa-exclamation-triangle');

INSERT INTO NotificationPriorityLevels (Name, CssClass)
VALUES
(N'Low', N'secondary'),
(N'Medium', N'info'),
(N'High', N'warning'),
(N'Critical', N'danger');

INSERT INTO Notifications
(
    Title,
    Message,
    TypeId,
    PriorityLevelId,
    RelatedEntityType,
    RelatedEntityId,
    IsGlobal
)
VALUES
(
    N'Ventilator Maintenance Due',
    N'Preventive maintenance for ICU Ventilator DEV-1025 is scheduled within 3 days.',
    1,
    3,
    N'Device',
    25,
    1
),
(
    N'CT Scanner Offline',
    N'Radiology CT Scanner DEV-1042 stopped responding to the monitoring service.',
    3,
    4,
    N'Device',
    42,
    1
);

INSERT INTO UserNotifications
(
    UserId,
    NotificationId,
    IsRead,
    ReadAt
)
VALUES
(
    12,
    1,
    1,
    DATEADD(hour, -2, GETUTCDATE())
),
(
    18,
    2,
    0,
    NULL
);

-- REPORTS
INSERT INTO Reports
(
    Title,
    ReportType,
    Format,
    Parameters,
    GeneratedByUserId
)
VALUES
(
    N'Radiology MRI Calibration Compliance Report - January 2026',
    N'Calibration Report',
    N'PDF',
    N'{"department":"Radiology","deviceType":"MRI Scanner","month":"January","year":"2026"}',
    4
),
(
    N'ICU Ventilator Preventive Maintenance Status',
    N'Maintenance Summary',
    N'PDF',
    N'{"department":"ICU","deviceType":"Ventilator","quarter":"Q1-2026"}',
    2
),
(
    N'CT Scanner Downtime Analysis Report',
    N'Operational Analytics',
    N'PDF',
    N'{"department":"Radiology","device":"CT Scanner","period":"Q4-2025"}',
    7
),
(
    N'Laboratory Blood Gas Analyzer Inspection Results',
    N'Inspection Report',
    N'PDF',
    N'{"department":"Laboratory","inspectionMonth":"February","year":"2026"}',
    5
),
(
    N'Emergency Department Defibrillator Readiness Audit',
    N'Safety Audit',
    N'PDF',
    N'{"department":"Emergency","deviceType":"Defibrillator","auditYear":"2026"}',
    8
),
(
    N'NICU Incubator Preventive Maintenance Summary',
    N'Maintenance Summary',
    N'PDF',
    N'{"department":"NICU","deviceType":"Infant Incubator","quarter":"Q1-2026"}',
    3
),
(
    N'Operating Rooms Anesthesia Machine Performance Report',
    N'Performance Report',
    N'PDF',
    N'{"department":"Operating Rooms","deviceType":"Anesthesia Machine","month":"March","year":"2026"}',
    9
),
(
    N'Dialysis Unit Equipment Service History',
    N'Service History',
    N'PDF',
    N'{"department":"Dialysis","deviceType":"Dialysis Machine","year":"2025"}',
    6
),
(
    N'Cardiology ECG Monitor Calibration Certificates',
    N'Calibration Report',
    N'PDF',
    N'{"department":"Cardiology","deviceType":"ECG Monitor","year":"2026"}',
    11
),
(
    N'Ultrasound Systems Preventive Maintenance Overview',
    N'Maintenance Overview',
    N'PDF',
    N'{"department":"Radiology","deviceType":"Ultrasound Machine","quarter":"Q2-2026"}',
    10
),
(
    N'Sterilization Unit Equipment Validation Report',
    N'Validation Report',
    N'PDF',
    N'{"department":"Sterilization","validationCycle":"2026"}',
    13
),
(
    N'Patient Monitor Failure Trend Analysis',
    N'Failure Analysis',
    N'PDF',
    N'{"deviceType":"Patient Monitor","analysisPeriod":"2025"}',
    14
),
(
    N'Infusion Pump Battery Replacement Summary',
    N'Replacement Report',
    N'PDF',
    N'{"deviceType":"Infusion Pump","maintenanceType":"Battery Replacement","quarter":"Q1-2026"}',
    5
),
(
    N'MRI Scanner Annual Safety Inspection',
    N'Safety Inspection',
    N'PDF',
    N'{"deviceType":"MRI Scanner","inspectionYear":"2026"}',
    15
),
(
    N'Critical Devices Compliance Dashboard Export',
    N'Compliance Report',
    N'PDF',
    N'{"riskLevel":"Critical","generatedFor":"Hospital Administration"}',
    1
),
(
    N'ICU Preventive Maintenance Summary Q1 2026',
    N'Maintenance Summary',
    N'PDF',
    N'{"department":"ICU","quarter":"Q1-2026"}',
    2
),
(
    N'Respiratory Therapy Ventilator Calibration Report',
    N'Calibration Report',
    N'PDF',
    N'{"department":"Respiratory Therapy","month":"April","year":"2026"}',
    16
),
(
    N'X-Ray Machine Quality Assurance Report',
    N'Quality Assurance',
    N'PDF',
    N'{"department":"Radiology","deviceType":"X-Ray Machine","year":"2026"}',
    12
),
(
    N'Biomedical Engineering Monthly Workload Summary',
    N'Operational Summary',
    N'PDF',
    N'{"department":"Biomedical Engineering","month":"March","year":"2026"}',
    2
),
(
    N'Preventive Maintenance SLA Compliance Report',
    N'SLA Report',
    N'PDF',
    N'{"period":"Q1-2026","scope":"Hospital Wide"}',
    1
),
(
    N'Patient Monitor Network Connectivity Audit',
    N'Network Audit',
    N'PDF',
    N'{"deviceType":"Patient Monitor","auditDate":"2026-03"}',
    18
),
(
    N'Critical Alarm Events Investigation Summary',
    N'Incident Investigation',
    N'PDF',
    N'{"priority":"Critical","period":"February 2026"}',
    7
),
(
    N'Infant Incubator Temperature Stability Report',
    N'Performance Validation',
    N'PDF',
    N'{"department":"NICU","deviceType":"Infant Incubator"}',
    6
),
(
    N'Surgical Equipment Maintenance Completion Report',
    N'Completion Report',
    N'PDF',
    N'{"department":"Operating Rooms","month":"January","year":"2026"}',
    9
),
(
    N'Electrosurgical Unit Preventive Inspection',
    N'Inspection Report',
    N'PDF',
    N'{"deviceType":"Electrosurgical Unit","inspectionQuarter":"Q1-2026"}',
    5
),
(
    N'Laboratory Equipment Downtime Statistics',
    N'Downtime Report',
    N'PDF',
    N'{"department":"Laboratory","year":"2025"}',
    4
),
(
    N'Defibrillator Battery Health Assessment',
    N'Battery Assessment',
    N'PDF',
    N'{"deviceType":"Defibrillator","assessmentMonth":"February","year":"2026"}',
    8
),
(
    N'Annual Medical Equipment Asset Utilization Report',
    N'Asset Utilization',
    N'PDF',
    N'{"year":"2025","scope":"Hospital Wide"}',
    1
),
(
    N'Operating Theater Equipment Calibration Certificates',
    N'Calibration Certificates',
    N'PDF',
    N'{"department":"Operating Rooms","year":"2026"}',
    3
),
(
    N'Critical Care Device Maintenance Backlog',
    N'Maintenance Backlog',
    N'PDF',
    N'{"department":"ICU","generatedMonth":"March","year":"2026"}',
    2
),
(
    N'Preventive Maintenance Completion KPI Dashboard',
    N'KPI Report',
    N'PDF',
    N'{"period":"Q1-2026","department":"Biomedical Engineering"}',
    11
),
(
    N'Warranty Expiration Forecast Report',
    N'Warranty Report',
    N'PDF',
    N'{"forecastPeriod":"2026","scope":"Medical Devices"}',
    13
),
(
    N'Ultrasound Probe Replacement History',
    N'Replacement History',
    N'PDF',
    N'{"deviceType":"Ultrasound Machine","component":"Probe"}',
    14
),
(
    N'Central Monitoring System Incident Review',
    N'Incident Review',
    N'PDF',
    N'{"system":"Central Monitoring","reviewYear":"2026"}',
    15
),
(
    N'CT Scanner Cooling System Maintenance Report',
    N'Maintenance Report',
    N'PDF',
    N'{"deviceType":"CT Scanner","component":"Cooling System"}',
    7
),
(
    N'Radiology Equipment Preventive Maintenance Schedule',
    N'Schedule Report',
    N'PDF',
    N'{"department":"Radiology","scheduleQuarter":"Q2-2026"}',
    10
),
(
    N'Biomedical Spare Parts Consumption Analysis',
    N'Inventory Analysis',
    N'PDF',
    N'{"year":"2025","inventory":"Medical Spare Parts"}',
    6
),
(
    N'ECG Device Software Update Verification',
    N'Software Verification',
    N'PDF',
    N'{"deviceType":"ECG Monitor","softwareVersion":"v5.2"}',
    12
),
(
    N'Critical Device Incident Escalation Report',
    N'Incident Escalation',
    N'PDF',
    N'{"priority":"Critical","period":"Q1-2026"}',
    1
),
(
    N'Ventilator Sensor Replacement Completion Report',
    N'Completion Report',
    N'PDF',
    N'{"deviceType":"Ventilator","maintenanceAction":"Sensor Replacement"}',
    5
),
(
    N'Hospital-Wide Medical Equipment Compliance Audit',
    N'Compliance Audit',
    N'PDF',
    N'{"scope":"Hospital Wide","auditYear":"2026"}',
    1
);


INSERT INTO ReportFiles (ReportId, FileId)
VALUES
    (16, 1),
    (20, 67),
    (35, 53),
    (13, 7),
    (6, 8),
    (33, 5),
    (17, 50),
    (6, 63),
    (1, 7),
    (35, 39),
    (8, 12),
    (12, 66),
    (14, 66),
    (24, 33),
    (37, 33),
    (39, 49),
    (9, 49),
    (2, 8),
    (32, 40),
    (5, 37),
    (13, 36),
    (31, 6),
    (26, 19),
    (7, 51),
    (6, 50),
    (22, 27),
    (9, 32),
    (25, 45),
    (6, 28),
    (40, 3),
    (15, 76),
    (38, 5),
    (2, 30),
    (18, 3),
    (27, 54),
    (1, 35),
    (38, 47),
    (38, 14),
    (13, 12),
    (38, 17);






INSERT INTO AuditLogs (UserId, Action, EntityType, EntityId, OldValues, NewValues, IpAddress, UserAgent, OccurredAt) VALUES 
(1, N'UPDATE_DEVICE', N'Device', 78, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.122', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-3,GETUTCDATE())),
(23, N'CREATE_DEVICE', N'Device', 53, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.143', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-357,GETUTCDATE())),
(63, N'COMPLETE_MAINTENANCE', N'Device', 98, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.101', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-276,GETUTCDATE())),
(10, N'CREATE_DEVICE', N'Device', 69, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.8', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-344,GETUTCDATE())),
(16, N'CREATE_REQUEST', N'Device', 46, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.249', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-193,GETUTCDATE())),
(46, N'ASSIGN_ENGINEER', N'Device', 50, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.46', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-394,GETUTCDATE())),
(2, N'COMPLETE_MAINTENANCE', N'Device', 16, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.119', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-190,GETUTCDATE())),
(57, N'UPDATE_DEVICE', N'Device', 2, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.57', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-381,GETUTCDATE())),
(36, N'CREATE_DEVICE', N'Device', 88, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.236', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-364,GETUTCDATE())),
(25, N'LOGIN_SUCCESS', N'Device', 12, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.209', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-315,GETUTCDATE())),
(39, N'COMPLETE_MAINTENANCE', N'Device', 104, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.184', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-114,GETUTCDATE())),
(64, N'UPDATE_DEVICE', N'Device', 47, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.10', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-144,GETUTCDATE())),
(78, N'CREATE_REQUEST', N'Device', 27, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.2', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-101,GETUTCDATE())),
(51, N'COMPLETE_MAINTENANCE', N'Device', 15, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.223', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-143,GETUTCDATE())),
(65, N'ASSIGN_ENGINEER', N'Device', 64, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.44', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-283,GETUTCDATE())),
(73, N'UPDATE_DEVICE', N'Device', 87, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.175', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-309,GETUTCDATE())),
(23, N'ASSIGN_ENGINEER', N'Device', 9, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.151', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-66,GETUTCDATE())),
(9, N'COMPLETE_MAINTENANCE', N'Device', 17, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.67', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-292,GETUTCDATE())),
(67, N'UPDATE_DEVICE', N'Device', 94, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.201', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-141,GETUTCDATE())),
(3, N'UPDATE_DEVICE', N'Device', 89, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.174', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-273,GETUTCDATE())),
(33, N'ASSIGN_ENGINEER', N'Device', 88, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.144', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-233,GETUTCDATE())),
(55, N'CREATE_DEVICE', N'Device', 83, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.173', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-333,GETUTCDATE())),
(42, N'CREATE_DEVICE', N'Device', 56, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.217', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-209,GETUTCDATE())),
(16, N'LOGIN_SUCCESS', N'Device', 88, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.133', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-239,GETUTCDATE())),
(47, N'CREATE_REQUEST', N'Device', 67, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.195', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-23,GETUTCDATE())),
(29, N'COMPLETE_MAINTENANCE', N'Device', 7, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.72', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-216,GETUTCDATE())),
(58, N'ASSIGN_ENGINEER', N'Device', 41, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.2', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-201,GETUTCDATE())),
(43, N'UPDATE_DEVICE', N'Device', 11, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.226', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-293,GETUTCDATE())),
(29, N'CREATE_DEVICE', N'Device', 89, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.109', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-39,GETUTCDATE())),
(26, N'UPDATE_DEVICE', N'Device', 22, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.85', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-160,GETUTCDATE())),
(13, N'CREATE_DEVICE', N'Device', 4, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.123', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-222,GETUTCDATE())),
(76, N'CREATE_DEVICE', N'Device', 103, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.161', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-172,GETUTCDATE())),
(32, N'LOGIN_SUCCESS', N'Device', 14, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.122', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-123,GETUTCDATE())),
(7, N'LOGIN_SUCCESS', N'Device', 106, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.86', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-267,GETUTCDATE())),
(10, N'UPDATE_DEVICE', N'Device', 100, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.154', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-318,GETUTCDATE())),
(13, N'CREATE_REQUEST', N'Device', 81, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.115', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-297,GETUTCDATE())),
(11, N'CREATE_DEVICE', N'Device', 8, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.235', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-18,GETUTCDATE())),
(41, N'CREATE_REQUEST', N'Device', 114, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.218', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-356,GETUTCDATE())),
(17, N'CREATE_DEVICE', N'Device', 8, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.236', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-227,GETUTCDATE())),
(39, N'CREATE_DEVICE', N'Device', 79, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.161', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-222,GETUTCDATE())),
(14, N'CREATE_DEVICE', N'Device', 87, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.15', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-287,GETUTCDATE())),
(38, N'CREATE_DEVICE', N'Device', 109, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.98', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-206,GETUTCDATE())),
(80, N'CREATE_DEVICE', N'Device', 97, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.106', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-120,GETUTCDATE())),
(80, N'ASSIGN_ENGINEER', N'Device', 2, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.117', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-197,GETUTCDATE())),
(55, N'CREATE_REQUEST', N'Device', 113, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.159', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-318,GETUTCDATE())),
(44, N'CREATE_DEVICE', N'Device', 84, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.241', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-346,GETUTCDATE())),
(59, N'CREATE_DEVICE', N'Device', 67, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.85', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-301,GETUTCDATE())),
(14, N'UPDATE_DEVICE', N'Device', 14, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.4', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-305,GETUTCDATE())),
(9, N'COMPLETE_MAINTENANCE', N'Device', 76, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.203', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-100,GETUTCDATE())),
(17, N'ASSIGN_ENGINEER', N'Device', 82, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.131', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-132,GETUTCDATE())),
(54, N'LOGIN_SUCCESS', N'Device', 62, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.186', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-318,GETUTCDATE())),
(24, N'CREATE_REQUEST', N'Device', 32, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.36', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-23,GETUTCDATE())),
(17, N'CREATE_DEVICE', N'Device', 40, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.150', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-224,GETUTCDATE())),
(46, N'ASSIGN_ENGINEER', N'Device', 40, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.150', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-278,GETUTCDATE())),
(19, N'UPDATE_DEVICE', N'Device', 61, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.80', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-309,GETUTCDATE())),
(38, N'LOGIN_SUCCESS', N'Device', 48, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.249', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-5,GETUTCDATE())),
(76, N'ASSIGN_ENGINEER', N'Device', 85, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.174', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-75,GETUTCDATE())),
(31, N'CREATE_DEVICE', N'Device', 65, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.210', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-287,GETUTCDATE())),
(55, N'CREATE_DEVICE', N'Device', 45, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.51', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-103,GETUTCDATE())),
(26, N'COMPLETE_MAINTENANCE', N'Device', 101, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.18', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-175,GETUTCDATE())),
(61, N'UPDATE_DEVICE', N'Device', 89, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.178', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-240,GETUTCDATE())),
(43, N'ASSIGN_ENGINEER', N'Device', 110, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.149', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-290,GETUTCDATE())),
(79, N'LOGIN_SUCCESS', N'Device', 39, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.108', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-169,GETUTCDATE())),
(14, N'UPDATE_DEVICE', N'Device', 59, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.225', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-22,GETUTCDATE())),
(29, N'CREATE_REQUEST', N'Device', 118, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-328,GETUTCDATE())),
(30, N'UPDATE_DEVICE', N'Device', 60, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.160', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-110,GETUTCDATE())),
(62, N'UPDATE_DEVICE', N'Device', 95, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.197', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-170,GETUTCDATE())),
(49, N'COMPLETE_MAINTENANCE', N'Device', 27, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.103', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-95,GETUTCDATE())),
(47, N'CREATE_DEVICE', N'Device', 2, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.19', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-184,GETUTCDATE())),
(72, N'CREATE_DEVICE', N'Device', 15, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.37', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-149,GETUTCDATE())),
(25, N'CREATE_REQUEST', N'Device', 81, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.150', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-392,GETUTCDATE())),
(6, N'LOGIN_SUCCESS', N'Device', 4, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.51', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-102,GETUTCDATE())),
(23, N'LOGIN_SUCCESS', N'Device', 29, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.227', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-135,GETUTCDATE())),
(23, N'COMPLETE_MAINTENANCE', N'Device', 44, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.217', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-284,GETUTCDATE())),
(23, N'UPDATE_DEVICE', N'Device', 26, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.6', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-91,GETUTCDATE())),
(13, N'LOGIN_SUCCESS', N'Device', 3, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.213', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-347,GETUTCDATE())),
(49, N'UPDATE_DEVICE', N'Device', 84, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.202', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-57,GETUTCDATE())),
(27, N'LOGIN_SUCCESS', N'Device', 40, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.117', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-123,GETUTCDATE())),
(48, N'LOGIN_SUCCESS', N'Device', 85, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.44', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-270,GETUTCDATE())),
(56, N'ASSIGN_ENGINEER', N'Device', 113, N'{"status":"Pending Inspection","risk":"Medium"}', N'{"status":"Operational","risk":"High"}', N'192.168.1.183', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATEADD(hour,-34,GETUTCDATE()));






INSERT INTO SystemLogs (Level, Source, Message, Exception, UserId, IpAddress, OccurredAt) VALUES 
(N'Information', N'SMEMS.WebAPI', N'Device communication timeout detected', NULL, 17, N'10.0.0.204', DATEADD(minute,-3108,GETUTCDATE())),
(N'Warning', N'SMEMS.WebAPI', N'Application service restarted', NULL, 49, N'10.0.0.178', DATEADD(minute,-6132,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Application service restarted', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 55, N'10.0.0.251', DATEADD(minute,-4007,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Application service restarted', NULL, 76, N'10.0.0.49', DATEADD(minute,-8774,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Device communication timeout detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 42, N'10.0.0.64', DATEADD(minute,-873,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Device communication timeout detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 66, N'10.0.0.248', DATEADD(minute,-9570,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Device communication timeout detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 11, N'10.0.0.201', DATEADD(minute,-7712,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Device communication timeout detected', NULL, 66, N'10.0.0.100', DATEADD(minute,-8343,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 67, N'10.0.0.119', DATEADD(minute,-2933,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Backup completed successfully', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 68, N'10.0.0.178', DATEADD(minute,-7919,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 35, N'10.0.0.149', DATEADD(minute,-6570,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Device communication timeout detected', NULL, 29, N'10.0.0.230', DATEADD(minute,-3326,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Device communication timeout detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 51, N'10.0.0.56', DATEADD(minute,-5014,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 74, N'10.0.0.41', DATEADD(minute,-6130,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Application service restarted', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 11, N'10.0.0.35', DATEADD(minute,-1377,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 67, N'10.0.0.91', DATEADD(minute,-3772,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', NULL, 66, N'10.0.0.160', DATEADD(minute,-5512,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 60, N'10.0.0.111', DATEADD(minute,-6701,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 41, N'10.0.0.70', DATEADD(minute,-6265,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Device communication timeout detected', NULL, 57, N'10.0.0.60', DATEADD(minute,-4352,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Backup completed successfully', NULL, 11, N'10.0.0.76', DATEADD(minute,-8221,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Backup completed successfully', NULL, 30, N'10.0.0.26', DATEADD(minute,-1943,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Backup completed successfully', NULL, 5, N'10.0.0.140', DATEADD(minute,-3282,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Device communication timeout detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 43, N'10.0.0.65', DATEADD(minute,-4960,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Device communication timeout detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 78, N'10.0.0.36', DATEADD(minute,-8899,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Scheduled maintenance service started', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 39, N'10.0.0.73', DATEADD(minute,-5680,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 75, N'10.0.0.194', DATEADD(minute,-195,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Application service restarted', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 20, N'10.0.0.222', DATEADD(minute,-6513,GETUTCDATE())),
(N'Warning', N'SMEMS.WebAPI', N'Device communication timeout detected', NULL, 27, N'10.0.0.122', DATEADD(minute,-3830,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 44, N'10.0.0.203', DATEADD(minute,-1407,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Device communication timeout detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 55, N'10.0.0.198', DATEADD(minute,-6844,GETUTCDATE())),
(N'Warning', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', NULL, 58, N'10.0.0.219', DATEADD(minute,-9150,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Backup completed successfully', NULL, 18, N'10.0.0.148', DATEADD(minute,-2103,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Scheduled maintenance service started', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 64, N'10.0.0.208', DATEADD(minute,-5811,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Device communication timeout detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 54, N'10.0.0.109', DATEADD(minute,-6609,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Backup completed successfully', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 76, N'10.0.0.6', DATEADD(minute,-9300,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Device communication timeout detected', NULL, 20, N'10.0.0.251', DATEADD(minute,-5411,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 27, N'10.0.0.243', DATEADD(minute,-6401,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Application service restarted', NULL, 50, N'10.0.0.49', DATEADD(minute,-7779,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Backup completed successfully', NULL, 73, N'10.0.0.247', DATEADD(minute,-7398,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Scheduled maintenance service started', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 22, N'10.0.0.27', DATEADD(minute,-9059,GETUTCDATE())),
(N'Warning', N'SMEMS.WebAPI', N'Scheduled maintenance service started', NULL, 78, N'10.0.0.126', DATEADD(minute,-440,GETUTCDATE())),
(N'Warning', N'SMEMS.WebAPI', N'Device communication timeout detected', NULL, 9, N'10.0.0.234', DATEADD(minute,-6323,GETUTCDATE())),
(N'Error', N'SMEMS.WebAPI', N'Device communication timeout detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 30, N'10.0.0.75', DATEADD(minute,-8592,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', NULL, 8, N'10.0.0.95', DATEADD(minute,-8496,GETUTCDATE())),
(N'Information', N'SMEMS.WebAPI', N'Device communication timeout detected', NULL, 42, N'10.0.0.221', DATEADD(minute,-6732,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Device communication timeout detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 15, N'10.0.0.34', DATEADD(minute,-8790,GETUTCDATE())),
(N'Critical', N'SMEMS.WebAPI', N'Unauthorized login attempt detected', N'System.Data.SqlClient.SqlException: Timeout expired during query execution.', 9, N'10.0.0.100', DATEADD(minute,-3383,GETUTCDATE())),
(N'Warning', N'SMEMS.WebAPI', N'Device communication timeout detected', NULL, 40, N'10.0.0.111', DATEADD(minute,-7779,GETUTCDATE())),
(N'Warning', N'SMEMS.WebAPI', N'Application service restarted', NULL, 74, N'10.0.0.241', DATEADD(minute,-5085,GETUTCDATE()));






