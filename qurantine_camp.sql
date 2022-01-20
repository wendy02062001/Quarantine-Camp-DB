CREATE TABLE medication ( 
	code                 varchar(6)  NOT NULL    PRIMARY KEY,
	expiration_date      date  NOT NULL    ,
	name                 varchar(100)  NOT NULL    ,
	price                decimal(8,2)  NOT NULL    
 );

CREATE TABLE effect ( 
	medication_code      varchar(6)  NOT NULL    ,
	description          varchar(500)  NOT NULL    ,
	CONSTRAINT pk_effect PRIMARY KEY ( medication_code, description ),
	CONSTRAINT unq_effect_medication_code UNIQUE ( medication_code ) 
 );

CREATE TABLE building ( 
	building_number      int  NOT NULL    ,
	camp_number          int  NOT NULL    ,
	CONSTRAINT pk_building PRIMARY KEY ( building_number, camp_number )
 );

CREATE INDEX fk_building_camp ON building ( camp_number );

CREATE TABLE camp ( 
	camp_number          int  NOT NULL    PRIMARY KEY,
	head_of_camp         int  NOT NULL    ,
	CONSTRAINT unq_camp UNIQUE ( head_of_camp ) 
 );

CREATE TABLE comorbidity ( 
	patient_number       int  NOT NULL    ,
	name                 varchar(100)  NOT NULL    ,
	CONSTRAINT pk_comorbidity PRIMARY KEY ( patient_number, name )
 );

CREATE TABLE doctor ( 
	personnel_number     int  NOT NULL    PRIMARY KEY,
	full_name            varchar(100)  NOT NULL    ,
	responsibility       varchar(500)  NOT NULL    ,
	camp_number          int
 );

CREATE INDEX fk_doctor_camp ON doctor ( camp_number );

CREATE TABLE floor ( 
	floor_number         int  NOT NULL    ,
	building_number      int  NOT NULL    ,
	camp_number          int  NOT NULL    ,
	CONSTRAINT pk_floor PRIMARY KEY ( floor_number, building_number, camp_number )
 );

CREATE INDEX fk_floor_building ON floor ( building_number, camp_number );

CREATE TABLE manager ( 
	personnel_number     int  NOT NULL    PRIMARY KEY,
	full_name            varchar(100)  NOT NULL    ,
	responsibility       varchar(500)  NOT NULL    ,
	camp_number          int  NOT NULL    
 );

CREATE INDEX fk_manager_camp ON manager ( camp_number );

CREATE TABLE nurse ( 
	personnel_number     int  NOT NULL    PRIMARY KEY,
	full_name            varchar(100)  NOT NULL    ,
	responsibility       varchar(500)  NOT NULL    ,
	camp_number          int  NOT NULL    
 );

CREATE INDEX fk_nurse_camp ON nurse ( camp_number );

CREATE TABLE patient ( 
	patient_number       int  NOT NULL  AUTO_INCREMENT PRIMARY KEY,
	full_name            varchar(100)  NOT NULL    ,
	gender               char(1)  NOT NULL    ,
	identity_number      varchar(12)  NOT NULL    ,
	phone                varchar(12)  NOT NULL    ,
	address              varchar(500)  NOT NULL    ,
	patient_status       varchar(7)  NOT NULL DEFAULT 'normal'   ,
	discharge_date       date      ,
	admitting_staff      int  NOT NULL    ,
	admission_date       date  NOT NULL    ,
	last_location        varchar(500)  NOT NULL    ,
	nurse_number         int  NOT NULL    ,
	room_number          int  NOT NULL    ,
	floor_number         int  NOT NULL    ,
	building_number      int  NOT NULL    ,
	camp_number          int  NOT NULL    ,
	CONSTRAINT unq_patient UNIQUE ( identity_number ) 
 );

CREATE INDEX fk_patient_nurse ON patient ( nurse_number );

CREATE INDEX fk_patient_room ON patient ( room_number, floor_number, building_number, camp_number );

CREATE INDEX fk_patient_staff ON patient ( admitting_staff );

CREATE TABLE room ( 
	room_number          int  NOT NULL    ,
	floor_number         int  NOT NULL    ,
	building_number      int  NOT NULL    ,
	camp_number          int  NOT NULL    ,
	capacity             int      ,
	room_type            varchar(100)   DEFAULT 'normal'   ,
	CONSTRAINT pk_room PRIMARY KEY ( room_number, floor_number, building_number, camp_number )
 );

