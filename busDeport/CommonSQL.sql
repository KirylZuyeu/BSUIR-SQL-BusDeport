CREATE DATABASE BusDeport 
ON PRIMARY 
(NAME = BusDeport_Data, 
FILENAME = 'D:\1_BGUIR\2_�������\2_����\��\������\BusDeport_Data.mdf', 
SIZE = 3MB, 
MAXSIZE = 50MB, 
FILEGROWTH = 2MB), 
FILEGROUP Secondary 
(NAME = BusDeport2_Data, 
FILENAME = 'D:\1_BGUIR\2_�������\2_����\��\������\BusDeport_Data2.ndf', 
SIZE = 2MB,
MAXSIZE = 70MB, 
FILEGROWTH = 20%), 
(NAME = BusDeport3_Data, 
FILENAME = 'D:\1_BGUIR\2_�������\2_����\��\������\BusDeport_Data3.ndf', 
SIZE = 2MB, 
FILEGROWTH = 5MB) 
LOG ON 
(NAME = BusDeport_Log, 
FILENAME = 'D:\1_BGUIR\2_�������\2_����\��\������\BusDeport_Log.ldf', 
SIZE = 1MB, 
MAXSIZE = 10MB, 
FILEGROWTH = 15%), 
(NAME = BusDeport2_Log, 
FILENAME = 'D:\1_BGUIR\2_�������\2_����\��\������\BusDeport_Log2.ldf', 
SIZE = 512KB, 
MAXSIZE = 5MB, 
FILEGROWTH = 10%)
GO

  USE BusDeport
 GO 

  CREATE RULE Logical_Rule AS @value IN ('���', '��') 
 GO

 CREATE DEFAULT Logical_Default AS '���' 
 GO 

 EXEC sp_addtype Logical, 'char(3)', 'NOT NULL'
 GO 

 EXEC sp_bindrule 'Logical_Rule', 'Logical'
 GO 

 EXEC sp_bindefault 'Logical_Default', 'Logical'
 GO 

CREATE TABLE ��������� ( 
	������������ INT PRIMARY KEY NOT NULL, 
	��������� VARCHAR(60) NOT NULL
);

CREATE TABLE ��������� ( 
	������������� INT PRIMARY KEY NOT NULL,
	��� VARCHAR(60) NOT NULL, 
	������������ DATE NULL, 
	������� VARCHAR(60) NULL, 
	���������� DATE DEFAULT getdate() NULL, 
	�������������� DATE NULL, 
	������� CHAR(20) NOT NULL,
	������������ INT NOT NULL,
	CONSTRAINT FK_���������_��������� FOREIGN KEY (������������) REFERENCES ��������� ON UPDATE CASCADE
);

CREATE TABLE ������������ ( 
	���������������� INT PRIMARY KEY NOT NULL, 
	������������ VARCHAR(60) NOT NULL
);

CREATE TABLE �������� ( 
	������������ INT PRIMARY KEY NOT NULL, 
	���������� VARCHAR(60) NULL,
	���������������� INT NOT NULL,
	CONSTRAINT FK_��������_������������ FOREIGN KEY (����������������) REFERENCES ������������ ON UPDATE CASCADE
);

CREATE TABLE ����������������� ( 
	��������������������� INT PRIMARY KEY NOT NULL, 
	����������������� VARCHAR(60) NOT NULL, 
); 

CREATE TABLE ������������� ( 
	����������������� INT PRIMARY KEY NOT NULL, 
	������������������� VARCHAR(50) NOT NULL, 
	�������������������� VARCHAR(50) NOT NULL, 
	����������� INT NULL CHECK (����������� > 0), 
	������������� INT NULL CHECK (������������� > 0),
	��������������������� INT NOT NULL,
	CONSTRAINT FK_�������������_����������������� FOREIGN KEY (���������������������) REFERENCES ����������������� ON UPDATE CASCADE
);

CREATE TABLE ������������ ( 
	���������������� INT PRIMARY KEY NOT NULL, 
	������������ VARCHAR(60) NOT NULL, 
);

