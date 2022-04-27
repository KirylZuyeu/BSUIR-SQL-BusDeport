CREATE DATABASE BusDeport 
ON PRIMARY 
(NAME = BusDeport_Data, 
FILENAME = 'D:\1_BGUIR\2_Семестр\2_ОПБД\ПЗ\Кирилл\BusDeport_Data.mdf', 
SIZE = 3MB, 
MAXSIZE = 50MB, 
FILEGROWTH = 2MB), 
FILEGROUP Secondary 
(NAME = BusDeport2_Data, 
FILENAME = 'D:\1_BGUIR\2_Семестр\2_ОПБД\ПЗ\Кирилл\BusDeport_Data2.ndf', 
SIZE = 2MB,
MAXSIZE = 70MB, 
FILEGROWTH = 20%), 
(NAME = BusDeport3_Data, 
FILENAME = 'D:\1_BGUIR\2_Семестр\2_ОПБД\ПЗ\Кирилл\BusDeport_Data3.ndf', 
SIZE = 2MB, 
FILEGROWTH = 5MB) 
LOG ON 
(NAME = BusDeport_Log, 
FILENAME = 'D:\1_BGUIR\2_Семестр\2_ОПБД\ПЗ\Кирилл\BusDeport_Log.ldf', 
SIZE = 1MB, 
MAXSIZE = 10MB, 
FILEGROWTH = 15%), 
(NAME = BusDeport2_Log, 
FILENAME = 'D:\1_BGUIR\2_Семестр\2_ОПБД\ПЗ\Кирилл\BusDeport_Log2.ldf', 
SIZE = 512KB, 
MAXSIZE = 5MB, 
FILEGROWTH = 10%)
GO

  USE BusDeport
 GO 

  CREATE RULE Logical_Rule AS @value IN ('Нет', 'Да') 
 GO

 CREATE DEFAULT Logical_Default AS 'Нет' 
 GO 

 EXEC sp_addtype Logical, 'char(3)', 'NOT NULL'
 GO 

 EXEC sp_bindrule 'Logical_Rule', 'Logical'
 GO 

 EXEC sp_bindefault 'Logical_Default', 'Logical'
 GO 

CREATE TABLE Должность ( 
	КодДолжности INT PRIMARY KEY NOT NULL, 
	Должности VARCHAR(60) NOT NULL
);

CREATE TABLE Сотрудник ( 
	КодСотрудника INT PRIMARY KEY NOT NULL,
	ФИО VARCHAR(60) NOT NULL, 
	ДатаРождения DATE NULL, 
	Телефон VARCHAR(60) NULL, 
	ДатаПриема DATE DEFAULT getdate() NULL, 
	ДатаУвольнения DATE NULL, 
	Подпись CHAR(20) NOT NULL,
	КодДолжности INT NOT NULL,
	CONSTRAINT FK_Сотрудник_Должность FOREIGN KEY (КодДолжности) REFERENCES Должность ON UPDATE CASCADE
);

CREATE TABLE ТипПассажира ( 
	КодТипаПассажира INT PRIMARY KEY NOT NULL, 
	ВидПассажира VARCHAR(60) NOT NULL
);

CREATE TABLE Пассажир ( 
	КодПассажира INT PRIMARY KEY NOT NULL, 
	Примечание VARCHAR(60) NULL,
	КодТипаПассажира INT NOT NULL,
	CONSTRAINT FK_Пассажир_ТипПассажира FOREIGN KEY (КодТипаПассажира) REFERENCES ТипПассажира ON UPDATE CASCADE
);

CREATE TABLE ТипАвтотранспорта ( 
	КодТипаАвтотранспорта INT PRIMARY KEY NOT NULL, 
	ВидАвтотранспорта VARCHAR(60) NOT NULL, 
); 

CREATE TABLE Автотранспорт ( 
	КодАвтотранспорта INT PRIMARY KEY NOT NULL, 
	МаркаАвтотранспорта VARCHAR(50) NOT NULL, 
	РегистрационныйНомер VARCHAR(50) NOT NULL, 
	Вместимость INT NULL CHECK (Вместимость > 0), 
	РасходТоплива INT NULL CHECK (РасходТоплива > 0),
	КодТипаАвтотранспорта INT NOT NULL,
	CONSTRAINT FK_Автотранспорт_ТипАвтотранспорта FOREIGN KEY (КодТипаАвтотранспорта) REFERENCES ТипАвтотранспорта ON UPDATE CASCADE
);

CREATE TABLE ТипПеревозки ( 
	КодТипаПеревозки INT PRIMARY KEY NOT NULL, 
	ВидПеревозки VARCHAR(60) NOT NULL, 
);

