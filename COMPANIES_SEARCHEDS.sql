CREATE TABLE COMPANIES_SEARCHEDS(
ID_COMPANY   INT, 
COMPANY_NAME  VARCHAR2(250),
CNPJ VARCHAR2(20)UNIQUE NOT NULL ,
ACTIVITY_TEXT VARCHAR2(250),
TYPE_COMPANY VARCHAR2(250),
OPENED_DATE VARCHAR2(20),
SITUATION VARCHAR2(40) ,
COMPANY_STATUS VARCHAR2(40) ,
ADDRESS VARCHAR2(250),
COMPLEMENT VARCHAR2(250),
NEIGHBORHOOD VARCHAR2(250),
POSTAL_CODE VARCHAR2(20),
COUNTY  VARCHAR2(250),
COMPANY_SIZE VARCHAR2(30),
LEGAL_NATURE VARCHAR2(250),
CREATED_DATE DATE DEFAULT SYSDATE,
LAST_UPDATED_DATE DATE DEFAULT SYSDATE,
CONSTRAINT PK_ID_COMPANY PRIMARY KEY (ID_COMPANY)
);

CREATE SEQUENCE COMPANIES_SEARCHEDS_S
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 100000000000000
NOCACHE
NOCYCLE;