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

create view cs1160315_paperjvenue as select paper.paperid, paper.venueid, venue.type from paper, venue where paper.venueid = venue.venueid;
create view cs1160315_journalpapers as select paperid from cs1160315_paperjvenue where type='journals';
create view cs1160315_journalauthors as select distinct authorid from cs1160315_journalpapers ,paperbyauthors where cs1160315_journalpapers.paperid = paperbyauthors.paperid;
create view cs1160315_targetqueryq7 as select * from cs1160315_allauthorid except select * from cs1160315_journalauthors;


create view cs1160315_authorjpaperjvenue as select paperbyauthors.authorid, cs1160315_paperjvenue.paperid, cs1160315_paperjvenue.venueid, cs1160315_paperjvenue.type from paperbyauthors cross join cs1160315_paperjvenue where paperbyauthors.paperid = cs1160315_paperjvenue.paperid;
create view cs1160315_journalauthorid as select distinct authorid from cs1160315_authorjpaperjvenue where type='journals';
create view cs1160315_nonjournalauthorid as select distinct authorid from cs1160315_authorjpaperjvenue where type!='journals';
create view cs1160315_onlyjournalauthorid as select * from cs1160315_journalauthorid except select * from cs1160315_nonjournalauthorid;

create view cs1160315_authoridjpaperayear as select paperByAuthors.authorid, paper.paperid, paper.year from paperbyauthors cross join paper where paperbyauthors.paperid=paper.paperid;
create view cs1160315_authorpaperyearcount as select authorid, year, count(paperid) as co from cs1160315_authoridjpaperayear group by authorid, year;
create view cs1160315_targetqueryq9 as select distinct authorid from cs1160315_authorpaperyearcount where year=2012 and co>1 intersect select distinct authorid from cs1160315_authorpaperyearcount where year=2013 and co>2;

create view cs1160315_paperjvenueaname as select paper.paperid, paper.venueid, venue.type, venue.name from paper, venue where paper.venueid = venue.venueid;
create view cs1160315_authorjpaperjvenueaname as select paperbyauthors.authorid, cs1160315_paperjvenueaname.paperid, cs1160315_paperjvenueaname.venueid, cs1160315_paperjvenueaname.type, cs1160315_paperjvenueaname.name from paperbyauthors cross join cs1160315_paperjvenueaname where paperbyauthors.paperid = cs1160315_paperjvenueaname.paperid;
create view cs1160315_corrjournal as select * from cs1160315_authorjpaperjvenueaname where type='journals' and name='corr';
create view cs1160315_targetqueryq10 as select authorid, count(authorid) as co from cs1160315_corrjournal group by authorid order by co desc limit 20;

create view cs1160315_amcjournal as select * from cs1160315_authorjpaperjvenueaname where type='journals' and name='amc';
create view cs1160315_targetqueryq11interim as select authorid, count(authorid) as co from cs1160315_amcjournal group by authorid;
create view cs1160315_targetqueryq11 as select * from cs1160315_targetqueryq11interim where co>3;

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
--before this check the left outer joins, they are wrong probably--
--7--
select name from author, cs1160315_targetqueryq7 where author.authorid = cs1160315_targetqueryq7.authorid order by name;
--8--
select name from cs1160315_onlyjournalauthorid cross join author where cs1160315_onlyjournalauthorid.authorid=author.authorid order by name;
--9--
select name from cs1160315_targetqueryq9 cross join author where cs1160315_targetqueryq9.authorid = author.authorid order by name;
--10--
select name from cs1160315_targetqueryq10, author where cs1160315_targetqueryq10.authorid= author.authorid order by name;
--11--
select name from cs1160315_targetqueryq11, author where cs1160315_targetqueryq11.authorid=author.authorid order by name;
--12--


--CLEANUP--
drop view cs1160315_targetqueryq11;
drop view cs1160315_targetqueryq11interim;
drop view cs1160315_amcjournal;
drop view cs1160315_targetqueryq10;
drop view cs1160315_corrjournal;
drop view cs1160315_authorjpaperjvenueaname;
drop view cs1160315_paperjvenueaname;
drop view cs1160315_targetqueryq9;
drop view cs1160315_authorpaperyearcount;
drop view cs1160315_authoridjpaperayear;
drop view cs1160315_onlyjournalauthorid;
drop view cs1160315_nonjournalauthorid;
drop view cs1160315_journalauthorid;
drop view cs1160315_authorjpaperjvenue;
drop view cs1160315_targetqueryq7;
drop view cs1160315_journalauthors;
drop view cs1160315_journalpapers;
drop view cs1160315_paperjvenue;
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