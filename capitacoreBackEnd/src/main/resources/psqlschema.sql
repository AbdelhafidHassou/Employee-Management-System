CREATE SCHEMA IF NOT EXISTS pfasecureapi;

CREATE TABLE Users
(
    id         BIGSERIAL NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(100) NOT NULL,
    password   VARCHAR(255) DEFAULT NULL,
    address    VARCHAR(255) DEFAULT NULL,
    phone      VARCHAR(30) DEFAULT NULL,
    title      VARCHAR(50) DEFAULT NULL,
    bio        VARCHAR(255) DEFAULT NULL,
    enabled    BOOLEAN DEFAULT FALSE,
    non_locked BOOLEAN DEFAULT TRUE,
    using_mfa  BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    image_url  VARCHAR(255) DEFAULT 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
    CONSTRAINT UQ_Users_Email UNIQUE (email)
);


CREATE TABLE Roles
(
    id         BIGSERIAL NOT NULL PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    permission VARCHAR(255) NOT NULL,
    CONSTRAINT UQ_Roles_Name UNIQUE (name)
);

CREATE TABLE UserRoles (
                           id      BIGSERIAL NOT NULL PRIMARY KEY,
                           user_id BIGSERIAL NOT NULL,
                           role_id BIGSERIAL NOT NULL,
                           FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
                           FOREIGN KEY (role_id) REFERENCES Roles (id) ON DELETE RESTRICT ON UPDATE CASCADE,
                           CONSTRAINT UQ_UserRoles_User_Id UNIQUE (user_id)
);

CREATE TABLE Events
(
    id          BIGSERIAL NOT NULL PRIMARY KEY,
    type        VARCHAR(255) NOT NULL CHECK(type IN ('LOGIN_ATTEMPT', 'LOGIN_ATTEMPT_FAILURE', 'LOGIN_ATTEMPT_SUCCESS', 'PROFILE_UPDATE', 'PROFILE_PICTURE_UPDATE', 'ROLE_UPDATE', 'ACCOUNT_SETTINGS_UPDATE', 'PASSWORD_UPDATE', 'MFA_UPDATE')),
    description VARCHAR(255) NOT NULL,
    CONSTRAINT UQ_Events_Type UNIQUE (type)
);

CREATE TABLE UserEvents
(
    id         BIGSERIAL NOT NULL PRIMARY KEY,
    user_id    BIGSERIAL NOT NULL,
    event_id   BIGSERIAL NOT NULL,
    device     VARCHAR(100) DEFAULT NULL,
    ip_address VARCHAR(100) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE AccountVerifications
(
    id      BIGSERIAL NOT NULL PRIMARY KEY,
    user_id BIGSERIAL NOT NULL,
    url     VARCHAR(255) NOT NULL,
    -- date     TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_AccountVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_AccountVerifications_Url UNIQUE (url)
);

CREATE TABLE ResetPasswordVerifications
(
    id              BIGSERIAL NOT NULL PRIMARY KEY,
    user_id         BIGSERIAL NOT NULL,
    url             VARCHAR(255) NOT NULL,
    expiration_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_ResetPasswordVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_ResetPasswordVerifications_Url UNIQUE (url)
);

CREATE TABLE TwoFactorVerifications
(
    id              BIGSERIAL NOT NULL PRIMARY KEY,
    user_id         BIGSERIAL NOT NULL,
    code            VARCHAR(10) NOT NULL,
    expiration_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_TwoFactorVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_TwoFactorVerifications_Code UNIQUE (code)
);



CREATE TABLE Documents
(
    id                  BIGSERIAL PRIMARY KEY,
    user_id             BIGINT NOT NULL,
    document_name       VARCHAR(255) NOT NULL,
    document_type       VARCHAR(50) NOT NULL,
    document_url        VARCHAR(255) NOT NULL,
    upload_date         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE EmployeeChurnData
(
    id                  BIGSERIAL PRIMARY KEY,
    user_id             BIGINT NOT NULL,
    tenure              INT NOT NULL,
    satisfaction_level  DECIMAL(3, 2),
    last_evaluation     DECIMAL(3, 2),
    number_of_projects  INT,
    average_monthly_hrs INT,
    time_spent_company  INT,
    work_accident       BOOLEAN,
    last_5years         BOOLEAN,
    department          VARCHAR(100),
    salary_level        VARCHAR(6) CHECK (salary_level IN ('low', 'medium', 'high')),
    churn_probability   DECIMAL(4, 3) DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE LearningRecommendations
(
    id                  BIGSERIAL PRIMARY KEY,
    user_id             BIGINT NOT NULL,
    skill_gap           VARCHAR(255),
    recommended_program VARCHAR(255),
    program_url         VARCHAR(255),
    program_type        VARCHAR(10) CHECK (program_type IN ('online', 'workshop', 'mentorship', 'course')),
    completion_status   BOOLEAN DEFAULT FALSE,
    recommendation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE
);

