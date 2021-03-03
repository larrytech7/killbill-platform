-- SQL server doesn't have any object called serial, so first we want to create a new type alias for serial based on the int type
--DROP TYPE IF EXISTS serial;
--CREATE  TYPE serial FROM INT NOT NULL;

-- DROP TYPE IF EXISTS bool;
-- CREATE TYPE  bool FROM bit NOT NULL;