CREATE TABLE ��������� ( 
	������������ INT PRIMARY KEY NOT NULL, 
	���������������� VARCHAR(50) NOT NULL, 
	����������� INT NULL CHECK (����������� > 0), 
	�������� MONEY NULL CHECK (�������� > 0),
	���������������� INT NOT NULL,
	CONSTRAINT FK_���������_������������ FOREIGN KEY (����������������) REFERENCES ������������ ON UPDATE CASCADE
);

CREATE TABLE ���������������� ( 
	������������������� INT NOT NULL, 
	��������� INT NOT NULL, 
	������������ INT NOT NULL, 
	PRIMARY KEY (�������������������, ������������),
	CONSTRAINT FK_����������������_�������� FOREIGN KEY (������������) REFERENCES �������� ON UPDATE CASCADE
);

CREATE TABLE ��������������� ( 
	������������������ INT NOT NULL, 
	��������� INT NOT NULL, 
	������������ INT NOT NULL,
	PRIMARY KEY (������������������, ������������), 
	CONSTRAINT FK_���������������_��������� FOREIGN KEY (������������) REFERENCES ��������� ON UPDATE CASCADE
);

CREATE TABLE ����� ( 
	��������� INT NOT NULL, 
	��������������� DATETIME NOT NULL,
	��������������� INT NULL CHECK (��������������� > 0), 
	�������������������� INT NOT NULL, 
	����������� MONEY NOT NULL,
	����������������� INT NOT NULL CHECK (����������������� > 0),
	����������������� INT NOT NULL, 
	������������� INT NOT NULL, 
	������������������ INT NOT NULL, 
	������������ INT NOT NULL,
	������������������� INT NOT NULL,
	������������ INT NOT NULL,
	PRIMARY KEY (���������, �����������������, �������������), 
	CONSTRAINT FK_�����_������������� FOREIGN KEY (�����������������) REFERENCES ������������� ON UPDATE CASCADE,
	CONSTRAINT FK_�����_��������� FOREIGN KEY (�������������) REFERENCES ��������� ON UPDATE CASCADE,
	CONSTRAINT FK_�����_������������ FOREIGN KEY (�������������������, ������������) REFERENCES ���������������� ON UPDATE CASCADE,
	CONSTRAINT FK_�����_������������ FOREIGN KEY (������������������, ������������) REFERENCES ��������������� ON UPDATE CASCADE,
);

GO

 CREATE UNIQUE INDEX UIX_��������� ON ��������� (���)
 ON Secondary
  CREATE UNIQUE INDEX UIX_�������� ON �������� (����������)
 ON Secondary
  CREATE UNIQUE INDEX UIX_������������� ON ������������� (��������������������)
 ON Secondary
  CREATE UNIQUE INDEX UIX_��������� ON ��������� (����������������)
 ON Secondary
  CREATE INDEX IX_��������� ON ��������� (���, �������) 
 ON Secondary
  CREATE INDEX IX_����� ON ����� (���������) ON Secondary
 GO


INSERT INTO ��������� VALUES (1, '��������')
INSERT INTO ��������� VALUES (2, '��������������')
INSERT INTO ��������� VALUES (3, '����������������������')
INSERT INTO ��������� VALUES (4, '������������������������')
INSERT INTO ��������� VALUES (5, '����������������������')
INSERT INTO ��������� VALUES (6, '����������������')
INSERT INTO ��������� VALUES (7, '���������')
INSERT INTO ��������� VALUES (8, '���������������')
INSERT INTO ��������� VALUES (9, '��������')
INSERT INTO ��������� VALUES (10, '�����������')
INSERT INTO ��������� VALUES (11, '�����')
INSERT INTO ��������� VALUES (12, '���������')
INSERT INTO ��������� VALUES (13, '��������������')
INSERT INTO ��������� VALUES (14, '�������')
INSERT INTO ��������� VALUES (15, '�������')
INSERT INTO ��������� VALUES (16, '��������')
INSERT INTO ��������� VALUES (17, '����������')
INSERT INTO ��������� VALUES (18, '��������')
INSERT INTO ��������� VALUES (19, '�����������������')
INSERT INTO ��������� VALUES (20, '�������������')
INSERT INTO ��������� VALUES (21, '����������������')
INSERT INTO ��������� VALUES (22, '����������������')
INSERT INTO ��������� VALUES (23, '���������')
INSERT INTO ��������� VALUES (24, '������')
GO 