CREATE TABLE Перевозка ( 
	КодПеревозки INT PRIMARY KEY NOT NULL, 
	МаршрутПеревозки VARCHAR(50) NOT NULL, 
	Киллометраж INT NULL CHECK (Киллометраж > 0), 
	ЦенаЗаКМ MONEY NULL CHECK (ЦенаЗаКМ > 0),
	КодТипаПеревозки INT NOT NULL,
	CONSTRAINT FK_Перевозка_ТипПеревозки FOREIGN KEY (КодТипаПеревозки) REFERENCES ТипПеревозки ON UPDATE CASCADE
);

CREATE TABLE ПассажирыВЗаказе ( 
	КодПассажираВЗаказе INT NOT NULL, 
	КодЗаказа INT NOT NULL, 
	КодПассажира INT NOT NULL, 
	PRIMARY KEY (КодПассажираВЗаказе, КодПассажира),
	CONSTRAINT FK_ПассажирыВЗаказе_Пассажир FOREIGN KEY (КодПассажира) REFERENCES Пассажир ON UPDATE CASCADE
);

CREATE TABLE МаршрутыВЗаказе ( 
	КодМаршрутаВЗаказе INT NOT NULL, 
	КодЗаказа INT NOT NULL, 
	КодПеревозки INT NOT NULL,
	PRIMARY KEY (КодМаршрутаВЗаказе, КодПеревозки), 
	CONSTRAINT FK_МаршрутыВЗаказе_Перевозка FOREIGN KEY (КодПеревозки) REFERENCES Перевозка ON UPDATE CASCADE
);

CREATE TABLE Заказ ( 
	КодЗаказа INT NOT NULL, 
	ДатаОтправления DATETIME NOT NULL,
	КоличествоЧасов INT NULL CHECK (КоличествоЧасов > 0), 
	КоличествоПассажиров INT NOT NULL, 
	СуммаЗаказа MONEY NOT NULL,
	КоличествоТоплива INT NOT NULL CHECK (КоличествоТоплива > 0),
	КодАвтотранспорта INT NOT NULL, 
	КодСотрудника INT NOT NULL, 
	КодМаршрутаВЗаказе INT NOT NULL, 
	КодПеревозки INT NOT NULL,
	КодПассажираВЗаказе INT NOT NULL,
	КодПассажира INT NOT NULL,
	PRIMARY KEY (КодЗаказа, КодАвтотранспорта, КодСотрудника), 
	CONSTRAINT FK_Заказ_Автотранспорт FOREIGN KEY (КодАвтотранспорта) REFERENCES Автотранспорт ON UPDATE CASCADE,
	CONSTRAINT FK_Заказ_Сотрудник FOREIGN KEY (КодСотрудника) REFERENCES Сотрудник ON UPDATE CASCADE,
	CONSTRAINT FK_Заказ_КодПассажира FOREIGN KEY (КодПассажираВЗаказе, КодПассажира) REFERENCES ПассажирыВЗаказе ON UPDATE CASCADE,
	CONSTRAINT FK_Заказ_КодПеревозки FOREIGN KEY (КодМаршрутаВЗаказе, КодПеревозки) REFERENCES МаршрутыВЗаказе ON UPDATE CASCADE,
);

GO

 CREATE UNIQUE INDEX UIX_Сотрудник ON Сотрудник (ФИО)
 ON Secondary
  CREATE UNIQUE INDEX UIX_Пассажир ON Пассажир (Примечание)
 ON Secondary
  CREATE UNIQUE INDEX UIX_Автотранспорт ON Автотранспорт (РегистрационныйНомер)
 ON Secondary
  CREATE UNIQUE INDEX UIX_Перевозка ON Перевозка (МаршрутПеревозки)
 ON Secondary
  CREATE INDEX IX_Сотрудник ON Сотрудник (ФИО, Подпись) 
 ON Secondary
  CREATE INDEX IX_Заказ ON Заказ (КодЗаказа) ON Secondary
 GO


