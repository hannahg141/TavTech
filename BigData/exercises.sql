--QUESTION 1
CREATE TABLE Celebrity (
    cid int,
    cname varchar(255),
	age int
);

CREATE TABLE Car (
    cnum int,
    color varchar(255),
	model varchar(255)
);

CREATE TABLE Road (
    rid int,
    length int,
	maxAllowedSpeed int
);

CREATE TABLE TrafficOffence (
    cid int,
    cnum int,
	rid int,
	date date,
	type varchar(255),
	recordedSpeed int
);

INSERT INTO Celebrity VALUES 
('654', 'Rebecca', '42'),
('610', 'Quincy', '15'),
('154', 'James', '35'),
('687', 'Sara', '17'),
('851', 'Guy', '23'),

-- Row Made For Shmulik 
('984', 'Shmulik', '46');

INSERT INTO Car VALUES 
('5214', 'white', 'Buick'),
('3574', 'yellow', 'Chevrolet'),
('8612', 'black', 'Mazda'),
('4068', 'red', 'Toyota'),
('3514', 'blue', 'Tesla');

INSERT INTO Road VALUES 
('1', '53', '60'),
('2', '167', '55'),
('3', '29', '70'),
('4', '834', '35'),
('5', '16', '45'),
('6', '245', '63');

INSERT INTO TrafficOffence VALUES 
('654', '3514', '3', '2001-05-24', 'Speeding', '75' ),
('687', '3574', '2', '2015-07-15', 'Traffic', '86'),
('687', '5214', '1', '2004-09-16', 'Reckless Driving', '80'),
('851', '8612', '6', '2008-03-03', 'DUI', '55'),
('610', '3574', '5', '2017-09-20', 'Speeding', '91'),
('610', '4068', '5', '2009-06-28', 'Stop Infringement', '65'),
('851', '3514', '3', '2000-01-02', 'Speeding', '90'),
('687', '3574', '5', '2017-09-16', 'Traffic', '81'),
('654', '5214', '4', '2003-10-14', 'DUI', '65'),
('154', '8612', '2', '2014-03-08', 'Speeding', '95'),
('687', '3574', '6', '2016-02-16', 'Stop Infringement', '86'),
('610', '3574', '4', '2013-04-13', 'Reckless Driving', '72'),
('154', '8612', '2', '2010-11-21', 'Reckless Driving', '67'),

-- Rows With Shmulik 
('984', '8612', '2', '2004-05-29', 'speeding', '110'),
('984', '3514', '2', '2004-05-29', 'drunk', '45');


-- write a SQL query that returns the names of the celebrities whose 
-- ages are under 18 and who’ve had more than 2 traffic offences between the date of 11/09/2007 and 21/09/2017 
-- on road #5 or any road longer than 100 miles while using a yellow Chevrolet. 
SELECT cname from Celebrity 
    where Celebrity.age < 18 
    and cid IN 
        (select cid from TrafficOffence, Road 
        where date BETWEEN "11/09/2007" and "21/09/2017" 
            and Road.rid == 5 or Road.length > 100
            and cnum IN 
            (select cnum from Car where car.color == "yellow" AND car.model == "Chevrolet")
            GROUP BY cid having count(cid) >= 2);

--QUESTION 2
CREATE TABLE BodyGuards (
    id int,
    name varchar(255),
    gender varchar(255),
	age int
);

CREATE TABLE Celebrities (
    id int,
    name varchar(255),
    gender varchar,
    age int,
    fid int
);

CREATE TABLE FanaticFan (
    id int,
    name varchar(255),
    mental_illness varchar(255)
);

CREATE TABLE Threats (
    fid int,
    cid int,
    risk_level int
);

CREATE TABLE PublicEvents (
    cid int,
    gid int,
    fid int,
    location varchar(255),
    event_date date
);

INSERT INTO BodyGuards VALUES 
('95473', 'Max', 'Male', '42'),
('69124', 'Brittany', 'Female', '35'),
('35467', 'Kevin', 'Male', '26'),
('83014', 'Rose', 'Female', '37'),
('20547', 'Dylan', 'Male', '20'),
('63014', 'Abraham', 'Male', '48'),
('98201', 'Felisha', 'Female', '25'),
('63741', 'Tiffany', 'Female', '19'),
('96785', 'Peter', 'Male', '24'),
('21407', 'Robin', 'Female', '18');

