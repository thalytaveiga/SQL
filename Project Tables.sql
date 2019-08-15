-- drop table bankbranch cascade constraints;
-- drop table bankemployee cascade constraints;
-- drop table bankcustomer cascade constraints;
-- drop table bankaccount cascade constraints;
-- drop table accounttypes cascade constraints;

commit;

create table bankbranch (
branchid number (4) not null,
branchname varchar2 (15) not null,
address varchar2 (30) not null,
province varchar2 (2) not null,
postalcode varchar2 (6) not null,
phone number (10) not null,
    constraint branch_branchid_pk primary key(branchid),
    constraint branch_province_ck
                CHECK (province IN ('BC', 'ON', 'QC', 'NS', 'PE', 'NL', 'NB', 'MB', 'SK', 'AB', 'YT', 'NT', 'NU'))
);

create table bankemployee (
empid number (4) not null,
branchid number (4) not null,
name varchar2 (10) not null,
address varchar2 (30) not null,
province varchar2 (2) not null,
postalcode varchar2 (6) not null,
phone number (10) not null,
email varchar2 (20) not null,
managerid number (4),
    constraint bankemployee_empid_pk primary key(empid),
    constraint bankemployee_branchid_fk foreign key(branchid) references bankbranch(branchid)
);

create table bankcustomer (
customerid number (6) not null,
name varchar2 (10) not null,
sinnumber number (10),
address varchar2 (30) not null,
province varchar2 (2) not null,
postalcode varchar2 (6) not null,
phone number (10) not null,
email varchar2 (20) not null,
    constraint bankcustomer_customerid_pk primary key(customerid)
);

create table accounttypes (
typeid number (3),
typename varchar2 (10),
    constraint accounttypes_typeid_pk primary key(typeid)
);

create table bankaccount (
accountnumber number (10) not null,
customerid number (6) not null,
branchid number (4) not null,
managerid number (4) not null,
accounttype number (4) not null,
balance number (15,2) default 0,
    constraint bankaccount_accountnumber_pk primary key(accountnumber),
    constraint bankaccount_customerid_fk foreign key(customerid) references bankcustomer(customerid),
    constraint bankaccount_managerid_fk foreign key(managerid) references bankemployee(empid),
    constraint bankaccount_branchid_fk foreign key(branchid) references bankbranch(branchid),
    constraint bankaccount_accounttype_fk foreign key(accounttype) references accounttypes(typeid)
);

commit;

-- Populate the tables
insert into bankbranch values (0001, 'Sheppard', '5000 Yonge Street, Toronto', 'ON', 'M1N1M1', 1111111111);
insert into bankbranch values (0002, 'Bloor', '200 Bloor Street East, Toronto', 'ON', 'M1C3C2', 2222222222);
insert into bankbranch values (0003, 'Montreal', '50 Main Street, Montreal', 'QC', 'B2CR3R', 3333333333);
insert into bankbranch values (0004, 'University', '100 University Avenue, Calgary', 'AB', 'A1B2B3', 4444444444);

insert into bankemployee values (001, 0001, 'Bob', '5051 Yonge Street, Toronto', 'ON', 'M1N1M1', 1234567891, 'bob@bank.ca', 004);
insert into bankemployee values (002, 0001, 'Ally', '2 Bloor Street West, Toronto', 'ON', 'M1C3C2', 2323232323, 'ally@bank.ca', 004);
insert into bankemployee values (003, 0002, 'Charlie', '10 Main Street, Montreal', 'QC', 'B2CR3R', 3213213213, 'charlie@bank.ca', 001);
insert into bankemployee values (004, 0003, 'Jane', '100 University Avenue, Calgary', 'AB', 'A1B2B3', 4445556664, 'jane@bank.ca', 004);

insert into bankcustomer values (000111, 'Daniel A', 9998889999, '55 Sheppard Avenue, Toronto', 'ON', 'M4N5T5', 4445552222, 'daniel@net.ca');
insert into bankcustomer values (000222, 'Ellen J', 7778889999, '2 Bloor Street West, Toronto', 'ON', 'M1C3C2', 4445552222, 'ellen@net.ca');
insert into bankcustomer values (000333, 'Lizzy H', 5552223333, '10 Main Street, Montreal', 'QC', 'B2CR3R', 4445552222, 'lizzy@net.ca');
insert into bankcustomer values (000444, 'Issac N', 3332225555, '100 University Avenue, Calgary', 'AB', 'M4N5T5', 4445552222, 'isaac@net.ca');

insert into accounttypes values (001, 'Checking');
insert into accounttypes values (002, 'Savings');
insert into accounttypes values (003, 'Investment');