CREATE INDEX fk_room_floor ON room ( floor_number, building_number, camp_number );

CREATE TABLE staff ( 
	personnel_number     int  NOT NULL    PRIMARY KEY,
	full_name            varchar(100)  NOT NULL    ,
	responsibility       varchar(500)  NOT NULL    ,
	camp_number          int  NOT NULL    
 );

CREATE INDEX fk_staff_camp ON staff ( camp_number );

CREATE TABLE symptom ( 
	patient_number       int  NOT NULL    ,
	check_time           date  NOT NULL    ,
	description          varchar(500)  NOT NULL    ,
	CONSTRAINT pk_symptom PRIMARY KEY ( patient_number, check_time, description )
 );

CREATE TABLE testing_information ( 
	patient_number       int  NOT NULL    ,
	test_time            date  NOT NULL    ,
	pcr_test_result      char(1)      ,
	pcr_test_ct_value    decimal(4,1)      ,
	quick_test_result    char(1)      ,
	quick_test_ct_value  decimal(4,1)      ,
	respiratory_rate     int      ,
	spo2                 decimal(4,1)      ,
	CONSTRAINT pk_testing_information UNIQUE ( patient_number, test_time, pcr_test_result, pcr_test_ct_value, quick_test_result, quick_test_ct_value, respiratory_rate, spo2 ) 
 );

CREATE TABLE treatment ( 
	patient_number       int  NOT NULL    ,
	doctor_number        int  NOT NULL    ,
	medication_code      varchar(6)  NOT NULL    ,
	result               varchar(500)      ,
	start_date           date  NOT NULL    ,
	end_date             date  NOT NULL    ,
	CONSTRAINT pk_treatment PRIMARY KEY ( patient_number, doctor_number, medication_code )
 );

CREATE INDEX fk_treatment_doctor ON treatment ( doctor_number );

CREATE INDEX fk_treatment_medication ON treatment ( medication_code );

CREATE TABLE volunteer ( 
	personnel_number     int  NOT NULL    PRIMARY KEY,
	full_name            varchar(100)  NOT NULL    ,
	responsibility       varchar(500)  NOT NULL    ,
	camp_number          int  NOT NULL    
 );


-- add the basic data before adding FKs to avoid conflicts
INSERT INTO camp ( camp_number, head_of_camp ) VALUES ( 1, 1 );
INSERT INTO camp ( camp_number, head_of_camp ) VALUES ( 2, 3 );
INSERT INTO camp ( camp_number, head_of_camp ) VALUES ( 3, 5 );
INSERT INTO camp ( camp_number, head_of_camp ) VALUES ( 4, 7 );

-- it should be noted that the personnel_number is used to identify a person among all personnels (including doctors, nurses, staffs, ...)

INSERT INTO doctor ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 1, 'Tran Van A', 'head doctor of camp no.1; work at the intensive care unit', 1 );
INSERT INTO doctor ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 2, 'Le Van B', 'take care of elderly patients', 1 );
INSERT INTO doctor ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 3, 'Le Thi C', 'head doctor of camp no.2; work at the intensive care unit', 2 );
INSERT INTO doctor ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 4, 'Nguyen Van D', 'take care of elderly patients', 2 );
INSERT INTO doctor ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 5, 'Tran Thi E', 'head doctor of camp no.3; work at the intensive care unit', 3 );
INSERT INTO doctor ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 6, 'Nguyen Van F', 'take care of elderly patients', 3 );
INSERT INTO doctor ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 7, 'Nguyen Thanh G', 'head doctor of camp no.4; work at the intensive care unit', 4 );
INSERT INTO doctor ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 8, 'Le Van H', 'take care of elderly patients', 4 );


INSERT INTO nurse ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 9, 'Le Thi A', 'take care of elderly patients', 1 );
INSERT INTO nurse ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 10, 'Tran Van B', 'take care of general patients', 1 );
INSERT INTO nurse ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 11, 'Nguyen Thanh C', 'take care of general patients', 1 );
INSERT INTO nurse ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 12, 'Nguyen Thi D', 'take care of elderly patients', 1 );
INSERT INTO nurse ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 13, 'Le Thi E', 'take care of general patients', 1 );


