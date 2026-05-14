-- =============================================
-- SMEMS Database Seed Data
-- Smart Medical Equipment Management System
-- SQL Server 2019+
-- =============================================

USE SMEMS_DB;
GO

-- =============================================
-- SEED LOOKUP TABLES
-- =============================================

-- Seed Roles
SET IDENTITY_INSERT Roles ON;
INSERT INTO Roles (RoleId, RoleName, Description) VALUES
(1, 'Administrator', 'Full system access and management capabilities'),
(2, 'Engineer', 'Biomedical engineers who perform maintenance and repairs'),
(3, 'Medical Staff', 'Doctors, nurses, and medical personnel who use equipment');
SET IDENTITY_INSERT Roles OFF;
GO

PRINT 'Roles seeded.';
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
(9, 'Inventory', 'INV', 'Equipment inventory management', 'Building D, Floor 1'),
(10, 'Pediatrics', 'PED', 'Pediatric care department', 'Building B, Floor 1'),
(11, 'Oncology', 'ONC', 'Cancer treatment department', 'Building C, Floor 3'),
(12, 'Neurology', 'NEUR', 'Neurological care department', 'Building B, Floor 5');
SET IDENTITY_INSERT Departments OFF;
GO

PRINT 'Departments seeded.';
GO

-- Seed Device Categories
SET IDENTITY_INSERT DeviceCategories ON;
INSERT INTO DeviceCategories (CategoryId, CategoryName, CategoryCode, Description) VALUES
(1, 'Diagnostic Equipment', 'DIAG', 'Equipment used for patient diagnosis'),
(2, 'Therapeutic Equipment', 'THER', 'Equipment used for patient treatment'),
(3, 'Life Support Equipment', 'LIFE', 'Critical life-sustaining equipment'),
(4, 'Monitoring Equipment', 'MON', 'Patient monitoring devices'),
(5, 'Laboratory Equipment', 'LAB', 'Laboratory analysis equipment'),
(6, 'Imaging Equipment', 'IMG', 'Medical imaging devices'),
(7, 'Surgical Equipment', 'SURG', 'Equipment used in surgical procedures'),
(8, 'Sterilization Equipment', 'STER', 'Equipment for sterilization purposes');
SET IDENTITY_INSERT DeviceCategories OFF;
GO

PRINT 'DeviceCategories seeded.';
GO

-- Seed Manufacturers
SET IDENTITY_INSERT Manufacturers ON;
INSERT INTO Manufacturers (ManufacturerId, ManufacturerName, ContactPerson, Email, Phone, Country, Website, IsActive) VALUES
(1, 'MedTech Solutions', 'John Smith', 'contact@medtech.com', '+1-555-0101', 'USA', 'www.medtech.com', 1),
(2, 'CardioTech', 'Sarah Johnson', 'info@cardiotech.com', '+1-555-0102', 'Germany', 'www.cardiotech.com', 1),
(3, 'PumpTech', 'Michael Brown', 'sales@pumptech.com', '+1-555-0103', 'Japan', 'www.pumptech.com', 1),
(4, 'RadioTech', 'Emily Davis', 'support@radiotech.com', '+1-555-0104', 'USA', 'www.radiotech.com', 1),
(5, 'HeartSave', 'Robert Wilson', 'contact@heartsave.com', '+1-555-0105', 'Netherlands', 'www.heartsave.com', 1),
(6, 'SonoTech', 'Lisa Anderson', 'info@sonotech.com', '+1-555-0106', 'South Korea', 'www.sonotech.com', 1),
(7, 'LabEquip International', 'David Lee', 'sales@labequip.com', '+1-555-0107', 'Switzerland', 'www.labequip.com', 1),
(8, 'SurgicalPro', 'Jennifer Martinez', 'contact@surgicalpro.com', '+1-555-0108', 'Germany', 'www.surgicalpro.com', 1),
(9, 'VitalSigns Medical', 'Thomas White', 'info@vitalsigns.com', '+1-555-0109', 'USA', 'www.vitalsigns.com', 1),
(10, 'NeuroDiag Systems', 'Amanda Green', 'support@neurodiag.com', '+1-555-0110', 'Israel', 'www.neurodiag.com', 1);
SET IDENTITY_INSERT Manufacturers OFF;
GO

