--Arrange
declare
  l_mask     varchar2(20) := '[a-z]+\d+[a-z]+';
  l_string   varchar2(50) := 'asd123asd';
  l_result   integer;
begin
--Act
  ut_assert.is_matching(l_string, l_mask);
  l_result :=  ut_assert_processor.get_aggregate_asserts_result();
--Assert
  if l_result = ut_utils.tr_success then
    :test_result := ut_utils.tr_success;
  else
    dbms_output.put_line('expected: string like'''||l_mask||''', got: '''||l_result||'''' );
  end if;
end;
/
