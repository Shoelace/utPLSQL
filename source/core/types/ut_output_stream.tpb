create or replace type body ut_output_stream as

  overriding final member procedure close(self in out nocopy ut_output_stream) is
  begin
    self.close( a_timeout_sec=>60 );
  end;

  overriding final member function get_lines(a_output_id varchar2) return ut_varchar2_list pipelined is
  begin
    for i in ( select column_value from table( self.get_lines(a_output_id, 60*60*4) ) ) loop
      pipe row(i.column_value);
    end loop;
    return;
  end;

  overriding final member function get_clob_lines(a_output_id varchar2) return ut_clob_list pipelined is
  begin
    for i in ( select column_value from table( self.get_clob_lines(a_output_id, 60*60*4) ) ) loop
      pipe row(i.column_value);
    end loop;
    return;
  end;

end;
/
