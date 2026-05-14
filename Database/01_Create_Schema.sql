-- =============================================
-- SMEMS Database Schema
-- Smart Medical Equipment Management System
-- SQL Server 2019+
-- Author: SMEMS Development Team
-- Date: 2026
-- =============================================

-- Create Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'SMEMS_DB')
BEGIN
    CREATE DATABASE SMEMS_DB;
END
GO

USE SMEMS_DB;
GO

-- =============================================
-- DROP EXISTING TABLES (for clean install)
-- =============================================

-- Drop tables in reverse dependency order
IF OBJECT_ID('dbo.ActivityHistory', 'U') IS NOT NULL DROP TABLE dbo.ActivityHistory;
IF OBJECT_ID('dbo.AuditLogs', 'U') IS NOT NULL DROP TABLE dbo.AuditLogs;
IF OBJECT_ID('dbo.Attachments', 'U') IS NOT NULL DROP TABLE dbo.Attachments;
IF OBJECT_ID('dbo.DeviceAssignments', 'U') IS NOT NULL DROP TABLE dbo.DeviceAssignments;
IF OBJECT_ID('dbo.Reports', 'U') IS NOT NULL DROP TABLE dbo.Reports;
IF OBJECT_ID('dbo.Notifications', 'U') IS NOT NULL DROP TABLE dbo.Notifications;
IF OBJECT_ID('dbo.MaintenanceLogs', 'U') IS NOT NULL DROP TABLE dbo.MaintenanceLogs;
IF OBJECT_ID('dbo.MaintenanceRequests', 'U') IS NOT NULL DROP TABLE dbo.MaintenanceRequests;
IF OBJECT_ID('dbo.DeviceAccessories', 'U') IS NOT NULL DROP TABLE dbo.DeviceAccessories;
IF OBJECT_ID('dbo.Devices', 'U') IS NOT NULL DROP TABLE dbo.Devices;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.ReportTypes', 'U') IS NOT NULL DROP TABLE dbo.ReportTypes;
IF OBJECT_ID('dbo.NotificationTypes', 'U') IS NOT NULL DROP TABLE dbo.NotificationTypes;
IF OBJECT_ID('dbo.RequestStatuses', 'U') IS NOT NULL DROP TABLE dbo.RequestStatuses;
IF OBJECT_ID('dbo.MaintenanceTypes', 'U') IS NOT NULL DROP TABLE dbo.MaintenanceTypes;
IF OBJECT_ID('dbo.Priorities', 'U') IS NOT NULL DROP TABLE dbo.Priorities;
IF OBJECT_ID('dbo.RiskLevels', 'U') IS NOT NULL DROP TABLE dbo.RiskLevels;
IF OBJECT_ID('dbo.DeviceStatuses', 'U') IS NOT NULL DROP TABLE dbo.DeviceStatuses;
IF OBJECT_ID('dbo.Suppliers', 'U') IS NOT NULL DROP TABLE dbo.Suppliers;
IF OBJECT_ID('dbo.Manufacturers', 'U') IS NOT NULL DROP TABLE dbo.Manufacturers;
IF OBJECT_ID('dbo.DeviceCategories', 'U') IS NOT NULL DROP TABLE dbo.DeviceCategories;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL DROP TABLE dbo.Roles;
GO

PRINT 'Existing tables dropped successfully.';
GO

-- =============================================
-- LOOKUP TABLES
-- =============================================