/*���������� �������������*/
INSERT INTO ��������� VALUES (1, '������ �.�.', '1964-01-01', '375290000001', '2012-01-01', '2021-01-01', '������', 1)
INSERT INTO ��������� VALUES (2, '������� �.�.', '1974-01-01', '375290000002', '2013-01-01', '2022-01-01', '�������', 2)
INSERT INTO ��������� VALUES (3, '�������� �.�.', '1990-01-01', '375290000003', '2016-01-01', '2020-01-01', '��������', 3)
INSERT INTO ��������� VALUES (4, '�������� �.�.', '1970-01-01', '375290000004', '2014-01-01', '2019-01-01', '��������', 4)
INSERT INTO ��������� VALUES (5, '������� �.�.', '1976-01-01', '375290000005', '2014-01-01', '2021-01-01', '�������', 5)
INSERT INTO ��������� VALUES (6, '�������� �.�.', '1981-01-01', '375290000006', '2015-01-01', '2022-01-01', '��������', 6)
INSERT INTO ��������� VALUES (7, '������ �.�.', '1963-01-01', '375290000007', '2009-01-01', '2019-01-01', '������', 7)
INSERT INTO ��������� VALUES (8, '������� �.�.', '1982-01-01', '375290000008', '2010-01-01', '2020-01-01', '�������', 8)
INSERT INTO ��������� VALUES (9, '�������� �.�.', '1985-01-01', '375290000009', '2011-01-01', '2022-01-01', '��������', 9)
INSERT INTO ��������� VALUES (10, '��������� �.�.', '1986-01-01', '375290000011', '2008-01-01', '2022-01-01', '���������', 10)
INSERT INTO ��������� VALUES (11, '���������� �.�.', '1986-01-01', '375290000021', '2009-01-01', '2021-01-01', '����������', 10)
INSERT INTO ��������� VALUES (12, '��������� �.�.', '1979-01-01', '375290000012', '2005-01-01', '2020-01-01', '���������', 11)
INSERT INTO ��������� VALUES (13, '������� �.�.', '1962-01-01', '375290000013', '2007-01-01', '2021-01-01', '�������', 11)
INSERT INTO ��������� VALUES (14, '���������� �.�.', '1965-01-01', '375290000014', '2003-01-01', '2020-01-01', '����������', 12)
INSERT INTO ��������� VALUES (15, '���� �.�.', '1994-01-01', '375290000015', '2005-01-01', '2019-01-01', '����', 12)
INSERT INTO ��������� VALUES (16, '������� �.�.', '1978-01-01', '375290000016', '2007-01-01', '2022-01-01', '�������', 13)
INSERT INTO ��������� VALUES (17, '������� �.�.', '1984-01-01', '375290000017', '2012-01-01', '2021-01-01', '�������', 14)
INSERT INTO ��������� VALUES (18, '�������� �.�.', '1996-01-01', '375290000018', '2013-01-01', '2020-01-01', '��������', 14)
INSERT INTO ��������� VALUES (19, '������� �.�.', '1997-01-01', '375290000019', '2009-01-01', '2021-01-01', '�������', 14)
INSERT INTO ��������� VALUES (20, '������ �.�.', '1981-01-01', '375290000020', '2010-01-01', '2022-01-01', '������', 15)
INSERT INTO ��������� VALUES (21, '�������� �.�.', '1982-01-01', '375290000021', '2011-01-01', '2020-01-01', '��������', 15)
INSERT INTO ��������� VALUES (22, '�������� �.�.', '1973-01-01', '375290000022', '2018-01-01', '2021-01-01', '��������', 16)
INSERT INTO ��������� VALUES (23, '������ �.�.', '1966-01-01', '375290000023', '2004-01-01', '2019-01-01', '������', 17)
INSERT INTO ��������� VALUES (24, '��������� �.�.', '1982-01-01', '375290000024', '2003-01-01', '2020-01-01', '���������', 17)
/*������������� ��������*/
INSERT INTO ��������� VALUES (25, '������� �.�.', '1975-01-01', '375290000025', '2002-01-01', '2021-01-01', '�������', 18)
/*������ ��������*/
INSERT INTO ��������� VALUES (26, '������� �.�.', '1979-01-01', '375290000026', '2001-01-01', '2020-01-01', '�������', 19)
/*��������� ��������*/
INSERT INTO ��������� VALUES (27, '���������� �.�.', '1969-01-01', '375290000027', '2010-01-01', '2021-01-01', '����������', 20)
INSERT INTO ��������� VALUES (28, '��������� �.�.', '1968-01-01', '375290000028', '2002-01-01', '2022-01-01', '���������', 20)
INSERT INTO ��������� VALUES (29, '������� �.�.', '1992-01-01', '375290000029', '2005-01-01', '2022-01-01', '�������', 20)
INSERT INTO ��������� VALUES (30, '������� �.�.', '1990-01-01', '375290000030', '2007-01-01', '2019-01-01', '�������', 20)
INSERT INTO ��������� VALUES (31, '��������� �.�.', '1981-01-01', '375290000031', '2007-01-01', '2020-01-01', '���������', 20)
INSERT INTO ��������� VALUES (32, '�������� �.�.', '1980-01-01', '375290000032', '2009-01-01', '2021-01-01', '��������', 20)
/*����������� ��������*/
INSERT INTO ��������� VALUES (33, '�������� �.�.', '1982-01-01', '375290000033', '2005-01-01', '2022-01-01', '��������', 21)
INSERT INTO ��������� VALUES (34, '������ �.�.', '1979-01-01', '375290000034', '2012-01-01', '2022-01-01', '������', 21)
INSERT INTO ��������� VALUES (35, '����������� �.�.', '1993-01-01', '375290000035', '2016-01-01', '2019-01-01', '�����������', 21)
INSERT INTO ��������� VALUES (36, '�������� �.�.', '1993-01-01', '375290000036', '2014-01-01', '2020-01-01', '��������', 21)
INSERT INTO ��������� VALUES (37, '���������� �.�.', '1983-01-01', '375290000037', '2013-01-01', '2021-01-01', '����������', 21)
INSERT INTO ��������� VALUES (38, '������� �.�.', '1985-01-01', '375290000038', '2010-01-01', '2022-01-01', '�������', 21)
/*������������� ��������*/
INSERT INTO ��������� VALUES (39, '����� �.�.', '1970-01-01', '375290000039', '2009-01-01', '2019-01-01', '�����', 22)
INSERT INTO ��������� VALUES (40, '�������� �.�.', '1980-01-01', '375290000040', '2008-01-01', '2019-01-01', '��������', 22)
INSERT INTO ��������� VALUES (41, '������ �.�.', '1983-01-01', '375290000041', '2005-01-01', '2020-01-01', '������', 22)
INSERT INTO ��������� VALUES (42, '������ �.�.', '1964-01-01', '375290000042', '2007-01-01', '2022-01-01', '������', 22)
INSERT INTO ��������� VALUES (43, '���������� �.�.', '1974-01-01', '375290000043', '2003-01-01', '2022-01-01', '����������', 22)
INSERT INTO ��������� VALUES (44, '�������� �.�.', '1984-01-01', '375290000044', '2002-01-01', '2021-01-01', '��������', 22)
/*����������*/
INSERT INTO ��������� VALUES (45, '��������� �.�.', '1967-01-01', '375290000045', '2001-01-01', '2022-01-01', '���������', 23)
INSERT INTO ��������� VALUES (46, '��������� �.�.', '1977-01-01', '375290000046', '2000-01-01', '2021-01-01', '���������', 23)
INSERT INTO ��������� VALUES (47, '������ �.�.', '1987-01-01', '375290000047', '2012-01-01', '2020-01-01', '������', 23)
INSERT INTO ��������� VALUES (48, '��������� �.�.', '1973-01-01', '375290000048', '2016-01-01', '2019-01-01', '���������', 23)
INSERT INTO ��������� VALUES (49, '������ �.�.', '1973-01-01', '375290000049', '2015-01-01', '2022-01-01', '������', 23)
INSERT INTO ��������� VALUES (50, '���������� �.�.', '1985-01-01', '375290000050', '2013-01-01', '2022-01-01', '����������', 23)
/*�������*/
INSERT INTO ��������� VALUES (51, '������� �.�.', '1983-01-01', '375290000051', '2005-01-01', '2021-01-01', '�������', 24)
INSERT INTO ��������� VALUES (52, '�������� �.�.', '1988-01-01', '375290000052', '2007-01-01', '2022-01-01', '��������', 24)
GO 
/*������������*/
INSERT INTO ������������  VALUES (1, '��������')
INSERT INTO ������������  VALUES (2, '����������')
INSERT INTO ������������  VALUES (3, '������')
GO 
/*��������*/
INSERT INTO ��������  VALUES (1, '�����-��������', 1)
INSERT INTO ��������  VALUES (2, '��������-��������', 1)
INSERT INTO ��������  VALUES (3, '��������-��������', 1)
INSERT INTO ��������  VALUES (4, '�����-����������', 2)
INSERT INTO ��������  VALUES (5, '��������-����������', 2)
INSERT INTO ��������  VALUES (6, '��������-����������', 2)
INSERT INTO ��������  VALUES (7, '�����-������', 3)
INSERT INTO ��������  VALUES (8, '��������-������', 3)
INSERT INTO ��������  VALUES (9, '��������-������', 3)
INSERT INTO ��������  VALUES (10, '��������-������', 3)
GO 
/*�����������������*/
INSERT INTO �����������������  VALUES (1, '��������')
INSERT INTO �����������������  VALUES (2, '����������')
INSERT INTO �����������������  VALUES (3, '��������������')
INSERT INTO �����������������  VALUES (4, '����������������')
INSERT INTO �����������������  VALUES (5, '�����������')
INSERT INTO �����������������  VALUES (6, '�������������')
GO 
/*�������������*/
INSERT INTO �������������  VALUES (1, '������', 'AE9601-6', 4, 6, 1)
INSERT INTO �������������  VALUES (2, '������', 'AE9647-6', 16, 10, 2)
INSERT INTO �������������  VALUES (3, '������', 'AE9648-6', 16, 10, 2)
INSERT INTO �������������  VALUES (4, '���-103.5', 'AE9701-6', 80, 36, 3)
INSERT INTO �������������  VALUES (5, '���-103.5', 'AE9702-6', 80, 36, 3)
INSERT INTO �������������  VALUES (6, '���-103.5', 'AE9703-6', 80, 36, 3)
INSERT INTO �������������  VALUES (7, '���-103.5', 'AE9704-6', 80, 36, 3)
INSERT INTO �������������  VALUES (8, '���-103.5', 'AE9705-6', 80, 36, 3)
INSERT INTO �������������  VALUES (9, '���-103.6', 'AE9801-6', 120, 41, 4)
INSERT INTO �������������  VALUES (10, '�������', 'AE9301-6', 27, 21, 5)
INSERT INTO �������������  VALUES (11, '�������', 'AE9302-6', 27, 21, 5)
INSERT INTO �������������  VALUES (12, '���-241', 'AE9401-6', 25, 23, 5)
INSERT INTO �������������  VALUES (13, '���-241', 'AE9402-6', 25, 23, 5)
INSERT INTO �������������  VALUES (14, '���-256', 'AE9501-6', 29, 25, 5)
INSERT INTO �������������  VALUES (15, '���-256', 'AE9502-6', 29, 25, 5)
INSERT INTO �������������  VALUES (16, '�����', 'AE9001-6', 48, 46, 6)
INSERT INTO �������������  VALUES (17, '�����', 'AE9002-6', 48, 46, 6)
INSERT INTO �������������  VALUES (18, '���-246', 'AE9101-6', 49, 48, 6)
INSERT INTO �������������  VALUES (19, '���-246', 'AE9102-6', 49, 48, 6)
INSERT INTO �������������  VALUES (20, '���-258', 'AE9201-6', 51, 50, 6)
INSERT INTO �������������  VALUES (21, '���-258', 'AE9202-6', 51, 50, 6)
GO 
/*������������*/
INSERT INTO ������������  VALUES (1, '���������')
INSERT INTO ������������  VALUES (2, '�����������')
INSERT INTO ������������  VALUES (3, '�������������')
INSERT INTO ������������  VALUES (4, '��������')
GO 
/*���������*/
INSERT INTO ���������  VALUES (1, '������� 3', 108, 10, 1)
INSERT INTO ���������  VALUES (2, '������� 4', 118, 10, 1)
INSERT INTO ���������  VALUES (3, '������� 6', 128, 10, 1)
INSERT INTO ���������  VALUES (4, '������� 8', 138, 10, 1)
INSERT INTO ���������  VALUES (5, '������� 9', 148, 10, 1)
INSERT INTO ���������  VALUES (6, '������� ��������', 88, 10, 1)

