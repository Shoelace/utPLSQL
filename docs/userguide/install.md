# Installation

##Recommended Schema
It is recommended that utPLSQL be placed in it's own schema.   You are free to choose any name for this schema.

The installation user/schema must have the following Oracle system permissions during the installation.
TODO: Verify this list.
  - CREATE SESSION
  - CREATE TABLE
  - CREATE SYNONYM
  - CREATE PROCEDURE
  - CREATE TRIGGER
  - CREATE TYPE
  
In addition it must be granted execute to the following system packages.

  - dbms_crypto  
  
TODO: Verify what we need for running permissions.
  
TODO: Create Script that will automatically create user "utplsql" with the permissions that can be run by DBA if desired
 
# Installation Procedure

To install run the `/source/install.sql` script.   You must connect to the database as the user/schema where you want utPLSQL located.

The following tools that support the SQL*Plus commands can be used to run the installation script
  - SQL*Plus 
  - Oracle SQL Developer
  - TOAD Script Runner 
  
TODO: Verify, Toad Script Runner, is a valid option as it may have broken.
 
# Uninstall

To uninstall run `/source/uninstall.sql`.   If you have you have extended any utPLSQL types such as a custom reporter, these will need to be dropped before the uninstall script will run successfully.