-- Roles Table
CREATE TABLE Roles (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'Roles table created.';
GO

-- Departments Table
CREATE TABLE Departments (
    DepartmentId INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL UNIQUE,
    DepartmentCode NVARCHAR(20) NOT NULL UNIQUE,
    Description NVARCHAR(500),
    Location NVARCHAR(255),
    PhoneExtension NVARCHAR(20),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'Departments table created.';
GO

-- Device Categories Table
CREATE TABLE DeviceCategories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    CategoryCode NVARCHAR(20) NOT NULL UNIQUE,
    Description NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'DeviceCategories table created.';
GO

-- Manufacturers Table
CREATE TABLE Manufacturers (
    ManufacturerId INT IDENTITY(1,1) PRIMARY KEY,
    ManufacturerName NVARCHAR(150) NOT NULL,
    ContactPerson NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(30),
    Address NVARCHAR(500),
    Website NVARCHAR(255),
    Country NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'Manufacturers table created.';
GO

-- Suppliers Table
CREATE TABLE Suppliers (
    SupplierId INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(150) NOT NULL,
    ContactPerson NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(30),
    Address NVARCHAR(500),
    Website NVARCHAR(255),
    Country NVARCHAR(100),
    ContractStartDate DATE,
    ContractEndDate DATE,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'Suppliers table created.';
GO

-- Device Statuses Table
CREATE TABLE DeviceStatuses (
    StatusId INT IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(50) NOT NULL UNIQUE,
    StatusCode NVARCHAR(20) NOT NULL UNIQUE,
    ColorCode NVARCHAR(7), -- Hex color for UI
    Description NVARCHAR(255),
    DisplayOrder INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'DeviceStatuses table created.';
GO

-- Risk Levels Table
CREATE TABLE RiskLevels (
    RiskLevelId INT IDENTITY(1,1) PRIMARY KEY,
    RiskLevelName NVARCHAR(50) NOT NULL UNIQUE,
    RiskLevelCode NVARCHAR(20) NOT NULL UNIQUE,
    ColorCode NVARCHAR(7),
    Description NVARCHAR(255),
    DisplayOrder INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'RiskLevels table created.';
GO

-- Priorities Table
CREATE TABLE Priorities (
    PriorityId INT IDENTITY(1,1) PRIMARY KEY,
    PriorityName NVARCHAR(50) NOT NULL UNIQUE,
    PriorityCode NVARCHAR(20) NOT NULL UNIQUE,
    ColorCode NVARCHAR(7),
    Description NVARCHAR(255),
    ResponseTimeHours INT, -- Expected response time
    DisplayOrder INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'Priorities table created.';
GO

-- Maintenance Types Table
CREATE TABLE MaintenanceTypes (
    MaintenanceTypeId INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL UNIQUE,
    TypeCode NVARCHAR(20) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'MaintenanceTypes table created.';
GO

-- Notification Types Table
CREATE TABLE NotificationTypes (
    NotificationTypeId INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL UNIQUE,
    TypeCode NVARCHAR(30) NOT NULL UNIQUE,
    IconName NVARCHAR(50),
    ColorCode NVARCHAR(7),
    Description NVARCHAR(255),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'NotificationTypes table created.';
GO

-- Report Types Table
CREATE TABLE ReportTypes (
    ReportTypeId INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL UNIQUE,
    TypeCode NVARCHAR(30) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    TemplateFileName NVARCHAR(255),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'ReportTypes table created.';
GO

-- Request Statuses Table
CREATE TABLE RequestStatuses (
    RequestStatusId INT IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(50) NOT NULL UNIQUE,
    StatusCode NVARCHAR(20) NOT NULL UNIQUE,
    ColorCode NVARCHAR(7),
    Description NVARCHAR(255),
    DisplayOrder INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0
);
GO

PRINT 'RequestStatuses table created.';
GO

-- =============================================
-- CORE TABLES
-- =============================================

-- Users Table
CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    PasswordSalt NVARCHAR(255),
    FullName NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(30),
    Position NVARCHAR(100),
    EmployeeId NVARCHAR(50) UNIQUE,
    ProfileImageUrl NVARCHAR(500),
    RoleId INT NOT NULL,
    DepartmentId INT NOT NULL,
    IsActive BIT DEFAULT 1,
    IsEmailVerified BIT DEFAULT 0,
    LastLoginAt DATETIME2,
    PasswordChangedAt DATETIME2,
    FailedLoginAttempts INT DEFAULT 0,
    LockoutEndAt DATETIME2,
    RefreshToken NVARCHAR(500),
    RefreshTokenExpiryTime DATETIME2,
    JoinedDate DATE DEFAULT CAST(GETUTCDATE() AS DATE),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId),
    CONSTRAINT FK_Users_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentId)
);
GO

PRINT 'Users table created.';
GO

-- Devices Table
CREATE TABLE Devices (
    DeviceId INT IDENTITY(1,1) PRIMARY KEY,
    DeviceCode NVARCHAR(50) NOT NULL UNIQUE, -- e.g., dev-001
    DeviceName NVARCHAR(200) NOT NULL,
    Model NVARCHAR(100),
    SerialNumber NVARCHAR(100) UNIQUE,
    Description NVARCHAR(1000),
    CategoryId INT NOT NULL,
    ManufacturerId INT,
    SupplierId INT,
    DepartmentId INT NOT NULL,
    StatusId INT NOT NULL,
    RiskLevelId INT NOT NULL,
    Location NVARCHAR(255), -- e.g., ICU - Room 101
    PurchaseDate DATE,
    PurchasePrice DECIMAL(18, 2),
    WarrantyExpiryDate DATE,
    ExpectedLifespanYears INT,
    InstallationDate DATE,
    LastMaintenanceDate DATE,
    NextMaintenanceDate DATE,
    MaintenanceIntervalDays INT DEFAULT 180, -- Default 6 months
    FailureCount INT DEFAULT 0,
    ImageUrl NVARCHAR(500),
    Notes NVARCHAR(MAX),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    CreatedByUserId INT,
    UpdatedByUserId INT,
    IsDeleted BIT DEFAULT 0,
    CONSTRAINT FK_Devices_Categories FOREIGN KEY (CategoryId) REFERENCES DeviceCategories(CategoryId),
    CONSTRAINT FK_Devices_Manufacturers FOREIGN KEY (ManufacturerId) REFERENCES Manufacturers(ManufacturerId),
    CONSTRAINT FK_Devices_Suppliers FOREIGN KEY (SupplierId) REFERENCES Suppliers(SupplierId),
    CONSTRAINT FK_Devices_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentId),
    CONSTRAINT FK_Devices_Statuses FOREIGN KEY (StatusId) REFERENCES DeviceStatuses(StatusId),
    CONSTRAINT FK_Devices_RiskLevels FOREIGN KEY (RiskLevelId) REFERENCES RiskLevels(RiskLevelId),
    CONSTRAINT FK_Devices_CreatedBy FOREIGN KEY (CreatedByUserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Devices_UpdatedBy FOREIGN KEY (UpdatedByUserId) REFERENCES Users(UserId)
);
GO

PRINT 'Devices table created.';
GO

-- Device Accessories Table
CREATE TABLE DeviceAccessories (
    AccessoryId INT IDENTITY(1,1) PRIMARY KEY,
    DeviceId INT NOT NULL,
    AccessoryName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(500),
    Quantity INT DEFAULT 1,
    SerialNumber NVARCHAR(100),
    PurchaseDate DATE,
    ExpiryDate DATE,
    IsAvailable BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0,
    CONSTRAINT FK_Accessories_Devices FOREIGN KEY (DeviceId) REFERENCES Devices(DeviceId)
);
GO

PRINT 'DeviceAccessories table created.';
GO

-- Maintenance Requests Table
CREATE TABLE MaintenanceRequests (
    RequestId INT IDENTITY(1,1) PRIMARY KEY,
    RequestCode NVARCHAR(50) NOT NULL UNIQUE, -- e.g., req-001
    DeviceId INT NOT NULL,
    RequestedByUserId INT NOT NULL,
    AssignedToUserId INT, -- Engineer assigned
    MaintenanceTypeId INT NOT NULL,
    PriorityId INT NOT NULL,
    RequestStatusId INT NOT NULL,
    IssueTitle NVARCHAR(200) NOT NULL,
    IssueDescription NVARCHAR(MAX),
    HasAlternativeDevice BIT DEFAULT 0,
    AlternativeDeviceId INT,
    RequestedDate DATETIME2 DEFAULT GETUTCDATE(),
    AssignedDate DATETIME2,
    StartedDate DATETIME2,
    CompletedDate DATETIME2,
    EstimatedCompletionDate DATETIME2,
    ActualWorkHours DECIMAL(5, 2),
    EngineerNotes NVARCHAR(MAX),
    ResolutionSummary NVARCHAR(MAX),
    PartsCost DECIMAL(18, 2),
    LaborCost DECIMAL(18, 2),
    TotalCost AS (ISNULL(PartsCost, 0) + ISNULL(LaborCost, 0)) PERSISTED,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0,
    CONSTRAINT FK_Requests_Devices FOREIGN KEY (DeviceId) REFERENCES Devices(DeviceId),
    CONSTRAINT FK_Requests_RequestedBy FOREIGN KEY (RequestedByUserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Requests_AssignedTo FOREIGN KEY (AssignedToUserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Requests_MaintenanceTypes FOREIGN KEY (MaintenanceTypeId) REFERENCES MaintenanceTypes(MaintenanceTypeId),
    CONSTRAINT FK_Requests_Priorities FOREIGN KEY (PriorityId) REFERENCES Priorities(PriorityId),
    CONSTRAINT FK_Requests_Statuses FOREIGN KEY (RequestStatusId) REFERENCES RequestStatuses(RequestStatusId),
    CONSTRAINT FK_Requests_AltDevice FOREIGN KEY (AlternativeDeviceId) REFERENCES Devices(DeviceId)
);
GO

PRINT 'MaintenanceRequests table created.';
GO

-- Maintenance Logs Table
CREATE TABLE MaintenanceLogs (
    LogId INT IDENTITY(1,1) PRIMARY KEY,
    RequestId INT,
    DeviceId INT NOT NULL,
    PerformedByUserId INT NOT NULL,
    MaintenanceTypeId INT NOT NULL,
    MaintenanceDate DATE NOT NULL,
    Description NVARCHAR(MAX),
    ActionsTaken NVARCHAR(MAX),
    PartsReplaced NVARCHAR(1000),
    PartsCost DECIMAL(18, 2),
    LaborHours DECIMAL(5, 2),
    LaborCost DECIMAL(18, 2),
    TotalCost AS (ISNULL(PartsCost, 0) + ISNULL(LaborCost, 0)) PERSISTED,
    NextMaintenanceDate DATE,
    IsScheduled BIT DEFAULT 0, -- Was this a scheduled maintenance?
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0,
    CONSTRAINT FK_Logs_Requests FOREIGN KEY (RequestId) REFERENCES MaintenanceRequests(RequestId),
    CONSTRAINT FK_Logs_Devices FOREIGN KEY (DeviceId) REFERENCES Devices(DeviceId),
    CONSTRAINT FK_Logs_PerformedBy FOREIGN KEY (PerformedByUserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Logs_MaintenanceTypes FOREIGN KEY (MaintenanceTypeId) REFERENCES MaintenanceTypes(MaintenanceTypeId)
);
GO

PRINT 'MaintenanceLogs table created.';
GO

-- Notifications Table
CREATE TABLE Notifications (
    NotificationId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    NotificationTypeId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Message NVARCHAR(1000) NOT NULL,
    PriorityId INT,
    RelatedEntityType NVARCHAR(50), -- 'Device', 'MaintenanceRequest', 'User'
    RelatedEntityId INT,
    IsRead BIT DEFAULT 0,
    ReadAt DATETIME2,
    ExpiresAt DATETIME2,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0,
    CONSTRAINT FK_Notifications_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Notifications_Types FOREIGN KEY (NotificationTypeId) REFERENCES NotificationTypes(NotificationTypeId),
    CONSTRAINT FK_Notifications_Priorities FOREIGN KEY (PriorityId) REFERENCES Priorities(PriorityId)
);
GO

PRINT 'Notifications table created.';
GO

-- Reports Table
CREATE TABLE Reports (
    ReportId INT IDENTITY(1,1) PRIMARY KEY,
    ReportCode NVARCHAR(50) NOT NULL UNIQUE,
    ReportTypeId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(500),
    GeneratedByUserId INT NOT NULL,
    FilterCriteria NVARCHAR(MAX), -- JSON string of applied filters
    DateFrom DATE,
    DateTo DATE,
    Format NVARCHAR(10) NOT NULL, -- 'PDF', 'EXCEL'
    FileUrl NVARCHAR(500),
    FileSizeBytes BIGINT,
    IncludesCharts BIT DEFAULT 0,
    GeneratedAt DATETIME2 DEFAULT GETUTCDATE(),
    ExpiresAt DATETIME2,
    DownloadCount INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0,
    CONSTRAINT FK_Reports_Types FOREIGN KEY (ReportTypeId) REFERENCES ReportTypes(ReportTypeId),
    CONSTRAINT FK_Reports_GeneratedBy FOREIGN KEY (GeneratedByUserId) REFERENCES Users(UserId)
);
GO

PRINT 'Reports table created.';
GO

-- Device Assignments Table
CREATE TABLE DeviceAssignments (
    AssignmentId INT IDENTITY(1,1) PRIMARY KEY,
    DeviceId INT NOT NULL,
    DepartmentId INT NOT NULL,
    Location NVARCHAR(255),
    AssignedByUserId INT NOT NULL,
    AssignedDate DATETIME2 DEFAULT GETUTCDATE(),
    ReturnedDate DATETIME2,
    Notes NVARCHAR(500),
    IsCurrentAssignment BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0,
    CONSTRAINT FK_Assignments_Devices FOREIGN KEY (DeviceId) REFERENCES Devices(DeviceId),
    CONSTRAINT FK_Assignments_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentId),
    CONSTRAINT FK_Assignments_AssignedBy FOREIGN KEY (AssignedByUserId) REFERENCES Users(UserId)
);
GO

PRINT 'DeviceAssignments table created.';
GO

-- Attachments Table
CREATE TABLE Attachments (
    AttachmentId INT IDENTITY(1,1) PRIMARY KEY,
    FileName NVARCHAR(255) NOT NULL,
    OriginalFileName NVARCHAR(255) NOT NULL,
    FileExtension NVARCHAR(10),
    ContentType NVARCHAR(100),
    FileSizeBytes BIGINT,
    FileUrl NVARCHAR(500) NOT NULL,
    EntityType NVARCHAR(50) NOT NULL, -- 'MaintenanceRequest', 'Device', 'Report'
    EntityId INT NOT NULL,
    UploadedByUserId INT NOT NULL,
    Description NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    IsDeleted BIT DEFAULT 0,
    CONSTRAINT FK_Attachments_UploadedBy FOREIGN KEY (UploadedByUserId) REFERENCES Users(UserId)
);
GO

PRINT 'Attachments table created.';
GO

-- Audit Logs Table
CREATE TABLE AuditLogs (
    AuditLogId BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserId INT,
    UserName NVARCHAR(100),
    Action NVARCHAR(100) NOT NULL, -- 'CREATE', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT'
    EntityType NVARCHAR(100), -- 'Device', 'User', 'MaintenanceRequest'
    EntityId INT,
    OldValues NVARCHAR(MAX), -- JSON of old values
    NewValues NVARCHAR(MAX), -- JSON of new values
    IpAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    AdditionalInfo NVARCHAR(MAX),
    Timestamp DATETIME2 DEFAULT GETUTCDATE(),
    CONSTRAINT FK_AuditLogs_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO

PRINT 'AuditLogs table created.';
GO

-- Activity History Table
CREATE TABLE ActivityHistory (
    ActivityId BIGINT IDENTITY(1,1) PRIMARY KEY,
    DeviceId INT NOT NULL,
    UserId INT,
    ActivityType NVARCHAR(100) NOT NULL, -- 'STATUS_CHANGE', 'MAINTENANCE', 'LOCATION_CHANGE', 'CALIBRATION'
    Description NVARCHAR(500),
    OldValue NVARCHAR(255),
    NewValue NVARCHAR(255),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Activity_Devices FOREIGN KEY (DeviceId) REFERENCES Devices(DeviceId),
    CONSTRAINT FK_Activity_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO

PRINT 'ActivityHistory table created.';
GO

-- =============================================
-- INDEXES
-- =============================================

-- Users Indexes
CREATE INDEX IX_Users_RoleId ON Users(RoleId);
CREATE INDEX IX_Users_DepartmentId ON Users(DepartmentId);
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_Username ON Users(Username);
CREATE INDEX IX_Users_IsActive ON Users(IsActive) WHERE IsDeleted = 0;

-- Devices Indexes
CREATE INDEX IX_Devices_DepartmentId ON Devices(DepartmentId);
CREATE INDEX IX_Devices_CategoryId ON Devices(CategoryId);
CREATE INDEX IX_Devices_StatusId ON Devices(StatusId);
CREATE INDEX IX_Devices_RiskLevelId ON Devices(RiskLevelId);
CREATE INDEX IX_Devices_NextMaintenance ON Devices(NextMaintenanceDate) WHERE IsDeleted = 0;
CREATE INDEX IX_Devices_DeviceCode ON Devices(DeviceCode);

-- Maintenance Requests Indexes
CREATE INDEX IX_Requests_DeviceId ON MaintenanceRequests(DeviceId);
CREATE INDEX IX_Requests_RequestedBy ON MaintenanceRequests(RequestedByUserId);
CREATE INDEX IX_Requests_AssignedTo ON MaintenanceRequests(AssignedToUserId);
CREATE INDEX IX_Requests_StatusId ON MaintenanceRequests(RequestStatusId);
CREATE INDEX IX_Requests_RequestedDate ON MaintenanceRequests(RequestedDate);

-- Maintenance Logs Indexes
CREATE INDEX IX_Logs_DeviceId ON MaintenanceLogs(DeviceId);
CREATE INDEX IX_Logs_RequestId ON MaintenanceLogs(RequestId);
CREATE INDEX IX_Logs_MaintenanceDate ON MaintenanceLogs(MaintenanceDate);

-- Notifications Indexes
CREATE INDEX IX_Notifications_UserId ON Notifications(UserId);
CREATE INDEX IX_Notifications_IsRead ON Notifications(IsRead) WHERE IsDeleted = 0;
CREATE INDEX IX_Notifications_CreatedAt ON Notifications(CreatedAt);

-- Audit Logs Indexes
CREATE INDEX IX_AuditLogs_UserId ON AuditLogs(UserId);
CREATE INDEX IX_AuditLogs_EntityType ON AuditLogs(EntityType, EntityId);
CREATE INDEX IX_AuditLogs_Timestamp ON AuditLogs(Timestamp);

-- Activity History Indexes
CREATE INDEX IX_Activity_DeviceId ON ActivityHistory(DeviceId);
CREATE INDEX IX_Activity_CreatedAt ON ActivityHistory(CreatedAt);

GO

PRINT 'All indexes created successfully.';
GO

PRINT '=============================================';
PRINT 'SMEMS Database Schema created successfully!';
PRINT '=============================================';
GO
