create or replace package body ut_metadata as

  ------------------------------
  --private definitions
  g_source_view varchar2(32);

  ------------------------------
  --public definitions

  procedure do_resolve(a_owner in out nocopy varchar2, a_object in out nocopy varchar2) is
    l_procedure_name  varchar2(200);
  begin
    do_resolve(a_owner, a_object, l_procedure_name );
  end do_resolve;

  procedure do_resolve(a_owner in out nocopy varchar2, a_object in out nocopy varchar2, a_procedure_name in out nocopy varchar2) is
    l_name          varchar2(200);
    l_context       integer := 1; --plsql
    l_dblink        varchar2(200);
    l_part1_type    number;
    l_object_number number;
  begin
    l_name := form_name(a_owner, a_object, a_procedure_name);

    dbms_utility.name_resolve(name          => l_name
                             ,context       => l_context
                             ,schema        => a_owner
                             ,part1         => a_object
                             ,part2         => a_procedure_name
                             ,dblink        => l_dblink
                             ,part1_type    => l_part1_type
                             ,object_number => l_object_number);

/*
exception
when others then
dbms_output.put_line(SQLERRM);
raise;*/

  end do_resolve;

  function form_name(a_owner_name varchar2, a_object varchar2, a_subprogram varchar2 default null) return varchar2 is
    l_name varchar2(200);
  begin
    l_name := trim(a_object);
    if trim(a_owner_name) is not null then
      l_name := trim(a_owner_name) || '.' || l_name;
    end if;
    if trim(a_subprogram) is not null then
      l_name := l_name || '.' || trim(a_subprogram);
    end if;
    return l_name;
  end form_name;

  function package_valid(a_owner_name varchar2, a_package_name in varchar2) return boolean as
    l_cnt            number;
    l_schema         varchar2(200);
    l_package_name   varchar2(200);
    l_procedure_name varchar2(200);
  begin

    l_schema       := a_owner_name;
    l_package_name := a_package_name;

    do_resolve(l_schema, l_package_name, l_procedure_name);

    select count(decode(status, 'VALID', 1, null)) / count(*)
      into l_cnt
      from all_objects
     where owner = l_schema
       and object_name = l_package_name
       and object_type in ('PACKAGE', 'PACKAGE BODY');

    -- expect both package and body to be valid
    return l_cnt = 1;
  exception
    when others then
      return false;
  end;

  function procedure_exists(a_owner_name varchar2, a_package_name in varchar2, a_procedure_name in varchar2)
    return boolean as
    l_cnt            number;
    l_schema         varchar2(200);
    l_package_name   varchar2(200);
    l_procedure_name varchar2(200);
  begin

    l_schema         := a_owner_name;
    l_package_name   := a_package_name;
    l_procedure_name := a_procedure_name;

    do_resolve(l_schema, l_package_name, l_procedure_name);

    select count(*)
      into l_cnt
      from all_procedures
     where owner = l_schema
       and object_name = l_package_name
       and procedure_name = l_procedure_name;

    --expect one method only for the package with that name.
    return l_cnt = 1;
  exception
    when others then
      return false;
  end;


  function get_package_spec_source(a_owner varchar2, a_object_name varchar2) return clob is
    l_txt_tab ut_varchar2_list;
  l_source_lines sys.dbms_preprocessor.source_lines_t;

  begin
    dbms_lob.createtemporary(l_source, true);
    

  l_source_lines := SYS.DBMS_PREPROCESSOR.GET_POST_PROCESSED_SOURCE(
    OBJECT_TYPE => 'PACKAGE',
    SCHEMA_NAME => a_owner,
    OBJECT_NAME => a_object_name
  );

 for i in 1 .. l_source_lines.count LOOP
      dbms_lob.writeappend(l_source, length(l_source_lines(i)), l_source_lines(i));
 END LOOP;


    /*l_cur := get_package_spec_source_cursor(a_owner, a_object_name);
    fetch l_cur bulk collect into l_txt_tab;
    for i in 1 .. cardinality(l_txt_tab) loop
      dbms_lob.writeappend(l_source, length(l_txt_tab(i)), l_txt_tab(i));
    end loop;
    close l_cur;*/
    
    return l_source;

  function get_source_definition_line(a_owner varchar2, a_object_name varchar2, a_line_no integer) return varchar2 is
    l_line varchar2(4000);
  begin
    execute immediate
      'select text from ' || get_source_view() || q'[
          where owner = :a_owner and name = :a_object_name and line = :a_line_no
             -- skip the declarations, consider only definitions
            and type != 'PACKAGE' ]'
      into l_line using a_owner, a_object_name, a_line_no;
    return '"'||ltrim(rtrim( lower( l_line ), chr(10) ))||'"';
  exception
    when no_data_found then
      return null;
  end;

end;
/