PRINT 'Manufacturers seeded.';
GO

-- Seed Suppliers
SET IDENTITY_INSERT Suppliers ON;
INSERT INTO Suppliers (SupplierId, SupplierName, ContactPerson, Email, Phone, Country, ContractStartDate, ContractEndDate, IsActive) VALUES
(1, 'Global Medical Supplies', 'Ahmed Khan', 'orders@globalmed.com', '+1-555-0201', 'UAE', '2024-01-01', '2026-12-31', 1),
(2, 'MedSupply Co', 'Fatima Ali', 'sales@medsupply.com', '+1-555-0202', 'Jordan', '2023-06-01', '2025-05-31', 1),
(3, 'BioMed Supply', 'Omar Hassan', 'contact@biomed.com', '+1-555-0203', 'Egypt', '2024-03-01', '2027-02-28', 1),
(4, 'Imaging Solutions', 'Layla Mohammed', 'info@imagingsol.com', '+1-555-0204', 'Saudi Arabia', '2022-01-01', '2026-12-31', 1),
(5, 'Emergency Med', 'Khalid Ibrahim', 'orders@emergmed.com', '+1-555-0205', 'Kuwait', '2024-01-01', '2026-12-31', 1),
(6, 'LabTech Distributors', 'Yasmine Nasser', 'sales@labtech.com', '+1-555-0206', 'Qatar', '2023-09-01', '2026-08-31', 1),
(7, 'SurgMed International', 'Hassan Ahmed', 'contact@surgmed.com', '+1-555-0207', 'Bahrain', '2024-02-01', '2027-01-31', 1);
SET IDENTITY_INSERT Suppliers OFF;
GO

PRINT 'Suppliers seeded.';
GO

-- Seed Device Statuses
SET IDENTITY_INSERT DeviceStatuses ON;
INSERT INTO DeviceStatuses (StatusId, StatusName, StatusCode, ColorCode, Description, DisplayOrder) VALUES
(1, 'Operational', 'OPER', '#16A34A', 'Device is fully functional and in use', 1),
(2, 'Maintenance Needed', 'MAINT_NEED', '#D97706', 'Device requires scheduled maintenance', 2),
(3, 'Under Maintenance', 'UNDER_MAINT', '#0891B2', 'Device is currently being serviced', 3),
(4, 'Out of Service', 'OUT_SERV', '#DC2626', 'Device is non-functional and unavailable', 4),
(5, 'Decommissioned', 'DECOM', '#6B7280', 'Device has been permanently retired', 5);
SET IDENTITY_INSERT DeviceStatuses OFF;
GO

PRINT 'DeviceStatuses seeded.';
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

PRINT 'RiskLevels seeded.';
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

PRINT 'Priorities seeded.';
GO

-- Seed Maintenance Types
SET IDENTITY_INSERT MaintenanceTypes ON;
INSERT INTO MaintenanceTypes (MaintenanceTypeId, TypeName, TypeCode, Description) VALUES
(1, 'Preventive Maintenance', 'PREV', 'Scheduled routine maintenance to prevent failures'),
(2, 'Corrective Maintenance', 'CORR', 'Repairs to fix equipment failures or malfunctions'),
(3, 'Calibration', 'CAL', 'Equipment calibration and accuracy verification'),
(4, 'Installation', 'INST', 'New equipment installation and setup'),
(5, 'Inspection', 'INSP', 'Safety and compliance inspection'),
(6, 'Software Update', 'SW_UPD', 'Firmware and software updates'),
(7, 'Emergency Repair', 'EMERG', 'Urgent unplanned repairs');
SET IDENTITY_INSERT MaintenanceTypes OFF;
GO

PRINT 'MaintenanceTypes seeded.';
GO

