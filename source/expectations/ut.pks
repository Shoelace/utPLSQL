create or replace package ut authid current_user as

  /**
  * Run suites/tests by path
  * Accepts value of the following formats:
  * schema - executes all suites in the schema
  * schema:suite1[.suite2] - executes all items of suite1 (suite2) in the schema. 
  *                          suite1.suite2 is a suitepath variable
  * schema:suite1[.suite2][.test1] - executes test1 in suite suite1.suite2
  * schema.suite1 - executes the suite package suite1 in the schema "schema"
  *                 all the parent suites in the hiearcy setups/teardown procedures as also executed
  *                 all chile items are executed
  * schema.suite1.test2 - executes test2 procedure of suite1 suite with execution of all 
  *                       parent setup/teardown procedures
  */
  procedure run(a_path in varchar2, a_reporter in ut_reporter);

  function expect(a_actual in anydata, a_message varchar2 := null) return ut_expectation_anydata;

  function expect(a_actual in blob, a_message varchar2 := null) return ut_expectation_blob;

  function expect(a_actual in boolean, a_message varchar2 := null) return ut_expectation_boolean;

  function expect(a_actual in clob, a_message varchar2 := null) return ut_expectation_clob;

  function expect(a_actual in date, a_message varchar2 := null) return ut_expectation_date;

  function expect(a_actual in number, a_message varchar2 := null) return ut_expectation_number;

  function expect(a_actual in sys_refcursor, a_message varchar2 := null) return ut_expectation_refcursor;

  function expect(a_actual in timestamp_unconstrained, a_message varchar2 := null) return ut_expectation_timestamp;

  function expect(a_actual in timestamp_ltz_unconstrained, a_message varchar2 := null) return ut_expectation_timestamp_ltz;

  function expect(a_actual in timestamp_tz_unconstrained, a_message varchar2 := null) return ut_expectation_timestamp_tz;

  function expect(a_actual in varchar2, a_message varchar2 := null) return ut_expectation_varchar2;

end ut;
/
