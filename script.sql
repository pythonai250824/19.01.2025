-- create with check
CREATE TABLE COMPANY2(
ID INT PRIMARY KEY NOT NULL,
NAME TEXT NOT NULL,
AGE INT NOT NULL,
ADDRESS CHAR(50),
SALARY REAL CHECK(SALARY > 0)
);

-- create if not exists with check
CREATE TABLE if not exists parent (
    serial_id INTEGER PRIMARY KEY AUTOINCREMENT,
	id TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL
	CHECK (LENGTH(name) > 4)
);

-- on delete cascade
CREATE TABLE child (
    serial_id INTEGER PRIMARY KEY,
	child_id TEXT NOT NULL,
    parent_serial_id INTEGER UNIQUE NOT NULL,
    description TEXT,
    FOREIGN KEY (parent_serial_id) REFERENCES parent (serial_id)
	   ON DELETE CASCADE
);

-- 1 insert 1
INSERT INTO parent (id, name) VALUES (1, 'Parent 1');

-- 2 insert many
INSERT INTO parent (id, name) VALUES
	(4, 'Parent 4'),
	(5, 'Parent 5'),
	(6, 'Parent 6'),
	(7, 'Parent 7');

-- 3 insert from select query
INSERT INTO parent(id, name)
SELECT id , name FROM parent_prev
where id >= 8;

-- 4 insert-or-update upsert
-- if exist then update ... customize
-- when update does not increase the autoincrement key by 1
INSERT into parent(id, name)
values (9, 'danny')
on conflict (id)
do update set name='danny2';

-- raises auto-increment
-- will override or insert the same row
-- increase the autoincrement key by 1
INSERT OR REPLACE into parent (id, name) values (10, 'masha2');

-- how to implement auto-increment
-- cast id to integer since it was defined as TEXT
update parent
set id = (select CAST(id as integer) + 1 from parent
		  order by CAST(id as integer) desc
		  limit 1)
where id = (select CAST(id as integer) from parent
		  order by CAST(id as integer) desc
		  limit 1);