INSERT INTO ���������  VALUES (7, '��������', 68, 10, 2)
INSERT INTO ���������  VALUES (8, '��������', 72, 10, 2)
INSERT INTO ���������  VALUES (9, '����������', 74, 10, 2)
INSERT INTO ���������  VALUES (10, '����������', 110, 10, 2)
INSERT INTO ���������  VALUES (11, '�������', 115, 10, 2)
INSERT INTO ���������  VALUES (12, '���������', 145, 10, 2)

INSERT INTO ���������  VALUES (13, '�������', 250, 10, 3)
INSERT INTO ���������  VALUES (14, '�����', 450, 10, 3)
INSERT INTO ���������  VALUES (15, '������', 416, 10, 3)

INSERT INTO ���������  VALUES (16, '��������������', 40, 10, 4)
INSERT INTO ���������  VALUES (17, '���������������', 250, 10, 4)
INSERT INTO ���������  VALUES (18, '�����������������', 600, 10, 4)

INSERT INTO ���������  VALUES (19, '��������������', 40, 10, 4)

GO 
/*����������������*/
INSERT INTO ����������������  VALUES (1, 2, 3)
INSERT INTO ����������������  VALUES (2, 2, 3)
INSERT INTO ����������������  VALUES (3, 3, 3)
INSERT INTO ����������������  VALUES (4, 4, 3)
INSERT INTO ����������������  VALUES (5, 5, 3)
INSERT INTO ����������������  VALUES (6, 6, 3)
INSERT INTO ����������������  VALUES (7, 7, 3)
INSERT INTO ����������������  VALUES (8, 8, 3)
INSERT INTO ����������������  VALUES (9, 9, 3)
INSERT INTO ����������������  VALUES (10, 10, 3)
INSERT INTO ����������������  VALUES (11, 11, 3)
INSERT INTO ����������������  VALUES (12, 12, 3)
INSERT INTO ����������������  VALUES (13, 13, 3)
INSERT INTO ����������������  VALUES (14, 14, 3)
INSERT INTO ����������������  VALUES (15, 15, 3)
INSERT INTO ����������������  VALUES (16, 16, 3)
INSERT INTO ����������������  VALUES (17, 17, 3)
INSERT INTO ����������������  VALUES (18, 18, 3)
INSERT INTO ����������������  VALUES (19, 19, 3)
GO 
/*���������������*/
INSERT INTO ���������������  VALUES (1, 1, 1)
INSERT INTO ���������������  VALUES (2, 2, 2)
INSERT INTO ���������������  VALUES (3, 3, 3)
INSERT INTO ���������������  VALUES (4, 4, 4)
INSERT INTO ���������������  VALUES (5, 5, 5)
INSERT INTO ���������������  VALUES (6, 6, 6)
INSERT INTO ���������������  VALUES (7, 7, 7)
INSERT INTO ���������������  VALUES (8, 8, 8)
INSERT INTO ���������������  VALUES (9, 9, 9)
INSERT INTO ���������������  VALUES (10, 10, 10)
INSERT INTO ���������������  VALUES (11, 11, 11)
INSERT INTO ���������������  VALUES (12, 12, 12)
INSERT INTO ���������������  VALUES (13, 13, 13)
INSERT INTO ���������������  VALUES (14, 14, 14)
INSERT INTO ���������������  VALUES (15, 15, 15)
INSERT INTO ���������������  VALUES (16, 16, 16)
INSERT INTO ���������������  VALUES (17, 17, 17)
INSERT INTO ���������������  VALUES (18, 18, 18)
INSERT INTO ���������������  VALUES (19, 19, 19)
GO 
/*�����*/
INSERT INTO �����  VALUES (1, '2018-04-15T06:00:00', 6, 220, 1080, 38, 4, 27, 1, 1, 3, 3)
INSERT INTO �����  VALUES (2, '2018-04-15T06:10:00', 7, 230, 1180, 39, 5, 28, 2, 2, 3, 3)
INSERT INTO �����  VALUES (3, '2018-04-15T06:20:00', 8, 240, 1280, 40, 6, 29, 3, 3, 3, 3)
INSERT INTO �����  VALUES (4, '2018-04-15T06:30:00', 9, 250, 1380, 41, 7, 30, 4, 4, 3, 3)
INSERT INTO �����  VALUES (5, '2018-04-15T06:30:00', 10, 260, 1480, 42, 8, 31, 5, 5, 3, 3)
INSERT INTO �����  VALUES (6, '2018-04-15T06:40:00', 8, 260, 880, 40, 9, 32, 6, 6, 3, 3)