-- Seed Request Statuses
SET IDENTITY_INSERT RequestStatuses ON;
INSERT INTO RequestStatuses (RequestStatusId, StatusName, StatusCode, ColorCode, DisplayOrder) VALUES
(1, 'Pending', 'PEND', '#D97706', 1),
(2, 'In Progress', 'PROG', '#0891B2', 2),
(3, 'Completed', 'COMP', '#16A34A', 3),
(4, 'Cancelled', 'CANC', '#6B7280', 4),
(5, 'On Hold', 'HOLD', '#8B5CF6', 5),
(6, 'Awaiting Parts', 'AWAIT', '#F59E0B', 6);
SET IDENTITY_INSERT RequestStatuses OFF;
GO

PRINT 'RequestStatuses seeded.';
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
(8, 'System Alert', 'SYS_ALERT', 'bell', '#DC2626'),
(9, 'New Request Created', 'REQ_CREATE', 'plus-circle', '#3B82F6'),
(10, 'Device Added', 'DEV_ADD', 'cpu', '#16A34A');
SET IDENTITY_INSERT NotificationTypes OFF;
GO

PRINT 'NotificationTypes seeded.';
GO

-- Seed Report Types
SET IDENTITY_INSERT ReportTypes ON;
INSERT INTO ReportTypes (ReportTypeId, TypeName, TypeCode, Description, TemplateFileName) VALUES
(1, 'Device Report', 'DEV_RPT', 'Comprehensive device inventory and status report', 'DeviceReportTemplate.rdlc'),
(2, 'Maintenance Report', 'MAINT_RPT', 'Maintenance activities and history report', 'MaintenanceReportTemplate.rdlc'),
(3, 'Full Report', 'FULL_RPT', 'Complete system report including all data', 'FullReportTemplate.rdlc'),
(4, 'User Activity Report', 'USER_RPT', 'User activities and audit trail report', 'UserActivityReportTemplate.rdlc'),
(5, 'Department Report', 'DEPT_RPT', 'Department-wise equipment and maintenance report', 'DepartmentReportTemplate.rdlc'),
(6, 'Cost Analysis Report', 'COST_RPT', 'Maintenance cost analysis report', 'CostAnalysisReportTemplate.rdlc');
SET IDENTITY_INSERT ReportTypes OFF;
GO

PRINT 'ReportTypes seeded.';
GO

-- =============================================
-- SEED CORE DATA
-- =============================================

