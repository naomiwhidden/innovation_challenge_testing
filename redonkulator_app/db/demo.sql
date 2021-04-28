-- User logs into the website for the first time
insert into users (edipi, rank_abbr, last_name, first_name, email, phone)
VALUES ('1234567890', 'MGySgt', 'Breen', 'Christopher', 'christopher.breen@usmc.mil', '619-701-2017');

-- User creates a a new exercise
insert into exercises (exercise, evolution, start_date, end_date)
VALUES ('MEFEX', '21.1', '2020-11-13', '2020-11-18');

-- User adds their own unit to the exercise as senior element
insert into units (uic, short_name, long_name, mcc, ruc)
VALUES ('M20129', 'CE III MEF', 'Command Element III MEF', '000', '20381');

-- Above auto-generates own permissions entry
insert into permissions (parent_user_edipi, user_edipi, exercise_evolution, unit_uic)
VALUES ('1234567899', '1234567890', '21.1', 'M20129');