INSERT INTO �����  VALUES (7, '2018-04-15T06:00:00', 6, 100, 680, 33, 10, 33, 7, 7, 3, 3)
INSERT INTO �����  VALUES (8, '2018-04-15T06:10:00', 7, 110, 720, 34, 11, 34, 8, 8, 3, 3)
INSERT INTO �����  VALUES (9, '2018-04-15T06:20:00', 8, 110, 740, 35, 12, 35, 9, 9, 3, 3)
INSERT INTO �����  VALUES (10, '2018-04-15T06:30:00', 9, 110, 1100, 36, 13, 36, 10, 10, 3, 3)
INSERT INTO �����  VALUES (11, '2018-04-15T06:30:00', 9, 100, 1150, 37, 14, 37, 11, 11, 3, 3)
INSERT INTO �����  VALUES (12, '2018-04-15T06:40:00', 9, 110, 1450, 38, 15, 38, 12, 12, 3, 3)

INSERT INTO �����  VALUES (13, '2018-04-15T06:00:00', 9, 80, 2500, 99, 16, 39, 13, 13, 3, 3)
INSERT INTO �����  VALUES (14, '2018-04-15T06:10:00', 12, 85, 4500, 102, 17, 40, 14, 14, 3, 3)
INSERT INTO �����  VALUES (15, '2018-04-15T06:20:00', 10, 80, 416, 105, 18, 41, 15, 15, 3, 3)

