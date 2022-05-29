create database masicsql;

C:\PostgreSQL\14\bin\psql.exe -U postgres -d masicsql
postgre1984




/* ２．*/





/*コラム ６．相関サブクエリ（WHERE）について理解を深めた＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝*/

create table teams(
  member varchar(20) not null,
  team_id integer not null,
  status varchar(20) not null
);

insert into teams values('ジョー', 1, '待機');
insert into teams values('ケン', 1, '出動中');
insert into teams values('ミック', 1, '待機');
insert into teams values('カレン', 2, '出動中');
insert into teams values('キース', 2, '休暇');
insert into teams values('ジャン', 3, '待機');
insert into teams values('ハート', 3, '待機');
insert into teams values('ディック', 3, '待機');
insert into teams values('ベス', 4, '待機');
insert into teams values('アレン', 5, '出動中');
insert into teams values('ロバート', 5, '休暇');
insert into teams values('ケーガン', 5, '待機');


select team_id, member
  from teams as T1
  where not exists(
    select * from teams as T2 where T1.team_id = T2.team_id and status <> '待機'
  )
;

select team_id from teams where status <> '待機' group by team_id; 


/* １．Case式のススメ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝*/

create table Poptable(
    pref_name varchar(10) not null,
    population integer not null,
    primary key (pref_name)
);

insert into poptable values('徳島', 100);
insert into poptable values('香川', 200);
insert into poptable values('愛媛', 150);
insert into poptable values('高知', 200);
insert into poptable values('福岡', 300);
insert into poptable values('佐賀', 100);
insert into poptable values('長崎', 200);
insert into poptable values('東京', 400);
insert into poptable values('群馬', 50);


select
  case pref_name
      when '徳島' then '四国'
      when '香川' then '四国'
      when '愛媛' then '四国'
      when '高知' then '四国'
      when '福岡' then '九州'
      when '佐賀' then '九州'
      when '長崎' then '九州'
    else 'その他' end as district,
  sum(population) as pop
  from poptable
  group by case pref_name
      when '徳島' then '四国'
      when '香川' then '四国'
      when '愛媛' then '四国'
      when '高知' then '四国'
      when '福岡' then '九州'
      when '佐賀' then '九州'
      when '長崎' then '九州'
    else 'その他' end
  order by pop;

select
    case
      when population < 100 then '01'
      when population >= 100 and population < 200 then '02'
      when population >= 200 and population < 300 then '03'
      when population >= 300 then '04'
    else null end as poprabel,
    count(*) as cnt
  from poptable
  group by poprabel   /*これは特定のRDBMSでしか書けない*/
  order by poprabel;


create table potable2(
  pref_name varchar(20) not null,
  sex integer not null,
  population integer not null
);

insert into potable2(pref_name, sex, population) values('徳島', 1, 60);
insert into potable2(pref_name, sex, population) values('徳島', 2, 40);
insert into potable2(pref_name, sex, population) values('香川', 1, 100);
insert into potable2(pref_name, sex, population) values('香川', 2, 100);
insert into potable2(pref_name, sex, population) values('愛媛', 1, 100);
insert into potable2(pref_name, sex, population) values('愛媛', 2, 50);
insert into potable2(pref_name, sex, population) values('高知', 1, 100);
insert into potable2(pref_name, sex, population) values('高知', 2, 100);
insert into potable2(pref_name, sex, population) values('福岡', 1, 100);
insert into potable2(pref_name, sex, population) values('福岡', 2, 200);
insert into potable2(pref_name, sex, population) values('佐賀', 1, 20);
insert into potable2(pref_name, sex, population) values('佐賀', 2, 80);
insert into potable2(pref_name, sex, population) values('長崎', 1, 125);
insert into potable2(pref_name, sex, population) values('長崎', 2, 125);
insert into potable2(pref_name, sex, population) values('東京', 1, 250);
insert into potable2(pref_name, sex, population) values('東京', 2, 150);


select pref_name, population as p1
from potable2
where sex = 1
union
select pref_name, population as p2
from potable2 as pp2
where sex = 2;

select pref_name,
  sum(case when sex = 1 then population else 0 end) as p1,
  sum(case when sex = 2 then population else 0 end) as p2
from potable2
group by pref_name;

select
  case pref_name
      when '高知' then '四国' 
      when '香川' then '四国' 
      when '徳島' then '四国' 
      when '愛媛' then '四国' 
      when '佐賀' then '九州' 
      when '長崎' then '九州'
      when '福岡' then '九州'
    else 'その他' end as area, 
  sum(case when sex = 1 then population else 0 end) as p1,
  sum(case when sex = 2 then population else 0 end) as p2,
  sum(population) as pall
from potable2
group by area
order by pall desc, p1 desc;

create table potable3(
  sex integer not null ,
  salary integer not null,
  constraint check_salary check(
      case when sex = '2'
        then case when salary <= 200000
          then 1 else 0 end
        else 1 end = 1
    )
);

alter table potable3 add column
  name varchar(20) not null
;

insert into potable3 values(1, 300000, '相田');
insert into potable3 values(1, 270000, '神崎');
insert into potable3 values(1, 220000, '木村');
insert into potable3 values(1, 290000, '斉藤');

update potable3
  set salary = case
    when salary >= 300000 then salary * 0.9
    when salary >= 250000 and salary < 280000 then salary * 1.2
    else salary
  end
;