-- Seed Users (Password: "Password123!" - In production, use proper password hashing)
-- Note: The PasswordHash shown is a placeholder. Use ASP.NET Core Identity's UserManager to create proper hashes.
SET IDENTITY_INSERT Users ON;
INSERT INTO Users (UserId, Username, Email, PasswordHash, FullName, Phone, Position, EmployeeId, RoleId, DepartmentId, IsActive, JoinedDate) VALUES
(1, 'ahmed.hassan', 'ahmed.hassan@hospital.com', 'AQAAAAEAACcQAAAAEPBhKpqsF5YDyxTPdKfh...', 'Dr. Ahmed Hassan', '0790000001', 'Administrator', 'EMP-1001', 1, 1, 1, '2020-01-15'),
(2, 'mohammed.ali', 'mohammed.ali@hospital.com', 'AQAAAAEAACcQAAAAEPBhKpqsF5YDyxTPdKfh...', 'Eng. Mohammed Ali', '0790000002', 'Biomedical Engineer', 'EMP-1002', 2, 7, 1, '2021-03-10'),
(3, 'sarah.ahmed', 'sarah.ahmed@hospital.com', 'AQAAAAEAACcQAAAAEPBhKpqsF5YDyxTPdKfh...', 'Nurse Sarah Ahmed', '0790000003', 'Nurse', 'EMP-1003', 3, 2, 1, '2022-01-10'),
(4, 'fatima.hatem', 'fatima.hatem@hospital.com', 'AQAAAAEAACcQAAAAEPBhKpqsF5YDyxTPdKfh...', 'Nurse Fatima Hatem', '0790000004', 'Nurse', 'EMP-1004', 3, 9, 1, '2022-06-15'),
(5, 'layla.hassan', 'layla.hassan@hospital.com', 'AQAAAAEAACcQAAAAEPBhKpqsF5YDyxTPdKfh...', 'Dr. Layla Hassan', '0790000005', 'Doctor', 'EMP-1005', 3, 4, 1, '2021-09-20'),
(6, 'ahmed.ibrahim', 'ahmed.ibrahim@hospital.com', 'AQAAAAEAACcQAAAAEPBhKpqsF5YDyxTPdKfh...', 'Eng. Ahmed Ibrahim', '0790000006', 'Biomedical Engineer', 'EMP-1006', 2, 7, 1, '2023-04-01'),
(7, 'omar.khaled', 'omar.khaled@hospital.com', 'AQAAAAEAACcQAAAAEPBhKpqsF5YDyxTPdKfh...', 'Dr. Omar Khaled', '0790000007', 'Doctor', 'EMP-1007', 3, 5, 1, '2020-08-15'),
(8, 'mona.salem', 'mona.salem@hospital.com', 'AQAAAAEAACcQAAAAEPBhKpqsF5YDyxTPdKfh...', 'Nurse Mona Salem', '0790000008', 'Head Nurse', 'EMP-1008', 3, 3, 1, '2019-05-20'),
(9, 'hassan.yousef', 'hassan.yousef@hospital.com', 'AQAAAAEAACcQAAAAEPBhKpqsF5YDyxTPdKfh...', 'Eng. Hassan Yousef', '0790000009', 'Senior Biomedical Engineer', 'EMP-1009', 2, 7, 1, '2018-11-01'),
(10, 'nour.karim', 'nour.karim@hospital.com', 'AQAAAAEAACcQAAAAEPBhKpqsF5YDyxTPdKfh...', 'Admin Nour Karim', '0790000010', 'System Administrator', 'EMP-1010', 1, 1, 1, '2021-02-28');
SET IDENTITY_INSERT Users OFF;
GO

PRINT 'Users seeded.';
GO

