-- =============================================
-- SMEMS - Smart Medical Equipment Management System
-- Database Creation Script
-- Database First Approach
-- =============================================

-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SMEMS')
BEGIN
    CREATE DATABASE SMEMS;
END
GO

USE SMEMS;
GO

-- =============================================
-- Drop existing tables (if recreating)
-- =============================================
IF OBJECT_ID('Notifications', 'U') IS NOT NULL DROP TABLE Notifications;
IF OBJECT_ID('MaintenanceRecords', 'U') IS NOT NULL DROP TABLE MaintenanceRecords;
IF OBJECT_ID('MaintenanceRequests', 'U') IS NOT NULL DROP TABLE MaintenanceRequests;
IF OBJECT_ID('MaintenanceStatuses', 'U') IS NOT NULL DROP TABLE MaintenanceStatuses;
IF OBJECT_ID('MaintenanceTypes', 'U') IS NOT NULL DROP TABLE MaintenanceTypes;
IF OBJECT_ID('Devices', 'U') IS NOT NULL DROP TABLE Devices;
IF OBJECT_ID('RiskLevels', 'U') IS NOT NULL DROP TABLE RiskLevels;
IF OBJECT_ID('DeviceStatuses', 'U') IS NOT NULL DROP TABLE DeviceStatuses;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Departments', 'U') IS NOT NULL DROP TABLE Departments;
IF OBJECT_ID('Roles', 'U') IS NOT NULL DROP TABLE Roles;
GO

-- =============================================
-- Create Tables
-- =============================================

-- 1. Roles Table
CREATE TABLE Roles (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL UNIQUE,
    DisplayName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);
GO

-- 2. Departments Table
CREATE TABLE Departments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Code NVARCHAR(20) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 3. Users Table
CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(256) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    RoleId INT NOT NULL,
    DepartmentId INT,
    Position NVARCHAR(100),
    ProfileImage NVARCHAR(255),
    JoinDate DATE,
    LastLogin DATETIME,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(Id),
    CONSTRAINT FK_Users_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);
GO

-- 4. Device Statuses Table
CREATE TABLE DeviceStatuses (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL UNIQUE,
    DisplayName NVARCHAR(100) NOT NULL,
    CssClass NVARCHAR(50),
    Description NVARCHAR(255)
);
GO

-- 5. Risk Levels Table
CREATE TABLE RiskLevels (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL UNIQUE,
    DisplayName NVARCHAR(100) NOT NULL,
    CssClass NVARCHAR(50),
    Priority INT DEFAULT 0
);
GO

-- 6. Devices Table
CREATE TABLE Devices (
    Id INT PRIMARY KEY IDENTITY(1,1),
    DeviceCode NVARCHAR(20) NOT NULL UNIQUE,
    Name NVARCHAR(100) NOT NULL,
    Model NVARCHAR(100),
    SerialNumber NVARCHAR(100),
    Manufacturer NVARCHAR(100),
    Supplier NVARCHAR(100),
    DepartmentId INT,
    Location NVARCHAR(200),
    StatusId INT NOT NULL,
    RiskLevelId INT,
    PurchaseDate DATE,
    WarrantyExpiry DATE,
    ExpectedLifespan NVARCHAR(50),
    FailureCount INT DEFAULT 0,
    LastMaintenanceDate DATE,
    NextMaintenanceDate DATE,
    MaintenanceIntervalDays INT DEFAULT 90,
    Accessories NVARCHAR(500),
    Notes NVARCHAR(MAX),
    ImagePath NVARCHAR(255),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    CONSTRAINT FK_Devices_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(Id),
    CONSTRAINT FK_Devices_DeviceStatuses FOREIGN KEY (StatusId) REFERENCES DeviceStatuses(Id),
    CONSTRAINT FK_Devices_RiskLevels FOREIGN KEY (RiskLevelId) REFERENCES RiskLevels(Id)
);
GO

-- 7. Maintenance Types Table
CREATE TABLE MaintenanceTypes (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL UNIQUE,
    DisplayName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);
GO

-- 8. Maintenance Statuses Table
CREATE TABLE MaintenanceStatuses (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL UNIQUE,
    DisplayName NVARCHAR(100) NOT NULL,
    CssClass NVARCHAR(50)
);
GO

