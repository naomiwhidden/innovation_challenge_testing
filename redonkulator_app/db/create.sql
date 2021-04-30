-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE =
        'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema redonkulator
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `redonkulator`;

-- -----------------------------------------------------
-- Schema redonkulator
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `redonkulator` DEFAULT CHARACTER SET utf8;
USE `redonkulator`;

-- -----------------------------------------------------
-- Table `redonkulator`.`exercises`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `redonkulator`.`exercises`;

CREATE TABLE IF NOT EXISTS `redonkulator`.`exercises`
(
    `id`         INT                                 NOT NULL AUTO_INCREMENT,
    `exercise`   VARCHAR(45) CHARACTER SET 'utf8mb4' NOT NULL,
    `evolution`  VARCHAR(8) CHARACTER SET 'utf8mb4'  NOT NULL COMMENT 'Sequence, typically in the form of month-year or just year, depending on the frequency.',
    `start_date` DATETIME                            NULL,
    `end_date`   DATETIME                            NULL,
    `logo`       BLOB                                NULL,
    UNIQUE INDEX `exercise_evolution_UNIQUE` (`exercise` ASC, `evolution` ASC) VISIBLE,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `redonkulator`.`units`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `redonkulator`.`units`;

CREATE TABLE IF NOT EXISTS `redonkulator`.`units`
(
    `id`         INT         NOT NULL AUTO_INCREMENT,
    `uic`        VARCHAR(45) NOT NULL,
    `short_name` VARCHAR(45) NOT NULL,
    `long_name`  VARCHAR(45) NOT NULL,
    `mcc`        VARCHAR(45) NULL,
    `ruc`        VARCHAR(45) NULL,
    `type`       VARCHAR(45) NULL,
    UNIQUE INDEX `short_name_UNIQUE` (`short_name` ASC) VISIBLE,
    UNIQUE INDEX `long_name_UNIQUE` (`long_name` ASC) VISIBLE,
    UNIQUE INDEX `uic_UNIQUE` (`uic` ASC) VISIBLE,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `mcc_UNIQUE` (`mcc` ASC) VISIBLE,
    UNIQUE INDEX `ruc_UNIQUE` (`ruc` ASC) VISIBLE
)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `redonkulator`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `redonkulator`.`users`;

CREATE TABLE IF NOT EXISTS `redonkulator`.`users`
(
    `id`           INT         NOT NULL AUTO_INCREMENT,
    `email`        VARCHAR(45) NOT NULL,
    `edipi`        INT         NULL,
    `display_name` VARCHAR(45) NULL,
    `phone`        VARCHAR(45) NULL,
    UNIQUE INDEX `edipi_UNIQUE` (`edipi` ASC) VISIBLE,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE
)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `redonkulator`.`permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `redonkulator`.`permissions`;

CREATE TABLE IF NOT EXISTS `redonkulator`.`permissions`
(
    `id`             INT NOT NULL AUTO_INCREMENT,
    `unit_id`        INT NOT NULL,
    `exercise_id`    INT NOT NULL,
    `parent_user_id` INT NULL,
    `user_id`        INT NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `unit_exercise_user` (`user_id` ASC, `exercise_id` ASC, `unit_id` ASC) VISIBLE,
    INDEX `fk_permissions_units1_idx` (`unit_id` ASC) VISIBLE,
    INDEX `fk_permissions_exercises1_idx` (`exercise_id` ASC) VISIBLE,
    INDEX `fk_permissions_users1_idx` (`parent_user_id` ASC) VISIBLE,
    CONSTRAINT `fk_permissions_units1`
        FOREIGN KEY (`unit_id`)
            REFERENCES `redonkulator`.`units` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT `fk_permissions_exercises1`
        FOREIGN KEY (`exercise_id`)
            REFERENCES `redonkulator`.`exercises` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT `fk_permissions_users1`
        FOREIGN KEY (`parent_user_id`)
            REFERENCES `redonkulator`.`users` (`id`)
            ON DELETE SET NULL
            ON UPDATE CASCADE,
    CONSTRAINT `fk_permissions_users2`
        FOREIGN KEY (`user_id`)
            REFERENCES `redonkulator`.`users` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE
)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `redonkulator`.`after_actions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `redonkulator`.`after_actions`;

CREATE TABLE IF NOT EXISTS `redonkulator`.`after_actions`
(
    `id`          INT  NOT NULL AUTO_INCREMENT,
    `exercise_id` INT  NULL,
    `data`        BLOB NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_after_actions_exercises1_idx` (`exercise_id` ASC) VISIBLE,
    CONSTRAINT `fk_after_actions_exercises1`
        FOREIGN KEY (`exercise_id`)
            REFERENCES `redonkulator`.`exercises` (`id`)
            ON DELETE RESTRICT
            ON UPDATE CASCADE
)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `redonkulator`.`equipment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `redonkulator`.`equipment`;

CREATE TABLE IF NOT EXISTS `redonkulator`.`equipment`
(
    `id`                     INT           NOT NULL AUTO_INCREMENT,
    `tamcn`                  VARCHAR(16)   NOT NULL,
    `nomen`                  VARCHAR(45)   NULL,
    `type`                   VARCHAR(45)   NULL,
    `length`                 DECIMAL(8, 2) NULL,
    `width`                  DECIMAL(8, 2) NULL,
    `height`                 DECIMAL(8, 2) NULL,
    `sqft`                   DECIMAL(8, 2) NULL,
    `cuft`                   DECIMAL(8, 2) NULL,
    `gvw_combat_loaded`      DECIMAL(8, 2) NULL,
    `fuel_capacity`          DECIMAL(8, 2) NULL,
    `burn_rate`              DECIMAL(8, 2) NULL COMMENT 'MPG or MPH',
    `crew`                   INT           NULL,
    `passengers`             INT           NULL,
    `fuel_payload`           DECIMAL(8, 2) NULL,
    `water_payload`          DECIMAL(8, 2) NULL,
    `payload`                DECIMAL(8, 2) NULL,
    `pallets_palcons`        INT           NULL,
    `sixcon_transpo`         INT           NULL,
    `quadcon`                INT           NULL,
    `isocon`                 INT           NULL,
    `combat_load_pallet`     INT           NULL,
    `combat_load_pallet_wt`  DECIMAL(8, 2) NULL,
    `aslt_rate_pallet`       DECIMAL(8, 2) NULL,
    `aslt_rate_pallet_wt`    DECIMAL(8, 2) NULL,
    `sustain_rate_pallet`    DECIMAL(7, 2) NULL,
    `sustain_rate_pallet_wt` DECIMAL(7, 2) NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `redonkulator`.`unit_inventory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `redonkulator`.`unit_inventory`;

CREATE TABLE IF NOT EXISTS `redonkulator`.`unit_inventory`
(
    `id`           INT NOT NULL AUTO_INCREMENT,
    `unit_id`      INT NULL,
    `equipment_id` INT NULL,
    `on_hand`      INT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_unit_inventory_units_idx` (`unit_id` ASC) VISIBLE,
    INDEX `fk_unit_invetory_equipment1_idx` (`equipment_id` ASC) VISIBLE,
    CONSTRAINT `fk_unit_inventory_units`
        FOREIGN KEY (`unit_id`)
            REFERENCES `redonkulator`.`units` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT `fk_unit_inventory_equipment1`
        FOREIGN KEY (`equipment_id`)
            REFERENCES `redonkulator`.`equipment` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE
)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `redonkulator`.`equip_utilization`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `redonkulator`.`equip_utilization`;

CREATE TABLE IF NOT EXISTS `redonkulator`.`equip_utilization`
(
    `id`           INT         NOT NULL AUTO_INCREMENT,
    `unit_id`      INT         NOT NULL,
    `exercises_id` INT         NULL,
    `qty`          INT         NOT NULL,
    `location`     VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_equip_utilization_exercises1_idx` (`exercises_id` ASC) VISIBLE,
    INDEX `fk_equip_utilization_units1_idx` (`unit_id` ASC) VISIBLE,
    CONSTRAINT `fk_equip_utilization_exercises1`
        FOREIGN KEY (`exercises_id`)
            REFERENCES `redonkulator`.`exercises` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT `fk_equip_utilization_units1`
        FOREIGN KEY (`unit_id`)
            REFERENCES `redonkulator`.`units` (`id`)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
)
    ENGINE = InnoDB;


SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;