INSERT INTO �����  VALUES (16, '2018-04-15T06:30:00', 9, 20, 400, 36, 19, 42, 16, 16, 3, 3)
INSERT INTO �����  VALUES (17, '2018-04-15T06:30:00', 12, 85, 2500, 100, 20, 43, 17, 17, 3, 3)
INSERT INTO �����  VALUES (18, '2018-04-15T06:40:00', 10, 85, 6000, 200, 21, 44, 18, 18, 3, 3)
INSERT INTO �����  VALUES (19, '2018-04-15T06:40:00', 10, 1, 400, 6, 1, 26, 19, 19, 3, 3)

GO 

SELECT ������������, COUNT(*) AS ���������������������
FROM ���������
WHERE YEAR(GETDATE()) - YEAR(������������ ) > 40
GROUP BY ������������
ORDER BY ������������ ASC

SELECT ������������, COUNT(*) AS ���������������������
FROM ���������
WHERE YEAR(GETDATE()) - YEAR(������������ ) > 40 AND ������������ BETWEEN 19 AND 22
GROUP BY ������������
ORDER BY ������������ ASC

SELECT �������������������, Count(�������������) 
FROM �������������
where ������������� > 26
GROUP BY �������������������

SELECT YEAR(GETDATE()) - YEAR(������������) AS ����������������, COUNT(�������������) AS ���������������
FROM ���������
GROUP BY ������������ 
ORDER BY ���������������� DESC


