-- User logs into the website for the first time, creates self in users table
insert into users (email, edipi, display_name, phone)
VALUES ('christopher.breen@usmc.mil', '1111111111', 'Breen MGySgt Christopher P', '619-701-2017');

-- User creates a a new exercise
insert into exercises (exercise, evolution, start_date, end_date)
VALUES ('MEFEX', '21.1', '2020-11-13', '2020-11-18');

-- User adds their own unit to the db
insert into units (uic, short_name, long_name, mcc, ruc, type)
VALUES ('M20129', 'CE III MEF', 'Command Element III MEF', '000', '20381', 'Inf Bn');

-- auto-generate own permissions entry for self on first unit
insert into permissions (unit_id, exercise_id, user_id)
VALUES ((select id from units where uic = 'M20129'),
        (select id from exercises where exercise = 'MEFEX' and evolution = '21.1'),
        (select id from users where email = 'christopher.breen@usmc.mil'));

-- add second logistician
insert into users (email)
VALUES ('jon.smith@usmc.mil');

insert into permissions (unit_id, exercise_id, parent_user_id, user_id)
VALUES ((select id from units where uic = 'M20129'),
        (select id from exercises where exercise = 'MEFEX' and evolution = '21.1'),
        (select id from users where email = 'christopher.breen@usmc.mil'),
        (select id from users where email = 'jon.smith@usmc.mil'));

-- create adam smith in users table
insert into users (email)
VALUES ('adam.smith@usmc.mil');

-- adding smith to exercise with invalid parent succeeds as parent allows null; must first get id of current user
-- and ensure a non-null id is obtained before continuing insertion with current user as parent.
insert into permissions (unit_id, exercise_id, parent_user_id, user_id)
VALUES ((select id from units where uic = 'M20129'),
        (select id from exercises where exercise = 'MEFEX' and evolution = '21.1'),
        (select id from users where email = 'no_exist@mail.mil'),
        (select id from users where email = 'adam.smith@usmc.mil'));
-- cleanup above erroneous entry
delete from permissions where user_id = (select id from users where email = 'adam.smith@usmc.mil');

-- add non-existant user fails.  Must insert email into users table as part of pipeline for creating new permission.
insert into permissions (unit_id, exercise_id, parent_user_id, user_id)
VALUES ((select id from units where uic = 'M20129'),
        (select id from exercises where exercise = 'MEFEX' and evolution = '21.1'),
        (select id from users where email = 'christopher.breen@usmc.mil'),
        (select id from users where email = 'no_exist@usmc.mil'));

-- successfully add existing user into permissions with current user as parent.
insert into permissions (unit_id, exercise_id, parent_user_id, user_id)
VALUES ((select id from units where uic = 'M20129'),
        (select id from exercises where exercise = 'MEFEX' and evolution = '21.1'),
        (select id from users where email = 'christopher.breen@usmc.mil'),
        (select id from users where email = 'adam.smith@usmc.mil'));