INSERT INTO Должность VALUES (1, 'Директор')
INSERT INTO Должность VALUES (2, 'ГлавныйИнженер')
INSERT INTO Должность VALUES (3, 'НачальникБезопастности')
INSERT INTO Должность VALUES (4, 'НачальникОтделаПеревозок')
INSERT INTO Должность VALUES (5, 'ИнженерОтделаПеревозок')
INSERT INTO Должность VALUES (6, 'ГлавныйЭкономист')
INSERT INTO Должность VALUES (7, 'Экономист')
INSERT INTO Должность VALUES (8, 'ГлавныйБугалтер')
INSERT INTO Должность VALUES (9, 'Бугалтер')
INSERT INTO Должность VALUES (10, 'ОператорЭВМ')
INSERT INTO Должность VALUES (11, 'Медик')
INSERT INTO Должность VALUES (12, 'Диспетчер')
INSERT INTO Должность VALUES (13, 'ГлавныйМеханик')
INSERT INTO Должность VALUES (14, 'Механик')
INSERT INTO Должность VALUES (15, 'Слесарь')
INSERT INTO Должность VALUES (16, 'Электрик')
INSERT INTO Должность VALUES (17, 'Заправщица')
INSERT INTO Должность VALUES (18, 'Уборщица')
INSERT INTO Должность VALUES (19, 'ВодительДиректора')
INSERT INTO Должность VALUES (20, 'ВодительГород')
INSERT INTO Должность VALUES (21, 'ВодительПригород')
INSERT INTO Должность VALUES (22, 'ВодительМежгород')
INSERT INTO Должность VALUES (23, 'Кандуктор')
INSERT INTO Должность VALUES (24, 'Кассир')
GO 

