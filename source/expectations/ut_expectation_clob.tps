create or replace type ut_expectation_clob under ut_expectation
(
  overriding member procedure to_equal(self in ut_expectation_clob, a_expected clob, a_nulls_are_equal boolean := null),
  member procedure to_be_like(self in ut_expectation_clob, a_mask in varchar2, a_escape_char in varchar2 := null),
  member procedure to_match(self in ut_expectation_clob, a_pattern in varchar2, a_modifiers in varchar2 := null)
)
/