-- Seed Devices
SET IDENTITY_INSERT Devices ON;
INSERT INTO Devices (DeviceId, DeviceCode, DeviceName, Model, SerialNumber, CategoryId, ManufacturerId, SupplierId, DepartmentId, StatusId, RiskLevelId, Location, PurchaseDate, WarrantyExpiryDate, ExpectedLifespanYears, FailureCount, NextMaintenanceDate, MaintenanceIntervalDays, CreatedByUserId) VALUES
(1, 'dev-001', 'Ventilator Model X200', 'X200', 'VNT-2023-001', 3, 1, 1, 2, 1, 3, 'ICU - Room 101', '2023-01-15', '2026-01-15', 10, 1, '2026-05-15', 180, 1),
(2, 'dev-002', 'ECG Monitor Pro', 'ECG-500', 'ECG-2022-002', 4, 2, 2, 2, 2, 2, 'ICU - Room 203', '2022-06-10', '2025-06-10', 8, 2, '2026-04-26', 90, 1),
(3, 'dev-003', 'Infusion Pump Smart', 'IP-300', 'INF-2024-003', 2, 3, 3, 2, 1, 1, 'ICU - Room 105', '2024-02-01', '2027-02-01', 7, 0, '2026-08-01', 180, 1),
(4, 'dev-004', 'X-Ray Machine Digital', 'XR-1000', 'XRY-2021-004', 6, 4, 4, 4, 4, 4, 'Radiology - Room A', '2021-03-20', '2024-03-20', 12, 4, '2026-06-20', 365, 1),
(5, 'dev-005', 'Defibrillator AED Plus', 'AED-250', 'AED-2023-005', 3, 5, 5, 3, 1, 4, 'ER - Station 1', '2023-09-05', '2026-09-05', 10, 0, '2026-09-05', 365, 1),
(6, 'dev-006', 'Ultrasound Scanner Pro', 'US-700', 'ULS-2022-006', 6, 6, 4, 4, 3, 2, 'Radiology - Room B', '2022-11-12', '2025-11-12', 9, 1, '2026-11-12', 180, 1),
(7, 'dev-007', 'Patient Monitor Advanced', 'PM-400', 'PM-2023-007', 4, 9, 1, 2, 1, 3, 'ICU - Room 102', '2023-05-20', '2026-05-20', 8, 0, '2026-11-20', 180, 1),
(8, 'dev-008', 'CT Scanner 64-Slice', 'CT-64', 'CT-2020-008', 6, 4, 4, 4, 1, 4, 'Radiology - Room C', '2020-08-15', '2025-08-15', 15, 2, '2026-08-15', 365, 1),
(9, 'dev-009', 'Anesthesia Machine', 'AN-2000', 'AN-2022-009', 3, 1, 1, 6, 1, 4, 'Surgery - OR 1', '2022-03-10', '2027-03-10', 12, 0, '2026-09-10', 180, 1),
(10, 'dev-010', 'Blood Analyzer', 'BA-500', 'BA-2024-010', 5, 7, 6, 8, 1, 2, 'Laboratory - Main Lab', '2024-01-15', '2027-01-15', 10, 0, '2026-07-15', 180, 1),
(11, 'dev-011', 'Portable ECG Monitor', 'ECG-P100', 'ECGP-2024-011', 4, 2, 2, 3, 1, 2, 'ER - Mobile Unit', '2024-03-01', '2027-03-01', 6, 0, '2026-09-01', 180, 1),
(12, 'dev-012', 'Surgical Laser System', 'SL-3000', 'SL-2021-012', 7, 8, 7, 6, 1, 3, 'Surgery - OR 2', '2021-11-20', '2024-11-20', 10, 1, '2026-05-20', 180, 1);
SET IDENTITY_INSERT Devices OFF;
GO

PRINT 'Devices seeded.';
GO

-- Seed Device Accessories
INSERT INTO DeviceAccessories (DeviceId, AccessoryName, Description, Quantity) VALUES
(1, 'Breathing circuits', 'Standard breathing circuits for ventilator', 5),
(1, 'Filters', 'HEPA filters for ventilator', 10),
(1, 'Humidifier', 'Heated humidifier attachment', 2),
(2, 'Electrode pads', 'ECG electrode pads - adult', 50),
(2, 'Lead cables', '12-lead ECG cables', 3),
(2, 'Mounting bracket', 'Wall mounting bracket', 1),
(3, 'IV sets', 'Standard IV administration sets', 20),
(3, 'Drug library module', 'Pre-programmed drug library', 1),
(5, 'Electrode pads (adult)', 'AED electrode pads for adults', 4),
(5, 'Electrode pads (pediatric)', 'AED electrode pads for children', 2),
(5, 'Carry case', 'Portable carry case', 1),
(6, 'Transducer probes', 'Ultrasound transducer probes', 3),
(6, 'Gel warmer', 'Ultrasound gel warmer', 1),
(6, 'Printer', 'Thermal image printer', 1),
(7, 'SpO2 sensors', 'Pulse oximetry sensors', 5),
(7, 'NIBP cuffs', 'Non-invasive blood pressure cuffs (various sizes)', 4),
(8, 'Contrast injector', 'CT contrast media injector', 1),
(9, 'Vaporizers', 'Anesthetic agent vaporizers', 3),
(10, 'Reagent kits', 'Blood analysis reagent kits', 10),
(12, 'Safety goggles', 'Laser safety goggles', 6);
GO

PRINT 'DeviceAccessories seeded.';
GO