/*Сотрудники администрации*/
INSERT INTO Сотрудник VALUES (1, 'Гердий А.Н.', '1964-01-01', '375290000001', '2012-01-01', '2021-01-01', 'Гердий', 1)
INSERT INTO Сотрудник VALUES (2, 'Терехов Н.Н.', '1974-01-01', '375290000002', '2013-01-01', '2022-01-01', 'Терехов', 2)
INSERT INTO Сотрудник VALUES (3, 'Белоусов Е.Н.', '1990-01-01', '375290000003', '2016-01-01', '2020-01-01', 'Белоусов', 3)
INSERT INTO Сотрудник VALUES (4, 'Подчалин Н.Н.', '1970-01-01', '375290000004', '2014-01-01', '2019-01-01', 'Подчалин', 4)
INSERT INTO Сотрудник VALUES (5, 'Козлова О.А.', '1976-01-01', '375290000005', '2014-01-01', '2021-01-01', 'Козлова', 5)
INSERT INTO Сотрудник VALUES (6, 'Саранчов Д.А.', '1981-01-01', '375290000006', '2015-01-01', '2022-01-01', 'Саранчов', 6)
INSERT INTO Сотрудник VALUES (7, 'Милова Т.В.', '1963-01-01', '375290000007', '2009-01-01', '2019-01-01', 'Милова', 7)
INSERT INTO Сотрудник VALUES (8, 'Ляшкина Э.Н.', '1982-01-01', '375290000008', '2010-01-01', '2020-01-01', 'Ляшкина', 8)
INSERT INTO Сотрудник VALUES (9, 'Смирнова О.В.', '1985-01-01', '375290000009', '2011-01-01', '2022-01-01', 'Смирнова', 9)
INSERT INTO Сотрудник VALUES (10, 'Устиненко О.О.', '1986-01-01', '375290000011', '2008-01-01', '2022-01-01', 'Устиненко', 10)
INSERT INTO Сотрудник VALUES (11, 'Петроченко А.А.', '1986-01-01', '375290000021', '2009-01-01', '2021-01-01', 'Петроченко', 10)
INSERT INTO Сотрудник VALUES (12, 'Тимошенко Т.В.', '1979-01-01', '375290000012', '2005-01-01', '2020-01-01', 'Тимошенко', 11)
INSERT INTO Сотрудник VALUES (13, 'Зайцева Н.А.', '1962-01-01', '375290000013', '2007-01-01', '2021-01-01', 'Зайцева', 11)
INSERT INTO Сотрудник VALUES (14, 'Семченкова Н.И.', '1965-01-01', '375290000014', '2003-01-01', '2020-01-01', 'Семченкова', 12)
INSERT INTO Сотрудник VALUES (15, 'Зуев К.А.', '1994-01-01', '375290000015', '2005-01-01', '2019-01-01', 'Зуев', 12)
INSERT INTO Сотрудник VALUES (16, 'Каралев М.Н.', '1978-01-01', '375290000016', '2007-01-01', '2022-01-01', 'Каралев', 13)
INSERT INTO Сотрудник VALUES (17, 'Тутькин А.Н.', '1984-01-01', '375290000017', '2012-01-01', '2021-01-01', 'Тутькин', 14)
INSERT INTO Сотрудник VALUES (18, 'Бомбизов Р.О.', '1996-01-01', '375290000018', '2013-01-01', '2020-01-01', 'Бомбизов', 14)
INSERT INTO Сотрудник VALUES (19, 'Маголин Е.А.', '1997-01-01', '375290000019', '2009-01-01', '2021-01-01', 'Маголин', 14)
INSERT INTO Сотрудник VALUES (20, 'Власов П.П.', '1981-01-01', '375290000020', '2010-01-01', '2022-01-01', 'Власов', 15)
INSERT INTO Сотрудник VALUES (21, 'Степанов В.В.', '1982-01-01', '375290000021', '2011-01-01', '2020-01-01', 'Степанов', 15)
INSERT INTO Сотрудник VALUES (22, 'Егоренко Д.Д.', '1973-01-01', '375290000022', '2018-01-01', '2021-01-01', 'Егоренко', 16)
INSERT INTO Сотрудник VALUES (23, 'Титова О.О.', '1966-01-01', '375290000023', '2004-01-01', '2019-01-01', 'Титова', 17)
INSERT INTO Сотрудник VALUES (24, 'Балтунова А.А.', '1982-01-01', '375290000024', '2003-01-01', '2020-01-01', 'Балтунова', 17)
/*Обслуживающий персонал*/
INSERT INTO Сотрудник VALUES (25, 'Рябцева В.В.', '1975-01-01', '375290000025', '2002-01-01', '2021-01-01', 'Рябцева', 18)
/*Личный водитель*/
INSERT INTO Сотрудник VALUES (26, 'Королев А.А.', '1979-01-01', '375290000026', '2001-01-01', '2020-01-01', 'Королев', 19)
/*Городские водители*/
INSERT INTO Сотрудник VALUES (27, 'Печковский Г.Н.', '1969-01-01', '375290000027', '2010-01-01', '2021-01-01', 'Печковский', 20)
INSERT INTO Сотрудник VALUES (28, 'Борисечив О.О.', '1968-01-01', '375290000028', '2002-01-01', '2022-01-01', 'Борисечив', 20)
INSERT INTO Сотрудник VALUES (29, 'Голиков М.А.', '1992-01-01', '375290000029', '2005-01-01', '2022-01-01', 'Голиков', 20)
INSERT INTO Сотрудник VALUES (30, 'Рубанов М.Н.', '1990-01-01', '375290000030', '2007-01-01', '2019-01-01', 'Рубанов', 20)
INSERT INTO Сотрудник VALUES (31, 'Даниленко А.Л.', '1981-01-01', '375290000031', '2007-01-01', '2020-01-01', 'Даниленко', 20)
INSERT INTO Сотрудник VALUES (32, 'Табачков А.Л.', '1980-01-01', '375290000032', '2009-01-01', '2021-01-01', 'Табачков', 20)
/*Пригородные водители*/
INSERT INTO Сотрудник VALUES (33, 'Лятецкий Н.Н.', '1982-01-01', '375290000033', '2005-01-01', '2022-01-01', 'Лятецкий', 21)
INSERT INTO Сотрудник VALUES (34, 'Павлов Н.Н.', '1979-01-01', '375290000034', '2012-01-01', '2022-01-01', 'Павлов', 21)
INSERT INTO Сотрудник VALUES (35, 'Осмоловский М.Н.', '1993-01-01', '375290000035', '2016-01-01', '2019-01-01', 'Осмоловский', 21)
INSERT INTO Сотрудник VALUES (36, 'Попенков В.Н.', '1993-01-01', '375290000036', '2014-01-01', '2020-01-01', 'Попенков', 21)
INSERT INTO Сотрудник VALUES (37, 'Кузьменков О.А.', '1983-01-01', '375290000037', '2013-01-01', '2021-01-01', 'Кузьменков', 21)
INSERT INTO Сотрудник VALUES (38, 'Кляусов В.А.', '1985-01-01', '375290000038', '2010-01-01', '2022-01-01', 'Кляусов', 21)
/*Междугородние водители*/
INSERT INTO Сотрудник VALUES (39, 'Бусов Б.Т.', '1970-01-01', '375290000039', '2009-01-01', '2019-01-01', 'Бусов', 22)
INSERT INTO Сотрудник VALUES (40, 'Балдесов А.А.', '1980-01-01', '375290000040', '2008-01-01', '2019-01-01', 'Балдесов', 22)
INSERT INTO Сотрудник VALUES (41, 'Волков В.Н.', '1983-01-01', '375290000041', '2005-01-01', '2020-01-01', 'Волков', 22)
INSERT INTO Сотрудник VALUES (42, 'Шевцов А.Н.', '1964-01-01', '375290000042', '2007-01-01', '2022-01-01', 'Шевцов', 22)
INSERT INTO Сотрудник VALUES (43, 'Лукянчиков А.Н.', '1974-01-01', '375290000043', '2003-01-01', '2022-01-01', 'Лукянчиков', 22)
INSERT INTO Сотрудник VALUES (44, 'Кузнецов В.В.', '1984-01-01', '375290000044', '2002-01-01', '2021-01-01', 'Кузнецов', 22)
/*Кондуктора*/
INSERT INTO Сотрудник VALUES (45, 'Борисевич Н.Н.', '1967-01-01', '375290000045', '2001-01-01', '2022-01-01', 'Борисевич', 23)
INSERT INTO Сотрудник VALUES (46, 'Макаревич Н.Н.', '1977-01-01', '375290000046', '2000-01-01', '2021-01-01', 'Макаревич', 23)
INSERT INTO Сотрудник VALUES (47, 'Кузьма Н.Н.', '1987-01-01', '375290000047', '2012-01-01', '2020-01-01', 'Кузьма', 23)
INSERT INTO Сотрудник VALUES (48, 'Викторова Н.Н.', '1973-01-01', '375290000048', '2016-01-01', '2019-01-01', 'Викторова', 23)
INSERT INTO Сотрудник VALUES (49, 'Ежкина Н.Н.', '1973-01-01', '375290000049', '2015-01-01', '2022-01-01', 'Ежкина', 23)
INSERT INTO Сотрудник VALUES (50, 'Картошкина Н.Н.', '1985-01-01', '375290000050', '2013-01-01', '2022-01-01', 'Картошкина', 23)
/*Кассиры*/
INSERT INTO Сотрудник VALUES (51, 'Меншова Н.Н.', '1983-01-01', '375290000051', '2005-01-01', '2021-01-01', 'Меншова', 24)
INSERT INTO Сотрудник VALUES (52, 'Зузькина Н.Н.', '1988-01-01', '375290000052', '2007-01-01', '2022-01-01', 'Зузькина', 24)
GO 
/*ТипПассажира*/
INSERT INTO ТипПассажира  VALUES (1, 'Льготный')
INSERT INTO ТипПассажира  VALUES (2, 'Половинный')
INSERT INTO ТипПассажира  VALUES (3, 'Полный')
GO 
/*Пассажир*/
INSERT INTO Пассажир  VALUES (1, 'Город-Льготный', 1)
INSERT INTO Пассажир  VALUES (2, 'Пригород-Льготный', 1)
INSERT INTO Пассажир  VALUES (3, 'Межгород-Льготный', 1)
INSERT INTO Пассажир  VALUES (4, 'Город-Половинный', 2)
INSERT INTO Пассажир  VALUES (5, 'Пригород-Половинный', 2)
INSERT INTO Пассажир  VALUES (6, 'Межгород-Половинный', 2)
INSERT INTO Пассажир  VALUES (7, 'Город-Полный', 3)
INSERT INTO Пассажир  VALUES (8, 'Пригород-Полный', 3)
INSERT INTO Пассажир  VALUES (9, 'Межгород-Полный', 3)
INSERT INTO Пассажир  VALUES (10, 'Заказной-Полный', 3)
GO 
/*ТипАвтотранспорта*/
INSERT INTO ТипАвтотранспорта  VALUES (1, 'Легковой')
INSERT INTO ТипАвтотранспорта  VALUES (2, 'Маршрутный')
INSERT INTO ТипАвтотранспорта  VALUES (3, 'ГородскойМалый')
INSERT INTO ТипАвтотранспорта  VALUES (4, 'ГородскойБольшой')
INSERT INTO ТипАвтотранспорта  VALUES (5, 'Пригородный')
INSERT INTO ТипАвтотранспорта  VALUES (6, 'Междугородний')
GO 
/*Автотранспорт*/
INSERT INTO Автотранспорт  VALUES (1, 'Саманд', 'AE9601-6', 4, 6, 1)
INSERT INTO Автотранспорт  VALUES (2, 'Газель', 'AE9647-6', 16, 10, 2)
INSERT INTO Автотранспорт  VALUES (3, 'Газель', 'AE9648-6', 16, 10, 2)
INSERT INTO Автотранспорт  VALUES (4, 'МАЗ-103.5', 'AE9701-6', 80, 36, 3)
INSERT INTO Автотранспорт  VALUES (5, 'МАЗ-103.5', 'AE9702-6', 80, 36, 3)
INSERT INTO Автотранспорт  VALUES (6, 'МАЗ-103.5', 'AE9703-6', 80, 36, 3)
INSERT INTO Автотранспорт  VALUES (7, 'МАЗ-103.5', 'AE9704-6', 80, 36, 3)
INSERT INTO Автотранспорт  VALUES (8, 'МАЗ-103.5', 'AE9705-6', 80, 36, 3)
INSERT INTO Автотранспорт  VALUES (9, 'МАЗ-103.6', 'AE9801-6', 120, 41, 4)
INSERT INTO Автотранспорт  VALUES (10, 'Радимич', 'AE9301-6', 27, 21, 5)
INSERT INTO Автотранспорт  VALUES (11, 'Радимич', 'AE9302-6', 27, 21, 5)
INSERT INTO Автотранспорт  VALUES (12, 'МАЗ-241', 'AE9401-6', 25, 23, 5)
INSERT INTO Автотранспорт  VALUES (13, 'МАЗ-241', 'AE9402-6', 25, 23, 5)
INSERT INTO Автотранспорт  VALUES (14, 'МАЗ-256', 'AE9501-6', 29, 25, 5)
INSERT INTO Автотранспорт  VALUES (15, 'МАЗ-256', 'AE9502-6', 29, 25, 5)
INSERT INTO Автотранспорт  VALUES (16, 'Голаз', 'AE9001-6', 48, 46, 6)
INSERT INTO Автотранспорт  VALUES (17, 'Голаз', 'AE9002-6', 48, 46, 6)
INSERT INTO Автотранспорт  VALUES (18, 'МАЗ-246', 'AE9101-6', 49, 48, 6)
INSERT INTO Автотранспорт  VALUES (19, 'МАЗ-246', 'AE9102-6', 49, 48, 6)
INSERT INTO Автотранспорт  VALUES (20, 'МАЗ-258', 'AE9201-6', 51, 50, 6)
INSERT INTO Автотранспорт  VALUES (21, 'МАЗ-258', 'AE9202-6', 51, 50, 6)
GO 
/*ТипПеревозки*/
INSERT INTO ТипПеревозки  VALUES (1, 'Городская')
INSERT INTO ТипПеревозки  VALUES (2, 'Пригородная')
INSERT INTO ТипПеревозки  VALUES (3, 'Междугородняя')
INSERT INTO ТипПеревозки  VALUES (4, 'Заказная')
GO 
/*Перевозка*/
INSERT INTO Перевозка  VALUES (1, 'Маршрут 3', 108, 10, 1)
INSERT INTO Перевозка  VALUES (2, 'Маршрут 4', 118, 10, 1)
INSERT INTO Перевозка  VALUES (3, 'Маршрут 6', 128, 10, 1)
INSERT INTO Перевозка  VALUES (4, 'Маршрут 8', 138, 10, 1)
INSERT INTO Перевозка  VALUES (5, 'Маршрут 9', 148, 10, 1)
INSERT INTO Перевозка  VALUES (6, 'Маршрут ЦемЗавод', 88, 10, 1)