DECLARE @minPas INT
SET @minPas = (SELECT MIN(��������������������)
                FROM �����);
SELECT ���, �������������������, ��������������������, ����������������
FROM ����� INNER JOIN ������������� ON �����.�����������������=�������������.����������������� 
INNER JOIN ��������� ON �����.�������������=���������.�������������
INNER JOIN ��������� ON �����.������������=���������.������������
where �������������������� = @minPas

SELECT �������������������, ��������������������, ����������������
FROM ����� INNER JOIN ������������� ON �����.�����������������=�������������.����������������� 
INNER JOIN ��������� ON �����.�������������=���������.�������������
INNER JOIN ��������� ON �����.������������=���������.������������
WHERE ������������������� LIKE '���%'


SELECT COUNT(�������������������) AS �����������
FROM ����� INNER JOIN ������������� ON �����.�����������������=�������������.����������������� 
INNER JOIN ��������� ON �����.�������������=���������.�������������
INNER JOIN ��������� ON �����.������������=���������.������������
WHERE ������������������� LIKE '���%' OR �������������������='�����'

CREATE PROCEDURE CountOfRowsInTable (@tableName VARCHAR(20), @numbderOfRows INT OUTPUT) AS
	BEGIN
		DECLARE @sqlCode nvarchar(50)
		DECLARE @result nvarchar(50)
		SET @sqlCode = N'SELECT @temp = COUNT(*) FROM ' + @tableName
		SET @result = N'@temp int OUTPUT'
		EXEC sp_executesql @sqlCode, @result, @temp = @numbderOfRows OUTPUT
	END;