-- Seed Maintenance Requests
SET IDENTITY_INSERT MaintenanceRequests ON;
INSERT INTO MaintenanceRequests (RequestId, RequestCode, DeviceId, RequestedByUserId, AssignedToUserId, MaintenanceTypeId, PriorityId, RequestStatusId, IssueTitle, IssueDescription, HasAlternativeDevice, RequestedDate, AssignedDate, StartedDate, EngineerNotes) VALUES
(1, 'req-001', 2, 3, NULL, 2, 3, 1, 'Display malfunction', 'Screen flickering and showing distorted readings intermittently.', 1, '2026-04-10', NULL, NULL, NULL),
(2, 'req-002', 4, 5, 2, 2, 3, 2, 'Complete failure', 'Machine not powering on after routine shutdown. Tried standard restart procedures with no success.', 0, '2026-04-08', '2026-04-08', '2026-04-09', 'Inspecting power supply unit. Ordered replacement parts.'),
(3, 'req-003', 6, 5, 6, 2, 2, 2, 'Image quality degradation', 'Ultrasound images are blurry and lack detail. Issue persists across all probe types.', 1, '2026-04-11', '2026-04-11', '2026-04-11', 'Probe replacement ordered. Temporary workaround provided.'),
(4, 'req-004', 1, 3, NULL, 2, 3, 1, 'Alarm system fault', 'Alarm not triggering during simulated pressure drop test.', 0, '2026-04-12', NULL, NULL, NULL),
(5, 'req-005', 7, 3, 9, 1, 2, 3, 'Scheduled preventive maintenance', 'Quarterly preventive maintenance for patient monitor.', 0, '2026-03-15', '2026-03-15', '2026-03-16', 'Completed all checks, calibration successful.'),
(6, 'req-006', 9, 7, 2, 3, 2, 3, 'Calibration required', 'Annual calibration for anesthesia machine vaporizers.', 0, '2026-02-20', '2026-02-21', '2026-02-22', 'Calibration completed, all parameters within acceptable range.'),
(7, 'req-007', 10, 4, 6, 1, 1, 3, 'Routine maintenance', 'Semi-annual preventive maintenance for blood analyzer.', 0, '2026-01-10', '2026-01-11', '2026-01-12', 'Replaced consumables and verified accuracy.'),
(8, 'req-008', 8, 5, NULL, 2, 2, 1, 'Calibration drift detected', 'HU values showing slight drift from baseline. Needs recalibration.', 0, '2026-04-14', NULL, NULL, NULL);
SET IDENTITY_INSERT MaintenanceRequests OFF;
GO

PRINT 'MaintenanceRequests seeded.';
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
(3, 6, 6, 2, '2026-04-11', 'Image quality issue', 'Image quality degradation - probe replacement in progress', 0),
(5, 7, 9, 1, '2026-03-16', 'Preventive maintenance completed', 'All parameters checked and within range', 1),
(6, 9, 2, 3, '2026-02-22', 'Calibration completed', 'Vaporizer calibration completed successfully', 1),
(7, 10, 6, 1, '2026-01-12', 'Routine maintenance completed', 'Replaced reagents and verified accuracy', 1),
(NULL, 8, 9, 1, '2025-08-15', 'Annual maintenance', 'Annual CT scanner maintenance completed', 1),
(NULL, 11, 2, 1, '2024-09-01', 'Initial setup and calibration', 'New device installation and initial calibration', 1),
(NULL, 12, 9, 1, '2025-11-20', 'Preventive maintenance', 'Laser alignment check and power calibration', 1);
GO

PRINT 'MaintenanceLogs seeded.';
GO