INSERT INTO Перевозка  VALUES (7, 'Дяговичи', 68, 10, 2)
INSERT INTO Перевозка  VALUES (8, 'Дарливое', 72, 10, 2)
INSERT INTO Перевозка  VALUES (9, 'Батвиновка', 74, 10, 2)
INSERT INTO Перевозка  VALUES (10, 'Мстиславль', 110, 10, 2)
INSERT INTO Перевозка  VALUES (11, 'Чериков', 115, 10, 2)
INSERT INTO Перевозка  VALUES (12, 'Климовичи', 145, 10, 2)

INSERT INTO Перевозка  VALUES (13, 'Могилев', 250, 10, 3)
INSERT INTO Перевозка  VALUES (14, 'Минск', 450, 10, 3)
INSERT INTO Перевозка  VALUES (15, 'Гомель', 416, 10, 3)

INSERT INTO Перевозка  VALUES (16, 'РайонныеЗаказы', 40, 10, 4)
INSERT INTO Перевозка  VALUES (17, 'ОбластныеЗаказы', 250, 10, 4)
INSERT INTO Перевозка  VALUES (18, 'МежобласныеЗаказы', 600, 10, 4)

INSERT INTO Перевозка  VALUES (19, 'ДеловыеПоездки', 40, 10, 4)