INSERT INTO staff ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 14, 'Le Tran A', 'in charge of hotline', 1 );
INSERT INTO staff ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 15, 'Nguyen Van B', 'admission staff', 1 );
INSERT INTO staff ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 16, 'Le Thanh C', 'admission staff', 1 );
INSERT INTO staff ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 17, 'Le Van D', 'admission staff', 1 );
INSERT INTO staff ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 18, 'Nguyen Tran E', 'in charge of hotline', 1 );


INSERT INTO manager ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 19, 'Le Thi A', 'manage medical personnels', 1 );
INSERT INTO manager ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 20, 'Tran Van B', 'manage the volunteers', 1 );
INSERT INTO manager ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 21, 'Nguyen Thanh C', 'storage manager', 1 );
INSERT INTO manager ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 22, 'Nguyen Thi D', 'manage the volunteers', 1 );


INSERT INTO volunteer ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 23, 'Le Hoang A', 'data entry', 1 );
INSERT INTO volunteer ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 24, 'Tran Thi B', 'data entry', 1 );
INSERT INTO volunteer ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 25, 'Nguyen Thanh C', 'transport patients', 1 );
INSERT INTO volunteer ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 26, 'Le Tran D', 'transport equipments', 1 );
INSERT INTO volunteer ( personnel_number, full_name, responsibility, camp_number ) VALUES ( 27, 'Nguyen Tran E', 'transport patients', 1 );


INSERT INTO building ( building_number, camp_number ) VALUES ( 1, 1 );
INSERT INTO building ( building_number, camp_number ) VALUES ( 2, 1 );
INSERT INTO building ( building_number, camp_number ) VALUES ( 3, 1 );
INSERT INTO building ( building_number, camp_number ) VALUES ( 4, 1 );
INSERT INTO building ( building_number, camp_number ) VALUES ( 5, 1 );


INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 1, 1, 1 );
INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 2, 1, 1 );
INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 3, 1, 1 );

INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 1, 2, 1 );
INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 2, 2, 1 );

INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 1, 3, 1 );
INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 2, 3, 1 );
INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 3, 3, 1 );

INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 1, 4, 1 );
INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 2, 4, 1 );
INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 3, 4, 1 );
INSERT INTO floor ( floor_number, building_number, camp_number ) VALUES ( 4, 4, 1 );


INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity, room_type ) VALUES ( 1, 1, 1, 1, 5, 'recuperation' );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity, room_type ) VALUES ( 2, 1, 1, 1, 5, 'recuperation' );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity, room_type ) VALUES ( 3, 1, 1, 1, 4, 'emergency' );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity, room_type ) VALUES ( 4, 1, 1, 1, 4, 'emergency' );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 5, 1, 1, 1, 10 );

INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 1, 2, 1, 1, 10 );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 2, 2, 1, 1, 10 );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 3, 2, 1, 1, 10 );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 4, 2, 1, 1, 10 );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 5, 2, 1, 1, 10 );

INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 1, 3, 1, 1, 10 );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 2, 3, 1, 1, 10 );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 3, 3, 1, 1, 10 );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 4, 3, 1, 1, 10 );
INSERT INTO room ( room_number, floor_number, building_number, camp_number, capacity ) VALUES ( 5, 3, 1, 1, 10 );