insert into bankaccount values (101101, 000111, 0001, 001, 001, 13450.43);
insert into bankaccount values (101111, 000111, 0001, 001, 002, 8756.77);
insert into bankaccount values (200001, 000222, 0002, 002, 001, 11899.89);
insert into bankaccount values (200111, 000222, 0002, 002, 002, 5999.00);
insert into bankaccount values (202222, 000222, 0002, 002, 003, 45237.78);
insert into bankaccount values (301101, 000333, 0003, 003, 001, 9786.12);
insert into bankaccount values (400001, 000444, 0004, 004, 001, 4500);
insert into bankaccount values (400002, 000444, 0004, 004, 003, 17345.48);

-- 1: List all Branches names and all customers of that branch with their accounts

SELECT BB.BRANCHID AS "BRANCH ID", BB.BRANCHNAME AS "BRANCH NAME", BC.NAME AS "CUSTOMER NAME", BA.ACCOUNTNUMBER AS "ACCOUNT NUMBER", ATYPE.TYPENAME AS "ACCOUNT TYPE"
    FROM BANKBRANCH BB, BANKCUSTOMER BC, BANKACCOUNT BA, ACCOUNTTYPES ATYPE
    WHERE BB.BRANCHID = BA.BRANCHID
     AND BA.ACCOUNTTYPE = ATYPE.TYPEID
     AND BA.CUSTOMERID = BC.CUSTOMERID
    ORDER BY (BB.BRANCHNAME) ASC;
    
SELECT BB.BRANCHID AS "BRANCH ID", BB.BRANCHNAME AS "BRANCH NAME", BC.NAME AS "CUSTOMER NAME", BA.ACCOUNTNUMBER AS "ACCOUNT NUMBER", ATYPE.TYPENAME AS "ACCOUNT TYPE"
    FROM BANKCUSTOMER BC, BANKBRANCH BB
    JOIN BANKACCOUNT BA ON BB.BRANCHID = BA.BRANCHID
    JOIN ACCOUNTTYPES ATYPE ON BA.ACCOUNTTYPE = ATYPE.TYPEID
    WHERE BC.CUSTOMERID = BA.CUSTOMERID
    ORDER BY BB.BRANCHNAME ASC;

-- 2: Select all accounts managed by employee Bob Burn, with the account types and customers

SELECT BE.NAME AS "ACCOUNT MANAGER", BB.BRANCHID AS "BRANCH", BA.ACCOUNTNUMBER AS "ACCOUNT NUMBER", ATYPE.TYPENAME AS "ACCOUNT TYPE", BC.NAME AS "CUSTOMER NAME"
    FROM BANKEMPLOYEE BE, BANKACCOUNT BA, ACCOUNTTYPES ATYPE, BANKCUSTOMER BC, BANKBRANCH BB
    WHERE BE.EMPID = BA.MANAGERID
     AND ATYPE.TYPEID = BA.ACCOUNTTYPE
     AND BC.CUSTOMERID = BA.CUSTOMERID
     AND BB.BRANCHID = BA.BRANCHID
     AND BE.NAME = 'Bob Burn';
     
SELECT BE.NAME AS "ACCOUNT MANAGER", BB.BRANCHID AS "BRANCH", BA.ACCOUNTNUMBER AS "ACCOUNT NUMBER", ATYPE.TYPENAME AS "ACCOUNT TYPE", BC.NAME AS "CUSTOMER NAME"
    FROM BANKACCOUNT BA 
    JOIN BANKBRANCH BB ON BB.BRANCHID = BA.BRANCHID
    JOIN BANKCUSTOMER BC ON BC.CUSTOMERID = BA.CUSTOMERID
    JOIN ACCOUNTTYPES ATYPE ON ATYPE.TYPEID = BA.ACCOUNTTYPE
    JOIN BANKEMPLOYEE BE ON BE.EMPID = BA.MANAGERID 
    WHERE BE.NAME = 'Bob Burn';
    
     
-- 3: List all savings accounts and the owners

SELECT ATYPE.TYPENAME AS "ACCOUNT TYPE", BB.BRANCHID AS "BRANCH", BA.ACCOUNTNUMBER AS "ACCOUNT NUMBER", BC.NAME AS "CUSTOMER NAME"
    FROM BANKACCOUNT BA, ACCOUNTTYPES ATYPE, BANKCUSTOMER BC, BANKBRANCH BB
    WHERE ATYPE.TYPEID = BA.ACCOUNTTYPE
     AND BC.CUSTOMERID = BA.CUSTOMERID
     AND BB.BRANCHID = BA.BRANCHID
     AND ATYPE.TYPENAME = 'Savings';
     
