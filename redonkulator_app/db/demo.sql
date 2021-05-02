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
delete
from permissions
where user_id = (select id from users where email = 'adam.smith@usmc.mil');

-- add non-existent user fails.  Must insert email into users table as part of pipeline for creating new permission.
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

-- populate unit EDL with generic inventory (new/edit unit page).  Vision: generic inventory becomes baseline inventory
-- from TFSMS, GCSS, CLC2S, etc.  A unit starts out by replicating OUR best assumption of what they should have, then
-- they can add/modify/delete their actual EDL as they see fit.  At any time (someone screws it up too bad), they could
-- revert back to our best guess.  Best guess (generic_inventory) could be updated regularly with newly published TO&E's
-- or other source data.
insert into unit_edl (unit_id, equipment_id, quantity) ((select '1', equipment_id, quantity
                                                         from generic_edl
                                                         where unit_type = 'Inf Bn'));

-- add CAB unit
insert into units (uic, short_name, long_name, mcc, ruc, type)
VALUES ('M12345', '1st CAB', '1st Combat Assault Battallion', '001', '20382', 'CAB');
-- add generic inventory to CAB
insert into unit_edl (unit_id, equipment_id, quantity) ((select '2', equipment_id, quantity
                                                         from generic_edl
                                                         where unit_type = 'CAB'));

-- populate climates: Conventional Hot Tropical, Conventional Hot Arid, Conventional Temperate, Conventional Cold
-- Integrated (CBRN wpn use anticipated) Hot Tropical, etc...
insert into climates (climate)
VALUES ('CHT'),
       ('CHA'),
       ('CT'),
       ('CC'),
       ('IHT'),
       ('IHA'),
       ('IT'),
       ('IC');

-- thought: if this app is used by higher-level OPT planners prior to detailed planning, there may not be any
-- logistician names to associate with units until some time after planning has begun.  We may want to default to best
-- guess for planning factors, human resources, and equip edl.  When a local unit logO

-- planning factors
insert into exercise_unit_planning_factors (unit_id, exercise_id, aslt_rom, aslt_op_hours, sustain_rom,
                                            sustain_op_hours, climate_id, min_class_one_water_gal,
                                            sustain_class_one_water_gals)
VALUES ('1', '1', 3.0, 18.0, 3.0, 12.0, (select id from climates where climate = 'CT'), 2.0, 7.0);

-- UI diagram modified to allow for personnel to be added to as many locations as needed (and custom location names).
-- i.e. AE, AFOE, etc.

-- TODO:validate all On Update/Delete constraints






