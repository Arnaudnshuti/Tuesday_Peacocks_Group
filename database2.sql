/create table Notification

CREATE TABLE Notifications (
    NotificationID INT PRIMARY KEY,
    ScheduleID INT NOT NULL,
    SentDate DATE,
    Status VARCHAR(50),
    MessageType VARCHAR(50)
);


/create table application
CREATE TABLE Application (
    ApplicationID INT PRIMARY KEY,
    ApplicantID INT NOT NULL,
    Status VARCHAR(50),
    Remarks VARCHAR(255)
);

/create table Examination_scheduling

CREATE TABLE Examination_Scheduling (
    ScheduleID INT PRIMARY KEY,
    ApplicationID INT NOT NULL,
    ExamCenterID INT NOT NULL,
    NotificationStatus VARCHAR(50)
);

/create table Applicant 
CREATE TABLE Applicant (
    ApplicantID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1),
    Address VARCHAR(255)
);

/create table Test
CREATE TABLE Test (
    TestID INT PRIMARY KEY,
    ScheduleID INT NOT NULL,
    ExaminerID INT NOT NULL,
    TestType VARCHAR(50),
    Result VARCHAR(50),
    Comments VARCHAR(255)
);

/create table Examiner
CREATE TABLE Examiner (
    ExaminerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Qualification VARCHAR(100),
    AssignedCenterID INT
);

/create table examination ExamCenter
CREATE TABLE Examination_Center (
    ExamCenterID INT PRIMARY KEY,
    CenterName VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Capacity INT
);

/create table license
CREATE TABLE License (
    LicenseID INT PRIMARY KEY,
    ApplicantID INT NOT NULL,
    IssueDate DATE NOT NULL,
    ExpirationDate DATE NOT NULL,
    LicenseType VARCHAR(50)
);
 
 /relationships on notification 
 ALTER TABLE Notifications
ADD CONSTRAINT fk_notifications_schedule
FOREIGN KEY (ScheduleID) REFERENCES Examination_Scheduling(ScheduleID);

/relationships on application 
ALTER TABLE Application
ADD CONSTRAINT fk_application_applicant
FOREIGN KEY (ApplicantID) REFERENCES Applicant(ApplicantID);

/relationships on examination scheduling
ALTER TABLE Examination_Scheduling
ADD CONSTRAINT fk_scheduling_application
FOREIGN KEY (ApplicationID) REFERENCES Application(ApplicationID);

ALTER TABLE Examination_Scheduling
ADD CONSTRAINT fk_scheduling_examcenter
FOREIGN KEY (ExamCenterID) REFERENCES Examination_Center(ExamCenterID);

/relationships on test 
ALTER TABLE Test
ADD CONSTRAINT fk_test_schedule
FOREIGN KEY (ScheduleID) REFERENCES Examination_Scheduling(ScheduleID);

ALTER TABLE Test
ADD CONSTRAINT fk_test_examiner
FOREIGN KEY (ExaminerID) REFERENCES Examiner(ExaminerID);

/relationships on examiner 
ALTER TABLE Examiner
ADD CONSTRAINT fk_examiner_center
FOREIGN KEY (AssignedCenterID) REFERENCES Examination_Center(ExamCenterID);

/relationships on license 
ALTER TABLE License
ADD CONSTRAINT fk_license_applicant
FOREIGN KEY (ApplicantID) REFERENCES Applicant(ApplicantID);

ALTER USER SYSTEM ACCOUNT UNLOCK;

--Insert Data into Applicant Table
INSERT INTO Applicant (ApplicantID, FirstName, LastName, DateOfBirth, Gender, Address) 
VALUES (1, 'John', 'Doe', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'M', '123 Elm St');
INSERT INTO Applicant (ApplicantID, FirstName, LastName, DateOfBirth, Gender, Address) 
VALUES (2, 'Jane', 'Smith', TO_DATE('1988-09-22', 'YYYY-MM-DD'), 'F', '456 Oak St');

--Insert Data into Examination_Center Table
INSERT INTO Examination_Center (ExamCenterID, CenterName, Location, Capacity) 
VALUES (1, 'Main Center', '123 Elm St', 100);
INSERT INTO Examination_Center (ExamCenterID, CenterName, Location, Capacity) 
VALUES (2, 'Secondary Center', '456 Oak St', 50);