SELECT ATYPE.TYPENAME AS "ACCOUNT TYPE", BB.BRANCHID AS "BRANCH", BA.ACCOUNTNUMBER AS "ACCOUNT NUMBER", BC.NAME AS "CUSTOMER NAME"
    FROM BANKACCOUNT BA
    JOIN ACCOUNTTYPES ATYPE ON ATYPE.TYPEID = BA.ACCOUNTTYPE
    JOIN BANKCUSTOMER BC ON BC.CUSTOMERID = BA.CUSTOMERID
    JOIN BANKBRANCH BB ON BB.BRANCHID = BA.BRANCHID
    WHERE ATYPE.TYPENAME = 'Savings';
     
-- 4: Count how many accounts are managed by each employee

SELECT BE.NAME AS "EMPLOYEE", COUNT(*) AS "ACCOUNTS MANAGED"
    FROM BANKACCOUNT BA, BANKEMPLOYEE BE
    WHERE BA.MANAGERID = BE.EMPID
    GROUP BY BE.NAME;
    
SELECT BE.NAME AS "EMPLOYEE", COUNT(*) AS "ACCOUNTS MANAGED"
    FROM BANKACCOUNT BA
    JOIN BANKEMPLOYEE BE ON BA.MANAGERID = BE.EMPID
    GROUP BY BE.NAME;

-- 5: List all customers from Alberta and how the account types they have
SELECT BC.NAME AS "CUSTOMER", BC.PROVINCE, ATYPES.TYPENAME
    FROM BANKACCOUNT BA, BANKCUSTOMER BC, ACCOUNTTYPES ATYPES
    WHERE BA.ACCOUNTTYPE = ATYPES.TYPEID
     AND BA.CUSTOMERID = BC.CUSTOMERID
     AND BC.PROVINCE = 'AB'
    ORDER BY BC.NAME;
    
-- 6: List employees by branch
SELECT BB.BRANCHNAME AS "BRANCH", BE.NAME AS "EMPLOYEE"
    FROM BANKBRANCH BB, BANKEMPLOYEE BE
    WHERE BB.BRANCHID = BE.BRANCHID
    ORDER BY BB.BRANCHNAME;
    
-- 7: List all information about all accounts
SELECT 
    BB.BRANCHID AS "BRANCH ID",
    BB.BRANCHNAME AS "BRANCH", 
    BB.ADDRESS AS "BRANCH ADDRESS",
    BB.PROVINCE AS "BRANCH PROVINCE",
    BB.POSTALCODE AS "BRANCH POSTAL CODE",
    BB.PHONE AS "BRANCH PHONE",
    BA.ACCOUNTNUMBER AS "ACCOUNT#", 
    TO_CHAR(BA.BALANCE,'$999999999999999.99')  AS "ACCOUNT BALANCE",
    BC.CUSTOMERID AS "CUSTOMER ID", 
    BC.NAME AS "CUSTOMER",
    BC.SINNUMBER AS "SIN NUMBER",
    BC.PROVINCE AS "CUSTOMER PROVINCE",
    BC.POSTALCODE AS "CUSTOMER POSTAL CODE",
    BC.PHONE AS "CUSTOMER PHONE",
    BC.EMAIL AS "CUSTOMER EMAIL",
    BE.NAME AS "ACCOUNT MANAGER", 
    ATYPES.TYPENAME AS "ACCOUNT TYPE"
    FROM BANKBRANCH BB, BANKCUSTOMER BC, BANKACCOUNT BA, ACCOUNTTYPES ATYPES, BANKEMPLOYEE BE
    WHERE BB.BRANCHID = BA.BRANCHID
     AND BC.CUSTOMERID = BA.CUSTOMERID
     AND ATYPES.TYPEID = BA.ACCOUNTTYPE
     AND BE.EMPID = BA.MANAGERID
    ORDER BY BB.BRANCHNAME;

-- 8: List the total balance ammount on each account type
SELECT ATYPES.TYPENAME AS "ACCOUNT TYPE", 
    TO_CHAR(SUM(BA.BALANCE),'$999999999999999.99')  AS "TOTAL ACCOUNT BALANCE"
    FROM ACCOUNTTYPES ATYPES, BANKACCOUNT BA
    WHERE BA.ACCOUNTTYPE = ATYPES.TYPEID
    GROUP BY ATYPES.TYPENAME;
    
-- 9: List the average ammount invested on all savings accounts
SELECT ATYPES.TYPENAME AS "ACCOUNT TYPE", 
    TO_CHAR(AVG(BA.BALANCE),'$999999999999999.99')  AS "AVERAGE ACCOUNT BALANCE"
    FROM ACCOUNTTYPES ATYPES, BANKACCOUNT BA
    WHERE BA.ACCOUNTTYPE = ATYPES.TYPEID
     AND BA.ACCOUNTTYPE = 2
    GROUP BY ATYPES.TYPENAME;

