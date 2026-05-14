# SMEMS Database Schema Documentation
## Smart Medical Equipment Management System

---

## Table of Contents
1. [ERD Explanation & Entity Relationships](#1-erd-explanation--entity-relationships)
2. [SQL Server CREATE TABLE Scripts](#2-sql-server-create-table-scripts)
3. [Sample Seed Data](#3-sample-seed-data)
4. [Entity Framework Core Model Names](#4-entity-framework-core-model-names)
5. [Recommended Folder Structure](#5-recommended-folder-structure)

---

## 1. ERD Explanation & Entity Relationships

### Core Entities Overview

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                           SMEMS DATABASE SCHEMA                                      │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                      │
│  ┌──────────────┐       ┌──────────────┐       ┌──────────────┐                     │
│  │    Roles     │◄──────│    Users     │───────►│ Departments  │                     │
│  └──────────────┘       └──────────────┘       └──────────────┘                     │
│                               │                       │                              │
│                               │                       │                              │
│                               ▼                       ▼                              │
│                        ┌──────────────┐       ┌──────────────┐                      │
│                        │ AuditLogs    │       │   Devices    │◄─────────────┐       │
│                        └──────────────┘       └──────────────┘              │       │
│                                                     │                        │       │
│  ┌──────────────┐                                   │                        │       │
│  │ DeviceCategories │◄──────────────────────────────┤                        │       │
│  └──────────────┘                                   │                        │       │
│                                                     │                        │       │
│  ┌──────────────┐                                   │                        │       │
│  │ Manufacturers│◄──────────────────────────────────┤                        │       │
│  └──────────────┘                                   │                        │       │
│                                                     │                        │       │
│  ┌──────────────┐                                   │                        │       │
│  │  Suppliers   │◄──────────────────────────────────┘                        │       │
│  └──────────────┘                                                            │       │
│                                                                              │       │
│  ┌──────────────┐       ┌──────────────┐       ┌──────────────┐             │       │
│  │ DeviceStatuses│◄─────│MaintenanceReq│───────►│ Priorities   │             │       │
│  └──────────────┘       └──────────────┘       └──────────────┘             │       │
│                               │                                              │       │
│                               ▼                                              │       │
│                        ┌──────────────┐                                      │       │
│                        │MaintenanceLogs│─────────────────────────────────────┘       │
│                        └──────────────┘                                              │
│                               │                                                      │
│                               ▼                                                      │
│  ┌──────────────┐       ┌──────────────┐       ┌──────────────┐                     │
│  │ Attachments  │◄──────│ Notifications│       │   Reports    │                     │
│  └──────────────┘       └──────────────┘       └──────────────┘                     │
│                                                                                      │
│  ┌──────────────┐       ┌──────────────┐                                            │
│  │DeviceAssign- │       │ActivityHistory│                                            │
│  │   ments      │       └──────────────┘                                            │
│  └──────────────┘                                                                    │
│                                                                                      │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Entity Descriptions & Relationships

#### 1. **Roles**
- **Purpose**: Defines system user roles (Administrator, Engineer, Medical Staff)
- **Relationships**: One-to-Many with Users

#### 2. **Users**
- **Purpose**: Stores all system users with authentication credentials
- **Relationships**:
  - Many-to-One with Roles (each user has one role)
  - Many-to-One with Departments (each user belongs to one department)
  - One-to-Many with MaintenanceRequests (users can create/be assigned requests)
  - One-to-Many with Notifications (users receive notifications)
  - One-to-Many with AuditLogs (user actions are logged)

#### 3. **Departments**
- **Purpose**: Hospital departments (ICU, Radiology, Emergency Room, etc.)
- **Relationships**:
  - One-to-Many with Users
  - One-to-Many with Devices

#### 4. **DeviceCategories**
- **Purpose**: Categories of medical equipment (Diagnostic, Therapeutic, Monitoring, etc.)
- **Relationships**: One-to-Many with Devices

#### 5. **Manufacturers**
- **Purpose**: Device manufacturers information
- **Relationships**: One-to-Many with Devices

#### 6. **Suppliers**
- **Purpose**: Device suppliers/vendors information
- **Relationships**: One-to-Many with Devices

#### 7. **DeviceStatuses**
- **Purpose**: Lookup table for device statuses (Operational, Maintenance Needed, Under Maintenance, Out of Service)
- **Relationships**: One-to-Many with Devices

#### 8. **RiskLevels**
- **Purpose**: Risk classification for devices (Low, Medium, High, Critical)
- **Relationships**: One-to-Many with Devices

#### 9. **Devices**
- **Purpose**: Core entity storing all medical equipment
- **Relationships**:
  - Many-to-One with Departments
  - Many-to-One with DeviceCategories
  - Many-to-One with Manufacturers
  - Many-to-One with Suppliers
  - Many-to-One with DeviceStatuses
  - Many-to-One with RiskLevels
  - One-to-Many with MaintenanceRequests
  - One-to-Many with MaintenanceLogs
  - One-to-Many with DeviceAssignments

#### 10. **Priorities**
- **Purpose**: Maintenance request priority levels (Low, Medium, High, Critical)
- **Relationships**: One-to-Many with MaintenanceRequests

#### 11. **MaintenanceTypes**
- **Purpose**: Types of maintenance (Preventive, Corrective, Calibration, Installation)
- **Relationships**: One-to-Many with MaintenanceRequests

#### 12. **MaintenanceRequests**
- **Purpose**: Maintenance request tickets
- **Relationships**:
  - Many-to-One with Devices
  - Many-to-One with Users (RequestedBy)
  - Many-to-One with Users (AssignedTo - Engineer)
  - Many-to-One with Priorities
  - Many-to-One with MaintenanceTypes
  - One-to-Many with MaintenanceLogs
  - One-to-Many with Attachments

#### 13. **MaintenanceLogs**
- **Purpose**: Detailed maintenance work history
- **Relationships**:
  - Many-to-One with MaintenanceRequests
  - Many-to-One with Devices
  - Many-to-One with Users (Engineer who performed work)

#### 14. **Notifications**
- **Purpose**: System notifications for users
- **Relationships**:
  - Many-to-One with Users (recipient)
  - Many-to-One with NotificationTypes

#### 15. **NotificationTypes**
- **Purpose**: Types of notifications (Maintenance Update, Device Status, Preventive Due, etc.)
- **Relationships**: One-to-Many with Notifications

#### 16. **Reports**
- **Purpose**: Generated report metadata and storage
- **Relationships**:
  - Many-to-One with Users (generated by)
  - Many-to-One with ReportTypes

#### 17. **ReportTypes**
- **Purpose**: Types of reports (Device Report, Maintenance Report, Full Report)
- **Relationships**: One-to-Many with Reports

#### 18. **DeviceAssignments**
- **Purpose**: Track device location assignments to departments/rooms
- **Relationships**:
  - Many-to-One with Devices
  - Many-to-One with Departments

#### 19. **Attachments**
- **Purpose**: File attachments for maintenance requests
- **Relationships**:
  - Many-to-One with MaintenanceRequests

#### 20. **AuditLogs**
- **Purpose**: System audit trail for all important actions
- **Relationships**:
  - Many-to-One with Users

#### 21. **ActivityHistory**
- **Purpose**: Detailed activity log for devices
- **Relationships**:
  - Many-to-One with Devices
  - Many-to-One with Users

#### 22. **DeviceAccessories**
- **Purpose**: Accessories associated with devices
- **Relationships**:
  - Many-to-One with Devices

---

## 2. SQL Server CREATE TABLE Scripts

```sql
-- =============================================
-- SMEMS Database Schema
-- Smart Medical Equipment Management System
-- SQL Server 2019+
-- =============================================

-- Create Database
CREATE DATABASE SMEMS_DB;
GO

USE SMEMS_DB;
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
```

---

## 3. Sample Seed Data

```sql
-- =============================================
-- SAMPLE SEED DATA
-- =============================================

USE SMEMS_DB;
GO

-- Seed Roles
SET IDENTITY_INSERT Roles ON;
INSERT INTO Roles (RoleId, RoleName, Description) VALUES
(1, 'Administrator', 'Full system access and management capabilities'),
(2, 'Engineer', 'Biomedical engineers who perform maintenance and repairs'),
(3, 'Medical Staff', 'Doctors, nurses, and medical personnel who use equipment');
SET IDENTITY_INSERT Roles OFF;
GO

-- Seed Departments
SET IDENTITY_INSERT Departments ON;
INSERT INTO Departments (DepartmentId, DepartmentName, DepartmentCode, Description, Location) VALUES
(1, 'Administration', 'ADMIN', 'Hospital administration department', 'Building A, Floor 1'),
(2, 'ICU', 'ICU', 'Intensive Care Unit', 'Building B, Floor 2'),
(3, 'Emergency Room', 'ER', 'Emergency services department', 'Building A, Ground Floor'),
(4, 'Radiology', 'RAD', 'Medical imaging department', 'Building C, Floor 1'),
(5, 'Cardiology', 'CARD', 'Heart and cardiovascular care', 'Building B, Floor 3'),
(6, 'Surgery', 'SURG', 'Surgical operations department', 'Building B, Floor 4'),
(7, 'Maintenance', 'MAINT', 'Equipment maintenance department', 'Building D, Ground Floor'),
(8, 'Laboratory', 'LAB', 'Medical laboratory services', 'Building C, Floor 2'),
(9, 'Inventory', 'INV', 'Equipment inventory management', 'Building D, Floor 1');
SET IDENTITY_INSERT Departments OFF;
GO

-- Seed Device Categories
SET IDENTITY_INSERT DeviceCategories ON;
INSERT INTO DeviceCategories (CategoryId, CategoryName, CategoryCode, Description) VALUES
(1, 'Diagnostic Equipment', 'DIAG', 'Equipment used for patient diagnosis'),
(2, 'Therapeutic Equipment', 'THER', 'Equipment used for patient treatment'),
(3, 'Life Support Equipment', 'LIFE', 'Critical life-sustaining equipment'),
(4, 'Monitoring Equipment', 'MON', 'Patient monitoring devices'),
(5, 'Laboratory Equipment', 'LAB', 'Laboratory analysis equipment'),
(6, 'Imaging Equipment', 'IMG', 'Medical imaging devices');
SET IDENTITY_INSERT DeviceCategories OFF;
GO

-- Seed Manufacturers
SET IDENTITY_INSERT Manufacturers ON;
INSERT INTO Manufacturers (ManufacturerId, ManufacturerName, ContactPerson, Email, Phone, Country, Website) VALUES
(1, 'MedTech Solutions', 'John Smith', 'contact@medtech.com', '+1-555-0101', 'USA', 'www.medtech.com'),
(2, 'CardioTech', 'Sarah Johnson', 'info@cardiotech.com', '+1-555-0102', 'Germany', 'www.cardiotech.com'),
(3, 'PumpTech', 'Michael Brown', 'sales@pumptech.com', '+1-555-0103', 'Japan', 'www.pumptech.com'),
(4, 'RadioTech', 'Emily Davis', 'support@radiotech.com', '+1-555-0104', 'USA', 'www.radiotech.com'),
(5, 'HeartSave', 'Robert Wilson', 'contact@heartsave.com', '+1-555-0105', 'Netherlands', 'www.heartsave.com'),
(6, 'SonoTech', 'Lisa Anderson', 'info@sonotech.com', '+1-555-0106', 'South Korea', 'www.sonotech.com');
SET IDENTITY_INSERT Manufacturers OFF;
GO

-- Seed Suppliers
SET IDENTITY_INSERT Suppliers ON;
INSERT INTO Suppliers (SupplierId, SupplierName, ContactPerson, Email, Phone, Country, ContractStartDate, ContractEndDate) VALUES
(1, 'Global Medical Supplies', 'Ahmed Khan', 'orders@globalmed.com', '+1-555-0201', 'UAE', '2024-01-01', '2026-12-31'),
(2, 'MedSupply Co', 'Fatima Ali', 'sales@medsupply.com', '+1-555-0202', 'Jordan', '2023-06-01', '2025-05-31'),
(3, 'BioMed Supply', 'Omar Hassan', 'contact@biomed.com', '+1-555-0203', 'Egypt', '2024-03-01', '2027-02-28'),
(4, 'Imaging Solutions', 'Layla Mohammed', 'info@imagingsol.com', '+1-555-0204', 'Saudi Arabia', '2022-01-01', '2026-12-31'),
(5, 'Emergency Med', 'Khalid Ibrahim', 'orders@emergmed.com', '+1-555-0205', 'Kuwait', '2024-01-01', '2026-12-31');
SET IDENTITY_INSERT Suppliers OFF;
GO

-- Seed Device Statuses
SET IDENTITY_INSERT DeviceStatuses ON;
INSERT INTO DeviceStatuses (StatusId, StatusName, StatusCode, ColorCode, Description, DisplayOrder) VALUES
(1, 'Operational', 'OPER', '#16A34A', 'Device is fully functional and in use', 1),
(2, 'Maintenance Needed', 'MAINT_NEED', '#D97706', 'Device requires scheduled maintenance', 2),
(3, 'Under Maintenance', 'UNDER_MAINT', '#0891B2', 'Device is currently being serviced', 3),
(4, 'Out of Service', 'OUT_SERV', '#DC2626', 'Device is non-functional and unavailable', 4);
SET IDENTITY_INSERT DeviceStatuses OFF;
GO

-- Seed Risk Levels
SET IDENTITY_INSERT RiskLevels ON;
INSERT INTO RiskLevels (RiskLevelId, RiskLevelName, RiskLevelCode, ColorCode, Description, DisplayOrder) VALUES
(1, 'Low Risk', 'LOW', '#16A34A', 'Low-risk equipment with minimal patient impact', 1),
(2, 'Medium Risk', 'MED', '#D97706', 'Medium-risk equipment requiring regular monitoring', 2),
(3, 'High Risk', 'HIGH', '#EA580C', 'High-risk equipment with significant patient impact', 3),
(4, 'Critical Risk', 'CRIT', '#DC2626', 'Life-critical equipment requiring immediate attention', 4);
SET IDENTITY_INSERT RiskLevels OFF;
GO

-- Seed Priorities
SET IDENTITY_INSERT Priorities ON;
INSERT INTO Priorities (PriorityId, PriorityName, PriorityCode, ColorCode, ResponseTimeHours, DisplayOrder) VALUES
(1, 'Low', 'LOW', '#16A34A', 72, 1),
(2, 'Medium', 'MED', '#D97706', 24, 2),
(3, 'High', 'HIGH', '#EA580C', 8, 3),
(4, 'Critical', 'CRIT', '#DC2626', 2, 4);
SET IDENTITY_INSERT Priorities OFF;
GO

-- Seed Maintenance Types
SET IDENTITY_INSERT MaintenanceTypes ON;
INSERT INTO MaintenanceTypes (MaintenanceTypeId, TypeName, TypeCode, Description) VALUES
(1, 'Preventive Maintenance', 'PREV', 'Scheduled routine maintenance to prevent failures'),
(2, 'Corrective Maintenance', 'CORR', 'Repairs to fix equipment failures or malfunctions'),
(3, 'Calibration', 'CAL', 'Equipment calibration and accuracy verification'),
(4, 'Installation', 'INST', 'New equipment installation and setup'),
(5, 'Inspection', 'INSP', 'Safety and compliance inspection');
SET IDENTITY_INSERT MaintenanceTypes OFF;
GO

-- Seed Request Statuses
SET IDENTITY_INSERT RequestStatuses ON;
INSERT INTO RequestStatuses (RequestStatusId, StatusName, StatusCode, ColorCode, DisplayOrder) VALUES
(1, 'Pending', 'PEND', '#D97706', 1),
(2, 'In Progress', 'PROG', '#0891B2', 2),
(3, 'Completed', 'COMP', '#16A34A', 3),
(4, 'Cancelled', 'CANC', '#6B7280', 4),
(5, 'On Hold', 'HOLD', '#8B5CF6', 5);
SET IDENTITY_INSERT RequestStatuses OFF;
GO

-- Seed Notification Types
SET IDENTITY_INSERT NotificationTypes ON;
INSERT INTO NotificationTypes (NotificationTypeId, TypeName, TypeCode, IconName, ColorCode) VALUES
(1, 'Maintenance Update', 'MAINT_UPDATE', 'wrench', '#0891B2'),
(2, 'Device Status Change', 'DEV_STATUS', 'monitor', '#8B5CF6'),
(3, 'Preventive Maintenance Due', 'PREV_DUE', 'calendar', '#D97706'),
(4, 'New User Added', 'USER_ADD', 'user-plus', '#16A34A'),
(5, 'Request Assigned', 'REQ_ASSIGN', 'clipboard', '#0891B2'),
(6, 'Request Completed', 'REQ_COMPLETE', 'check-circle', '#16A34A'),
(7, 'Warranty Expiring', 'WARR_EXP', 'alert-triangle', '#DC2626'),
(8, 'System Alert', 'SYS_ALERT', 'bell', '#DC2626');
SET IDENTITY_INSERT NotificationTypes OFF;
GO

-- Seed Report Types
SET IDENTITY_INSERT ReportTypes ON;
INSERT INTO ReportTypes (ReportTypeId, TypeName, TypeCode, Description, TemplateFileName) VALUES
(1, 'Device Report', 'DEV_RPT', 'Comprehensive device inventory and status report', 'DeviceReportTemplate.rdlc'),
(2, 'Maintenance Report', 'MAINT_RPT', 'Maintenance activities and history report', 'MaintenanceReportTemplate.rdlc'),
(3, 'Full Report', 'FULL_RPT', 'Complete system report including all data', 'FullReportTemplate.rdlc'),
(4, 'User Activity Report', 'USER_RPT', 'User activities and audit trail report', 'UserActivityReportTemplate.rdlc');
SET IDENTITY_INSERT ReportTypes OFF;
GO

-- Seed Users (Password: "Password123!" - Use proper hashing in production)
SET IDENTITY_INSERT Users ON;
INSERT INTO Users (UserId, Username, Email, PasswordHash, FullName, Phone, Position, EmployeeId, RoleId, DepartmentId, IsActive, JoinedDate) VALUES
(1, 'ahmed.hassan', 'ahmed.hassan@hospital.com', 'AQAAAAEAACcQAAAAELFk...', 'Dr. Ahmed Hassan', '0790000001', 'Administrator', 'EMP-1001', 1, 1, 1, '2020-01-15'),
(2, 'mohammed.ali', 'mohammed.ali@hospital.com', 'AQAAAAEAACcQAAAAELFk...', 'Eng. Mohammed Ali', '0790000002', 'Biomedical Engineer', 'EMP-1002', 2, 7, 1, '2021-03-10'),
(3, 'sarah.ahmed', 'sarah.ahmed@hospital.com', 'AQAAAAEAACcQAAAAELFk...', 'Nurse Sarah Ahmed', '0790000003', 'Nurse', 'EMP-1003', 3, 2, 1, '2022-01-10'),
(4, 'fatima.hatem', 'fatima.hatem@hospital.com', 'AQAAAAEAACcQAAAAELFk...', 'Nurse Fatima Hatem', '0790000004', 'Nurse', 'EMP-1004', 3, 9, 1, '2022-06-15'),
(5, 'layla.hassan', 'layla.hassan@hospital.com', 'AQAAAAEAACcQAAAAELFk...', 'Dr. Layla Hassan', '0790000005', 'Doctor', 'EMP-1005', 3, 4, 1, '2021-09-20'),
(6, 'ahmed.ibrahim', 'ahmed.ibrahim@hospital.com', 'AQAAAAEAACcQAAAAELFk...', 'Eng. Ahmed Ibrahim', '0790000006', 'Biomedical Engineer', 'EMP-1006', 2, 7, 1, '2023-04-01');
SET IDENTITY_INSERT Users OFF;
GO

-- Seed Devices
SET IDENTITY_INSERT Devices ON;
INSERT INTO Devices (DeviceId, DeviceCode, DeviceName, Model, SerialNumber, CategoryId, ManufacturerId, SupplierId, DepartmentId, StatusId, RiskLevelId, Location, PurchaseDate, WarrantyExpiryDate, ExpectedLifespanYears, FailureCount, NextMaintenanceDate, MaintenanceIntervalDays) VALUES
(1, 'dev-001', 'Ventilator Model X200', 'X200', 'VNT-2023-001', 3, 1, 1, 2, 1, 3, 'ICU - Room 101', '2023-01-15', '2026-01-15', 10, 1, '2026-05-15', 180),
(2, 'dev-002', 'ECG Monitor Pro', 'ECG-500', 'ECG-2022-002', 4, 2, 2, 2, 2, 2, 'ICU - Room 203', '2022-06-10', '2025-06-10', 8, 2, '2026-04-26', 90),
(3, 'dev-003', 'Infusion Pump Smart', 'IP-300', 'INF-2024-003', 2, 3, 3, 2, 1, 1, 'ICU - Room 105', '2024-02-01', '2027-02-01', 7, 0, '2026-08-01', 180),
(4, 'dev-004', 'X-Ray Machine Digital', 'XR-1000', 'XRY-2021-004', 6, 4, 4, 4, 4, 4, 'Radiology - Room A', '2021-03-20', '2024-03-20', 12, 4, '2026-06-20', 365),
(5, 'dev-005', 'Defibrillator AED Plus', 'AED-250', 'AED-2023-005', 3, 5, 5, 3, 1, 4, 'ER - Station 1', '2023-09-05', '2026-09-05', 10, 0, '2026-09-05', 365),
(6, 'dev-006', 'Ultrasound Scanner Pro', 'US-700', 'ULS-2022-006', 6, 6, 4, 4, 3, 2, 'Radiology - Room B', '2022-11-12', '2025-11-12', 9, 1, '2026-11-12', 180);
SET IDENTITY_INSERT Devices OFF;
GO

-- Seed Device Accessories
INSERT INTO DeviceAccessories (DeviceId, AccessoryName, Description, Quantity) VALUES
(1, 'Breathing circuits', 'Standard breathing circuits for ventilator', 5),
(1, 'Filters', 'HEPA filters for ventilator', 10),
(1, 'Humidifier', 'Heated humidifier attachment', 2),
(2, 'Electrode pads', 'ECG electrode pads - adult', 50),
(2, 'Lead cables', '12-lead ECG cables', 3),
(2, 'Mounting bracket', 'Wall mounting bracket', 1),
(5, 'Electrode pads (adult)', 'AED electrode pads for adults', 4),
(5, 'Electrode pads (pediatric)', 'AED electrode pads for children', 2),
(5, 'Carry case', 'Portable carry case', 1),
(6, 'Transducer probes', 'Ultrasound transducer probes', 3),
(6, 'Gel warmer', 'Ultrasound gel warmer', 1),
(6, 'Printer', 'Thermal image printer', 1);
GO

-- Seed Maintenance Requests
SET IDENTITY_INSERT MaintenanceRequests ON;
INSERT INTO MaintenanceRequests (RequestId, RequestCode, DeviceId, RequestedByUserId, AssignedToUserId, MaintenanceTypeId, PriorityId, RequestStatusId, IssueTitle, IssueDescription, HasAlternativeDevice, RequestedDate, AssignedDate, StartedDate, EngineerNotes) VALUES
(1, 'req-001', 2, 3, NULL, 2, 3, 1, 'Display malfunction', 'Screen flickering and showing distorted readings intermittently.', 1, '2026-04-10', NULL, NULL, NULL),
(2, 'req-002', 4, 5, 2, 2, 3, 2, 'Complete failure', 'Machine not powering on after routine shutdown. Tried standard restart procedures with no success.', 0, '2026-04-08', '2026-04-08', '2026-04-09', 'Inspecting power supply unit. Ordered replacement parts.'),
(3, 'req-003', 6, 5, 6, 2, 2, 2, 'Image quality degradation', 'Ultrasound images are blurry and lack detail. Issue persists across all probe types.', 1, '2026-04-11', '2026-04-11', '2026-04-11', 'Probe replacement ordered. Temporary workaround provided.'),
(4, 'req-004', 1, 3, NULL, 2, 3, 1, 'Alarm system fault', 'Alarm not triggering during simulated pressure drop test.', 0, '2026-04-12', NULL, NULL, NULL);
SET IDENTITY_INSERT MaintenanceRequests OFF;
GO

-- Seed Maintenance Logs
INSERT INTO MaintenanceLogs (RequestId, DeviceId, PerformedByUserId, MaintenanceTypeId, MaintenanceDate, Description, ActionsTaken, IsScheduled) VALUES
(NULL, 1, 2, 1, '2025-01-15', 'Annual preventive maintenance', 'Full system check, filter replacement, calibration', 1),
(NULL, 1, 2, 1, '2025-07-15', 'Quarterly preventive maintenance', 'Quarterly preventive maintenance completed', 1),
(NULL, 1, 2, 2, '2026-03-16', 'Corrective maintenance', 'Replaced pressure valve and calibrated sensors', 0),
(NULL, 2, 2, 1, '2025-06-10', 'Annual preventive maintenance', 'Annual preventive maintenance', 1),
(NULL, 2, 6, 1, '2026-01-10', 'Routine check', 'Routine check completed', 1),
(NULL, 2, 2, 2, '2025-11-20', 'Screen repair', 'Screen backlight replaced', 0),
(NULL, 3, 2, 1, '2025-08-01', 'Preventive maintenance', 'Calibration and software update', 1),
(NULL, 4, 2, 1, '2024-03-20', 'Annual maintenance', 'Annual maintenance', 1),
(NULL, 4, 2, 2, '2024-09-15', 'Power supply repair', 'Power supply unit replaced', 0),
(NULL, 4, 6, 2, '2025-06-01', 'Detector calibration', 'Detector calibration', 0),
(2, 4, 2, 2, '2026-04-08', 'Investigation started', 'Machine not powering on - under investigation', 0),
(NULL, 5, 2, 1, '2025-09-05', 'Annual preventive maintenance', 'Battery check, electrode test, self-test passed', 1),
(NULL, 6, 6, 1, '2025-05-12', 'Annual check', 'Annual check, probe calibration', 1),
(3, 6, 6, 2, '2026-04-11', 'Image quality issue', 'Image quality degradation - probe replacement in progress', 0);
GO

-- Seed Notifications
INSERT INTO Notifications (UserId, NotificationTypeId, Title, Message, PriorityId, RelatedEntityType, RelatedEntityId, IsRead, CreatedAt) VALUES
(1, 1, 'Maintenance Request Updated', 'X-Ray Machine Digital maintenance is now in progress', 3, 'MaintenanceRequest', 2, 1, '2026-04-09 09:20:00'),
(1, 2, 'Device Status Changed', 'X-Ray Machine Digital is now out of service', 3, 'Device', 4, 0, '2026-04-08 14:30:00'),
(1, 3, 'Preventive Maintenance Due Soon', 'ECG Monitor Pro preventive maintenance due in 8 days', 2, 'Device', 2, 0, '2026-04-12 06:00:00'),
(1, 4, 'New User Added', 'Eng. Ahmed Ibrahim has been added to the system', 1, 'User', 6, 1, '2026-04-07 10:00:00'),
(2, 5, 'Request Assigned', 'You have been assigned to maintenance request req-002', 3, 'MaintenanceRequest', 2, 1, '2026-04-08 10:00:00'),
(6, 5, 'Request Assigned', 'You have been assigned to maintenance request req-003', 2, 'MaintenanceRequest', 3, 1, '2026-04-11 09:00:00');
GO

-- Seed Activity History
INSERT INTO ActivityHistory (DeviceId, UserId, ActivityType, Description, OldValue, NewValue) VALUES
(4, 1, 'STATUS_CHANGE', 'Device status changed', 'Under Maintenance', 'Out of Service'),
(6, 1, 'STATUS_CHANGE', 'Device status changed', 'Operational', 'Under Maintenance'),
(2, 1, 'STATUS_CHANGE', 'Device status changed', 'Operational', 'Maintenance Needed'),
(1, 2, 'MAINTENANCE', 'Preventive maintenance completed', NULL, NULL),
(4, 2, 'MAINTENANCE', 'Corrective maintenance started', NULL, NULL);
GO

-- Seed Audit Logs
INSERT INTO AuditLogs (UserId, UserName, Action, EntityType, EntityId, NewValues, IpAddress, Timestamp) VALUES
(1, 'ahmed.hassan', 'LOGIN', 'User', 1, NULL, '192.168.1.100', '2026-04-20 08:00:00'),
(1, 'ahmed.hassan', 'CREATE', 'MaintenanceRequest', 4, '{"RequestCode":"req-004","DeviceId":1}', '192.168.1.100', '2026-04-12 10:30:00'),
(1, 'ahmed.hassan', 'UPDATE', 'Device', 4, '{"StatusId":4}', '192.168.1.100', '2026-04-08 14:30:00'),
(2, 'mohammed.ali', 'UPDATE', 'MaintenanceRequest', 2, '{"RequestStatusId":2}', '192.168.1.101', '2026-04-09 09:15:00');
GO

PRINT 'Seed data inserted successfully!';
GO
```

---

## 4. Entity Framework Core Model Names

### Model Classes

| Table Name | EF Core Model Class | DbSet Property Name |
|------------|---------------------|---------------------|
| Roles | `Role` | `Roles` |
| Users | `User` | `Users` |
| Departments | `Department` | `Departments` |
| DeviceCategories | `DeviceCategory` | `DeviceCategories` |
| Manufacturers | `Manufacturer` | `Manufacturers` |
| Suppliers | `Supplier` | `Suppliers` |
| DeviceStatuses | `DeviceStatus` | `DeviceStatuses` |
| RiskLevels | `RiskLevel` | `RiskLevels` |
| Devices | `Device` | `Devices` |
| DeviceAccessories | `DeviceAccessory` | `DeviceAccessories` |
| Priorities | `Priority` | `Priorities` |
| MaintenanceTypes | `MaintenanceType` | `MaintenanceTypes` |
| RequestStatuses | `RequestStatus` | `RequestStatuses` |
| MaintenanceRequests | `MaintenanceRequest` | `MaintenanceRequests` |
| MaintenanceLogs | `MaintenanceLog` | `MaintenanceLogs` |
| NotificationTypes | `NotificationType` | `NotificationTypes` |
| Notifications | `Notification` | `Notifications` |
| ReportTypes | `ReportType` | `ReportTypes` |
| Reports | `Report` | `Reports` |
| DeviceAssignments | `DeviceAssignment` | `DeviceAssignments` |
| Attachments | `Attachment` | `Attachments` |
| AuditLogs | `AuditLog` | `AuditLogs` |
| ActivityHistory | `ActivityHistory` | `ActivityHistories` |

### Sample Model Class

```csharp
// Models/Device.cs
public class Device
{
    public int DeviceId { get; set; }
    public string DeviceCode { get; set; } = string.Empty;
    public string DeviceName { get; set; } = string.Empty;
    public string? Model { get; set; }
    public string? SerialNumber { get; set; }
    public string? Description { get; set; }
    
    // Foreign Keys
    public int CategoryId { get; set; }
    public int? ManufacturerId { get; set; }
    public int? SupplierId { get; set; }
    public int DepartmentId { get; set; }
    public int StatusId { get; set; }
    public int RiskLevelId { get; set; }
    
    public string? Location { get; set; }
    public DateTime? PurchaseDate { get; set; }
    public decimal? PurchasePrice { get; set; }
    public DateTime? WarrantyExpiryDate { get; set; }
    public int? ExpectedLifespanYears { get; set; }
    public DateTime? InstallationDate { get; set; }
    public DateTime? LastMaintenanceDate { get; set; }
    public DateTime? NextMaintenanceDate { get; set; }
    public int MaintenanceIntervalDays { get; set; } = 180;
    public int FailureCount { get; set; } = 0;
    public string? ImageUrl { get; set; }
    public string? Notes { get; set; }
    public bool IsActive { get; set; } = true;
    
    // Audit Fields
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public int? CreatedByUserId { get; set; }
    public int? UpdatedByUserId { get; set; }
    public bool IsDeleted { get; set; } = false;
    
    // Navigation Properties
    public virtual DeviceCategory Category { get; set; } = null!;
    public virtual Manufacturer? Manufacturer { get; set; }
    public virtual Supplier? Supplier { get; set; }
    public virtual Department Department { get; set; } = null!;
    public virtual DeviceStatus Status { get; set; } = null!;
    public virtual RiskLevel RiskLevel { get; set; } = null!;
    public virtual User? CreatedBy { get; set; }
    public virtual User? UpdatedBy { get; set; }
    
    public virtual ICollection<DeviceAccessory> Accessories { get; set; } = new List<DeviceAccessory>();
    public virtual ICollection<MaintenanceRequest> MaintenanceRequests { get; set; } = new List<MaintenanceRequest>();
    public virtual ICollection<MaintenanceLog> MaintenanceLogs { get; set; } = new List<MaintenanceLog>();
    public virtual ICollection<DeviceAssignment> Assignments { get; set; } = new List<DeviceAssignment>();
    public virtual ICollection<ActivityHistory> ActivityHistories { get; set; } = new List<ActivityHistory>();
}
```

---

## 5. Recommended Folder Structure

```
SMEMS/
├── SMEMS.Web/                          # ASP.NET Core MVC Project
│   ├── Controllers/
│   │   ├── AccountController.cs
│   │   ├── AdminController.cs
│   │   ├── DashboardController.cs
│   │   ├── DevicesController.cs
│   │   ├── MaintenanceController.cs
│   │   ├── NotificationsController.cs
│   │   ├── ReportsController.cs
│   │   ├── UsersController.cs
│   │   └── ProfileController.cs
│   ├── Views/
│   │   ├── Account/
│   │   │   ├── Login.cshtml
│   │   │   ├── ResetPassword.cshtml
│   │   │   └── ForgotPassword.cshtml
│   │   ├── Dashboard/
│   │   │   ├── Admin.cshtml
│   │   │   ├── Engineer.cshtml
│   │   │   └── Staff.cshtml
│   │   ├── Devices/
│   │   │   ├── Index.cshtml
│   │   │   ├── Details.cshtml
│   │   │   ├── Create.cshtml
│   │   │   ├── Edit.cshtml
│   │   │   └── _DeviceForm.cshtml
│   │   ├── Maintenance/
│   │   │   ├── Index.cshtml
│   │   │   ├── Details.cshtml
│   │   │   ├── Create.cshtml
│   │   │   ├── MyRequests.cshtml
│   │   │   └── _RequestForm.cshtml
│   │   ├── Users/
│   │   │   ├── Index.cshtml
│   │   │   ├── Create.cshtml
│   │   │   ├── Edit.cshtml
│   │   │   └── _UserForm.cshtml
│   │   ├── Notifications/
│   │   │   └── Index.cshtml
│   │   ├── Reports/
│   │   │   └── Index.cshtml
│   │   ├── Profile/
│   │   │   ├── Index.cshtml
│   │   │   └── Edit.cshtml
│   │   └── Shared/
│   │       ├── _Layout.cshtml
│   │       ├── _AdminLayout.cshtml
│   │       ├── _EngineerLayout.cshtml
│   │       ├── _StaffLayout.cshtml
│   │       ├── _Sidebar.cshtml
│   │       ├── _TopBar.cshtml
│   │       ├── _ValidationScriptsPartial.cshtml
│   │       └── Components/
│   ├── wwwroot/
│   │   ├── css/
│   │   ├── js/
│   │   ├── images/
│   │   └── lib/
│   ├── ViewModels/
│   │   ├── Account/
│   │   │   ├── LoginViewModel.cs
│   │   │   ├── ResetPasswordViewModel.cs
│   │   │   └── ChangePasswordViewModel.cs
│   │   ├── Dashboard/
│   │   │   ├── AdminDashboardViewModel.cs
│   │   │   ├── EngineerDashboardViewModel.cs
│   │   │   └── StaffDashboardViewModel.cs
│   │   ├── Devices/
│   │   │   ├── DeviceListViewModel.cs
│   │   │   ├── DeviceDetailsViewModel.cs
│   │   │   ├── DeviceCreateViewModel.cs
│   │   │   └── DeviceEditViewModel.cs
│   │   ├── Maintenance/
│   │   │   ├── MaintenanceListViewModel.cs
│   │   │   ├── MaintenanceDetailsViewModel.cs
│   │   │   ├── MaintenanceCreateViewModel.cs
│   │   │   └── MaintenanceCompleteViewModel.cs
│   │   ├── Users/
│   │   │   ├── UserListViewModel.cs
│   │   │   ├── UserCreateViewModel.cs
│   │   │   └── UserEditViewModel.cs
│   │   ├── Notifications/
│   │   │   └── NotificationListViewModel.cs
│   │   ├── Reports/
│   │   │   ├── ReportFilterViewModel.cs
│   │   │   └── ReportGenerateViewModel.cs
│   │   └── Profile/
│   │       ├── ProfileViewModel.cs
│   │       └── ProfileEditViewModel.cs
│   ├── Filters/
│   │   ├── AuthorizeRoleAttribute.cs
│   │   └── AuditLogActionFilter.cs
│   ├── Middleware/
│   │   └── ExceptionHandlingMiddleware.cs
│   ├── Extensions/
│   │   └── ServiceCollectionExtensions.cs
│   ├── appsettings.json
│   ├── appsettings.Development.json
│   └── Program.cs
│
├── SMEMS.Core/                         # Core Domain Layer
│   ├── Entities/
│   │   ├── User.cs
│   │   ├── Role.cs
│   │   ├── Department.cs
│   │   ├── Device.cs
│   │   ├── DeviceCategory.cs
│   │   ├── DeviceStatus.cs
│   │   ├── DeviceAccessory.cs
│   │   ├── Manufacturer.cs
│   │   ├── Supplier.cs
│   │   ├── RiskLevel.cs
│   │   ├── Priority.cs
│   │   ├── MaintenanceType.cs
│   │   ├── RequestStatus.cs
│   │   ├── MaintenanceRequest.cs
│   │   ├── MaintenanceLog.cs
│   │   ├── NotificationType.cs
│   │   ├── Notification.cs
│   │   ├── ReportType.cs
│   │   ├── Report.cs
│   │   ├── DeviceAssignment.cs
│   │   ├── Attachment.cs
│   │   ├── AuditLog.cs
│   │   └── ActivityHistory.cs
│   ├── Interfaces/
│   │   ├── Repositories/
│   │   │   ├── IRepository.cs
│   │   │   ├── IUserRepository.cs
│   │   │   ├── IDeviceRepository.cs
│   │   │   ├── IMaintenanceRequestRepository.cs
│   │   │   ├── INotificationRepository.cs
│   │   │   └── IReportRepository.cs
│   │   └── Services/
│   │       ├── IAuthService.cs
│   │       ├── IUserService.cs
│   │       ├── IDeviceService.cs
│   │       ├── IMaintenanceService.cs
│   │       ├── INotificationService.cs
│   │       ├── IReportService.cs
│   │       └── IAuditService.cs
│   ├── Enums/
│   │   ├── UserRole.cs
│   │   ├── DeviceStatusEnum.cs
│   │   ├── RiskLevelEnum.cs
│   │   ├── PriorityEnum.cs
│   │   ├── MaintenanceTypeEnum.cs
│   │   └── RequestStatusEnum.cs
│   ├── Constants/
│   │   └── AppConstants.cs
│   └── Exceptions/
│       ├── NotFoundException.cs
│       ├── ValidationException.cs
│       └── UnauthorizedException.cs
│
├── SMEMS.Infrastructure/               # Infrastructure Layer
│   ├── Data/
│   │   ├── SMEMSDbContext.cs
│   │   ├── Configurations/
│   │   │   ├── UserConfiguration.cs
│   │   │   ├── DeviceConfiguration.cs
│   │   │   ├── MaintenanceRequestConfiguration.cs
│   │   │   └── ... (other configurations)
│   │   └── Migrations/
│   ├── Repositories/
│   │   ├── Repository.cs
│   │   ├── UserRepository.cs
│   │   ├── DeviceRepository.cs
│   │   ├── MaintenanceRequestRepository.cs
│   │   ├── NotificationRepository.cs
│   │   └── ReportRepository.cs
│   └── Services/
│       └── EmailService.cs
│
├── SMEMS.Application/                  # Application/Business Logic Layer
│   ├── Services/
│   │   ├── AuthService.cs
│   │   ├── UserService.cs
│   │   ├── DeviceService.cs
│   │   ├── MaintenanceService.cs
│   │   ├── NotificationService.cs
│   │   ├── ReportService.cs
│   │   ├── DashboardService.cs
│   │   └── AuditService.cs
│   ├── DTOs/
│   │   ├── UserDto.cs
│   │   ├── DeviceDto.cs
│   │   ├── MaintenanceRequestDto.cs
│   │   ├── NotificationDto.cs
│   │   └── ReportDto.cs
│   ├── Mappings/
│   │   └── MappingProfile.cs
│   └── Validators/
│       ├── UserValidator.cs
│       ├── DeviceValidator.cs
│       └── MaintenanceRequestValidator.cs
│
├── SMEMS.Tests/                        # Unit & Integration Tests
│   ├── UnitTests/
│   │   ├── Services/
│   │   └── Repositories/
│   └── IntegrationTests/
│       └── Controllers/
│
└── SMEMS.sln                           # Solution File
```

---

## Summary

This database schema provides:

1. **22 Tables** covering all aspects of the SMEMS system
2. **Proper Normalization** with lookup tables for statuses, types, and priorities
3. **Audit Trail** support through AuditLogs and ActivityHistory tables
4. **Soft Delete** pattern with IsDeleted flags
5. **Timestamp Tracking** with CreatedAt and UpdatedAt fields
6. **Authentication Support** with secure password storage fields
7. **Full Relationship Mapping** with proper foreign keys and indexes
8. **Scalable Design** ready for production deployment

The schema fully supports all frontend pages including:
- Login/Authentication
- Admin/Engineer/Staff Dashboards
- Device Management
- Maintenance Requests & Logs
- User Management
- Notifications
- Reports
- Profile Management