--Insert Data into Examiner Table
INSERT INTO Examiner (ExaminerID, FirstName, LastName, Qualification, AssignedCenterID) 
VALUES (1, 'Dr. Alan', 'Johnson', 'Certified Instructor', 1);
INSERT INTO Examiner (ExaminerID, FirstName, LastName, Qualification, AssignedCenterID) 
VALUES (2, 'Ms. Sarah', 'Lee', 'Certified Instructor', 2);

--Insert Data into Application Table
INSERT INTO Application (ApplicationID, ApplicantID, Status, Remarks) 
VALUES (1, 1, 'Pending', 'Documents submitted');
INSERT INTO Application (ApplicationID, ApplicantID, Status, Remarks) 
VALUES (2, 2, 'Complete', 'Documents verified');

--Insert Data into Examination_Scheduling Table
INSERT INTO Examination_Scheduling (ScheduleID, ApplicationID, ExamCenterID, NotificationStatus) 
VALUES (1, 1, 1, 'Scheduled');
INSERT INTO Examination_Scheduling (ScheduleID, ApplicationID, ExamCenterID, NotificationStatus) 
VALUES (2, 2, 2, 'Completed');

--Insert Data into Test Table
INSERT INTO Test (TestID, ScheduleID, ExaminerID, TestType, Result, Comments) 
VALUES (1, 1, 1, 'Practical', 'Pass', 'Good performance');
INSERT INTO Test (TestID, ScheduleID, ExaminerID, TestType, Result, Comments) 
VALUES (2, 2, 2, 'Theory', 'Fail', 'Incorrect answers');

--Insert Data into License Table
INSERT INTO License (LicenseID, ApplicantID, IssueDate, ExpirationDate, LicenseType) 
VALUES (1, 1, TO_DATE('2024-11-15', 'YYYY-MM-DD'), TO_DATE('2027-11-15', 'YYYY-MM-DD'), 'Regular');

--Insert Data into Notifications Table
INSERT INTO Notifications (NotificationID, ScheduleID, SentDate, Status, MessageType) 
VALUES (1, 1, TO_DATE('2024-11-01', 'YYYY-MM-DD'), 'Sent', 'Exam Scheduled');
INSERT INTO Notifications (NotificationID, ScheduleID, SentDate, Status, MessageType) 
VALUES (2, 2, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 'Delivered', 'Exam Completed');

--Verify Inserted Data
SELECT * FROM Applicant;
SELECT * FROM Application;
SELECT * FROM Examination_Scheduling;
SELECT * FROM Test;
SELECT * FROM License;
SELECT * FROM Notifications;

--Retrieve Applicant Details
--To get the details of an applicant along with their application status and exam schedule
SELECT a.FirstName, a.LastName, ap.Status AS ApplicationStatus, es.NotificationStatus AS ExamStatus
FROM Applicant a
JOIN Application ap ON a.ApplicantID = ap.ApplicantID
JOIN Examination_Scheduling es ON ap.ApplicationID = es.ApplicationID
WHERE a.ApplicantID = 1;

--Retrieve Exam Results for an Applicant
SELECT t.TestType, t.Result, t.Comments
FROM Test t
JOIN Examination_Scheduling es ON t.ScheduleID = es.ScheduleID
WHERE es.ApplicationID = 1;

--Generate Report of Pass/Fail Rates
SELECT t.TestType, t.Result, COUNT(*) AS ResultCount
FROM Test t
GROUP BY t.TestType, t.Result;

--Get All Licenses Issued
SELECT a.FirstName, a.LastName, l.LicenseType, l.IssueDate, l.ExpirationDate
FROM License l
JOIN Applicant a ON l.ApplicantID = a.ApplicantID;

--Cross Join
DECLARE
    v_schedule_id Examination_Scheduling.ScheduleID%TYPE;
    v_firstname Applicant.FirstName%TYPE;
    v_centername Examination_Center.CenterName%TYPE;
