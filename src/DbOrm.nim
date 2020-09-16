import db_sqlite
import strutils
import random

type DBOrm* = ref object
  db: DbConn
  table: string

var dbOrm: DBOrm

proc newDB*(filename: string):DBOrm=
  dbOrm = DBOrm(db: open(filename, "", "", ""))
  result = dbOrm

proc closeDB*(dbOrm: DBOrm)=
  dbOrm.db.close()

proc createTableIfNotExists*(dbOrm: DBOrm, table: string = "my_table")=
  let query = sql"""CREATE TABLE IF NOT EXISTS ? (
id TEXT PRIMARY KEY UNIQUE
start INT NOT NULL
end INT DEFAULT 0
);"""
  dbOrm.table = table
  dbOrm.db.exec(query, table)

proc getRows*(dbOrm: DBOrm, limit: string = "*"): seq[Row]=
  let query = sql"""SELECT id, start, end FROM timers LIMIT=?"""
  result = dbOrm.db.getAllRows(query, limit)

proc getRowsByTime*(dbOrm: DBOrm, time: int): seq[Row]=
  let query = sql"""SELECT id, start, end FROM timers WHERE end > ?"""
  result = dbOrm.db.getAllRows(query, time)

proc deleteRow*(dbOrm: DBOrm, id: string):seq[Row]=
  let query = sql"""DELETE FROM ? WHERE id=?"""
  result = dbOrm.db.getAllRows(query, dbOrm.table, id)

proc deleteAll*(dbOrm: DBOrm):seq[Row]=
  let query = sql"""DELETE FROM ?"""
  result = dbOrm.db.getAllRows(query, dbOrm.table)

proc getSingleRow*(dbOrm: DBOrm, id: string):Row=
  let query = sql"""SELECT id,start,end from ? where id=?"""
  result = dbOrm.db.getRow(query, dbOrm.table, id)

proc insertTime*(dbOrm: DBOrm, startTime, endTime: int)=
  let query = sql"""INSERT INTO ? (id, start, end) VALUES (?, ?, ?)"""
  let id = $rand(100)
  dbOrm.db.exec(query, dbOrm.table, id, startTime, endTime)

proc updateTime*(dbOrm: DBOrm, id: string, startTime, endTime: int):Row=
  let query = sql"""UPDATE ? SET start=?, end=? WHERE id=?"""
  result = dbOrm.db.getRow(query, dbOrm.table, startTime, endTime, id)

proc updateEndTime*(dbOrm: DBOrm, id: string, endTime: int):Row=
  let row = dbOrm.getSingleRow(id)
  let startTime = parseInt(row[1])
  result = dbOrm.updateTime(id, startTime, endTime)
