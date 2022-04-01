-- Add/modify columns 
alter table GNR_LOAD_TMB_FILE_DETAIL add cashier_batch_id NUMBER(10);
alter table GNR_LOAD_TMB_FILE_DETAIL add cashier_batch_item_id NUMBER(10);
alter table GNR_LOAD_TMB_FILE_DETAIL add quote_data_ref_id NUMBER(10);
alter table GNR_LOAD_TMB_FILE_DETAIL add quote_data_id NUMBER(10);
-- Add/modify columns 
alter table GNR_LOAD_TMB_FILE_DETAIL add data_source VARCHAR2(50);
alter table GNR_LOAD_TMB_FILE_DETAIL add version_no NUMBER(10);
-- Add comments to the columns 
comment on column GNR_LOAD_TMB_FILE_DETAIL.cashier_batch_id
  is 'ref. gnr_partner_cashier_batch_item.cashier_batch_id';
comment on column GNR_LOAD_TMB_FILE_DETAIL.cashier_batch_item_id
  is 'ref. gnr_partner_cashier_batch_item.cashier_batch_item_id 
quote_data_ref_id ref. gnr_partner_cashier_batch_item.quote_data_ref_id';
comment on column GNR_LOAD_TMB_FILE_DETAIL.quote_data_ref_id
  is 'ref. gnr_partner_cashier_batch_item.quote_data_ref_id';
comment on column GNR_LOAD_TMB_FILE_DETAIL.quote_data_id
  is 'ref. gnr_partner_cashier_batch_item.quote_data_id';
-- Add comments to the columns 
comment on column GNR_LOAD_TMB_FILE_DETAIL.data_source
  is 'QUICKQUOTE=Load from web quickquote,MANUALLOAD=Load from others source';
comment on column GNR_LOAD_TMB_FILE_DETAIL.version_no
  is 'Ref. version_no after Policy Issued';