-- Seed Notifications
INSERT INTO Notifications (UserId, NotificationTypeId, Title, Message, PriorityId, RelatedEntityType, RelatedEntityId, IsRead, CreatedAt) VALUES
(1, 1, 'Maintenance Request Updated', 'X-Ray Machine Digital maintenance is now in progress', 3, 'MaintenanceRequest', 2, 1, '2026-04-09 09:20:00'),
(1, 2, 'Device Status Changed', 'X-Ray Machine Digital is now out of service', 3, 'Device', 4, 0, '2026-04-08 14:30:00'),
(1, 3, 'Preventive Maintenance Due Soon', 'ECG Monitor Pro preventive maintenance due in 8 days', 2, 'Device', 2, 0, '2026-04-12 06:00:00'),
(1, 4, 'New User Added', 'Eng. Ahmed Ibrahim has been added to the system', 1, 'User', 6, 1, '2026-04-07 10:00:00'),
(2, 5, 'Request Assigned', 'You have been assigned to maintenance request req-002', 3, 'MaintenanceRequest', 2, 1, '2026-04-08 10:00:00'),
(6, 5, 'Request Assigned', 'You have been assigned to maintenance request req-003', 2, 'MaintenanceRequest', 3, 1, '2026-04-11 09:00:00'),
(9, 6, 'Request Completed', 'Maintenance request req-005 has been completed', 1, 'MaintenanceRequest', 5, 1, '2026-03-16 16:00:00'),
(2, 6, 'Request Completed', 'Maintenance request req-006 has been completed', 1, 'MaintenanceRequest', 6, 1, '2026-02-22 15:00:00'),
(1, 7, 'Warranty Expiring', 'X-Ray Machine Digital warranty expired', 3, 'Device', 4, 0, '2024-03-01 08:00:00'),
(1, 9, 'New Request Created', 'New maintenance request req-008 has been created', 2, 'MaintenanceRequest', 8, 0, '2026-04-14 11:00:00'),
(3, 2, 'Device Status Changed', 'Ultrasound Scanner Pro is now under maintenance', 2, 'Device', 6, 1, '2026-04-11 09:30:00'),
(5, 1, 'Maintenance Update', 'Your request for Ultrasound Scanner Pro is being processed', 2, 'MaintenanceRequest', 3, 1, '2026-04-11 10:00:00');
GO

PRINT 'Notifications seeded.';
GO

-- Seed Device Assignments
INSERT INTO DeviceAssignments (DeviceId, DepartmentId, Location, AssignedByUserId, AssignedDate, IsCurrentAssignment) VALUES
(1, 2, 'ICU - Room 101', 1, '2023-01-20', 1),
(2, 2, 'ICU - Room 203', 1, '2022-06-15', 1),
(3, 2, 'ICU - Room 105', 1, '2024-02-05', 1),
(4, 4, 'Radiology - Room A', 1, '2021-03-25', 1),
(5, 3, 'ER - Station 1', 1, '2023-09-10', 1),
(6, 4, 'Radiology - Room B', 1, '2022-11-15', 1),
(7, 2, 'ICU - Room 102', 1, '2023-05-25', 1),
(8, 4, 'Radiology - Room C', 1, '2020-08-20', 1),
(9, 6, 'Surgery - OR 1', 1, '2022-03-15', 1),
(10, 8, 'Laboratory - Main Lab', 1, '2024-01-20', 1),
(11, 3, 'ER - Mobile Unit', 1, '2024-03-05', 1),
(12, 6, 'Surgery - OR 2', 1, '2021-11-25', 1);
GO

PRINT 'DeviceAssignments seeded.';
GO

-- Seed Activity History
INSERT INTO ActivityHistory (DeviceId, UserId, ActivityType, Description, OldValue, NewValue, CreatedAt) VALUES
(4, 1, 'STATUS_CHANGE', 'Device status changed', 'Under Maintenance', 'Out of Service', '2026-04-08 14:30:00'),
(6, 1, 'STATUS_CHANGE', 'Device status changed', 'Operational', 'Under Maintenance', '2026-04-11 09:00:00'),
(2, 1, 'STATUS_CHANGE', 'Device status changed', 'Operational', 'Maintenance Needed', '2026-04-10 10:00:00'),
(1, 2, 'MAINTENANCE', 'Preventive maintenance completed', NULL, NULL, '2025-07-15 16:00:00'),
(4, 2, 'MAINTENANCE', 'Corrective maintenance started', NULL, NULL, '2026-04-09 09:00:00'),
(7, 9, 'MAINTENANCE', 'Preventive maintenance completed', NULL, NULL, '2026-03-16 16:00:00'),
(9, 2, 'CALIBRATION', 'Annual calibration completed', NULL, NULL, '2026-02-22 15:00:00'),
(10, 6, 'MAINTENANCE', 'Routine maintenance completed', NULL, NULL, '2026-01-12 14:00:00'),
(8, 9, 'MAINTENANCE', 'Annual maintenance completed', NULL, NULL, '2025-08-15 17:00:00'),
(5, 2, 'MAINTENANCE', 'Annual preventive maintenance completed', NULL, NULL, '2025-09-05 15:00:00');
GO