INSERT INTO patient ( patient_number, full_name, gender, identity_number, phone, address, patient_status, discharge_date, admitting_staff, admission_date, last_location, nurse_number, room_number, floor_number, building_number, camp_number )
VALUES
	(1, 'Le Minh D', 'M', '451284695123', '907-200-3553', '295 Ba Trieu', 'normal', NULL, 15, '2020-08-19', '295 Ba Trieu', 9, 1, 1, 1, 1),
	(2, 'Nguyen Ngoc B', 'F', '754812569452', '907-200-2730', '506 Hong Bang street ward 16 district 11', 'normal', '2020-05-22', 15, '2020-05-09', '506 Hong Bang street ward 16 district 11', 9, 1, 1, 1, 1),
	(3, 'Tran Dang K', 'M', '145268953145', '907-200-7686', 'No. 331 Ben Van Don, Ward 1, District 48', 'warning', NULL, 16, '2020-08-09', 'No. 331 Ben Van Don, Ward 1, District 48', 10, 1, 1, 1, 1),
	(4, 'Nguyen Huynh A', 'F', '845963256412', '907-200-1816', '74A Yersin, Phuong Sai.', 'normal', '2020-07-01', 17, '2020-06-18', '565B Au Co Street, Ward 10', 10, 3, 1, 1, 1),
	(5, 'Luong Tran Dieu A', 'F', '145865478562', '907-200-1926', '565B Au Co Street, Ward 10', 'normal', NULL, 17, '2020-08-10', '565B Au Co Street, Ward 10', 10, 4, 1, 1, 1),
	(6, 'Dinh Thien T', 'M', '754896325614', '907-200-3984', '81 Pho Quang, Ward 2', 'normal', '2020-08-06', 16, '2020-07-25', 'Building FPT, Pham Hung', 11, 3, 1, 1, 1),
	(7, 'Nguyen Hoang K', 'M', '754896532145', '907-200-9539', '212/3 Le Van Sy, Ward 10', 'normal', NULL, 17, '2020-08-11', 'Van Son street', 13, 4, 1, 1, 1),
	(8, 'Le Ngoc H', 'F', '748596254153', '907-200-4833', 'Tan Binh Industrial Park, B009 Lot B, Tay Thanh Ward', 'normal', '2020-04-01', 16, '2020-02-14', 'Van Son street', 12, 1, 2, 1, 1),
	(9, 'Nguyen Thi Thuy T', 'M', '125489635468', '907-200-5548', 'No 8, Pham Ngoc Thach Street', 'normal', '2020-07-18', 15, '2020-06-15', 'Van Son street', 13, 2, 2, 1, 1),
	(10, 'Le Thanh Khanh D', 'F', '125489635478', '907-200-1602', 'Van Son street', 'normal', NULL, 15, '2020-09-12', 'Van Son street', 11, 2, 2, 1, 1),
	(11, 'Nguyen Van A', 'M', '125698754355', '907-200-1750', '26 Dang Van Ngu Street Dong Da District', 'normal', NULL, 16, '2020-09-10', 'Van Son street', 9, 3, 2, 1, 1),
	(12, 'Tran Hoang L', 'F', '985642658632', '907-200-8265', '1051-1021 Nguyen Trai St., Ward 14, Dist. 5', 'normal', '2020-04-18', 16, '2020-03-10', 'Van Son street', 9, 3, 2, 1, 1),
	(13, 'Dao Pham Bao T', 'F', '458965482154', '907-200-0055', 'D104, Str.2, Phu Lo Hamlet', 'normal', '2020-06-09', 16, '2020-05-05', '565B Au Co Street, Ward 10', 12, 3, 2, 1, 1),
	(14, 'Nguyen Thi A', 'F', '741258963159', '907-200-5524', '67A Nguyen Thien Thuat street, Ward 24', 'warning', NULL, 15, '2020-09-12', '67A Nguyen Thien Thuat street, Ward 24', 10, 3, 2, 1, 1),
	(15, 'Le Minh H','M', '745896325641', '907-200-9725', '165B Phan Dang luu, Ward 3', 'warning','2020-10-25', 17, '2020-09-10', '80-33 Trung Lang Street, Ward 12', 10, 1, 2, 1, 1),
	(16, 'Luong Duc T', 'M', '748965894123', '907-200-0594', '21 Nguyen Bieu, Nam Ha Ward', 'warning', '2020-09-25', 16, '2020-04-10', '80-33 Trung Lang Street, Ward 12', 11, 2, 1, 1, 1),
	(17, 'Nguyen Phuong U', 'F', '145896325412', '907-200-0839', '265/32 Nguyen Xi Street,Ward 13', 'warning', NULL, 15, '2020-09-11', '80-33 Trung Lang Street, Ward 12', 12, 3, 1, 1, 1),
	(18, 'Tu Gia H', 'M', '632598741562', '907-200-2483', '44 Trang Tu, Dist.5', 'normal', NULL, 15, '2020-08-15', '80-33 Trung Lang Street, Ward 12', 13, 2, 3, 1, 1),
	(19, 'Ho Quynh T', 'F', '145896326547', '907-200-2602', '56 Phan Boi Chau street', 'normal', NULL, 15, '2020-09-20', '565B Au Co Street, Ward 10', 13, 2, 3, 1, 1),
	(20, 'Phan Boi D', 'F', '748965326541', '907-200-2171', '268 Cao Xuan Duc street, Ward 12, District 8', 'normal', '2020-06-21', 16, '2020-04-11', 'Da Nang IZ', 13, 3, 3, 1, 1),
	(21, 'Tran Van C', 'M', '456982365478', '907-200-9591', '61 Phan Boi Chau', 'normal', '2020-07-02', 17, '2020-05-11', '80-33 Trung Lang Street, Ward 12', 10, 3, 3, 1, 1),
	(22, 'Le Yen N', 'F', '125987563214', '907-200-9897', '029 Tran Nao Street, District 29', 'normal', '2020-10-13', 16, '2020-09-15', '80-33 Trung Lang Street, Ward 12', 13, 4, 3, 1, 1),
	(23, 'Nguyen Van A', 'M', '748965478521', '907-200-2548', '62 Hang Ga Street', 'normal', '2020-05-23', 17, '2020-04-13', 'Da Nang IZ', 12, 5, 3, 1, 1);