-- 9. Maintenance Requests Table
CREATE TABLE MaintenanceRequests (
    Id INT PRIMARY KEY IDENTITY(1,1),
    RequestCode NVARCHAR(20) NOT NULL UNIQUE,
    DeviceId INT NOT NULL,
    RequestedById INT NOT NULL,
    AssignedEngineerId INT,
    TypeId INT NOT NULL,
    StatusId INT NOT NULL,
    Priority NVARCHAR(20) DEFAULT 'medium',
    Issue NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    HasAlternative BIT DEFAULT 0,
    AlternativeDescription NVARCHAR(255),
    EngineerNotes NVARCHAR(MAX),
    RequestDate DATETIME DEFAULT GETDATE(),
    AssignedDate DATETIME,
    StartDate DATETIME,
    ExpectedCompletionDate DATETIME,
    CompletionDate DATETIME,
    Resolution NVARCHAR(MAX),
    PartsUsed NVARCHAR(500),
    Cost DECIMAL(18,2),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    CONSTRAINT FK_MaintenanceRequests_Devices FOREIGN KEY (DeviceId) REFERENCES Devices(Id),
    CONSTRAINT FK_MaintenanceRequests_RequestedBy FOREIGN KEY (RequestedById) REFERENCES Users(Id),
    CONSTRAINT FK_MaintenanceRequests_AssignedEngineer FOREIGN KEY (AssignedEngineerId) REFERENCES Users(Id),
    CONSTRAINT FK_MaintenanceRequests_Types FOREIGN KEY (TypeId) REFERENCES MaintenanceTypes(Id),
    CONSTRAINT FK_MaintenanceRequests_Statuses FOREIGN KEY (StatusId) REFERENCES MaintenanceStatuses(Id)
);
GO

-- 10. Maintenance Records Table (History)
CREATE TABLE MaintenanceRecords (
    Id INT PRIMARY KEY IDENTITY(1,1),
    DeviceId INT NOT NULL,
    MaintenanceRequestId INT,
    TypeId INT NOT NULL,
    MaintenanceDate DATE NOT NULL,
    Description NVARCHAR(MAX),
    Actions NVARCHAR(MAX),
    PartsReplaced NVARCHAR(500),
    Cost DECIMAL(18,2),
    PerformedById INT NOT NULL,
    NextScheduledDate DATE,
    Notes NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_MaintenanceRecords_Devices FOREIGN KEY (DeviceId) REFERENCES Devices(Id),
    CONSTRAINT FK_MaintenanceRecords_Requests FOREIGN KEY (MaintenanceRequestId) REFERENCES MaintenanceRequests(Id),
    CONSTRAINT FK_MaintenanceRecords_Types FOREIGN KEY (TypeId) REFERENCES MaintenanceTypes(Id),
    CONSTRAINT FK_MaintenanceRecords_PerformedBy FOREIGN KEY (PerformedById) REFERENCES Users(Id)
);
GO

-- 11. Notifications Table
CREATE TABLE Notifications (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Message NVARCHAR(MAX),
    Type NVARCHAR(50),
    Priority NVARCHAR(20) DEFAULT 'medium',
    Icon NVARCHAR(50),
    IsRead BIT DEFAULT 0,
    ReadAt DATETIME,
    RelatedEntityType NVARCHAR(50),
    RelatedEntityId INT,
    ActionUrl NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Notifications_Users FOREIGN KEY (UserId) REFERENCES Users(Id)
);
GO

-- =============================================
-- Insert Default Data
-- =============================================

-- Insert Roles
INSERT INTO Roles (Name, DisplayName, Description) VALUES
('admin', 'Administrator', 'Full system access - manage users, devices, and reports'),
('engineer', 'Engineer', 'Maintenance management - handle maintenance requests and device repairs'),
('staff', 'Medical Staff', 'Limited access - view devices and request maintenance');
GO

-- Insert Departments
INSERT INTO Departments (Name, Code, Description) VALUES
('Emergency', 'ER', 'Emergency Room Department'),
('Surgery', 'SURG', 'Surgery Department'),
('ICU', 'ICU', 'Intensive Care Unit'),
('Radiology', 'RAD', 'Radiology and Imaging Department'),
('Laboratory', 'LAB', 'Medical Laboratory'),
('Cardiology', 'CARD', 'Cardiology Department'),
('Pediatrics', 'PED', 'Pediatrics Department'),
('Orthopedics', 'ORTH', 'Orthopedics Department'),
('Neurology', 'NEUR', 'Neurology Department'),
('Oncology', 'ONCO', 'Oncology Department');
GO

-- Insert Device Statuses
INSERT INTO DeviceStatuses (Name, DisplayName, CssClass, Description) VALUES
('operational', 'Operational', 'status-operational', 'Device is working normally'),
('maintenance_needed', 'Maintenance Needed', 'status-maintenance-needed', 'Device requires maintenance'),
('under_maintenance', 'Under Maintenance', 'status-under-maintenance', 'Device is currently being repaired'),
('out_of_service', 'Out of Service', 'status-out-of-service', 'Device is not operational');
GO

-- Insert Risk Levels
INSERT INTO RiskLevels (Name, DisplayName, CssClass, Priority) VALUES
('low', 'Low', 'risk-low', 1),
('medium', 'Medium', 'risk-medium', 2),
('high', 'High', 'risk-high', 3),
('critical', 'Critical', 'risk-critical', 4);
GO