PRINT 'ActivityHistory seeded.';
GO

-- Seed Audit Logs
INSERT INTO AuditLogs (UserId, UserName, Action, EntityType, EntityId, NewValues, IpAddress, Timestamp) VALUES
(1, 'ahmed.hassan', 'LOGIN', 'User', 1, NULL, '192.168.1.100', '2026-04-20 08:00:00'),
(1, 'ahmed.hassan', 'CREATE', 'MaintenanceRequest', 4, '{"RequestCode":"req-004","DeviceId":1}', '192.168.1.100', '2026-04-12 10:30:00'),
(1, 'ahmed.hassan', 'UPDATE', 'Device', 4, '{"StatusId":4}', '192.168.1.100', '2026-04-08 14:30:00'),
(2, 'mohammed.ali', 'UPDATE', 'MaintenanceRequest', 2, '{"RequestStatusId":2}', '192.168.1.101', '2026-04-09 09:15:00'),
(1, 'ahmed.hassan', 'CREATE', 'User', 6, '{"Username":"ahmed.ibrahim","RoleId":2}', '192.168.1.100', '2026-04-07 10:00:00'),
(6, 'ahmed.ibrahim', 'LOGIN', 'User', 6, NULL, '192.168.1.102', '2026-04-11 08:30:00'),
(6, 'ahmed.ibrahim', 'UPDATE', 'MaintenanceRequest', 3, '{"RequestStatusId":2,"EngineerNotes":"Probe replacement ordered."}', '192.168.1.102', '2026-04-11 11:00:00'),
(9, 'hassan.yousef', 'UPDATE', 'MaintenanceRequest', 5, '{"RequestStatusId":3,"CompletedDate":"2026-03-16"}', '192.168.1.103', '2026-03-16 16:00:00'),
(2, 'mohammed.ali', 'UPDATE', 'MaintenanceRequest', 6, '{"RequestStatusId":3}', '192.168.1.101', '2026-02-22 15:00:00'),
(1, 'ahmed.hassan', 'CREATE', 'Device', 12, '{"DeviceCode":"dev-012","DeviceName":"Surgical Laser System"}', '192.168.1.100', '2021-11-20 10:00:00');
GO

PRINT 'AuditLogs seeded.';
GO

-- =============================================
-- FINAL VERIFICATION
-- =============================================

PRINT '';
PRINT '=============================================';
PRINT 'SMEMS Database Seed Data Complete!';
PRINT '=============================================';
PRINT '';
PRINT 'Summary of seeded data:';
PRINT '- Roles: 3';
PRINT '- Departments: 12';
PRINT '- Device Categories: 8';
PRINT '- Manufacturers: 10';
PRINT '- Suppliers: 7';
PRINT '- Device Statuses: 5';
PRINT '- Risk Levels: 4';
PRINT '- Priorities: 4';
PRINT '- Maintenance Types: 7';
PRINT '- Request Statuses: 6';
PRINT '- Notification Types: 10';
PRINT '- Report Types: 6';
PRINT '- Users: 10';
PRINT '- Devices: 12';
PRINT '- Device Accessories: 20';
PRINT '- Maintenance Requests: 8';
PRINT '- Maintenance Logs: 20';
PRINT '- Notifications: 12';
PRINT '- Device Assignments: 12';
PRINT '- Activity History: 10';
PRINT '- Audit Logs: 10';
PRINT '';
PRINT '=============================================';
GO
