CREATE TABLE SHIPMENTS
(
  customer varchar2(40),
  type varchar2(1) default 'i' not null,
  status number default 0,
  load_lat number(8,6),
  load_lon number(8,6),
  load_date date,
  load_time varchar2(10),
  unload_lat number(8,6),
  unload_lon number(8,6),
  unload_date date,
  unload_time varchar2(10),
  goodtype varchar2(4) not null,
  goodqty number,
  fieldYN1 varchar2(1),
  fieldYN2 varchar2(1),
  num number primary key
);

drop table shipments;

create sequence shipments_seq increment by 1 start with 1000;


create or replace trigger shipments_tri
  before insert on shipments
  for each row
begin
  if :new.num is null then
    select shipments_seq.nextval into :new.num from dual;
  end if;
end;

drop trigger shipments_tri;

drop table orders;

CREATE TABLE ORDERS
(
  order_id number,
  shipment_num number,
  load_date date,
  load_time varchar2(10),
  load_timetosec number,
  load_lat number(8,2),
  load_lon number(8,2),
  unload_date date,
  unload_time varchar2(10),
  unload_timetosec number,
  unload_lat number(8,6),
  unload_lon number(8,6),
  trip_num number
);