INSERT INTO medication ( expiration_date, name, price, code )
VALUES
	('2022-12-20', 'Remdesvir', 250000.00, '1SR5DF'),
	('2022-03-16', 'Dexamethasone', 450000.00, '275D1F'),
	('2022-06-08', 'Ivermectin', 750000.00, '348FDS'),
	('2022-08-26', 'Hydroxychloroquine', 156000.00, '445DSF'),
	('2022-11-07', 'Chloroquine', 741000.00, '5SDE82'),
	('2022-06-24', 'Molnupiravir', 152000.00, '6EF896'),
	('2022-09-19', 'Favipiravir', 756000.00, '7AS568'),
	('2022-03-05', 'Recombinant ACE-2', 265000.00, '8SDF85'),
	('2022-03-12', 'PF-07321332', 654000.00, '9SDG85'),
	('2022-08-16', 'Lopinavir', 963000.00, '10ED48'),
	('2022-08-16', 'Ritonavir', 458000.00, '114D8S');


INSERT INTO effect ( medication_code, description )
VALUES
	('1SR5DF', 'Top the coronavirus from multiplying in cells'),
	('275D1F', 'Reduces the risk for deaths by about 30% for people on ventilators and by about 20% for people who needed supplemental oxygen'),
	('348FDS', 'Taking large doses of this drug can cause serious harm'),
	('445DSF', 'Malaria drugs but they can cause serious heart problems'),
	('5SDE82', 'Malaria drugs but they can cause serious heart problems'),
	('6EF896', 'Reduced the risk of hospitalization and death by half'),
	('7AS568', 'Has only negligible impact on mortality in TREATMENTs with serious symptoms'),
	('8SDF85', 'Might be able to act as decoys, luring the coronavirus away from vulnerable cells'),
	('9SDG85', 'Blocks the virus from replicating inside cells'),
	('10ED48', 'Stop the coronavirus from replicating in cultures of cells'),
	('114D8S', 'Stop the coronavirus from replicating in cultures of cells');


INSERT INTO treatment ( patient_number, doctor_number, medication_code, result, start_date, end_date )
VALUES
	(1, 1,'9SDG85', NULL, '2020-08-20', '2020-08-30'),
	(2, 2,'1SR5DF', 'Serious', '2020-05-10', '2020-05-20'),
	(3, 4,'7AS568', NULL, '2020-08-10', '2020-08-15'),
	(4, 1,'9SDG85', 'Recover', '2020-06-20', '2020-06-30'),
	(5, 5,'1SR5DF', NULL, '2020-08-11', '2020-08-25'),
	(6, 5,'114D8S', 'Non-recover', '2020-07-30', '2020-08-05'),
	(7, 3,'445DSF', NULL, '2020-08-12', '2020-08-30'),
	(8, 2,'5SDE82', 'Recover', '2020-02-15', '2020-03-30'),
	(9, 5,'114D8S', 'Serious', '2020-06-16', '2020-07-17'),
	(10, 5,'445DSF', NULL, '2020-09-13', '2020-09-17'),
	(11, 1,'7AS568', NULL, '2020-09-14', '2020-09-17'),
	(12, 3,'7AS568', 'Non-recover', '2020-03-20', '2020-04-16'),
	(13, 2,'1SR5DF', 'Recover', '2020-05-06', '2020-06-08'),
	(14, 1,'9SDG85', NULL, '2020-09-15', '2020-09-20'),
	(15, 4,'114D8S', 'Non-recover', '2020-09-20', '2020-10-20'),
	(16, 3,'445DSF', 'Non-recover', '2020-04-11', '2020-09-20'),
	(17, 2,'6EF896', NULL, '2020-09-21', '2020-10-01'),
	(18, 3,'6EF896', NULL, '2020-08-16', '2020-08-20'),
	(19, 5,'8SDF85', NULL, '2020-09-22', '2020-09-30'),
	(20, 2,'10ED48', 'Non-recover', '2020-04-12', '2020-06-20'),
	(21, 5,'1SR5DF', 'Recover', '2020-05-13', '2020-06-30'),
	(22, 5,'10ED48', NULL, '2020-09-17', '2020-10-12'),
	(23, 5,'348FDS', 'Recover', '2020-04-14', '2020-05-20');