GO 
/*ПассажирыВЗаказе*/
INSERT INTO ПассажирыВЗаказе  VALUES (1, 2, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (2, 2, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (3, 3, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (4, 4, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (5, 5, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (6, 6, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (7, 7, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (8, 8, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (9, 9, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (10, 10, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (11, 11, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (12, 12, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (13, 13, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (14, 14, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (15, 15, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (16, 16, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (17, 17, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (18, 18, 3)
INSERT INTO ПассажирыВЗаказе  VALUES (19, 19, 3)
GO 
/*МаршрутыВЗаказе*/
INSERT INTO МаршрутыВЗаказе  VALUES (1, 1, 1)
INSERT INTO МаршрутыВЗаказе  VALUES (2, 2, 2)
INSERT INTO МаршрутыВЗаказе  VALUES (3, 3, 3)
INSERT INTO МаршрутыВЗаказе  VALUES (4, 4, 4)
INSERT INTO МаршрутыВЗаказе  VALUES (5, 5, 5)
INSERT INTO МаршрутыВЗаказе  VALUES (6, 6, 6)
INSERT INTO МаршрутыВЗаказе  VALUES (7, 7, 7)
INSERT INTO МаршрутыВЗаказе  VALUES (8, 8, 8)
INSERT INTO МаршрутыВЗаказе  VALUES (9, 9, 9)
INSERT INTO МаршрутыВЗаказе  VALUES (10, 10, 10)
INSERT INTO МаршрутыВЗаказе  VALUES (11, 11, 11)
INSERT INTO МаршрутыВЗаказе  VALUES (12, 12, 12)
INSERT INTO МаршрутыВЗаказе  VALUES (13, 13, 13)
INSERT INTO МаршрутыВЗаказе  VALUES (14, 14, 14)
INSERT INTO МаршрутыВЗаказе  VALUES (15, 15, 15)
INSERT INTO МаршрутыВЗаказе  VALUES (16, 16, 16)
INSERT INTO МаршрутыВЗаказе  VALUES (17, 17, 17)
INSERT INTO МаршрутыВЗаказе  VALUES (18, 18, 18)
INSERT INTO МаршрутыВЗаказе  VALUES (19, 19, 19)
GO 
/*Заказ*/
INSERT INTO Заказ  VALUES (1, '2018-04-15T06:00:00', 6, 220, 1080, 38, 4, 27, 1, 1, 3, 3)
INSERT INTO Заказ  VALUES (2, '2018-04-15T06:10:00', 7, 230, 1180, 39, 5, 28, 2, 2, 3, 3)
INSERT INTO Заказ  VALUES (3, '2018-04-15T06:20:00', 8, 240, 1280, 40, 6, 29, 3, 3, 3, 3)
INSERT INTO Заказ  VALUES (4, '2018-04-15T06:30:00', 9, 250, 1380, 41, 7, 30, 4, 4, 3, 3)
INSERT INTO Заказ  VALUES (5, '2018-04-15T06:30:00', 10, 260, 1480, 42, 8, 31, 5, 5, 3, 3)
INSERT INTO Заказ  VALUES (6, '2018-04-15T06:40:00', 8, 260, 880, 40, 9, 32, 6, 6, 3, 3)

INSERT INTO Заказ  VALUES (7, '2018-04-15T06:00:00', 6, 100, 680, 33, 10, 33, 7, 7, 3, 3)
INSERT INTO Заказ  VALUES (8, '2018-04-15T06:10:00', 7, 110, 720, 34, 11, 34, 8, 8, 3, 3)
INSERT INTO Заказ  VALUES (9, '2018-04-15T06:20:00', 8, 110, 740, 35, 12, 35, 9, 9, 3, 3)
INSERT INTO Заказ  VALUES (10, '2018-04-15T06:30:00', 9, 110, 1100, 36, 13, 36, 10, 10, 3, 3)
INSERT INTO Заказ  VALUES (11, '2018-04-15T06:30:00', 9, 100, 1150, 37, 14, 37, 11, 11, 3, 3)
INSERT INTO Заказ  VALUES (12, '2018-04-15T06:40:00', 9, 110, 1450, 38, 15, 38, 12, 12, 3, 3)

INSERT INTO Заказ  VALUES (13, '2018-04-15T06:00:00', 9, 80, 2500, 99, 16, 39, 13, 13, 3, 3)
INSERT INTO Заказ  VALUES (14, '2018-04-15T06:10:00', 12, 85, 4500, 102, 17, 40, 14, 14, 3, 3)
INSERT INTO Заказ  VALUES (15, '2018-04-15T06:20:00', 10, 80, 416, 105, 18, 41, 15, 15, 3, 3)

INSERT INTO Заказ  VALUES (16, '2018-04-15T06:30:00', 9, 20, 400, 36, 19, 42, 16, 16, 3, 3)
INSERT INTO Заказ  VALUES (17, '2018-04-15T06:30:00', 12, 85, 2500, 100, 20, 43, 17, 17, 3, 3)
INSERT INTO Заказ  VALUES (18, '2018-04-15T06:40:00', 10, 85, 6000, 200, 21, 44, 18, 18, 3, 3)
INSERT INTO Заказ  VALUES (19, '2018-04-15T06:40:00', 10, 1, 400, 6, 1, 26, 19, 19, 3, 3)

GO 

SELECT КодДолжности, COUNT(*) AS КоличествоСотрудников
FROM Сотрудник
WHERE YEAR(GETDATE()) - YEAR(ДатаРождения ) > 40
GROUP BY КодДолжности
ORDER BY КодДолжности ASC

SELECT КодДолжности, COUNT(*) AS КоличествоСотрудников
FROM Сотрудник
WHERE YEAR(GETDATE()) - YEAR(ДатаРождения ) > 40 AND КодДолжности BETWEEN 19 AND 22
GROUP BY КодДолжности
ORDER BY КодДолжности ASC

SELECT МаркаАвтотранспорта, Count(РасходТоплива) 
FROM Автотранспорт
where РасходТоплива > 26
GROUP BY МаркаАвтотранспорта

SELECT YEAR(GETDATE()) - YEAR(ДатаРождения) AS ВозрастнаяГруппа, COUNT(КодСотрудника) AS ОбщееКоличество
FROM Сотрудник
GROUP BY ДатаРождения 
ORDER BY ВозрастнаяГруппа DESC


DECLARE @minPas INT
SET @minPas = (SELECT MIN(КоличествоПассажиров)
                FROM Заказ);
SELECT ФИО, МаркаАвтотранспорта, РегистрационныйНомер, МаршрутПеревозки
FROM Заказ INNER JOIN Автотранспорт ON Заказ.КодАвтотранспорта=Автотранспорт.КодАвтотранспорта 
INNER JOIN Сотрудник ON Заказ.КодСотрудника=Сотрудник.КодСотрудника
INNER JOIN Перевозка ON Заказ.КодПеревозки=Перевозка.КодПеревозки
where КоличествоПассажиров = @minPas

SELECT МаркаАвтотранспорта, РегистрационныйНомер, МаршрутПеревозки
FROM Заказ INNER JOIN Автотранспорт ON Заказ.КодАвтотранспорта=Автотранспорт.КодАвтотранспорта 
INNER JOIN Сотрудник ON Заказ.КодСотрудника=Сотрудник.КодСотрудника
INNER JOIN Перевозка ON Заказ.КодПеревозки=Перевозка.КодПеревозки
WHERE МаркаАвтотранспорта LIKE 'МАЗ%'


SELECT COUNT(МаркаАвтотранспорта) AS ВсеМазГолаз
FROM Заказ INNER JOIN Автотранспорт ON Заказ.КодАвтотранспорта=Автотранспорт.КодАвтотранспорта 
INNER JOIN Сотрудник ON Заказ.КодСотрудника=Сотрудник.КодСотрудника
INNER JOIN Перевозка ON Заказ.КодПеревозки=Перевозка.КодПеревозки
WHERE МаркаАвтотранспорта LIKE 'МАЗ%' OR МаркаАвтотранспорта='Голаз'

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
SET @Name ='Должность'
EXEC CountOfRowsInTable @Name, @Number OUTPUT
SELECT @Number AS ЧислоСтрок
GO

DECLARE @Name VARCHAR(20), @Number INT
SET @Name ='ТипАвтотранспорта'
EXEC CountOfRowsInTable @Name, @Number OUTPUT
SELECT @Number AS ЧислоСтрок
GO

DROP PROCEDURE CountOfRowsInTable

CREATE PROCEDURE CountValues (@c_name nvarchar(30), @r_min int OUTPUT, @r_avg int OUTPUT, @r_max int OUTPUT, @r_sum int OUTPUT) AS
	BEGIN
	DECLARE @sqlCode nvarchar(50),
	@result nvarchar(50)
	SET @sqlCode = N'SELECT @t_min = MIN(' +@c_name + ') FROM Перевозка'
	SET @result = N'@t_min int OUTPUT'
	EXEC sp_executesql @sqlCode, @result, @t_min = @r_min OUTPUT
	SET @sqlCode = N'SELECT @t_avg = MAX(' +@c_name + ') FROM Перевозка'
	SET @result = N'@t_avg int OUTPUT'
	EXEC sp_executesql @sqlCode, @result, @t_avg = @r_avg OUTPUT
	SET @sqlCode = N'SELECT @t_max = AVG(' +@c_name + ') FROM Перевозка'
	SET @result = N'@t_max int OUTPUT'
	EXEC sp_executesql @sqlCode, @result, @t_max = @r_max OUTPUT
	SET @sqlCode = N'SELECT @t_sum = SUM(' +@c_name + ') FROM Перевозка'
	SET @result = N'@t_sum int OUTPUT'
	EXEC sp_executesql @sqlCode, @result, @t_sum = @r_sum OUTPUT
	END
GO

DECLARE @Name VARCHAR(20), @Min INT, @Max INT, @Average INT , @Sum INT
SET @Name ='Киллометраж'
EXEC CountValues @Name, @Min OUTPUT, @Max OUTPUT, @Average OUTPUT, @Sum OUTPUT
SELECT @Min AS МинимальнаяДлинна
SELECT @Max AS МаксимальнаяДлинна
SELECT @Average AS СредняяДлинна
SELECT @Sum AS ОбщаяДлинна
GO

DROP PROCEDURE CountValues