create table sometable(
  p_key varchar(1) not null,
  col_1 integer not null,
  col_2 varchar(3) not null,
  primary key(p_key) DEFERRABLE INITIALLY DEFERRED
);

/*遅延製薬の設定方法*/
/*https://qiita.com/ariaki/items/9c9cee0cc763964a4ed2*/
/*CREATE TABLE posts2(
    id integer NOT NULL,
    CONSTRAINT posts2_pk PRIMARY KEY (id) DEFERRABLE INITIALLY DEFERRED
);*/

insert into sometable values('a', 1, 'あ');
insert into sometable values('b', 2, 'い');
insert into sometable values('c', 3, 'う');

update sometable
  set p_key = case
    when p_key = 'a' then 'b'
    when p_key = 'b' then 'a'
  else p_key end
where p_key in ('a', 'b');



create table coursemaster(
  course_id integer not null,
  course_name varchar(20) not null,
  primary key(course_id)
);


insert into coursemaster values(1,'経済入門');
insert into coursemaster values(2,'財務知識');
insert into coursemaster values(3,'簿記検定開講講座');
insert into coursemaster values(4,'税理士');

create table opencourses(
  course_month integer not null,
  course_id integer not null
);

insert into opencourses values(201806, 1);
insert into opencourses values(201806, 3);
insert into opencourses values(201806, 4);
insert into opencourses values(201807, 4);
insert into opencourses values(201808, 2);
insert into opencourses values(201808, 4);


select course_name, 
  case 
    when course_id in (select course_id 
      from opencourses 
      where course_month = 201806
      ) then 1 
  else 0 end as "6月",
  case 
    when course_id in (select course_id 
      from opencourses 
      where course_month = 201807
      ) then 1 
  else 0 end as "7月",
  case 
    when course_id in (select course_id 
      from opencourses 
      where course_month = 201808
      ) then 1 
  else 0 end as "8月"
from coursemaster;


select cm.course_name,
  case when exists(
    select course_id from opencourses as oc
      where course_month = 201806
      and oc.course_id = cm.course_id
    ) then 1
  else 0 end as "6月",
  case when exists(
    select course_id from opencourses as oc
      where course_month = 201807
      and oc.course_id = cm.course_id
    ) then 1
  else 0 end as "7月",
  case when exists(
    select course_id from opencourses as oc
      where course_month = 201808
      and oc.course_id = cm.course_id
    ) then 1
  else 0 end as "8月"
from coursemaster as cm;


create table studentc(
  std_id integer not null,
  club_id integer not null,
  club_name varchar(30) not null,
  main_club_flg char(1) not null
);

insert into studentc values(100, 1, '野球', 'Y');
insert into studentc values(100, 2, '吹奏楽', 'N');
insert into studentc values(200, 2, '吹奏楽', 'N');
insert into studentc values(200, 3, 'バドミントン', 'Y');
insert into studentc values(200, 4, 'サッカー', 'N');
insert into studentc values(300, 4, 'サッカー', 'N');
insert into studentc values(400, 5, '水泳', 'N');
insert into studentc values(500, 6, '囲碁', 'N');


select std_id, max(club_id) as main_club
  from studentc
  group by std_id
  having count(*)=1;

select std_id, club_id as main_club
  from studentc
  where main_club_flg ='Y';

Select std_id, 
    case when count(*)=1 then max(club_id)
      else max(
        case when main_club_flg ='Y' then club_id 
          else null
        end)
    end as main_club
  from studentc
  group by std_id
  order by std_id;

create table greatests(
  key char(1),
  x integer,
  y integer,
  z integer
);

insert into greatests values('A',1,2,3);
insert into greatests values('B',5,5,2);
insert into greatests values('C',4,7,1);
insert into greatests values('D',3,3,8);

select key, 
    case when x < y then y else x end as greatest
  from greatests;

select key, 
    case when x > y then 
        case when x > z then x else z end 
      else 
        case when y > z then y else z end 
    end as greatest
  from greatests;

select sex as "性別", 
    sum(population) as "全国",
    sum(case when pref_name ='徳島' then population else 0 end) as "徳島",
    sum(case when pref_name ='香川' then population else 0 end) as "香川",
    sum(case when pref_name ='愛媛' then population else 0 end) as "愛媛",
    sum(case when pref_name ='高知' then population else 0 end) as "高知",
    sum(case when pref_name ='徳島' or pref_name ='香川' or pref_name ='愛媛' or pref_name ='高知' then population else 0 end) as "四国（再掲）"
  from potable2
  group by sex
  order by sex
;

select key, 
    case when x > y then 
        case when x > z then x else z end 
      else 
        case when y > z then y else z end 
    end as greatest
  from greatests
  order by 
    case when key ='B' then 1 else
      case when key ='A' then 2 else
        case when key ='D' then 3 else
          case when key ='C' then 4 else 0 end
        end
      end
    end
;


select key, 
    case when x > y then 
        case when x > z then x else z end 
      else 
        case when y > z then y else z end 
    end as greatest
  from greatests
  order by 
    case
      when key ='B' then 1
      when key ='A' then 2
      when key ='D' then 3
      when key ='C' then 4
    else 0 end
;

select key, max(col)
  from(
    select key, x as col from greatests
    union all
    select key, y as col from greatests
    union all
    select key, z as col from greatests
  ) as tmp
  group by key
  order by key
;

select key, greatest(greatest(x,y),z) as greatest from greatests;


