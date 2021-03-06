PROMPT Parse procedure level annotations with annotations mixed with comments

--Arrange
declare
  l_source clob;
  l_parsing_result ut_annotations.typ_annotated_package;
  l_expected ut_annotations.typ_annotated_package;
  l_ann_param ut_annotations.typ_annotation_param;

begin
  l_source := 'PACKAGE test_tt AS
  -- %suite(Name of suite)
  -- %suitepackage(all.globaltests)
  
  -- %ann1(Name of suite)
  -- wrong line
  -- %ann2(some_value)  
  procedure foo;
END;';

--Act
  l_parsing_result := ut_annotations.parse_package_annotations(l_source);
  
--Assert
  l_ann_param := null;
  l_ann_param.val := 'Name of suite'; 
  l_expected.package_annotations('suite')(1) := l_ann_param;
  
  l_ann_param := null;
  l_ann_param.val := 'all.globaltests';  
  l_expected.package_annotations('suitepackage')(1) := l_ann_param;
  
  l_ann_param := null;
  l_ann_param.val := 'some_value';  
  l_expected.procedure_annotations('foo')('ann2')(1) := l_ann_param;
  
  check_annotation_parsing(l_expected, l_parsing_result);
  
  if ut_assert_processor.get_aggregate_asserts_result = ut_utils.tr_success then
    :test_result := ut_utils.tr_success;
  end if;

end;
/
