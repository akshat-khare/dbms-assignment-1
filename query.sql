\timing

--PREAMBLE--
create view cs1160315_paperidcount as select PaperId, count(PaperId) as co from paperByAuthors group by PaperId order by co desc, PaperId;
create view cs1160315_morethan20authors as select PaperId from cs1160315_paperidcount where co > 20;

create view cs1160315_allauthorid as select distinct AuthorId from PaperByAuthors;
create view cs1160315_soleauthorpaper as select PaperId from cs1160315_paperidcount where co=1;
create view cs1160315_authorwhohavesolepapers as select distinct AuthorId from cs1160315_soleauthorpaper, PaperByAuthors where cs1160315_soleauthorpaper.paperid = PaperByAuthors.paperid;
create view cs1160315_targetauthoridq4 as select * from cs1160315_allauthorid except select * from cs1160315_authorwhohavesolepapers;

create view cs1160315_authoridcount as select authorid, count(authorid) as co from paperbyauthors group by authorid order by co desc;
create view cs1160315_top20authorid as select * from cs1160315_authoridcount limit 20;

create view cs1160315_soleauthorpaperwithcount as select AuthorId, count(authorid) as co from cs1160315_soleauthorpaper, PaperByAuthors where cs1160315_soleauthorpaper.paperid = PaperByAuthors.paperid group by authorid order by co desc;
create view cs1160315_targetqueryq6 as select authorid from cs1160315_soleauthorpaperwithcount where co>50;
--1--
select type, count(type) as co from venue group by type order by co desc, type;
--2--
select avg(co) from cs1160315_paperidcount;
--3--
select Title from cs1160315_morethan20authors, Paper where cs1160315_morethan20authors.Paperid = Paper.Paperid order by Title;
--4--
select name from cs1160315_targetauthoridq4 left outer join author on cs1160315_targetauthoridq4.authorid = author.authorid order by name;
--5--
select name from cs1160315_top20authorid left outer join author on cs1160315_top20authorid.authorid = author.authorid order by co desc, name;
--6--
select name from cs1160315_targetqueryq6 left outer join author on cs1160315_targetqueryq6.authorid = author.authorid order by name;
--CLEANUP--
drop view cs1160315_targetqueryq6;
drop view cs1160315_soleauthorpaperwithcount;
drop view cs1160315_top20authorid;
drop view cs1160315_authoridcount;
drop view cs1160315_targetauthoridq4;
drop view cs1160315_authorwhohavesolepapers;
drop view cs1160315_soleauthorpaper;
drop view cs1160315_allauthorid;
drop view cs1160315_morethan20authors;
drop view cs1160315_paperidcount;