SET DEFINE OFF;
Prompt Package gnr_pk_quote_data;
CREATE OR REPLACE PACKAGE gnr_pk_quote_data IS
  /*
    --  Module        TTB_ReconcilePayment
    --  Author        Phoungpaka.H
    --  DATE          17/09/2021
    --  Purpose       เก็บข้อมูล TTB Automatic payment reconciliation from Fast Quote and OPUS
    --  Description   CRF Number 2021-09-BPI-500137: TTB_ReconcilePayment pharse 1


    --  Revision History:
    --  Vesion      Date              Name                 Description of Changes
  --   1           17/09/2021       Phoungpaka.H          Initial version.
                                                          Add Procedure TTB Automatic payment reconciliation reports
  --   2           29/10/2021       Phoungpaka.H          TTB Project - Automatic Reconcile Phase 1.1
  --   3           21/01/2022       Phoungpaka.H          Fix case Ref2 null 2021-10-BPI-500138 - TTB Project - Automatic Reconcile Phase 1.1(CHGXXXXXX)
                                                          add Procedure TTB Automatic payment reconciliation reports
  */
    -- Public type dreclarations
    --type <TypeName> is <Datatype>;
    -- Public constant declarations
    --<ConstantName> constant <Datatype> := <Value>;
    g_message_err                        CONSTANT VARCHAR(10)       := 'Error: ';
    g_package_name                       CONSTANT VARCHAR(150)      := 'gnr_pk_quote_data.';
    g_space                              CONSTANT VARCHAR(10)       := ' ';
    -- Public variable declarations
   -- <VariableName> <Datatype>;
  ----------------------------------------------------------------------------------------------------
 PROCEDURE P_ASSIGN_QUOTE_DATA(r_gnr_quote_text IN develop.gnr_quote_text%ROWTYPE
                                 ,i_cover_year IN NUMBER
                                 ,o_gnr_quote_data OUT gnr_quote_data%ROWTYPE
                                 ,o_message_error OUT VARCHAR2);
  ----------------------------------------------------------------------------------------------------
  PROCEDURE  P_VALIDATE_QUOTE(ir_gnr_quote_data IN gnr_quote_data%ROWTYPE
                         ,o_msgerror OUT VARCHAR2);
  ----------------------------------------------------------------------------------------------------
  PROCEDURE P_INS_GNR_QUOTE_DATA(ir_gnr_quote_data IN gnr_quote_data%ROWTYPE
                                 ,o_quote_data_id OUT NUMBER
                                 ,o_msgerror OUT VARCHAR2);
  ----------------------------------------------------------------------------------------------------
  PROCEDURE P_INSERT_DATA_REF( p_data_ref_id  IN  NUMBER  ,
                             p_Ref1         IN  VARCHAR ,
                             p_Ref2         IN  VARCHAR ,
                             p_amount       IN  NUMBER  ,
                             p_year         IN  VARCHAR ) ;
  ----------------------------------------------------------------------------------------------------
  --Fix case Ref2 null 2021-10-BPI-500138 - TTB Project - Automatic Reconcile Phase 1.1(CHGXXXXXX)
  PROCEDURE P_UPD_QUOTE_REF2(i_load_date DATE);
  ----------------------------------------------------------------------------------------------------  
  PROCEDURE P_UPD_GNR_QUOTE_DATA(ir_gnr_quote_data IN gnr_quote_data%ROWTYPE
                               ,o_rec_no OUT NUMBER
                               ,o_message_error OUT VARCHAR2);
  ----------------------------------------------------------------------------------------------------
  PROCEDURE P_IMPORT_DATA_QUOTATION;
  ----------------------------------------------------------------------------------------------------
  END gnr_pk_quote_data;
  /
SHOW ERRORS;

Prompt Synonym gnr_pk_quote_data;
CREATE OR REPLACE PUBLIC SYNONYM gnr_pk_quote_data FOR CUSTOMER.gnr_pk_quote_data;

Prompt Grants on PACKAGE gnr_pk_quote_data TO GENERAL_OPUS_USER to GENERAL_OPUS_USER;
GRANT EXECUTE ON CUSTOMER.gnr_pk_quote_data TO GENERAL_OPUS_USER;

Prompt Grants on PACKAGE gnr_pk_quote_data TO OPUS_CORE to OPUS_CORE;
GRANT EXECUTE ON CUSTOMER.gnr_pk_quote_data TO OPUS_CORE;

Prompt Grants on PACKAGE gnr_pk_quote_data TO RCUSTOMER to RCUSTOMER;
GRANT EXECUTE ON CUSTOMER.gnr_pk_quote_data TO RCUSTOMER;

Prompt Grants on PACKAGE gnr_pk_quote_data TO DOCADM to DOCADM;
GRANT EXECUTE ON CUSTOMER.gnr_pk_quote_data TO DOCADM;