INSERT INTO comorbidity ( patient_number, name )
VALUES 
	(1, 'Chronic kidney disease'),
	(4, 'Cancer'),
	(5, 'Heart conditions'),
	(8, 'Chronic kidney disease'),
	(14, 'Overweight and obesity'),
	(20, 'Chronic kidney disease'),
	(23, 'Overweight and obesity');


INSERT INTO symptom ( patient_number, check_time, description )
VALUES 
	(1, '2020-08-20', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat'),
	(2, '2020-05-10', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Aches and pains'),
	(3, '2020-08-10', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Diarrhoea, A rash on skin'),
	(4, '2020-06-20', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Difficulty in breathing'),
	(5, '2020-08-11', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Diarrhoea, A rash on skin'),
	(6, '2020-07-30', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Loss of speech or mobility'),
	(7, '2020-08-12', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat'),
	(8, '2020-02-15', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Chest pain'),
	(9, '2020-06-16', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Loss of speech or mobility'),
	(10, '2020-09-13', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Aches and pains'),
	(11, '2020-09-14', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat'),
	(12, '2020-03-20', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat'),
	(13, '2020-05-06', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Difficulty in breathing'),
	(14, '2020-09-15', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Diarrhoea, A rash on skin'),
	(15, '2020-09-20', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Diarrhoea, A rash on skin'),
	(16, '2020-04-11', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat'),
	(17, '2020-09-21', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Difficulty in breathing'),
	(18, '2020-08-16', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Chest pain'),
	(19, '2020-09-22', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat'),
	(20, '2020-04-12', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Loss of speech or mobility'),
	(21, '2020-05-13', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat'),
	(22, '2020-09-17', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Aches and pains'),
	(23, '2020-04-14', 'Fever, Cough, Tiredness, Loss of taste or smell, Sore throat, Chest pain');



INSERT INTO testing_information ( patient_number, test_time, pcr_test_result, pcr_test_ct_value, quick_test_result, quick_test_ct_value, respiratory_rate, spo2 )
VALUES
	(1, '2020-08-20', 'P', 29.5, NULL, NULL, 20, 96.5),
	(2, '2020-05-10', 'P', NULL, 'P', 29, 19, 96.4),
	(2, '2020-05-20', 'N', 31, 'P', NULL, 20, 96),
	(3, '2020-08-10', 'P', 28, 'P', NULL, 20, 96.1),
	(4, '2020-06-20', 'P', 28.9, 'P', NULL, 20, 96.5),
	(4, '2020-06-30', 'P', 32, 'P', NULL, 20, 96),
	(5, '2020-08-11', 'P', 29.9, NULL, NULL, 20, 96.1),
	(6, '2020-07-30', 'P', 28.5, NULL, NULL, 20, 96),
	(6, '2020-08-05', 'N', 31, NULL, NULL, 20, 96),
	(7, '2020-08-12', NULL, NULL, 'P', 29.5, 20, 96.1),
	(8, '2020-02-15', NULL, NULL, 'N', 27.5, 20, 96.5),
	(8, '2020-03-30', NULL, NULL, 'N', 31, 20, 96),
	(9, '2020-06-16', NULL, NULL, 'P', 27, 19, 96.5),
	(9, '2020-07-17', NULL, NULL, 'N', 31, 20, 96),
	(10, '2020-09-13', NULL, NULL, 'P', 28.6, 20, 96),
	(11, '2020-09-14', 'P', 27.5, NULL, NULL, 20, 96.5),
	(12, '2020-03-20', 'P', 28.9, NULL, NULL, 20, 96.7),
	(12, '2020-04-16', 'N', 32, NULL, NULL, 20, 96),
	(13, '2020-05-06', 'P', 27.5, NULL, NULL, 20, 96),
	(13, '2020-06-08', 'N', 31, NULL, NULL, 20, 96),
	(14, '2020-09-15', 'P', 29.5, NULL, NULL, 20, 96.5),
	(15, '2020-09-20', NULL, NULL, 'P', 28.9, 20, 96.6),
	(15, '2020-10-20', NULL, NULL, 'N', 30.5, 20, 96),
	(16, '2020-04-11', 'P', 29, NULL, NULL, 20, 96),
	(16, '2020-09-20', 'N', 30.9, NULL, NULL, 20, 96),
	(17, '2020-09-21', NULL, NULL, 'N', 29.5, 20, 96.6),
	(18, '2020-08-16', NULL, NULL, 'P', 29.5, 20, 96.6),
	(19, '2020-09-22', NULL, NULL, 'P', 29.5, 20, 96),
	(20, '2020-04-12', 'P', 28.9, NULL, NULL, 18, 96),
	(20, '2020-06-20', 'N', 30.2, NULL, NULL, 20, 96),
	(21, '2020-05-13', 'P', 29.5, NULL, NULL, 18, 96.6),
	(21, '2020-06-30', 'N', 30.6, NULL, NULL, 20, 96.6),
	(22, '2020-09-17', 'P', 29, NULL, NULL, 20, 96),
	(22, '2020-10-12', 'N', 31, NULL, NULL, 20, 96),
	(23, '2020-04-14', NULL, NULL, 'P', 27.5, 20, 96.6);



CREATE INDEX fk_volunteer_camp ON volunteer ( camp_number );

ALTER TABLE building ADD CONSTRAINT fk_building_camp FOREIGN KEY ( camp_number ) REFERENCES camp( camp_number ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE camp ADD CONSTRAINT fk_camp_doctor FOREIGN KEY ( head_of_camp ) REFERENCES doctor( personnel_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE comorbidity ADD CONSTRAINT fk_comorbidity_patient FOREIGN KEY ( patient_number ) REFERENCES patient( patient_number ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE doctor ADD CONSTRAINT fk_doctor_camp FOREIGN KEY ( camp_number ) REFERENCES camp( camp_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE effect ADD CONSTRAINT fk_effect_medication FOREIGN KEY ( medication_code ) REFERENCES medication( code ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE floor ADD CONSTRAINT fk_floor_building FOREIGN KEY ( building_number, camp_number ) REFERENCES building( building_number, camp_number ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE manager ADD CONSTRAINT fk_manager_camp FOREIGN KEY ( camp_number ) REFERENCES camp( camp_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE nurse ADD CONSTRAINT fk_nurse_camp FOREIGN KEY ( camp_number ) REFERENCES camp( camp_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE patient ADD CONSTRAINT fk_patient_nurse FOREIGN KEY ( nurse_number ) REFERENCES nurse( personnel_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE patient ADD CONSTRAINT fk_patient_room FOREIGN KEY ( room_number, floor_number, building_number, camp_number ) REFERENCES room( room_number, floor_number, building_number, camp_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE patient ADD CONSTRAINT fk_patient_staff FOREIGN KEY ( admitting_staff ) REFERENCES staff( personnel_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE room ADD CONSTRAINT fk_room_floor FOREIGN KEY ( floor_number, building_number, camp_number ) REFERENCES floor( floor_number, building_number, camp_number ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE staff ADD CONSTRAINT fk_staff_camp FOREIGN KEY ( camp_number ) REFERENCES camp( camp_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE symptom ADD CONSTRAINT fk_symptom_patient FOREIGN KEY ( patient_number ) REFERENCES patient( patient_number ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE testing_information ADD CONSTRAINT fk_testing_information_patient FOREIGN KEY ( patient_number ) REFERENCES patient( patient_number ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE treatment ADD CONSTRAINT fk_treatment_doctor FOREIGN KEY ( doctor_number ) REFERENCES doctor( personnel_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE treatment ADD CONSTRAINT fk_treatment_medication FOREIGN KEY ( medication_code ) REFERENCES medication( code ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE treatment ADD CONSTRAINT fk_treatment_patient FOREIGN KEY ( patient_number ) REFERENCES patient( patient_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE volunteer ADD CONSTRAINT fk_volunteer_camp FOREIGN KEY ( camp_number ) REFERENCES camp( camp_number ) ON DELETE RESTRICT ON UPDATE CASCADE;