BEGIN
    -- Check if ScheduleID = 3 exists
    SELECT ScheduleID INTO v_schedule_id
    FROM Examination_Scheduling
    WHERE ScheduleID = 3;

    -- If found, proceed with your transaction
    -- Check if the TestID = 3 already exists before inserting
    BEGIN
        SELECT 1 INTO v_firstname
        FROM Test
        WHERE TestID = 3;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO Test (TestID, ScheduleID, ExaminerID, TestType, Result, Comments)
            VALUES (3, 3, 1, 'Practical', 'Pass', 'Excellent performance');
    END;

    -- Check if LicenseID = 2 already exists before inserting
    BEGIN
        SELECT 1 INTO v_firstname
        FROM License
        WHERE LicenseID = 2;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO License (LicenseID, ApplicantID, IssueDate, ExpirationDate, LicenseType)
            VALUES (2, 1, TO_DATE('2024-11-15', 'YYYY-MM-DD'), TO_DATE('2027-11-15', 'YYYY-MM-DD'), 'Regular');
    END;

    COMMIT;

    -- Execute SELECT query inside PL/SQL block
    FOR rec IN (SELECT a.FirstName, e.CenterName
                FROM Applicant a
                CROSS JOIN Examination_Center e) 
    LOOP
        -- You can now process the values or display them
        DBMS_OUTPUT.PUT_LINE('First Name: ' || rec.FirstName || ', Center Name: ' || rec.CenterName);
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle case if ScheduleID = 3 does not exist
        INSERT INTO Examination_Scheduling (ScheduleID, ApplicationID, ExamCenterID, NotificationStatus)
        VALUES (3, 1, 1, 'Scheduled');
        COMMIT;
END;
/
----INNER JOIN
SELECT a.FirstName, a.LastName, ap.Status AS ApplicationStatus, es.NotificationStatus AS ExamStatus
FROM Applicant a
INNER JOIN Application ap ON a.ApplicantID = ap.ApplicantID
INNER JOIN Examination_Scheduling es ON ap.ApplicationID = es.ApplicationID
WHERE a.ApplicantID = 1;

----LEFT OUTER JOIN
SELECT a.FirstName, a.LastName, es.NotificationStatus
FROM Applicant a
LEFT OUTER JOIN Examination_Scheduling es ON a.ApplicantID = es.ApplicationID;

-- Right Outer Join

SELECT es.ScheduleID, es.NotificationStatus, a.FirstName, a.LastName
FROM Examination_Scheduling es
RIGHT OUTER JOIN Applicant a ON es.ApplicationID = a.ApplicantID;

-- Full outer Join

SELECT a.FirstName, a.LastName, es.NotificationStatus
FROM Applicant a
FULL OUTER JOIN Examination_Scheduling es ON a.ApplicantID = es.ApplicationID;

-- Up date Data of Examination_Scheduling

UPDATE Examination_Scheduling
SET ApplicationID = 4, ExamCenterID = 302, NotificationStatus = 'Pending'
WHERE ScheduleID = 104;

-- insert data

INSERT INTO Examination_Scheduling (ScheduleID, ApplicationID, ExamCenterID, NotificationStatus) 
VALUES (105, 4, 302, 'Pending');

-- transaction

MERGE INTO Examination_Scheduling es
USING (SELECT 104 AS ScheduleID, 4 AS ApplicationID, 302 AS ExamCenterID, 'Pending' AS NotificationStatus FROM DUAL) src
ON (es.ScheduleID = src.ScheduleID)
WHEN MATCHED THEN
    UPDATE SET ApplicationID = src.ApplicationID, 
               ExamCenterID = src.ExamCenterID, 
               NotificationStatus = src.NotificationStatus
WHEN NOT MATCHED THEN
    INSERT (ScheduleID, ApplicationID, ExamCenterID, NotificationStatus)
    VALUES (src.ScheduleID, src.ApplicationID, src.ExamCenterID, src.NotificationStatus);

-- Commit the transaction
COMMIT;

-- Start the transaction
SET SERVEROUTPUT ON;
-- Check if the NotificationID exists
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Notifications
    WHERE NotificationID = 2;
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No record found with NotificationID = 2.');
    ELSE
        -- Update the status of the notification
        UPDATE Notifications
        SET Status = 'Sent'
        WHERE NotificationID = 2;
        -- Commit the transaction
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Notification status updated successfully.');
    END IF;
END;
/

-- transaction

SET SERVEROUTPUT ON;
-- Check if the NotificationID exists
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Notifications
    WHERE NotificationID = 2;
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No record found with NotificationID = 2.');
    ELSE
        -- Update the status of the notification
        UPDATE Notifications
        SET Status = 'Sent'
        WHERE NotificationID = 2;
        -- Commit the transaction
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Notification status updated successfully.');
    END IF;
END;
/