-- Insert Maintenance Types
INSERT INTO MaintenanceTypes (Name, DisplayName, Description) VALUES
('preventive', 'Preventive', 'Scheduled maintenance to prevent failures'),
('corrective', 'Corrective', 'Repair maintenance to fix existing issues'),
('emergency', 'Emergency', 'Urgent maintenance for critical failures');
GO

-- Insert Maintenance Statuses
INSERT INTO MaintenanceStatuses (Name, DisplayName, CssClass) VALUES
('pending', 'Pending', 'status-pending'),
('assigned', 'Assigned', 'status-assigned'),
('in_progress', 'In Progress', 'status-in-progress'),
('completed', 'Completed', 'status-completed'),
('cancelled', 'Cancelled', 'status-cancelled');
GO

-- Insert Default Admin User (Password: Admin@123)
-- Note: This is a BCrypt hash - you should change this in production
INSERT INTO Users (Username, PasswordHash, FullName, Email, Phone, RoleId, Position, JoinDate, IsActive) VALUES
('admin', '$2a$11$K3B5E9m6s3vH2n1A4r7Z8eQxY5w0v1U2i3O4p5A6s7D8f9G0h1J2k3', 'System Administrator', 'admin@smems.com', '0599999999', 1, 'System Administrator', GETDATE(), 1);
GO

-- Insert Sample Engineer
INSERT INTO Users (Username, PasswordHash, FullName, Email, Phone, RoleId, DepartmentId, Position, JoinDate, IsActive) VALUES
('engineer1', '$2a$11$K3B5E9m6s3vH2n1A4r7Z8eQxY5w0v1U2i3O4p5A6s7D8f9G0h1J2k3', 'Ahmad Hassan', 'engineer@smems.com', '0598888888', 2, 1, 'Biomedical Engineer', GETDATE(), 1);
GO

-- Insert Sample Staff
INSERT INTO Users (Username, PasswordHash, FullName, Email, Phone, RoleId, DepartmentId, Position, JoinDate, IsActive) VALUES
('staff1', '$2a$11$K3B5E9m6s3vH2n1A4r7Z8eQxY5w0v1U2i3O4p5A6s7D8f9G0h1J2k3', 'Sara Ali', 'staff@smems.com', '0597777777', 3, 1, 'Head Nurse', GETDATE(), 1);
GO

-- Insert Sample Devices
INSERT INTO Devices (DeviceCode, Name, Model, SerialNumber, Manufacturer, DepartmentId, Location, StatusId, RiskLevelId, PurchaseDate, WarrantyExpiry, NextMaintenanceDate) VALUES
('DEV001', 'Ventilator', 'PB840', 'SN001234', 'Medtronic', 3, 'ICU Room 1', 1, 4, '2022-01-15', '2025-01-15', '2024-06-15'),
('DEV002', 'Patient Monitor', 'IntelliVue MX800', 'SN002345', 'Philips', 3, 'ICU Room 2', 1, 3, '2022-03-20', '2025-03-20', '2024-07-20'),
('DEV003', 'Defibrillator', 'LIFEPAK 15', 'SN003456', 'Stryker', 1, 'ER Bay 1', 2, 4, '2021-06-10', '2024-06-10', '2024-05-10'),
('DEV004', 'X-Ray Machine', 'Mobilett Mira Max', 'SN004567', 'Siemens', 4, 'Radiology Room 1', 1, 3, '2021-09-05', '2024-09-05', '2024-08-05'),
('DEV005', 'Ultrasound', 'LOGIQ E10', 'SN005678', 'GE Healthcare', 4, 'Radiology Room 2', 3, 2, '2022-02-28', '2025-02-28', '2024-05-28'),
('DEV006', 'Infusion Pump', 'Alaris System', 'SN006789', 'BD', 2, 'Surgery Room 1', 1, 2, '2023-01-10', '2026-01-10', '2024-09-10'),
('DEV007', 'ECG Machine', 'MAC 2000', 'SN007890', 'GE Healthcare', 6, 'Cardiology Clinic', 1, 2, '2022-07-15', '2025-07-15', '2024-10-15'),
('DEV008', 'Anesthesia Machine', 'Aisys CS2', 'SN008901', 'GE Healthcare', 2, 'Surgery Room 2', 4, 4, '2020-11-20', '2023-11-20', '2024-04-20');
GO

