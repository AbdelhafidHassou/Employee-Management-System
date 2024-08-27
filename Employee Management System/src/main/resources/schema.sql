CREATE SCHEMA IF NOT EXISTS pfasecureapi;

SET NAMES 'UTF8MB4';
SET TIME_ZONE = '+1:00';

USE pfasecureapi;

########################################################################################################################

DROP TABLE IF EXISTS Users;

CREATE TABLE Users
(
    user_id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    email               VARCHAR(100) NOT NULL,
    password            VARCHAR(255) DEFAULT NULL,
    address             VARCHAR(255) DEFAULT NULL,
    phone               VARCHAR(30) DEFAULT NULL,
    title               VARCHAR(50) DEFAULT NULL,
    bio                 VARCHAR(255) DEFAULT NULL,
    enabled             BOOLEAN DEFAULT FALSE,
    non_locked          BOOLEAN DEFAULT TRUE,
    using_mfa           BOOLEAN DEFAULT FALSE,
    create_at           DATETIME DEFAULT CURRENT_TIMESTAMP,
    image_url           VARCHAR(255) DEFAULT 'https://img.icons8.com/fluency/512/user#male#circle.png',
    CONSTRAINT UQ_Users_Email UNIQUE (email)
);

########################################################################################################################

DROP TABLE IF EXISTS Roles;

CREATE TABLE Roles
(
    role_id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(50) NOT NULL,
    permission          VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_Roles_Name UNIQUE (name)
);

########################################################################################################################

DROP TABLE IF EXISTS UserRoles;

CREATE TABLE UserRoles
(
    user_role_id        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    role_id             BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (role_id) REFERENCES Roles (role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT UQ_UserRoles_User_Id UNIQUE (user_id)
);

########################################################################################################################

DROP TABLE IF EXISTS Events;

CREATE TABLE Events
(
    event_id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type                VARCHAR(50) NOT NULL CHECK ( type IN (
                                                              'LOGIN_ATTEMPT',
                                                              'LOGIN_ATTEMPT_FAILURE',
                                                              'LOGIN_ATTEMPT_SUCCESS',
                                                              'PROFILE_UPDATE',
                                                              'PROFILE_PICTURE_UPDATE',
                                                              'ROLE_UPDATE',
                                                              'ACCOUNT_SETTINGS_UPDATE',
                                                              'PASSWORD_UPDATE',
                                                              'MFA_UPDATE'
        )),
    description         VARCHAR(255) NOT NULL,
    CONSTRAINT UQ_Events_type UNIQUE (type)
);

########################################################################################################################

DROP TABLE IF EXISTS UserEvents;

CREATE TABLE UserEvents
(
    user_event_id       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    event_id            BIGINT UNSIGNED NOT NULL,
    device              VARCHAR(100) DEFAULT NULL,
    ip_address          VARCHAR(100) DEFAULT NULL,
    create_at           DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Events (event_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

########################################################################################################################

DROP TABLE IF EXISTS ResetPasswordVerifications;

CREATE TABLE ResetPasswordVerifications
(
    reset_password_id   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    url                 VARCHAR(255) NOT NULL,
    expiration_date     DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_ResetPasswordVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_ResetPasswordVerifications_Url UNIQUE (url)
);

########################################################################################################################

DROP TABLE IF EXISTS TwoFactorVerifications;

CREATE TABLE TwoFactorVerifications
(
    two_factor_id       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    code                VARCHAR(255) NOT NULL,
    expiration_date     DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_TwoFactorVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_TwoFactorVerifications_Code UNIQUE (code)
);

########################################################################################################################

DROP TABLE IF EXISTS Documents;

CREATE TABLE Documents
(
    document_id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    document_name       VARCHAR(255) NOT NULL,
    document_type       VARCHAR(50) NOT NULL,
    document_url        VARCHAR(255) NOT NULL,
    upload_date         DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

########################################################################################################################

DROP TABLE IF EXISTS EmployeeChurnData;

CREATE TABLE EmployeeChurnData
(
    churn_id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    tenure              INT NOT NULL,
    satisfaction_level  DECIMAL(3, 2),
    last_evaluation     DECIMAL(3, 2),
    number_of_projects  INT,
    average_monthly_hrs INT,
    time_spent_company  INT,
    work_accident       BOOLEAN,
    last_5years         BOOLEAN,
    department          VARCHAR(100),
    salary_level        ENUM('low', 'medium', 'high'),
    churn_probability   DECIMAL(4, 3) DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

########################################################################################################################

DROP TABLE IF EXISTS LearningRecommendations;

CREATE TABLE LearningRecommendations
(
    recommendation_id   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    skill_gap           VARCHAR(255),
    recommended_program VARCHAR(255),
    program_url         VARCHAR(255),
    program_type        ENUM('online', 'workshop', 'mentorship', 'course'),
    completion_status   BOOLEAN DEFAULT FALSE,
    recommendation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE
);