INSERT INTO Celebrities VALUES 
('95473', 'Tony', 'Male', '61', '54102'),
('42578', 'Gustavo', 'Male', '24', '64276'),
('69321', 'Fred', 'Male', '37', '20541'),
('87421', 'Pedro', 'Male', '80', '32784'),
('30279', 'Hanna', 'Female', '26', '48630'),
('62057', 'Trey', 'Male', '19', '37502'),
('98501', 'Ann', 'Female', '62', '65832'),
('65402', 'John', 'Male', '30', '24937'),
('75314', 'Jennifer', 'Female', '51', '45613'),
('96547', 'Robert', 'Male', '23', '42147'),
('32015', 'Patricia', 'Female', '46', '32784');


INSERT INTO FanaticFan VALUES
('64276', 'Max', 'Mood'),
('48630', 'Albert', 'Eating'),
('24937', 'Juan', 'Anxiety'),
('42147', 'Sebastian', 'Mood'),
('54102', 'Emma', 'OCD'),
('32784', 'Sophia', 'Psychotic'),
('65832', 'Sam', 'Personality'),
('20541', 'Alice', 'OCD'),
('45613', 'Will', 'Insomnia'),
('37502', 'Linda', 'Psychotic');

INSERT INTO Threats VALUES
('32784', '32015', '84'),
('48630', '30279', '24'),
('20541', '75314', '93'),
('37502', '95473', '91'),
('64276', '42578', '35'),
('65832', '98501', '58'),
('54102', '69321', '89'),
('24937', '65402', '95'),
('45613', '87421', '24'),
('42147', '62057', '35'),
('42147', '96547', '64');


INSERT INTO PublicEvents VALUES
('65402', '21407', '20541', 'Washington DC', '2000-07-14'),
('87421', '98201', '37502', 'Berlin', '2000-07-14'),
('96547', '63741', '64276', 'Paris', '2013-12-12'),
('69321', '69124', '42147', 'Tel Aviv', '2012-03-08'),
('87421', '69124', '64276', 'Berlin', '2000-07-14'),
('62057', '21407', '45613', 'Copenhagen', '2007-02-26'),
('32015', '98201', '20541', 'Prague', '1999-05-28'),
('87421', '96785', '20541', 'Berlin', '2000-07-14'),
('42578', '63014', '48630', 'Mexico City', '2004-08-23'),
('65402', '63741', '45613', 'Rio', '2005-01-04'),
('42578', '98201', '24937', 'Ontario', '2014-03-21'),
('87421', '35467', '54102', 'London', '2011-05-23'),
('95473', '63014', '20541', 'Madrid', '2012-11-28'),
('75314', '96785', '32784', 'Tokyo', '2009-02-14'),
('95473', '20547', '37502', 'Moscow', '2002-08-16'),
('30279', '83014', '65832', 'San Diego', '2010-09-13'),
('96547', '63014', '54102', 'Budapest', '2016-10-04'),
('98501', '21407', '37502', 'Hong Kong', '1998-06-19'),
('62057', '69124', '65832', 'Kiev', '2014-12-15');


-- write a SQL query that returns the list of celebrities of over 18 years old 
-- who participated in at least one event in Berlin along with 3 body-guards 
-- who were aged 21 or older, and had in their audience 2 extremist fans with a risk level equal or higher to 80.

select DISTINCT name from Celebrities C, PublicEvents peC
    where age > 18
    and id == cid 
    and location == "Berlin"
    and 2 >= (select count(*) 
                from Threats, PublicEvents peF
                where peF.cid == C.id
                and peF.location == peC.location
                and peF.event_date == peC.event_date
                and peF.fid == Threats.fid
                and Threats.cid == C.id
                and risk_level >= 80)
    and 3 == (select count(*) 
                from BodyGuards, PublicEvents peG
                where BodyGuards.age >= 21
                and peG.gid == BodyGuards.id
                and peG.location == peC.location
                and peG.event_date == peC.event_date
                and peG.cid = C.id);



























