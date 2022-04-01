--Create ก่อนส่ง Object ให้พี่ต้นรัน เพื่อ Backup data GNR_LOAD_TMB_FILE_DETAIL ก่อน Update Address
CREATE TABLE GNR_LOAD_TMB_FILE_DETAIL_tmp AS
SELECT * FROM GNR_LOAD_TMB_FILE_DETAIL t;