GO

DECLARE @Name VARCHAR(20), @Number INT
SET @Name ='���������'
EXEC CountOfRowsInTable @Name, @Number OUTPUT
SELECT @Number AS ����������
GO

DECLARE @Name VARCHAR(20), @Number INT
SET @Name ='�����������������'
EXEC CountOfRowsInTable @Name, @Number OUTPUT
SELECT @Number AS ����������
GO

DROP PROCEDURE CountOfRowsInTable

CREATE PROCEDURE CountValues (@c_name nvarchar(30), @r_min int OUTPUT, @r_avg int OUTPUT, @r_max int OUTPUT, @r_sum int OUTPUT) AS
	BEGIN
	DECLARE @sqlCode nvarchar(50),
	@result nvarchar(50)
	SET @sqlCode = N'SELECT @t_min = MIN(' +@c_name + ') FROM ���������'
	SET @result = N'@t_min int OUTPUT'
	EXEC sp_executesql @sqlCode, @result, @t_min = @r_min OUTPUT
	SET @sqlCode = N'SELECT @t_avg = MAX(' +@c_name + ') FROM ���������'
	SET @result = N'@t_avg int OUTPUT'
	EXEC sp_executesql @sqlCode, @result, @t_avg = @r_avg OUTPUT
	SET @sqlCode = N'SELECT @t_max = AVG(' +@c_name + ') FROM ���������'
	SET @result = N'@t_max int OUTPUT'
	EXEC sp_executesql @sqlCode, @result, @t_max = @r_max OUTPUT
	SET @sqlCode = N'SELECT @t_sum = SUM(' +@c_name + ') FROM ���������'
	SET @result = N'@t_sum int OUTPUT'
	EXEC sp_executesql @sqlCode, @result, @t_sum = @r_sum OUTPUT
	END
GO

DECLARE @Name VARCHAR(20), @Min INT, @Max INT, @Average INT , @Sum INT
SET @Name ='�����������'
EXEC CountValues @Name, @Min OUTPUT, @Max OUTPUT, @Average OUTPUT, @Sum OUTPUT
SELECT @Min AS �����������������
SELECT @Max AS ������������������
SELECT @Average AS �������������
SELECT @Sum AS �����������
GO

DROP PROCEDURE CountValues