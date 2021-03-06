PROMPT Gives a success when comparing equal oracle objects
--Arrange
declare
  l_expected department$ := department$('HR');
  l_actual   department$ := department$('IT');
  l_result   integer;
begin
--Act
  ut_assert.are_equal( anydata.convertObject(l_expected), anydata.convertObject(l_actual) );
  l_result :=  ut_assert_processor.get_aggregate_asserts_result();
--Assert
  if l_result = ut_utils.tr_failure then
    :test_result := ut_utils.tr_success;
  else
    dbms_output.put_line('expected: '''||ut_utils.tr_failure||''', got: '''||l_result||'''' );
  end if;
end;
/
