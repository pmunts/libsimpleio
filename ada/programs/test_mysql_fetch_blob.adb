-- MySQL Binary Blob Fetch Test

-- Copyright (C)2026, Philip Munts dba Munts Technologies.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

-- TEST PROCEDURE:
--
-- # Very large blobs may require increasing max_allowed_packet:
--
-- cat <<EOD >>/etc/mysql/conf.d/mysql.cnf
-- [mysqld]
-- max_allowed_packet=1G
-- EOD
-- /etc/init.d/mariadb restart
--
-- # Create some blobs, and make them readable by the MySQL server process:
--
-- dd if=/dev/random of=blob1.bin bs=1M count=500
-- dd if=/dev/random of=blob2.bin bs=1M count=500
-- dd if=/dev/random of=blob3.bin bs=1M count=500
--
-- md5sum -b blob1.bin >blob1.md5
-- md5sum -b blob2.bin >blob2.md5
-- md5sum -b blob3.bin >blob3.md5
--
-- chmod 444 blob*.bin
-- mv blob*.bin /tmp
-- sudo chown mysql:mysql /tmp/blob*
--
-- ls -l /tmp/blob*
-- -r--r--r-- 1 mysql mysql 1048576 Jan 15 13:44 /tmp/blob1.bin
-- -r--r--r-- 1 mysql mysql      44 Jan 15 13:44 /tmp/blob1.md5
-- -r--r--r-- 1 mysql mysql 1048576 Jan 15 13:44 /tmp/blob2.bin
-- -r--r--r-- 1 mysql mysql      44 Jan 15 13:44 /tmp/blob2.md5
-- -r--r--r-- 1 mysql mysql 1048576 Jan 15 13:44 /tmp/blob3.bin
-- -r--r--r-- 1 mysql mysql      44 Jan 15 13:44 /tmp/blob3.md5
--
-- # Create a simple table of blobs, as database root user:
--
-- mysql -p -u root
-- MariaDB [(none)]> use test1
-- MariaDB [test1]> drop table Blobs;
-- MariaDB [test1]> create table Blobs(ID int, data longblob not null, primary key(ID));
-- Query OK, 0 rows affected (0.013 sec)
--
-- MariaDB [test1]> show tables ;
-- +-----------------+
-- | Tables_in_test1 |
-- +-----------------+
-- | Blobs           |
-- +-----------------+
-- 3 rows in set (0.001 sec)
--
-- MariaDB [test1]> show fields from Blobs ;
-- +-------+----------+------+-----+---------+-------+
-- | Field | Type     | Null | Key | Default | Extra |
-- +-------+----------+------+-----+---------+-------+
-- | ID    | int(11)  | NO   | PRI | NULL    |       |
-- | data  | longblob | NO   |     | NULL    |       |
-- +-------+----------+------+-----+---------+-------+
-- 2 rows in set (0.001 sec)
--
-- MariaDB [test1]> insert into Blobs values(1, load_file('/tmp/blob1.bin'));
-- Query OK, 1 row affected (0.086 sec)
--
-- MariaDB [test1]> insert into Blobs values(2, load_file('/tmp/blob2.bin'));
-- Query OK, 1 row affected (0.017 sec)
--
-- MariaDB [test1]> insert into Blobs values(3, load_file('/tmp/blob3.bin'));
-- Query OK, 1 row affected (0.018 sec)
--
-- MariaDB [test1]> select ID from Blobs ;
-- +----+
-- | ID |
-- +----+
-- |  1 |
-- |  2 |
-- |  3 |
-- +----+
-- 3 rows in set (0.001 sec)
--
-- MariaDB [test1]>
-- Bye
--
-- # Verify that a normal user can read the Blobs table:
--
-- mysql -p
-- MariaDB [(none)]> use test1
-- MariaDB [test1]> select ID from Blobs ;
-- +----+
-- | ID |
-- +----+
-- |  1 |
-- |  2 |
-- |  3 |
-- +----+
-- 3 rows in set (0.001 sec)
--
-- MariaDB [test1]> quit
-- Bye
--
-- # Reconstruct blob files from database:
--
-- ./test_mysql_fetch_blob localhost pmunts redacted test1 1
-- ./test_mysql_fetch_blob localhost pmunts redacted test1 2
-- ./test_mysql_fetch_blob localhost pmunts redacted test1 3
--
-- ls -l *.bin
-- -rw-r--r-- 1 pmunts pmunts 1048576 Jan 15 15:17 blob1.bin
-- -rw-r--r-- 1 pmunts pmunts 1048576 Jan 15 15:17 blob2.bin
-- -rw-r--r-- 1 pmunts pmunts 1048576 Jan 15 15:17 blob3.bin
--
-- md5sum -c *.md5
-- blob1.bin: OK
-- blob2.bin: OK
-- blob3.bin: OK

WITH Ada.Command_Line;
WITH Ada.Sequential_IO;
WITH Ada.Strings.Fixed;

WITH MySQL.libmysqlclient;

PROCEDURE test_mysql_fetch_blob IS

  FUNCTION Trim
   (Source : IN String;
    Side   : IN Ada.Strings.Trim_End :=
      Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

  TYPE Byte IS MOD 256;

  -- Convert a hex string to a byte

  FUNCTION ToByte(s : string) RETURN Byte IS

  BEGIN
    RETURN Byte'Value("16#" & s & "#");
  END ToByte;

  PACKAGE ByteIO IS NEW Ada.Sequential_IO(Byte);

  server : MySQL.libmysqlclient.Server;
  blobID : Natural;
  dstfile : ByteIO.File_Type;

BEGIN
  -- Connect to the database server

  server := MySQL.libmysqlclient.Create
   (Ada.Command_Line.Argument(1),
    Ada.Command_Line.Argument(2),
    Ada.Command_Line.Argument(3),
    Ada.Command_line.Argument(4));

  blobID := Natural'Value(Ada.Command_line.Argument(5));

  -- Issue query

  server.Dispatch("select hex(data) from Blobs where ID=" & Trim(blobID'Image));

  -- Process results

  server.FetchResults;
  server.FetchRow;

  ByteIO.Create(dstfile, name => "blob" & Trim(blobID'Image) & ".bin");

  DECLARE
    blobhex  : String := server.FetchColumn(1);
    blobsize : Natural := blobhex'Length/2;
  BEGIN
    FOR i IN 1 .. blobsize LOOP
      ByteIO.Write(dstfile, ToByte(blobhex((2*i-1) .. 2*i)));
    END LOOP;
  END;

  ByteIO.Close(dstfile);

  server.Disconnect;
END test_mysql_fetch_blob;