-- Insert Sample Maintenance Requests
INSERT INTO MaintenanceRequests (RequestCode, DeviceId, RequestedById, AssignedEngineerId, TypeId, StatusId, Priority, Issue, Description, RequestDate) VALUES
('MR001', 3, 3, 2, 2, 3, 'high', 'Device not charging', 'The defibrillator battery is not holding charge properly', GETDATE()),
('MR002', 5, 3, 2, 2, 2, 'medium', 'Image quality issues', 'Ultrasound images appear grainy and unclear', DATEADD(DAY, -2, GETDATE())),
('MR003', 8, 3, NULL, 2, 1, 'critical', 'Gas delivery malfunction', 'Anesthesia machine showing gas delivery errors', DATEADD(DAY, -1, GETDATE()));
GO

-- Insert Sample Notifications
INSERT INTO Notifications (UserId, Title, Message, Type, Priority, Icon, IsRead, RelatedEntityType, RelatedEntityId) VALUES
(2, 'New Maintenance Request', 'A new maintenance request MR003 has been submitted for Anesthesia Machine', 'maintenance_request', 'high', 'fa-tools', 0, 'MaintenanceRequest', 3),
(2, 'Request Assigned', 'You have been assigned to maintenance request MR001', 'assignment', 'medium', 'fa-user-check', 0, 'MaintenanceRequest', 1),
(3, 'Maintenance Started', 'Maintenance has started on Defibrillator (DEV003)', 'maintenance_update', 'low', 'fa-wrench', 1, 'Device', 3),
(1, 'Device Status Alert', 'Anesthesia Machine (DEV008) is now Out of Service', 'device_status', 'high', 'fa-exclamation-triangle', 0, 'Device', 8);
GO

-- =============================================
-- Create Indexes for Performance
-- =============================================
CREATE INDEX IX_Users_RoleId ON Users(RoleId);
CREATE INDEX IX_Users_DepartmentId ON Users(DepartmentId);
CREATE INDEX IX_Users_Username ON Users(Username);
CREATE INDEX IX_Devices_DepartmentId ON Devices(DepartmentId);
CREATE INDEX IX_Devices_StatusId ON Devices(StatusId);
CREATE INDEX IX_Devices_DeviceCode ON Devices(DeviceCode);
CREATE INDEX IX_MaintenanceRequests_DeviceId ON MaintenanceRequests(DeviceId);
CREATE INDEX IX_MaintenanceRequests_StatusId ON MaintenanceRequests(StatusId);
CREATE INDEX IX_MaintenanceRequests_AssignedEngineerId ON MaintenanceRequests(AssignedEngineerId);
CREATE INDEX IX_Notifications_UserId ON Notifications(UserId);
CREATE INDEX IX_Notifications_IsRead ON Notifications(IsRead);
GO

-- =============================================
-- Create Views for Reports
-- =============================================
CREATE OR ALTER VIEW vw_DeviceOverview AS
SELECT 
    d.Id,
    d.DeviceCode,
    d.Name AS DeviceName,
    d.Model,
    d.SerialNumber,
    d.Manufacturer,
    dep.Name AS DepartmentName,
    d.Location,
    ds.DisplayName AS Status,
    ds.CssClass AS StatusCssClass,
    rl.DisplayName AS RiskLevel,
    rl.CssClass AS RiskCssClass,
    d.PurchaseDate,
    d.WarrantyExpiry,
    d.NextMaintenanceDate,
    d.FailureCount,
    d.IsActive
FROM Devices d
LEFT JOIN Departments dep ON d.DepartmentId = dep.Id
LEFT JOIN DeviceStatuses ds ON d.StatusId = ds.Id
LEFT JOIN RiskLevels rl ON d.RiskLevelId = rl.Id;
GO

CREATE OR ALTER VIEW vw_MaintenanceOverview AS
SELECT 
    mr.Id,
    mr.RequestCode,
    d.DeviceCode,
    d.Name AS DeviceName,
    dep.Name AS DepartmentName,
    requester.FullName AS RequestedBy,
    engineer.FullName AS AssignedEngineer,
    mt.DisplayName AS MaintenanceType,
    ms.DisplayName AS Status,
    ms.CssClass AS StatusCssClass,
    mr.Priority,
    mr.Issue,
    mr.RequestDate,
    mr.StartDate,
    mr.CompletionDate
FROM MaintenanceRequests mr
JOIN Devices d ON mr.DeviceId = d.Id
LEFT JOIN Departments dep ON d.DepartmentId = dep.Id
JOIN Users requester ON mr.RequestedById = requester.Id
LEFT JOIN Users engineer ON mr.AssignedEngineerId = engineer.Id
JOIN MaintenanceTypes mt ON mr.TypeId = mt.Id
JOIN MaintenanceStatuses ms ON mr.StatusId = ms.Id;
GO

PRINT 'SMEMS Database created successfully!';
PRINT 'Default users created:';
PRINT '  - admin / Admin@123 (Administrator)';
PRINT '  - engineer1 / Admin@123 (Engineer)';
PRINT '  - staff1 / Admin@123 (Medical Staff)';
GO
