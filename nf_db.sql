create database nf_db;
show databases;
use nf_db;

CREATE TABLE nf_data (
    show_id VARCHAR(10),
    type VARCHAR(20),
    title TEXT,
    director TEXT,
    cast TEXT,
    country TEXT,
    date_added TEXT,
    release_year text,
    rating text,
    duration VARCHAR(20),
    genre TEXT,
    description TEXT,
    duration_value text,
    duration_type text,
    year_added text,
    month_added VARCHAR(20),
    Q_added VARCHAR(5),
    content_age INT
);
set global local_infile=on;

LOAD DATA LOCAL INFILE 'C:/Users/VIJAYALAKSHMI/Desktop/sql/netflix_Dataset.csv'
INTO TABLE nf_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select * from nf_data;

select count(*) from nf_data;

create view kpi1 as
select count(distinct show_id) as total_shows from nf_data;

SELECT n1.show_id,n1.type, n1.title
FROM nf_data n1
JOIN (
    SELECT title
    FROM nf_data
    GROUP BY title
    HAVING COUNT(DISTINCT show_id) > 1
) n2
ON n1.title = n2.title
ORDER BY n1.title, n1.show_id;

create view kpi2 as
SELECT type, COUNT(DISTINCT show_id) AS total
FROM nf_data
where type='movie'
GROUP BY type;

create view kpi3 as
SELECT type, COUNT(DISTINCT show_id) AS total
FROM nf_data
where type='tv show'
GROUP BY type;

create view kpi4 as
select type, avg(duration_value) as average_duration from nf_data 
where type='movie'
group by type; 

create view kpi5 as
select type, avg(duration_value) as average_duration from nf_data 
where type='tv show'
group by type;

create view content_trend_by_genre as
select genre, count(distinct show_id) as total_shows from nf_data 
group by genre order by total_shows desc; 

create view content_production_by_country as
select country,count(distinct show_id) as total_shows from nf_data 
group by country order by total_shows desc;

describe nf_data;

set sql_safe_updates=0;

update nf_data
set date_added = null
where date_added ='';

update nf_data
set date_added= str_to_date(date_added,'%d-%m-%Y')
where date_added is not null;

alter table nf_data
modify date_added date; 

alter table nf_data
modify release_year year;

update nf_data
set year_added = null
where year_added ='';

update nf_data
set year_added = 1901
where year_added < 1901;

alter table nf_data
modify year_added year;

update nf_data 
set duration_value=null 
where duration_value='';

alter table nf_data 
modify duration_value int;

select release_year, count(distinct show_id) as total_shows from nf_data 
group by release_year;

select year_added, count(distinct show_id) as total_shows from nf_data 
group by year_added;

create view release_of_content as
select release_year, Q_added, count(distinct show_id) as total_shows from nf_data 
group by release_year, Q_added;

create view adding_of_content as
select year_added, Q_added,count(distinct show_id) as total_shows from nf_data 
group by year_added, Q_added;

create view focus_on_old_or_new_content as
select content_age, count(distinct show_id) as total_shows from nf_data
group by content_age order by total_shows desc limit 10;
select*from focus_on_old_or_new_content;

show full tables where Table_type='VIEW';
show tables;

create table nf_data_backup as 
select* from nf_data;