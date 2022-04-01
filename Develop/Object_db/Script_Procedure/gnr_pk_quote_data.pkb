SET DEFINE OFF;
Prompt Package gnr_pk_quote_data;
CREATE OR REPLACE PACKAGE BODY gnr_pk_quote_data IS
/*
  --  Module        TTB_ReconcilePayment
  --  Author        Phoungpaka.H
  --  DATE          17/09/2021
  --  Purpose       เก็บข้อมูล TTB Automatic payment reconciliation from Fast Quote and OPUS
  --  Description   CRF Number 2021-09-BPI-500137: TTB_ReconcilePayment pharse 1


  --  Revision History:
  --  Version      Date              Name                 Description of Changes
  --   1           17/09/2021       Phoungpaka.H          Initial version.
                                                          Add Procedure TTB Automatic payment reconciliation reports
  --   2           29/10/2021       Phoungpaka.H          TTB Project - Automatic Reconcile Phase 1.1
  --   3           21/01/2022       Phoungpaka.H          Fix case Ref2 null 2021-10-BPI-500138 - TTB Project - Automatic Reconcile Phase 1.1(CHGXXXXXX)

*/
----------------------------------------------------------------------------------------------------
 FUNCTION char2date(p_text IN VARCHAR2) RETURN DATE IS
    v_function_name  VARCHAR2(200):=g_package_name||'.CHAR2date';
    v_date        DATE;
  BEGIN
    IF p_text IS NULL THEN
      RETURN NULL;
    ELSE
      v_date := to_date(SUBSTR(ltrim(rtrim(p_text)),1,8),'yyyymmdd');
      RETURN (v_date);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
    az_pk0_general.logtrace(v_function_name,userenv('sessionid'),SQLERRM);
    RETURN (NULL);
  END;
----------------------------------------------------------------------------------------------------
 FUNCTION NUM2CHAR(p_number IN NUMBER, p_format IN VARCHAR2 DEFAULT '99999999999999') RETURN VARCHAR2 IS
    v_function_name  VARCHAR2(200):=g_package_name||'.num2char';
    v_number         VARCHAR2(200);
  BEGIN
    IF p_number = 0 THEN
      RETURN NULL;
    ELSE
      v_number := ltrim(rtrim(to_char(p_number,p_format)));

    RETURN (v_number);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
    az_pk0_general.logtrace(v_function_name,userenv('sessionid'),SQLERRM);
    RETURN (NULL);
  END;
----------------------------------------------------------------------------------------------------
--TRIM(REPLACE(REPLACE(REPLACE(-
FUNCTION REPLACE_SPECIAL_CHR(i_text IN VARCHAR2) RETURN VARCHAR2 IS
    v_function_name  VARCHAR2(200):=g_package_name||'.replace_special_chr';
  BEGIN

    RETURN TRIM(REPLACE(REPLACE(REPLACE(i_text,CHR(10),''),
                              CHR(13),''),CHR(9),''));
  EXCEPTION
    WHEN OTHERS THEN
       az_pk0_general.logtrace(v_function_name,userenv('sessionid'),SQLERRM);
    RETURN (NULL);
  END;
----------------------------------------------------------------------------------------------------
FUNCTION NUM2CHAR2(p_number IN NUMBER, p_format IN VARCHAR2 DEFAULT '999,999,999,999.99') RETURN VARCHAR2 IS
    v_function_name  VARCHAR2(200):=g_package_name||'.num2char';
    v_number         VARCHAR2(200);
  BEGIN
   IF p_number = 0 THEN
     RETURN NULL;
   ELSE
    v_number := ltrim(rtrim(to_char(p_number,p_format)));
    RETURN (v_number);
  END IF;
  EXCEPTION
    WHEN OTHERS THEN
    az_pk0_general.logtrace(v_function_name,userenv('sessionid'),SQLERRM);
    RETURN (NULL);
  END;
---------------------------------------------------------------------------------------------------
PROCEDURE P_ASSIGN_QUOTE_DATA(r_gnr_quote_text IN develop.gnr_quote_text%ROWTYPE
                               ,i_cover_year IN NUMBER
                               ,o_gnr_quote_data OUT gnr_quote_data%ROWTYPE
                               ,o_message_error OUT VARCHAR2) IS

  v_func_name CONSTANT   VARCHAR2(300) := g_package_name||'p_assign_quote_data';
  v_message_err          VARCHAR2(1000) := NULL;

  r_gnr_quote_data gnr_quote_data%ROWTYPE;
  v_step NUMBER;
  v_cover_year NUMBER;
  v_cover_year1 NUMBER :=0;
  v_cover_year2 NUMBER :=0;
  v_cover_year3 NUMBER :=0;
 BEGIN
    --v_seq := 0;
    v_step := 1;
   -- select GNR_QUOTE_DATA_SEQ.Nextval into v_seq from dual ;
    v_step := 2;
    r_gnr_quote_data.QUOTE_DATA_ID := NULL;
    v_step := 3;
    r_gnr_quote_data.JOB_NUMBER := r_gnr_quote_text.COL_0001;  --1JOB NUMBER;
    v_step := 4;
    r_gnr_quote_data.BATCH_TYPE := r_gnr_quote_text.COL_0002;  --2Batch Type;
    v_step := 5;
    r_gnr_quote_data.FILE_NAME := r_gnr_quote_text.COL_0003;  --3File Name;
    v_step := 6;
    r_gnr_quote_data.UPLOAD_DATE := char2date(r_gnr_quote_text.COL_0004);  --4Upload Date;
    v_step := 7;
    r_gnr_quote_data.RM_ID := r_gnr_quote_text.COL_0005;  --5RM ID;
    v_step := 8;
    r_gnr_quote_data.RM_NAME := replace_special_chr(r_gnr_quote_text.COL_0006);  --6RM Name;
    v_step := 9;
    r_gnr_quote_data.REFER_ID := r_gnr_quote_text.COL_0007;  --7Refer ID;
    v_step := 10;
    r_gnr_quote_data.REFER_NAME := replace_special_chr(r_gnr_quote_text.COL_0008);  --8Refer Name;
    v_step := 11;
    r_gnr_quote_data.MKT_ID := r_gnr_quote_text.COL_0009;  --9MKT ID;
    v_step := 12;
    r_gnr_quote_data.MKT_NAME := replace_special_chr(r_gnr_quote_text.COL_0010);  --10MKT NAME;
    v_step := 13;
    r_gnr_quote_data.BRANCH_CODE := r_gnr_quote_text.COL_0011;  --11Branch Code;
    v_step := 14;
    r_gnr_quote_data.BRANCH_NAME := r_gnr_quote_text.COL_0012;  --12Branch Name;
    v_step := 15;
    r_gnr_quote_data.HUB_ID := r_gnr_quote_text.COL_0013;  --13Hub ID;
    v_step := 16;
    r_gnr_quote_data.HUB_NAME := rtrim(ltrim(r_gnr_quote_text.COL_0014));  --14Hub Name;
    v_step := 17;
    r_gnr_quote_data.TEAM := r_gnr_quote_text.COL_0015;  --15Team;
    v_step := 18;
    r_gnr_quote_data.SEGMENT := r_gnr_quote_text.COL_0016;  --16Segment;
    v_step := 19;
    r_gnr_quote_data.CHANNEL := upper(r_gnr_quote_text.COL_0017);  --17Channel;
    v_step := 20;
    r_gnr_quote_data.INSURANCE_CLASS := upper(r_gnr_quote_text.COL_0018);  --18Insurance Class;
    v_step := 21;
    r_gnr_quote_data.SUB_CLASS := upper(r_gnr_quote_text.COL_0019);  --19Sub Class;
    v_step := 22;
    r_gnr_quote_data.SUB_CLASS_TYPE := r_gnr_quote_text.COL_0020;  --20Sub Class Type;
    v_step := 23;
    r_gnr_quote_data.SUB_CHANNEL_ID := r_gnr_quote_text.COL_0021;  --21Sub-Channel ID;
    v_step := 24;
    r_gnr_quote_data.PARTNER_REF_NUMBER := r_gnr_quote_text.COL_0022;  --22Partner Reference Number;
    v_step := 25;
    r_gnr_quote_data.PREVIOUS_POLICY_NUMBER := r_gnr_quote_text.COL_0023;  --23Previous Policy Number;
    v_step := 26;
    r_gnr_quote_data.JOB_RECEIVED_DATE := char2date(r_gnr_quote_text.COL_0024);  --24Job Received Date;
    v_step := 27;
    r_gnr_quote_data.JOB_TYPE := upper(r_gnr_quote_text.COL_0025);  --25Job Type;
    v_step := 28;
    r_gnr_quote_data.DEPARTMENT_CODE := r_gnr_quote_text.COL_0026;  --26Department Code;
    v_step := 29;
    r_gnr_quote_data.TITLE := r_gnr_quote_text.COL_0027;  --27Title;
    v_step := 30;
    r_gnr_quote_data.INSURED_FIRSTNAME := rtrim(ltrim(r_gnr_quote_text.COL_0028));  --28Insured First Name;
    v_step := 31;
    r_gnr_quote_data.INSURED_LASTNAME := rtrim(ltrim(r_gnr_quote_text.COL_0029));  --29Insured Last Name;
    v_step := 32;
    r_gnr_quote_data.ID_NUMBER := r_gnr_quote_text.COL_0030;  --30ID Number;
    v_step := 33;
    r_gnr_quote_data.ID_TYPE := r_gnr_quote_text.COL_0031;  --31ID Type;
    v_step := 34;
    r_gnr_quote_data.INSURED_PERSON := rtrim(ltrim(r_gnr_quote_text.COL_0032));  --32Insured Person ;
    v_step := 35;
    r_gnr_quote_data.INSURED_PERSON_TYPE := upper(r_gnr_quote_text.COL_0033);  --33Insured Person Type;
    v_step := 36;
    r_gnr_quote_data.CUSTOMER_ID := r_gnr_quote_text.COL_0034;  --34Customer ID;
    v_step := 37;
    r_gnr_quote_data.CUSTOMER_NAME := rtrim(ltrim(r_gnr_quote_text.COL_0035));  --35Customer Name;
    v_step := 38;
    r_gnr_quote_data.DATE_OF_BIRTH := char2date(r_gnr_quote_text.COL_0036);  --36Date of Birth;
    v_step := 39;
    r_gnr_quote_data.INSURED_ADDR_NUMBER := replace_special_chr(r_gnr_quote_text.COL_0037);  --37Insured Address Number;
    v_step := 40;
    r_gnr_quote_data.INSURED_ADDR_BUIDING := r_gnr_quote_text.COL_0038;  --38Insured Address Building;
    v_step := 41;
    r_gnr_quote_data.INSURED_ADDR_MOO := r_gnr_quote_text.COL_0039;  --39Insured Address Moo;
    v_step := 42;
    r_gnr_quote_data.INSURED_ADDR_SOI := r_gnr_quote_text.COL_0040;  --40Insured Address Soi;
    v_step := 43;
    r_gnr_quote_data.INSURED_ADDR_ROAD := r_gnr_quote_text.COL_0041;  --41Insured Address Road;
    v_step := 44;
    r_gnr_quote_data.SUB_DISTRICT := r_gnr_quote_text.COL_0042;  --42Sub-District;
    v_step := 45;
    r_gnr_quote_data.DISTRICT := r_gnr_quote_text.COL_0043;  --43District;
    v_step := 46;
    r_gnr_quote_data.PROVINCE := r_gnr_quote_text.COL_0044;  --44Province;
    v_step := 47;
    r_gnr_quote_data.POST_CODE := r_gnr_quote_text.COL_0045;  --45Post Code;
    v_step := 48;

    r_gnr_quote_data.INSURED_FULL_ADDR := rtrim(ltrim(REPLACE(r_gnr_quote_text.COL_0046,'""""',NULL)));  --46Insured Full Address;
    r_gnr_quote_data.INSURED_FULL_ADDR :=  replace_special_chr(r_gnr_quote_data.INSURED_FULL_ADDR);
    v_step := 49;
    r_gnr_quote_data.TELEPHONE_NUMBER := r_gnr_quote_text.COL_0047;  --47Telephone Number;
     v_step := 50;
    r_gnr_quote_data.ACCOUNT_NUMBER := r_gnr_quote_text.COL_0048;  --48Account Number;
    v_step := 51;
    r_gnr_quote_data.CONTACT_PERSON_NAME := rtrim(ltrim(r_gnr_quote_text.COL_0049));  --49Contact Person Name;
    v_step := 52;
    r_gnr_quote_data.CONTACT_PERSON_EMAIL := r_gnr_quote_text.COL_0050;  --50Contact Person Email;
    v_step := 53;
    r_gnr_quote_data.CONTACT_PERSON_FAX := r_gnr_quote_text.COL_0051;  --51Contact Person Fax Number;
    v_step := 54;
    r_gnr_quote_data.CONTACT_PERSON_LINEID := r_gnr_quote_text.COL_0052;  --52Contact Person LINE ID;
    v_step := 55;
    r_gnr_quote_data.CONTACT_PERSON_MOBILE := r_gnr_quote_text.COL_0053;  --53Contact Person Mobile Number;
    v_step := 56;
    r_gnr_quote_data.CONTACT_PERSON_PHONE := r_gnr_quote_text.COL_0054;  --54Contact Person Phone Number;
    v_step := 57;
    --dbms_output.put_line('55IMD'||r_gnr_quote_text.COL_0055); 
    r_gnr_quote_data.IMD := r_gnr_quote_text.COL_0055;  --55IMD;
    v_step := 58;
    -- dbms_output.put_line('56Quotation Number'||r_gnr_quote_text.COL_0057); 
    r_gnr_quote_data.QUOTATION_NUMBER := r_gnr_quote_text.COL_0056;  --56Quotation Number;
    -- dbms_output.put_line('56.2Quotation Number'||r_gnr_quote_text.COL_0057); 
    v_step := 59;
    IF r_gnr_quote_text.COL_0057 IS NOT NULL THEN
       r_gnr_quote_data.QUOTATION_ISSUE_DATE := char2date(r_gnr_quote_text.COL_0057);  --57Quotation Issue Date;
    ELSE
       r_gnr_quote_data.QUOTATION_ISSUE_DATE := NULL;
    END IF;
    v_step := 60;
    r_gnr_quote_data.QUOTATION_VERSION := r_gnr_quote_text.COL_0058;  --58Quotation Version;
    v_step := 61;
    r_gnr_quote_data.QUOTATION_STATUS := nvl(r_gnr_quote_text.COL_0059,'QUOTE');  --59Quotation Status ;
    v_step := 62;
    r_gnr_quote_data.REF_QUOTATION_NUMBER := r_gnr_quote_text.COL_0060;  --60Reference Quotation Number;
    v_step := 63;
    r_gnr_quote_data.PACKAGE_NAME := upper(r_gnr_quote_text.COL_0061);  --61Package Name;
    v_step := 64;
    r_gnr_quote_data.COVER_PERIOD_DAYS := r_gnr_quote_text.COL_0062;  --62Cover Period (Days);
    v_step := 65;
    r_gnr_quote_data.COVER_PERIOD_YEAR := r_gnr_quote_text.COL_0063;  --63Cover Period (Year);
    v_step := 66;
    IF r_gnr_quote_text.COL_0064 IS NOT NULL THEN
       r_gnr_quote_data.EXPIRY_DATE := char2date(r_gnr_quote_text.COL_0064);  --64Expiry Date;
    ELSE
       r_gnr_quote_data.EXPIRY_DATE := NULL;
    END IF;
    v_step := 66;
    IF r_gnr_quote_text.COL_0065 IS NOT NULL THEN
       r_gnr_quote_data.INCEPTION_DATE := char2date(r_gnr_quote_text.COL_0065);  --65Inception Date;
    ELSE
       r_gnr_quote_data.INCEPTION_DATE := NULL;
    END IF;
    v_step := 67;
    r_gnr_quote_data.DEED_NUMBER := r_gnr_quote_text.COL_0066;  --66Deed Number;
    v_step := 68;
    r_gnr_quote_data.INSURED_OBJ_ADDR_NUMBER := r_gnr_quote_text.COL_0067;  --67Insured Object Address Number;
    v_step := 69;
    r_gnr_quote_data.INSURED_OBJ_BUILDING := r_gnr_quote_text.COL_0068;  --68Insured Object Building;
    v_step := 70;
    r_gnr_quote_data.INSURED_OBJ_DISTRICT := r_gnr_quote_text.COL_0069;  --69Insured Object District;
    v_step := 71;
    r_gnr_quote_data.INSURED_OBJ_FULL_ADDR :=replace_special_chr(r_gnr_quote_text.COL_0070);  --70Insured Object Full Address;
    v_step := 72;
    r_gnr_quote_data.INSURED_OBJ_MOO := r_gnr_quote_text.COL_0071;  --71Insured Object Moo;
    v_step := 73;
    r_gnr_quote_data.INSURED_OBJ_POST_CODE := r_gnr_quote_text.COL_0072;  --72Insured Object Post Code;
    v_step := 74;
    r_gnr_quote_data.INSURED_OBJ_PROVINCE := r_gnr_quote_text.COL_0073;  --73Insured Object Province;
    v_step := 75;
    r_gnr_quote_data.INSURED_OBJ_ROAD := r_gnr_quote_text.COL_0074;  --74Insured Object Road;
    v_step := 76;
    r_gnr_quote_data.INSURED_OBJ_SOI := r_gnr_quote_text.COL_0075;  --75Insured Object Soi;
    v_step := 77;
    r_gnr_quote_data.INSURED_OBJ_SUBDIST := r_gnr_quote_text.COL_0076;  --76Insured Object Sub-District;
    v_step := 78;
    r_gnr_quote_data.NUMBER_OF_FLOOR := r_gnr_quote_text.COL_0077;  --77Number of Floor;
    v_step := 79;
    r_gnr_quote_data.CONSTRUCTION_CLASS := r_gnr_quote_text.COL_0078;  --78Construction Class;
    v_step := 80;
    r_gnr_quote_data.REF1 := r_gnr_quote_text.COL_0079;  --79Payment Reference Number1;
    v_step := 81;
    r_gnr_quote_data.Y1_PAYREF_NUM2 := r_gnr_quote_text.COL_0080;  --80Y1_Payment Reference Number2;
    v_step := 82;
    r_gnr_quote_data.Y2_PAYREF_NUM2 := r_gnr_quote_text.COL_0081;  --81Y2_Payment Reference Number2;
    v_step := 83;
    r_gnr_quote_data.Y3_PAYREF_NUM2 := r_gnr_quote_text.COL_0082;  --82Y3_Payment Reference Number2;
    v_step := 84;
    r_gnr_quote_data.RISK_CODE := r_gnr_quote_text.COL_0083;  --83Risk Code;
    v_step := 85;
    r_gnr_quote_data.PURPOSED_OF_USE := r_gnr_quote_text.COL_0084;  --84Purposed of Use;
    v_step := 86;
    r_gnr_quote_data.ASSET_TYPE := r_gnr_quote_text.COL_0085;  --85Asset Type;
    v_step := 87;
    r_gnr_quote_data.CAPITAL_TYPE := r_gnr_quote_text.COL_0086;  --86Capital Type;
    v_step := 88;
    IF i_cover_year = 1 THEN --1 Year
        v_step := 89;
        r_gnr_quote_data.Y1_TOTAL_SUM_INSURED := r_gnr_quote_text.COL_0087;  --87Y1_total sum insured;
        v_step := 90;
        r_gnr_quote_data.Y1_NET_PREMIUM := r_gnr_quote_text.COL_0088;  --88Y1_Net Premium;
        v_step := 91;
        r_gnr_quote_data.Y1_DUTY := r_gnr_quote_text.COL_0089;  --89Y1_Duty;
        v_step := 92;
        r_gnr_quote_data.Y1_TAX := r_gnr_quote_text.COL_0090;  --90Y1_Tax;
        v_step := 93;
        r_gnr_quote_data.Y1_TOTAL_PREMIUM := r_gnr_quote_text.COL_0091;  --91Y1_Total Premium;
        v_step := 94;
        r_gnr_quote_data.Y1_SI_BUILDING := r_gnr_quote_text.COL_0092;  --92Y1_SI of Building;
        v_step := 95;
        r_gnr_quote_data.Y1_SI_FURNITURE := r_gnr_quote_text.COL_0093;  --93Y1_SI of Furniture;
        v_step := 96;
        r_gnr_quote_data.Y1_SI_MACHINERY := r_gnr_quote_text.COL_0094;  --94Y1_SI of Machinery;
        v_step := 97;
        r_gnr_quote_data.Y1_SI_OTHERS := r_gnr_quote_text.COL_0095;  --95Y1_SI of Others;
        v_step := 98;
        r_gnr_quote_data.Y1_SI_STOCK := r_gnr_quote_text.COL_0096;  --96Y1_SI of Stock;

        v_step := 99;
        r_gnr_quote_data.Y2_TOTAL_SUM_INSURED := NULL;  --97Y2_total sum insured;
        r_gnr_quote_data.Y2_NETPREMIUM := NULL;  --98Y2_Net Premium;
        r_gnr_quote_data.Y2_DUTY :=NULL;  --99Y2_Duty;
        r_gnr_quote_data.Y2_TAX := NULL;  --100Y2_Tax;
        r_gnr_quote_data.Y2_TOTAL_PREMIUM :=NULL;  --101Y2_Total Premium;
        r_gnr_quote_data.Y2_SI_BUILDING := NULL;  --102Y2_SI of Building;
        r_gnr_quote_data.Y2_SI_FURNITURE := NULL;  --103Y2_SI of Furniture;
        r_gnr_quote_data.Y2_SI_MACHINERY := NULL;  --104Y2_SI of Machinery;
        r_gnr_quote_data.Y2_SI_OTHERS := NULL;  --105Y2_SI of Others;
        r_gnr_quote_data.Y2_SI_STOCK := NULL;  --106Y2_SI of Stock;
        r_gnr_quote_data.Y3_TOTAL_SUM_INSURED := NULL;  --107Y3_total sum insured;
        r_gnr_quote_data.Y3_NET_PREMIUM := NULL;  --108Y3_Net Premium;
        r_gnr_quote_data.Y3_DUTY :=NULL;  --109Y3_Duty;
        r_gnr_quote_data.Y3_TAX :=NULL;  --110Y3_Tax;
        r_gnr_quote_data.Y3_TOTAL_PREMIUM := NULL;  --111Y3_Total Premium;
        r_gnr_quote_data.Y3_SI_BUILDING := NULL;  --112Y3_SI of Building;
        r_gnr_quote_data.Y3_SI_FURNITURE := NULL;  --113Y3_SI of Furniture;
        r_gnr_quote_data.Y3_SI_MACHINERY := NULL;  --114Y3_SI of Machinery;
        r_gnr_quote_data.Y3_SI_OTHERS :=NULL;  --115Y3_SI of Others;
        r_gnr_quote_data.Y3_SI_STOCK :=NULL;  --116Y3_SI of Stock;

      ELSIF i_cover_year = 2 THEN --2 Year

        r_gnr_quote_data.Y1_TOTAL_SUM_INSURED := NULL;  --87Y1_total sum insured;
        r_gnr_quote_data.Y1_NET_PREMIUM := NULL;  --88Y1_Net Premium;
        r_gnr_quote_data.Y1_DUTY := NULL;  --89Y1_Duty;
        r_gnr_quote_data.Y1_TAX := NULL;  --90Y1_Tax;
        r_gnr_quote_data.Y1_TOTAL_PREMIUM := NULL;  --91Y1_Total Premium;
        r_gnr_quote_data.Y1_SI_BUILDING := NULL;  --92Y1_SI of Building;
        r_gnr_quote_data.Y1_SI_FURNITURE := NULL;  --93Y1_SI of Furniture;
        r_gnr_quote_data.Y1_SI_MACHINERY := NULL;  --94Y1_SI of Machinery;
        r_gnr_quote_data.Y1_SI_OTHERS :=NULL;  --95Y1_SI of Others;
        r_gnr_quote_data.Y1_SI_STOCK := NULL;  --96Y1_SI of Stock;

        v_step := 100;
        r_gnr_quote_data.Y2_TOTAL_SUM_INSURED := r_gnr_quote_text.COL_0097;  --97Y2_total sum insured;
        v_step := 101;
        r_gnr_quote_data.Y2_NETPREMIUM := r_gnr_quote_text.COL_0098;  --98Y2_Net Premium;
        v_step := 102;
        r_gnr_quote_data.Y2_DUTY := r_gnr_quote_text.COL_0098;  --99Y2_Duty;
        v_step := 103;
        r_gnr_quote_data.Y2_TAX := r_gnr_quote_text.COL_0100;  --100Y2_Tax;
        v_step := 104;
        r_gnr_quote_data.Y2_TOTAL_PREMIUM := r_gnr_quote_text.COL_0101;  --101Y2_Total Premium;
        v_step := 105;
        r_gnr_quote_data.Y2_SI_BUILDING := r_gnr_quote_text.COL_0102;  --102Y2_SI of Building;
        v_step := 106;
        r_gnr_quote_data.Y2_SI_FURNITURE := r_gnr_quote_text.COL_0103;  --103Y2_SI of Furniture;
        v_step := 107;
        r_gnr_quote_data.Y2_SI_MACHINERY := r_gnr_quote_text.COL_0104;  --104Y2_SI of Machinery;
        v_step := 108;
        r_gnr_quote_data.Y2_SI_OTHERS := r_gnr_quote_text.COL_0105;  --105Y2_SI of Others;
        v_step := 109;
        r_gnr_quote_data.Y2_SI_STOCK := r_gnr_quote_text.COL_0106;  --106Y2_SI of Stock;

        v_step := 110;
        r_gnr_quote_data.Y3_TOTAL_SUM_INSURED := NULL;  --107Y3_total sum insured;
        r_gnr_quote_data.Y3_NET_PREMIUM := NULL;  --108Y3_Net Premium;
        r_gnr_quote_data.Y3_DUTY := NULL;  --109Y3_Duty;
        r_gnr_quote_data.Y3_TAX := NULL;  --110Y3_Tax;
        r_gnr_quote_data.Y3_TOTAL_PREMIUM := NULL;  --111Y3_Total Premium;
        r_gnr_quote_data.Y3_SI_BUILDING := NULL;  --112Y3_SI of Building;
        r_gnr_quote_data.Y3_SI_FURNITURE := NULL;  --113Y3_SI of Furniture;
        r_gnr_quote_data.Y3_SI_MACHINERY := NULL;  --114Y3_SI of Machinery;
        r_gnr_quote_data.Y3_SI_OTHERS := NULL;  --115Y3_SI of Others;
        r_gnr_quote_data.Y3_SI_STOCK := NULL;  --116Y3_SI of Stock;

     ELSIF i_cover_year = 3 THEN --3 Year

        r_gnr_quote_data.Y1_TOTAL_SUM_INSURED := NULL;  --87Y1_total sum insured;
        r_gnr_quote_data.Y1_NET_PREMIUM :=NULL;  --88Y1_Net Premium;
        r_gnr_quote_data.Y1_DUTY := NULL;  --89Y1_Duty;
        r_gnr_quote_data.Y1_TAX := NULL;  --90Y1_Tax;
        r_gnr_quote_data.Y1_TOTAL_PREMIUM := NULL;  --91Y1_Total Premium;
        r_gnr_quote_data.Y1_SI_BUILDING :=NULL;  --92Y1_SI of Building;
        r_gnr_quote_data.Y1_SI_FURNITURE := NULL;  --93Y1_SI of Furniture;
        r_gnr_quote_data.Y1_SI_MACHINERY := NULL;  --94Y1_SI of Machinery;
        r_gnr_quote_data.Y1_SI_OTHERS := NULL;  --95Y1_SI of Others;
        r_gnr_quote_data.Y1_SI_STOCK := NULL;  --96Y1_SI of Stock;

        r_gnr_quote_data.Y2_TOTAL_SUM_INSURED := NULL;  --97Y2_total sum insured;
        r_gnr_quote_data.Y2_NETPREMIUM := NULL;  --98Y2_Net Premium;
        r_gnr_quote_data.Y2_DUTY := NULL;  --99Y2_Duty;
        r_gnr_quote_data.Y2_TAX := NULL;  --100Y2_Tax;
        r_gnr_quote_data.Y2_TOTAL_PREMIUM := NULL;  --101Y2_Total Premium;
        r_gnr_quote_data.Y2_SI_BUILDING :=NULL;  --102Y2_SI of Building;
        r_gnr_quote_data.Y2_SI_FURNITURE := NULL;  --103Y2_SI of Furniture;
        r_gnr_quote_data.Y2_SI_MACHINERY := NULL;  --104Y2_SI of Machinery;
        r_gnr_quote_data.Y2_SI_OTHERS := NULL;  --105Y2_SI of Others;
        r_gnr_quote_data.Y2_SI_STOCK := NULL;  --106Y2_SI of Stock;

        v_step := 111;
        r_gnr_quote_data.Y3_TOTAL_SUM_INSURED := r_gnr_quote_text.COL_0107;  --107Y3_total sum insured;
        v_step := 112;
        r_gnr_quote_data.Y3_NET_PREMIUM := r_gnr_quote_text.COL_0108;  --108Y3_Net Premium;
        v_step := 113;
        r_gnr_quote_data.Y3_DUTY := r_gnr_quote_text.COL_0109;  --109Y3_Duty;
        v_step := 114;
        r_gnr_quote_data.Y3_TAX := r_gnr_quote_text.COL_0110;  --110Y3_Tax;
        v_step := 115;
        r_gnr_quote_data.Y3_TOTAL_PREMIUM := r_gnr_quote_text.COL_0111;  --111Y3_Total Premium;
        v_step := 116;
        r_gnr_quote_data.Y3_SI_BUILDING := r_gnr_quote_text.COL_0112;  --112Y3_SI of Building;
        v_step := 117;
        r_gnr_quote_data.Y3_SI_FURNITURE := r_gnr_quote_text.COL_0113;  --113Y3_SI of Furniture;
        v_step := 118;
        r_gnr_quote_data.Y3_SI_MACHINERY := r_gnr_quote_text.COL_0114;  --114Y3_SI of Machinery;
        v_step := 119;
        r_gnr_quote_data.Y3_SI_OTHERS := r_gnr_quote_text.COL_0115;  --115Y3_SI of Others;
        v_step := 120;
        r_gnr_quote_data.Y3_SI_STOCK := r_gnr_quote_text.COL_0116;  --116Y3_SI of Stock;
    ELSE
        v_step := 121;
        r_gnr_quote_data.Y1_TOTAL_SUM_INSURED := r_gnr_quote_text.COL_0087;  --87Y1_total sum insured;
        v_step := 122;
        r_gnr_quote_data.Y1_NET_PREMIUM := r_gnr_quote_text.COL_0088;  --88Y1_Net Premium;
        v_step := 123;
        r_gnr_quote_data.Y1_DUTY := r_gnr_quote_text.COL_0089;  --89Y1_Duty;
        v_step := 124;
        r_gnr_quote_data.Y1_TAX := r_gnr_quote_text.COL_0090;  --90Y1_Tax;
        v_step := 125;
        r_gnr_quote_data.Y1_TOTAL_PREMIUM := r_gnr_quote_text.COL_0091;  --91Y1_Total Premium;
        v_step := 126;
        r_gnr_quote_data.Y1_SI_BUILDING := r_gnr_quote_text.COL_0092;  --92Y1_SI of Building;
        v_step := 127;
        r_gnr_quote_data.Y1_SI_FURNITURE := r_gnr_quote_text.COL_0093;  --93Y1_SI of Furniture;
        v_step := 128;
        r_gnr_quote_data.Y1_SI_MACHINERY := r_gnr_quote_text.COL_0094;  --94Y1_SI of Machinery;
        v_step := 129;
        r_gnr_quote_data.Y1_SI_OTHERS := r_gnr_quote_text.COL_0095;  --95Y1_SI of Others;
        v_step := 130;
        r_gnr_quote_data.Y1_SI_STOCK := r_gnr_quote_text.COL_0096;  --96Y1_SI of Stock;
        v_step := 131;
        r_gnr_quote_data.Y2_TOTAL_SUM_INSURED := r_gnr_quote_text.COL_0097;  --97Y2_total sum insured;
        v_step := 132;
        r_gnr_quote_data.Y2_NETPREMIUM := r_gnr_quote_text.COL_0098;  --98Y2_Net Premium;
        v_step := 133;
        r_gnr_quote_data.Y2_DUTY := r_gnr_quote_text.COL_0099;  --99Y2_Duty;
        v_step := 134;
        r_gnr_quote_data.Y2_TAX := r_gnr_quote_text.COL_0100;  --100Y2_Tax;
        v_step := 135;
        r_gnr_quote_data.Y2_TOTAL_PREMIUM := r_gnr_quote_text.COL_0101;  --101Y2_Total Premium;
        v_step := 136;
        r_gnr_quote_data.Y2_SI_BUILDING := r_gnr_quote_text.COL_0102;  --102Y2_SI of Building;
        v_step := 137;
        r_gnr_quote_data.Y2_SI_FURNITURE := r_gnr_quote_text.COL_0103;  --103Y2_SI of Furniture;
        v_step := 138;
        r_gnr_quote_data.Y2_SI_MACHINERY := r_gnr_quote_text.COL_0104;  --104Y2_SI of Machinery;
        v_step := 139;
        r_gnr_quote_data.Y2_SI_OTHERS := r_gnr_quote_text.COL_0105;  --105Y2_SI of Others;
        v_step := 140;
        r_gnr_quote_data.Y2_SI_STOCK := r_gnr_quote_text.COL_0106;  --106Y2_SI of Stock;
        v_step := 141;
        r_gnr_quote_data.Y3_TOTAL_SUM_INSURED := r_gnr_quote_text.COL_0107;  --107Y3_total sum insured;
        v_step := 142;
        r_gnr_quote_data.Y3_NET_PREMIUM := r_gnr_quote_text.COL_0108;  --108Y3_Net Premium;
        v_step := 143;
        r_gnr_quote_data.Y3_DUTY := r_gnr_quote_text.COL_0109;  --109Y3_Duty;
        v_step := 144;
        r_gnr_quote_data.Y3_TAX := r_gnr_quote_text.COL_0110;  --110Y3_Tax;
        v_step := 145;
        r_gnr_quote_data.Y3_TOTAL_PREMIUM := r_gnr_quote_text.COL_0111;  --111Y3_Total Premium;
        v_step := 146;
        r_gnr_quote_data.Y3_SI_BUILDING := r_gnr_quote_text.COL_0112;  --112Y3_SI of Building;
        v_step := 147;
        r_gnr_quote_data.Y3_SI_FURNITURE := r_gnr_quote_text.COL_0113;  --113Y3_SI of Furniture;
        v_step := 148;
        r_gnr_quote_data.Y3_SI_MACHINERY := r_gnr_quote_text.COL_0114;  --114Y3_SI of Machinery;
        v_step := 149;
        r_gnr_quote_data.Y3_SI_OTHERS := r_gnr_quote_text.COL_0115;  --115Y3_SI of Others;
        v_step := 150;
        r_gnr_quote_data.Y3_SI_STOCK := r_gnr_quote_text.COL_0116;  --116Y3_SI of Stock;
    END IF;
    v_cover_year :=0;
    v_step := 150.1;
    IF r_gnr_quote_data.COVER_PERIOD_YEAR ='1' THEN
       v_cover_year := 1;
    ELSIF r_gnr_quote_data.COVER_PERIOD_YEAR ='2' THEN
       v_cover_year := 2;
    ELSIF r_gnr_quote_data.COVER_PERIOD_YEAR ='3' THEN
       v_cover_year := 3;
    ELSIF r_gnr_quote_data.COVER_PERIOD_YEAR ='1&3' THEN
       v_cover_year := 0;
       v_cover_year1 :=1;
       v_cover_year2 :=0;
       v_cover_year3 :=3;
    ELSIF r_gnr_quote_data.COVER_PERIOD_YEAR ='1&2' THEN
       v_cover_year := 0;
       v_cover_year1 :=1;
       v_cover_year2 :=2;
       v_cover_year3 :=0;
   ELSE
        v_cover_year := r_gnr_quote_data.COVER_PERIOD_YEAR;--Default
   END IF;
   v_step := 150.1;
   IF  r_gnr_quote_data.COVER_PERIOD_YEAR = '1' THEN --1 Year
      v_step := 151;
       r_gnr_quote_data.ref2 := r_gnr_quote_data.Y1_PAYREF_NUM2;
    ELSIF r_gnr_quote_data.COVER_PERIOD_YEAR = '2' THEN --2 Year
       v_step := 152;
       r_gnr_quote_data.ref2 := r_gnr_quote_data.Y2_PAYREF_NUM2;
    ELSIF r_gnr_quote_data.COVER_PERIOD_YEAR = '3' THEN --3 Year
       v_step := 153;
       r_gnr_quote_data.ref2 := r_gnr_quote_data.Y3_PAYREF_NUM2;
    ELSE
        v_step := 154;
        r_gnr_quote_data.ref2 := NULL;--if 1&3 ,1&2 set null
        /*IF v_cover_year1 =1 THEN
           r_gnr_quote_data.ref2 :=r_gnr_quote_data.Y1_PAYREF_NUM2; --if ไม่ส่งค่ามา Default 1 Year
        END IF;
        IF v_cover_year1 =2 THEN
           r_gnr_quote_data.ref2 :=r_gnr_quote_data.Y2_PAYREF_NUM2;
        END IF;
        IF v_cover_year1 =3 THEN
           r_gnr_quote_data.ref2 :=r_gnr_quote_data.Y3_PAYREF_NUM2;
        END IF;*/
    END IF;
    v_step := 155;
    r_gnr_quote_data.load_date := trunc(SYSDATE);
    r_gnr_quote_data.data_source := r_gnr_quote_text.col_0117; --Data Source
    v_step := 156;
    o_gnr_quote_data := r_gnr_quote_data;
 EXCEPTION WHEN OTHERS THEN
   v_message_err := 'Job_Number '||r_gnr_quote_text.COL_0001||' '||'Error step:'||v_step||' '||SQLERRM;
   o_message_error :=  v_message_err;
   az_pk0_general.logtrace(v_func_name,0,v_message_err);

 END;
----------------------------------------------------------------------------------------------------
PROCEDURE  P_VALIDATE_QUOTE(ir_gnr_quote_data IN gnr_quote_data%ROWTYPE
                         ,o_msgerror OUT VARCHAR2)
IS
   v_func_name CONSTANT   VARCHAR2(300) := g_package_name||'p_validate_quote'||g_space;

   v_message_err gnr_quote_data.MESSAGE_ERROR%TYPE := NULL;
   v_message_validate_text gnr_quote_data.MESSAGE_ERROR%TYPE := NULL;
   v_delimiter   CONSTANT VARCHAR2(10) := ',';
   invaid_data EXCEPTION;
   v_state NUMBER := 0;
   v_result NUMBER := 0;

   v_flag_err NUMBER :=0;
BEGIN
  if ir_gnr_quote_data.JOB_NUMBER is null then  --2JOB NUMBER M
    v_message_validate_text := v_message_validate_text||v_delimiter||' JOB_NUMBER is null';
    v_flag_err := 1;
  END IF;
 /* if ir_gnr_quote_data.BATCH_TYPE is null then  --3Batch Type M
    v_message_validate_text := v_message_validate_text||v_delimiter||' BATCH_TYPE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.FILE_NAME is null then  --4File Name M
    v_message_validate_text := v_message_validate_text||v_delimiter||' FILE_NAME is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.UPLOAD_DATE is null then  --5Upload Date M
    v_message_validate_text := v_message_validate_text||v_delimiter||' UPLOAD_DATE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.RM_ID is null then  --6RM ID M
    v_message_validate_text := v_message_validate_text||v_delimiter||' RM_ID is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.RM_NAME is null then  --7RM Name M
    v_message_validate_text := v_message_validate_text||v_delimiter||' RM_NAME is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.REFER_ID is null then  --8Refer ID M
    v_message_validate_text := v_message_validate_text||v_delimiter||' REFER_ID is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.REFER_NAME is null then  --9Refer Name M
    v_message_validate_text := v_message_validate_text||v_delimiter||' REFER_NAME is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.MKT_ID is null then  --10MKT ID
    v_message_validate_text := v_message_validate_text||v_delimiter||' MKT_ID is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.MKT_NAME is null then  --11MKT NAME
    v_message_validate_text := v_message_validate_text||v_delimiter||' MKT_NAME is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.BRANCH_CODE is null then  --12Branch Code
    v_message_validate_text := v_message_validate_text||v_delimiter||' BRANCH_CODE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.BRANCH_NAME is null then  --13Branch Name
    v_message_validate_text := v_message_validate_text||v_delimiter||' BRANCH_NAME is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.HUB_ID is null then  --14Hub ID
    v_message_validate_text := v_message_validate_text||v_delimiter||' HUB_ID is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.HUB_NAME is null then  --15Hub Name
    v_message_validate_text := v_message_validate_text||v_delimiter||' HUB_NAME is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.TEAM is null then  --16Team
    v_message_validate_text := v_message_validate_text||v_delimiter||' TEAM is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.SEGMENT is null then  --17Segment M
    v_message_validate_text := v_message_validate_text||v_delimiter||' SEGMENT is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.CHANNEL is null then  --18Channel M
    v_message_validate_text := v_message_validate_text||v_delimiter||' CHANNEL is null';
    v_flag_err := 1;
  END IF;*/
  if ir_gnr_quote_data.INSURANCE_CLASS is null then  --19Insurance Class M
    v_message_validate_text := v_message_validate_text||v_delimiter||' INSURANCE_CLASS is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.SUB_CLASS is null then  --20Sub Class M
    v_message_validate_text := v_message_validate_text||v_delimiter||' SUB_CLASS is null';
    v_flag_err := 1;
  END IF;
  /*if ir_gnr_quote_data.SUB_CLASS_TYPE is null then  --21Sub Class Type
    v_message_validate_text := v_message_validate_text||v_delimiter||' SUB_CLASS_TYPE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.SUB_CHANNEL_ID is null then  --22Sub-Channel ID
    v_message_validate_text := v_message_validate_text||v_delimiter||' SUB_CHANNEL_ID is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.PARTNER_REF_NUMBER is null then  --23Partner Reference Number
    v_message_validate_text := v_message_validate_text||v_delimiter||' PARTNER_REF_NUMBER is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.PREVIOUS_POLICY_NUMBER is null then  --24Previous Policy Number
    v_message_validate_text := v_message_validate_text||v_delimiter||' PREVIOUS_POLICY_NUMBER is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.JOB_RECEIVED_DATE is null then  --25Job Received Date M
    v_message_validate_text := v_message_validate_text||v_delimiter||' JOB_RECEIVED_DATE is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.JOB_TYPE is null then  --26Job Type M
    v_message_validate_text := v_message_validate_text||v_delimiter||' JOB_TYPE is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.DEPARTMENT_CODE is null then  --27Department Code
    v_message_validate_text := v_message_validate_text||v_delimiter||' DEPARTMENT_CODE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.TITLE is null then  --28Title
    v_message_validate_text := v_message_validate_text||v_delimiter||' TITLE is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.INSURED_FIRSTNAME is null then  --29Insured First Name
    v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_FIRSTNAME is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.INSURED_LASTNAME is null then  --30Insured Last Name
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_LASTNAME is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.ID_NUMBER is null then  --31ID Number M
      v_message_validate_text := v_message_validate_text||v_delimiter||' ID_NUMBER is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.ID_TYPE is null then  --32ID Type M
      v_message_validate_text := v_message_validate_text||v_delimiter||' ID_TYPE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.INSURED_PERSON is null then  --33Insured Person  M
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_PERSON is null';
    v_flag_err := 1;
  END IF;*/
  if ir_gnr_quote_data.INSURED_PERSON_TYPE is null then  --34Insured Person Type M
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_PERSON_TYPE is null';
    v_flag_err := 1;
  END IF;
  /*if ir_gnr_quote_data.CUSTOMER_ID is null then  --35Customer ID
      v_message_validate_text := v_message_validate_text||v_delimiter||' CUSTOMER_ID is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.CUSTOMER_NAME is null then  --36Customer Name
      v_message_validate_text := v_message_validate_text||v_delimiter||' CUSTOMER_NAME is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.DATE_OF_BIRTH is null then  --37Date of Birth
      v_message_validate_text := v_message_validate_text||v_delimiter||' DATE_OF_BIRTH is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.INSURED_ADDR_NUMBER is null then  --38Insured Address Number M
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_ADDR_NUMBER is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.INSURED_ADDR_BUIDING is null then  --39Insured Address Building
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_ADDR_BUIDING is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.INSURED_ADDR_MOO is null then  --40Insured Address Moo
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_ADDR_MOO is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.INSURED_ADDR_SOI is null then  --41Insured Address Soi
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_ADDR_SOI is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.INSURED_ADDR_ROAD is null then  --42Insured Address Road
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_ADDR_ROAD is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.SUB_DISTRICT is null then  --43Sub-District M
      v_message_validate_text := v_message_validate_text||v_delimiter||' SUB_DISTRICT is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.DISTRICT is null then  --44District M
      v_message_validate_text := v_message_validate_text||v_delimiter||' DISTRICT is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.PROVINCE is null then  --45Province M
      v_message_validate_text := v_message_validate_text||v_delimiter||' PROVINCE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.POST_CODE is null then  --46Post Code M
      v_message_validate_text := v_message_validate_text||v_delimiter||' POST_CODE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.INSURED_FULL_ADDR is null then  --47Insured Full Address M
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_FULL_ADDR is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.TELEPHONE_NUMBER is null then  --48Telephone Number
      v_message_validate_text := v_message_validate_text||v_delimiter||' TELEPHONE_NUMBER is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.ACCOUNT_NUMBER is null then  --49Account Number
      v_message_validate_text := v_message_validate_text||v_delimiter||' ACCOUNT_NUMBER is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.CONTACT_PERSON_NAME is null then  --50Contact Person Name
      v_message_validate_text := v_message_validate_text||v_delimiter||' CONTACT_PERSON_NAME is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.CONTACT_PERSON_EMAIL is null then  --51Contact Person Email
      v_message_validate_text := v_message_validate_text||v_delimiter||' CONTACT_PERSON_EMAIL is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.CONTACT_PERSON_FAX is null then  --52Contact Person Fax Number
      v_message_validate_text := v_message_validate_text||v_delimiter||' CONTACT_PERSON_FAX is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.CONTACT_PERSON_LINEID is null then  --53Contact Person LINE ID
      v_message_validate_text := v_message_validate_text||v_delimiter||' CONTACT_PERSON_LINEID is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.CONTACT_PERSON_MOBILE is null then  --54Contact Person Mobile Number
      v_message_validate_text := v_message_validate_text||v_delimiter||' CONTACT_PERSON_MOBILE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.CONTACT_PERSON_PHONE is null then  --55Contact Person Phone Number
      v_message_validate_text := v_message_validate_text||v_delimiter||' CONTACT_PERSON_PHONE is null';
    v_flag_err := 1;
  END IF;*/
  if ir_gnr_quote_data.IMD is null then  --56IMD M
      v_message_validate_text := v_message_validate_text||v_delimiter||' IMD is null';
    v_flag_err := 1;
  END IF;
  /*IF ir_gnr_quote_data.QUOTATION_NUMBER IS NULL THEN  --57Quotation Number M
      v_message_validate_text := v_message_validate_text||v_delimiter||' QUOTATION_NUMBER is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.QUOTATION_ISSUE_DATE is null then  --58Quotation Issue Date M
      v_message_validate_text := v_message_validate_text||v_delimiter||' QUOTATION_ISSUE_DATE is null';
    v_flag_err := 1;
  END IF;*/
  if ir_gnr_quote_data.QUOTATION_VERSION is null then  --59Quotation Version M
      v_message_validate_text := v_message_validate_text||v_delimiter||' QUOTATION_VERSION is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.QUOTATION_STATUS is null then  --60Quotation Status  M
      v_message_validate_text := v_message_validate_text||v_delimiter||' QUOTATION_STATUS is null';
    v_flag_err := 1;
  END IF;
  /*if ir_gnr_quote_data.REF_QUOTATION_NUMBER is null then  --61Reference Quotation Number
      v_message_validate_text := v_message_validate_text||v_delimiter||' REF_QUOTATION_NUMBER is null';
    v_flag_err := 1;
  END IF;*/
  IF ir_gnr_quote_data.PACKAGE_NAME IS NULL THEN  --62Package Name M
      v_message_validate_text := v_message_validate_text||v_delimiter||' PACKAGE_NAME is null';
    v_flag_err := 1;
  END IF;
  /*if ir_gnr_quote_data.COVER_PERIOD_DAYS is null then  --63Cover Period (Days)
      v_message_validate_text := v_message_validate_text||v_delimiter||' COVER_PERIOD_DAYS is null';
    v_flag_err := 1;
  END IF;*/
  IF ir_gnr_quote_data.COVER_PERIOD_YEAR IS NULL THEN  --64Cover Period (Year) M
      v_message_validate_text := v_message_validate_text||v_delimiter||' COVER_PERIOD_YEAR is null';
    v_flag_err := 1;
  END IF;
  /*if ir_gnr_quote_data.EXPIRY_DATE is null then  --65Expiry Date
      v_message_validate_text := v_message_validate_text||v_delimiter||' EXPIRY_DATE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.INCEPTION_DATE is null then  --66Inception Date
      v_message_validate_text := v_message_validate_text||v_delimiter||' INCEPTION_DATE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.DEED_NUMBER is null then  --67Deed Number
      v_message_validate_text := v_message_validate_text||v_delimiter||' DEED_NUMBER is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.INSURED_OBJ_ADDR_NUMBER is null then  --68Insured Object Address Number M
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_OBJ_ADDR_NUMBER is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.INSURED_OBJ_BUILDING is null then  --69Insured Object Building
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_OBJ_BUILDING is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.INSURED_OBJ_DISTRICT is null then  --70Insured Object District M
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_OBJ_DISTRICT is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.INSURED_OBJ_FULL_ADDR is null then  --71Insured Object Full Address M
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_OBJ_FULL_ADDR is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.INSURED_OBJ_MOO is null then  --72Insured Object Moo
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_OBJ_MOO is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.INSURED_OBJ_POST_CODE is null then  --73Insured Object Post Code M
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_OBJ_POST_CODE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.INSURED_OBJ_PROVINCE is null then  --74Insured Object Province M
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_OBJ_PROVINCE is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.INSURED_OBJ_ROAD is null then  --75Insured Object Road
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_OBJ_ROAD is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.INSURED_OBJ_SOI is null then  --76Insured Object Soi
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_OBJ_SOI is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.INSURED_OBJ_SUBDIST is null then  --77Insured Object Sub-District M
      v_message_validate_text := v_message_validate_text||v_delimiter||' INSURED_OBJ_SUBDIST is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.NUMBER_OF_FLOOR is null then  --78Number of Floor
      v_message_validate_text := v_message_validate_text||v_delimiter||' NUMBER_OF_FLOOR is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.CONSTRUCTION_CLASS is null then  --79Construction Class M
      v_message_validate_text := v_message_validate_text||v_delimiter||' CONSTRUCTION_CLASS is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.REF1 is null then  --80Payment Reference Number1 M
      v_message_validate_text := v_message_validate_text||v_delimiter||' REF1 is null';
    v_flag_err := 1;
  END IF;
  IF ir_gnr_quote_data.cover_period_year IN ('1','1&3') THEN
  if ir_gnr_quote_data.Y1_PAYREF_NUM2 is null then  --81Y1_Payment Reference Number2 M
      v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_PAYREF_NUM2 is null';
    v_flag_err := 1;
  END IF;
  END IF;*/
  /*
  IF ir_gnr_quote_data.cover_period_year IN ('2','1&2') THEN
  if ir_gnr_quote_data.Y2_PAYREF_NUM2 is null then  --82Y2_Payment Reference Number2
      v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_PAYREF_NUM2 is null';
    v_flag_err := 1;
  END IF;
  end if;
  */
 /* IF ir_gnr_quote_data.cover_period_year IN ('3','1&3') THEN
  if ir_gnr_quote_data.Y3_PAYREF_NUM2 is null then  --83Y3_Payment Reference Number2 M
      v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_PAYREF_NUM2 is null';
    v_flag_err := 1;
  END IF;
  END IF;*/
 /* if ir_gnr_quote_data.RISK_CODE is null then  --84Risk Code M
      v_message_validate_text := v_message_validate_text||v_delimiter||' RISK_CODE is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.PURPOSED_OF_USE is null then  --85Purposed of Use M
      v_message_validate_text := v_message_validate_text||v_delimiter||' PURPOSED_OF_USE is null';
    v_flag_err := 1;
  END IF;*/
 /* if ir_gnr_quote_data.ASSET_TYPE is null then  --86Asset Type
      v_message_validate_text := v_message_validate_text||v_delimiter||' ASSET_TYPE is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.CAPITAL_TYPE is null then  --87Capital Type
      v_message_validate_text := v_message_validate_text||v_delimiter||' CAPITAL_TYPE is null';
    v_flag_err := 1;
  END IF;*/
  IF ir_gnr_quote_data.COVER_PERIOD_YEAR IN ('1','1&3')  THEN
    /*IF ir_gnr_quote_data.Y1_TOTAL_SUM_INSURED IS NULL THEN  --88Y1_total sum insured M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_TOTAL_SUM_INSURED is null';
      v_flag_err := 1;
    END IF;*/
    IF ir_gnr_quote_data.Y1_NET_PREMIUM IS NULL THEN  --89Y1_Net Premium M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_NET_PREMIUM is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y1_DUTY IS NULL THEN  --90Y1_Duty M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_DUTY is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y1_TAX IS NULL THEN  --91Y1_Tax M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_TAX is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y1_TOTAL_PREMIUM IS NULL THEN  --92Y1_Total Premium M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_TOTAL_PREMIUM is null';
      v_flag_err := 1;
    END IF;
  /*  IF ir_gnr_quote_data.Y1_SI_BUILDING IS NULL THEN  --93Y1_SI of Building M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_SI_BUILDING is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y1_SI_FURNITURE IS NULL THEN  --94Y1_SI of Furniture M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_SI_FURNITURE is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y1_SI_MACHINERY IS NULL THEN  --95Y1_SI of Machinery M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_SI_MACHINERY is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y1_SI_OTHERS IS NULL THEN  --96Y1_SI of Others M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_SI_OTHERS is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y1_SI_STOCK IS NULL THEN  --97Y1_SI of Stock M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y1_SI_STOCK is null';
      v_flag_err := 1;
    END IF;*/
  END IF;--if ir_gnr_quote_data.COVER_PERIOD_YEAR IN ('1','1&3')  then
  IF ir_gnr_quote_data.COVER_PERIOD_YEAR IN ('2','1&2')  THEN
    /*IF ir_gnr_quote_data.Y2_TOTAL_SUM_INSURED IS NULL THEN  --98Y2_total sum insured
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_TOTAL_SUM_INSURED is null';
      v_flag_err := 1;
    END IF;*/
    IF ir_gnr_quote_data.Y2_NETPREMIUM IS NULL THEN  --99Y2_Net Premium
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_NETPREMIUM is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y2_DUTY IS NULL THEN  --100Y2_Duty
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_DUTY is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y2_TAX IS NULL THEN  --101Y2_Tax
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_TAX is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y2_TOTAL_PREMIUM IS NULL THEN  --102Y2_Total Premium
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_TOTAL_PREMIUM is null';
      v_flag_err := 1;
    END IF;
    /*IF ir_gnr_quote_data.Y2_SI_BUILDING IS NULL THEN  --103Y2_SI of Building
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_SI_BUILDING is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y2_SI_FURNITURE IS NULL THEN  --104Y2_SI of Furniture
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_SI_FURNITURE is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y2_SI_MACHINERY IS NULL THEN  --105Y2_SI of Machinery
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_SI_MACHINERY is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y2_SI_OTHERS IS NULL THEN  --106Y2_SI of Others
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_SI_OTHERS is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y2_SI_STOCK IS NULL THEN  --107Y2_SI of Stock
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y2_SI_STOCK is null';
      v_flag_err := 1;
    END IF;*/
  END IF;--if ir_gnr_quote_data.COVER_PERIOD_YEAR IN ('1','1&2')  then

  IF ir_gnr_quote_data.COVER_PERIOD_YEAR IN ('3','1&3')  THEN
   /* IF ir_gnr_quote_data.Y3_TOTAL_SUM_INSURED IS NULL THEN  --108Y3_total sum insured M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_TOTAL_SUM_INSURED is null';
      v_flag_err := 1;
    END IF;*/
    IF ir_gnr_quote_data.Y3_NET_PREMIUM IS NULL THEN  --109Y3_Net Premium M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_NET_PREMIUM is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y3_DUTY IS NULL THEN  --110Y3_Duty M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_DUTY is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y3_TAX IS NULL THEN  --111Y3_Tax M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_TAX is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y3_TOTAL_PREMIUM IS NULL THEN  --112Y3_Total Premium M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_TOTAL_PREMIUM is null';
      v_flag_err := 1;
    END IF;
   /* IF ir_gnr_quote_data.Y3_SI_BUILDING IS NULL THEN  --113Y3_SI of Building M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_SI_BUILDING is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y3_SI_FURNITURE IS NULL THEN  --114Y3_SI of Furniture M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_SI_FURNITURE is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y3_SI_MACHINERY IS NULL THEN  --115Y3_SI of Machinery M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_SI_MACHINERY is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y3_SI_OTHERS IS NULL THEN  --116Y3_SI of Others M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_SI_OTHERS is null';
      v_flag_err := 1;
    END IF;
    IF ir_gnr_quote_data.Y3_SI_STOCK IS NULL THEN  --117Y3_SI of Stock M
        v_message_validate_text := v_message_validate_text||v_delimiter||' Y3_SI_STOCK is null';
      v_flag_err := 1;
    END IF;*/
  END IF;--if ir_gnr_quote_data.COVER_PERIOD_YEAR IN ('3','1&3')  then

  /*if ir_gnr_quote_data.REF2 is null then  --118
      v_message_validate_text := v_message_validate_text||v_delimiter||' REF2 is null';
    v_flag_err := 1;
  END IF;
  if ir_gnr_quote_data.LOAD_DATE is null then  --119
      v_message_validate_text := v_message_validate_text||v_delimiter||' LOAD_DATE is null';
    v_flag_err := 1;
  END IF;*/
  /*if ir_gnr_quote_data.CREATE_DATE is null then  --120
  if ir_gnr_quote_data.CREATE_USER is null then  --121
  if ir_gnr_quote_data.UPDATE_DATE is null then  --122
  if ir_gnr_quote_data.UPDATE_USER is null then  --123 */
  --if ir_gnr_quote_data.MESSAGE_ERROR is null then  --124
  IF v_flag_err = 1 THEN
     o_msgerror := substr(v_message_validate_text,2);
  ELSE
    o_msgerror := NULL;
  END IF;
EXCEPTION WHEN invaid_data THEN
    o_msgerror := v_message_err;
 WHEN OTHERS THEN
  o_msgerror :=v_func_name||g_message_err||' v_state='||v_state||' '||SQLERRM ;
  az_pk0_general.LogTrace(v_func_name,userenv('sessionid'),o_msgerror);
END;
----------------------------------------------------------------------------------------------------
--เก็บข้อมูล error from insert gnr_quote_data
PROCEDURE P_INS_GNR_QUOTE_DATA_ERR(ir_gnr_quote_data_err IN gnr_quote_data_err%ROWTYPE
                                   ,o_msgerror OUT VARCHAR2)
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_func_name CONSTANT   VARCHAR2(300) := g_package_name||'P_INS_GNR_QUOTE_DATA_ERR';
  v_message_err      VARCHAR2(2000) := NULL;
  v_seq_id              NUMBER := 0;
BEGIN
 o_msgerror := NULL;
 v_seq_id := 0;

 BEGIN
 SELECT GNR_QUOTE_DATA_ERR_seq.Nextval INTO v_seq_id FROM dual ;
 END;

 INSERT INTO gnr_quote_data_err(
                                SEQ_ID,
                                job_number, 
                                file_name, 
                                quotation_number, 
                                load_date, 
                                message_error, 
                                create_date, 
                                create_user, 
                                update_date, 
                                update_user, 
                                data_source
                                )
                                VALUES
                                (v_seq_id, 
                                ir_gnr_quote_data_err.job_number, 
                                ir_gnr_quote_data_err.file_name, 
                                ir_gnr_quote_data_err.quotation_number, 
                                ir_gnr_quote_data_err.load_date, 
                                ir_gnr_quote_data_err.message_error, 
                                SYSDATE, 
                                USER, 
                                NULL, 
                                NULL, 
                                ir_gnr_quote_data_err.data_source);
  COMMIT;
  o_msgerror := NULL;
EXCEPTION WHEN OTHERS THEN
  o_msgerror := 'Cannot insert data to table gnr_quote_data_err '||' '||SQLERRM ;
  rollback;
  az_pk0_general.LogTrace(v_func_name,userenv('sessionid'),o_msgerror);
END;
----------------------------------------------------------------------------------------------------
--เก็บข้อมูล gnr_quote_data
PROCEDURE P_INS_GNR_QUOTE_DATA(ir_gnr_quote_data IN gnr_quote_data%ROWTYPE
                               ,o_quote_data_id OUT NUMBER
                               ,o_msgerror OUT VARCHAR2)
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_func_name CONSTANT   VARCHAR2(300) := g_package_name||'P_INS_GNR_QUOTE_DATA';
  v_message_err      VARCHAR2(2000) := NULL;
  v_seq              NUMBER := 0;
BEGIN
 o_msgerror := NULL;
 v_seq := 0;

 BEGIN
 SELECT GNR_QUOTE_DATA_SEQ.Nextval INTO v_seq FROM dual ;
 END;

 INSERT INTO gnr_quote_data(
                 quote_data_id,
                  job_number,
                  batch_type,
                  file_name,
                  upload_date,
                  rm_id,
                  rm_name,
                  refer_id,
                  refer_name,
                  mkt_id,
                  mkt_name,
                  branch_code,
                  branch_name,
                  hub_id,
                  hub_name,
                  team,
                  SEGMENT,
                  channel,
                  insurance_class,
                  sub_class,
                  sub_class_type,
                  sub_channel_id,
                  partner_ref_number,
                  previous_policy_number,
                  job_received_date,
                  job_type,
                  department_code,
                  title,
                  insured_firstname,
                  insured_lastname,
                  id_number,
                  id_type,
                  insured_person,
                  insured_person_type,
                  customer_id,
                  customer_name,
                  date_of_birth,
                  insured_addr_number,
                  insured_addr_buiding,
                  insured_addr_moo,
                  insured_addr_soi,
                  insured_addr_road,
                  sub_district,
                  district,
                  province,
                  post_code,
                  insured_full_addr,
                  telephone_number,
                  account_number,
                  contact_person_name,
                  contact_person_email,
                  contact_person_fax,
                  contact_person_lineid,
                  contact_person_mobile,
                  contact_person_phone,
                  imd,
                  quotation_number,
                  quotation_issue_date,
                  quotation_version,
                  quotation_status,
                  ref_quotation_number,
                  package_name,
                  cover_period_days,
                  cover_period_year,
                  expiry_date,
                  inception_date,
                  deed_number,
                  insured_obj_addr_number,
                  insured_obj_building,
                  insured_obj_district,
                  insured_obj_full_addr,
                  insured_obj_moo,
                  insured_obj_post_code,
                  insured_obj_province,
                  insured_obj_road,
                  insured_obj_soi,
                  insured_obj_subdist,
                  number_of_floor,
                  construction_class,
                  ref1,
                  y1_payref_num2,
                  y2_payref_num2,
                  y3_payref_num2,
                  risk_code,
                  purposed_of_use,
                  asset_type,
                  capital_type,
                  y1_total_sum_insured,
                  y1_net_premium,
                  y1_duty,
                  y1_tax,
                  y1_total_premium,
                  y1_si_building,
                  y1_si_furniture,
                  y1_si_machinery,
                  y1_si_others,
                  y1_si_stock,
                  y2_total_sum_insured,
                  y2_netpremium,
                  y2_duty,
                  y2_tax,
                  y2_total_premium,
                  y2_si_building,
                  y2_si_furniture,
                  y2_si_machinery,
                  y2_si_others,
                  y2_si_stock,
                  y3_total_sum_insured,
                  y3_net_premium,
                  y3_duty,
                  y3_tax,
                  y3_total_premium,
                  y3_si_building,
                  y3_si_furniture,
                  y3_si_machinery,
                  y3_si_others,
                  y3_si_stock,
                  ref2,
                  load_date,
                  create_date,
                  create_user,
                  update_date,
                  update_user,
                  data_source
                  )
                  VALUES
        (
        v_seq,  --1QUOTE_DATA_ID
        ir_gnr_quote_data.JOB_NUMBER,  --2JOB NUMBER
        ir_gnr_quote_data.BATCH_TYPE,  --3Batch Type
        ir_gnr_quote_data.FILE_NAME,  --4File Name
        ir_gnr_quote_data.UPLOAD_DATE,  --5Upload Date
        ir_gnr_quote_data.RM_ID,  --6RM ID
        ir_gnr_quote_data.RM_NAME,  --7RM Name
        ir_gnr_quote_data.REFER_ID,  --8Refer ID
        ir_gnr_quote_data.REFER_NAME,  --9Refer Name
        ir_gnr_quote_data.MKT_ID,  --10MKT ID
        ir_gnr_quote_data.MKT_NAME,  --11MKT NAME
        ir_gnr_quote_data.BRANCH_CODE,  --12Branch Code
        ir_gnr_quote_data.BRANCH_NAME,  --13Branch Name
        ir_gnr_quote_data.HUB_ID,  --14Hub ID
        ir_gnr_quote_data.HUB_NAME,  --15Hub Name
        ir_gnr_quote_data.TEAM,  --16Team
        ir_gnr_quote_data.SEGMENT,  --17Segment
        ir_gnr_quote_data.CHANNEL,  --18Channel
        ir_gnr_quote_data.INSURANCE_CLASS,  --19Insurance Class
        ir_gnr_quote_data.SUB_CLASS,  --20Sub Class
        ir_gnr_quote_data.SUB_CLASS_TYPE,  --21Sub Class Type
        ir_gnr_quote_data.SUB_CHANNEL_ID,  --22Sub-Channel ID
        ir_gnr_quote_data.PARTNER_REF_NUMBER,  --23Partner Reference Number
        ir_gnr_quote_data.PREVIOUS_POLICY_NUMBER,  --24Previous Policy Number
        ir_gnr_quote_data.JOB_RECEIVED_DATE,  --25Job Received Date
        ir_gnr_quote_data.JOB_TYPE,  --26Job Type
        ir_gnr_quote_data.DEPARTMENT_CODE,  --27Department Code
        ir_gnr_quote_data.TITLE,  --28Title
        ir_gnr_quote_data.INSURED_FIRSTNAME,  --29Insured First Name
        ir_gnr_quote_data.INSURED_LASTNAME,  --30Insured Last Name
        ir_gnr_quote_data.ID_NUMBER,  --31ID Number
        ir_gnr_quote_data.ID_TYPE,  --32ID Type
        ir_gnr_quote_data.INSURED_PERSON,  --33Insured Person
        ir_gnr_quote_data.INSURED_PERSON_TYPE,  --34Insured Person Type
        ir_gnr_quote_data.CUSTOMER_ID,  --35Customer ID
        ir_gnr_quote_data.CUSTOMER_NAME,  --36Customer Name
        ir_gnr_quote_data.DATE_OF_BIRTH,  --37Date of Birth
        ir_gnr_quote_data.INSURED_ADDR_NUMBER,  --38Insured Address Number
        ir_gnr_quote_data.INSURED_ADDR_BUIDING,  --39Insured Address Building
        ir_gnr_quote_data.INSURED_ADDR_MOO,  --40Insured Address Moo
        ir_gnr_quote_data.INSURED_ADDR_SOI,  --41Insured Address Soi
        ir_gnr_quote_data.INSURED_ADDR_ROAD,  --42Insured Address Road
        ir_gnr_quote_data.SUB_DISTRICT,  --43Sub-District
        ir_gnr_quote_data.DISTRICT,  --44District
        ir_gnr_quote_data.PROVINCE,  --45Province
        ir_gnr_quote_data.POST_CODE,  --46Post Code
        ir_gnr_quote_data.INSURED_FULL_ADDR,  --47Insured Full Address
        ir_gnr_quote_data.TELEPHONE_NUMBER,  --48Telephone Number
        ir_gnr_quote_data.ACCOUNT_NUMBER,  --49Account Number
        ir_gnr_quote_data.CONTACT_PERSON_NAME,  --50Contact Person Name
        ir_gnr_quote_data.CONTACT_PERSON_EMAIL,  --51Contact Person Email
        ir_gnr_quote_data.CONTACT_PERSON_FAX,  --52Contact Person Fax Number
        ir_gnr_quote_data.CONTACT_PERSON_LINEID,  --53Contact Person LINE ID
        ir_gnr_quote_data.CONTACT_PERSON_MOBILE,  --54Contact Person Mobile Number
        ir_gnr_quote_data.CONTACT_PERSON_PHONE,  --55Contact Person Phone Number
        ir_gnr_quote_data.IMD,  --56IMD
        ir_gnr_quote_data.QUOTATION_NUMBER,  --57Quotation Number
        ir_gnr_quote_data.QUOTATION_ISSUE_DATE,  --58Quotation Issue Date
        ir_gnr_quote_data.QUOTATION_VERSION,  --59Quotation Version
        ir_gnr_quote_data.QUOTATION_STATUS,  --60Quotation Status
        ir_gnr_quote_data.REF_QUOTATION_NUMBER,  --61Reference Quotation Number
        ir_gnr_quote_data.PACKAGE_NAME,  --62Package Name
        ir_gnr_quote_data.COVER_PERIOD_DAYS,  --63Cover Period (Days)
        ir_gnr_quote_data.COVER_PERIOD_YEAR,  --64Cover Period (Year)
        ir_gnr_quote_data.EXPIRY_DATE,  --65Expiry Date
        ir_gnr_quote_data.INCEPTION_DATE,  --66Inception Date
        ir_gnr_quote_data.DEED_NUMBER,  --67Deed Number
        ir_gnr_quote_data.INSURED_OBJ_ADDR_NUMBER,  --68Insured Object Address Number
        ir_gnr_quote_data.INSURED_OBJ_BUILDING,  --69Insured Object Building
        ir_gnr_quote_data.INSURED_OBJ_DISTRICT,  --70Insured Object District
        ir_gnr_quote_data.INSURED_OBJ_FULL_ADDR,  --71Insured Object Full Address
        ir_gnr_quote_data.INSURED_OBJ_MOO,  --72Insured Object Moo
        ir_gnr_quote_data.INSURED_OBJ_POST_CODE,  --73Insured Object Post Code
        ir_gnr_quote_data.INSURED_OBJ_PROVINCE,  --74Insured Object Province
        ir_gnr_quote_data.INSURED_OBJ_ROAD,  --75Insured Object Road
        ir_gnr_quote_data.INSURED_OBJ_SOI,  --76Insured Object Soi
        ir_gnr_quote_data.INSURED_OBJ_SUBDIST,  --77Insured Object Sub-District
        ir_gnr_quote_data.NUMBER_OF_FLOOR,  --78Number of Floor
        ir_gnr_quote_data.CONSTRUCTION_CLASS,  --79Construction Class
        ir_gnr_quote_data.REF1,  --80Payment Reference Number1
        ir_gnr_quote_data.Y1_PAYREF_NUM2,  --81Y1_Payment Reference Number2
        ir_gnr_quote_data.Y2_PAYREF_NUM2,  --82Y2_Payment Reference Number2
        ir_gnr_quote_data.Y3_PAYREF_NUM2,  --83Y3_Payment Reference Number2
        ir_gnr_quote_data.RISK_CODE,  --84Risk Code
        ir_gnr_quote_data.PURPOSED_OF_USE,  --85Purposed of Use
        ir_gnr_quote_data.ASSET_TYPE,  --86Asset Type
        ir_gnr_quote_data.CAPITAL_TYPE,  --87Capital Type
        ir_gnr_quote_data.Y1_TOTAL_SUM_INSURED,  --88Y1_total sum insured
        ir_gnr_quote_data.Y1_NET_PREMIUM,  --89Y1_Net Premium
        ir_gnr_quote_data.Y1_DUTY,  --90Y1_Duty
        ir_gnr_quote_data.Y1_TAX,  --91Y1_Tax
        ir_gnr_quote_data.Y1_TOTAL_PREMIUM,  --92Y1_Total Premium
        ir_gnr_quote_data.Y1_SI_BUILDING,  --93Y1_SI of Building
        ir_gnr_quote_data.Y1_SI_FURNITURE,  --94Y1_SI of Furniture
        ir_gnr_quote_data.Y1_SI_MACHINERY,  --95Y1_SI of Machinery
        ir_gnr_quote_data.Y1_SI_OTHERS,  --96Y1_SI of Others
        ir_gnr_quote_data.Y1_SI_STOCK,  --97Y1_SI of Stock
        ir_gnr_quote_data.Y2_TOTAL_SUM_INSURED,  --98Y2_total sum insured
        ir_gnr_quote_data.Y2_NETPREMIUM,  --99Y2_Net Premium
        ir_gnr_quote_data.Y2_DUTY,  --100Y2_Duty
        ir_gnr_quote_data.Y2_TAX,  --101Y2_Tax
        ir_gnr_quote_data.Y2_TOTAL_PREMIUM,  --102Y2_Total Premium
        ir_gnr_quote_data.Y2_SI_BUILDING,  --103Y2_SI of Building
        ir_gnr_quote_data.Y2_SI_FURNITURE,  --104Y2_SI of Furniture
        ir_gnr_quote_data.Y2_SI_MACHINERY,  --105Y2_SI of Machinery
        ir_gnr_quote_data.Y2_SI_OTHERS,  --106Y2_SI of Others
        ir_gnr_quote_data.Y2_SI_STOCK,  --107Y2_SI of Stock
        ir_gnr_quote_data.Y3_TOTAL_SUM_INSURED,  --108Y3_total sum insured
        ir_gnr_quote_data.Y3_NET_PREMIUM,  --109Y3_Net Premium
        ir_gnr_quote_data.Y3_DUTY,  --110Y3_Duty
        ir_gnr_quote_data.Y3_TAX,  --111Y3_Tax
        ir_gnr_quote_data.Y3_TOTAL_PREMIUM,  --112Y3_Total Premium
        ir_gnr_quote_data.Y3_SI_BUILDING,  --113Y3_SI of Building
        ir_gnr_quote_data.Y3_SI_FURNITURE,  --114Y3_SI of Furniture
        ir_gnr_quote_data.Y3_SI_MACHINERY,  --115Y3_SI of Machinery
        ir_gnr_quote_data.Y3_SI_OTHERS,  --116Y3_SI of Others
        ir_gnr_quote_data.Y3_SI_STOCK,  --117Y3_SI of Stock
        ir_gnr_quote_data.REF2,  --118ref2
        ir_gnr_quote_data.LOAD_DATE,  --119Load date
        SYSDATE,
        USER,
        NULL,
        NULL,
        ir_gnr_quote_data.data_source--Data source
        );
  FOR rec IN   (SELECT t.quote_data_id 
                FROM gnr_quote_data t 
                WHERE t.quote_data_id =v_seq) LOOP
     o_quote_data_id := rec.quote_data_id;
  END LOOP;
  COMMIT;
  o_msgerror := NULL;
EXCEPTION WHEN OTHERS THEN
  o_msgerror := 'Cannot insert data to table gnr_quote_data'||' '||SQLERRM ;
   az_pk0_general.LogTrace(v_func_name,userenv('sessionid'),o_msgerror);
   ROLLBACK;
END;
----------------------------------------------------------------------------------------------------
PROCEDURE P_INSERT_DATA_REF( p_data_ref_id  IN  NUMBER  ,
                           p_Ref1         IN  VARCHAR ,
                           p_Ref2         IN  VARCHAR ,
                           p_amount       IN  NUMBER  ,
                           p_year         IN  VARCHAR ) IS
PRAGMA AUTONOMOUS_TRANSACTION;
v_func_name CONSTANT   VARCHAR2(300) := g_package_name||'P_INSERT_DATA_REF';
v_message_err          VARCHAR2(1000) := NULL;
v_seg2  NUMBER;
v_state NUMBER :=0;
v_chk   NUMBER :=0;
v_count NUMBER :=0;
r_gnr_quote_data GNR_QUOTE_DATA_REF%ROWTYPE;
BEGIN
 v_state := 1;
 SELECT GNR_QUOTE_DATA_REF_SEQ.Nextval INTO v_seg2 FROM dual ;
 v_state := 2;
 --Check dup rec GNR_QUOTE_DATA
 v_count := 0;
 FOR rec IN
 (SELECT *
 FROM  GNR_QUOTE_DATA_REF r
 WHERE r.quote_data_ref_id  = p_data_ref_id
 AND r.ref2 = p_Ref2
 AND r.cover_period_year = p_year) LOOP
   v_count := v_count + 1;
   r_gnr_quote_data := rec;
   ----------------------------
        --Update gnr_quote_data_ref
      UPDATE gnr_quote_data_ref r
      SET
        --QUOTE_DATA_ID = r_gnr_quote_data.QUOTE_DATA_ID,  --1QUOTE_DATA_ID
        JOB_NUMBER = r_gnr_quote_data.JOB_NUMBER,  --2JOB NUMBER
        BATCH_TYPE = r_gnr_quote_data.BATCH_TYPE,  --3Batch Type
        FILE_NAME = r_gnr_quote_data.FILE_NAME,  --4File Name
        UPLOAD_DATE = r_gnr_quote_data.UPLOAD_DATE,  --5Upload Date
        RM_ID = r_gnr_quote_data.RM_ID,  --6RM ID
        RM_NAME = r_gnr_quote_data.RM_NAME,  --7RM Name
        REFER_ID = r_gnr_quote_data.REFER_ID,  --8Refer ID
        REFER_NAME = r_gnr_quote_data.REFER_NAME,  --9Refer Name
        MKT_ID = r_gnr_quote_data.MKT_ID,  --10MKT ID
        MKT_NAME = r_gnr_quote_data.MKT_NAME,  --11MKT NAME
        BRANCH_CODE = r_gnr_quote_data.BRANCH_CODE,  --12Branch Code
        BRANCH_NAME = r_gnr_quote_data.BRANCH_NAME,  --13Branch Name
        HUB_ID = r_gnr_quote_data.HUB_ID,  --14Hub ID
        HUB_NAME = r_gnr_quote_data.HUB_NAME,  --15Hub Name
        TEAM = r_gnr_quote_data.TEAM,  --16Team
        SEGMENT = r_gnr_quote_data.SEGMENT,  --17Segment
        CHANNEL = r_gnr_quote_data.CHANNEL,  --18Channel
        INSURANCE_CLASS = r_gnr_quote_data.INSURANCE_CLASS,  --19Insurance Class
        SUB_CLASS = r_gnr_quote_data.SUB_CLASS,  --20Sub Class
        SUB_CLASS_TYPE = r_gnr_quote_data.SUB_CLASS_TYPE,  --21Sub Class Type
        SUB_CHANNEL_ID = r_gnr_quote_data.SUB_CHANNEL_ID,  --22Sub-Channel ID
        PARTNER_REF_NUMBER = r_gnr_quote_data.PARTNER_REF_NUMBER,  --23Partner Reference Number
        PREVIOUS_POLICY_NUMBER = r_gnr_quote_data.PREVIOUS_POLICY_NUMBER,  --24Previous Policy Number
        JOB_RECEIVED_DATE = r_gnr_quote_data.JOB_RECEIVED_DATE,  --25Job Received Date
        JOB_TYPE = r_gnr_quote_data.JOB_TYPE,  --26Job Type
        DEPARTMENT_CODE = r_gnr_quote_data.DEPARTMENT_CODE,  --27Department Code
        TITLE = r_gnr_quote_data.TITLE,  --28Title
        INSURED_FIRSTNAME = r_gnr_quote_data.INSURED_FIRSTNAME,  --29Insured First Name
        INSURED_LASTNAME = r_gnr_quote_data.INSURED_LASTNAME,  --30Insured Last Name
        ID_NUMBER = r_gnr_quote_data.ID_NUMBER,  --31ID Number
        ID_TYPE = r_gnr_quote_data.ID_TYPE,  --32ID Type
        INSURED_PERSON = r_gnr_quote_data.INSURED_PERSON,  --33Insured Person
        INSURED_PERSON_TYPE = r_gnr_quote_data.INSURED_PERSON_TYPE,  --34Insured Person Type
        CUSTOMER_ID = r_gnr_quote_data.CUSTOMER_ID,  --35Customer ID
        CUSTOMER_NAME = r_gnr_quote_data.CUSTOMER_NAME,  --36Customer Name
        DATE_OF_BIRTH = r_gnr_quote_data.DATE_OF_BIRTH,  --37Date of Birth

        INSURED_ADDR_NUMBER = r_gnr_quote_data.INSURED_ADDR_NUMBER,  --38Insured Address Number
        INSURED_ADDR_BUIDING = r_gnr_quote_data.INSURED_ADDR_BUIDING,  --39Insured Address Building
        INSURED_ADDR_MOO = r_gnr_quote_data.INSURED_ADDR_MOO,  --40Insured Address Moo
        INSURED_ADDR_SOI = r_gnr_quote_data.INSURED_ADDR_SOI,  --41Insured Address Soi
        INSURED_ADDR_ROAD = r_gnr_quote_data.INSURED_ADDR_ROAD,  --42Insured Address Road
        SUB_DISTRICT = r_gnr_quote_data.SUB_DISTRICT,  --43Sub-District
        DISTRICT = r_gnr_quote_data.DISTRICT,  --44District
        PROVINCE = r_gnr_quote_data.PROVINCE,  --45Province
        POST_CODE = r_gnr_quote_data.POST_CODE,  --46Post Code

        INSURED_FULL_ADDR = r_gnr_quote_data.INSURED_FULL_ADDR,  --47Insured Full Address
        TELEPHONE_NUMBER = r_gnr_quote_data.TELEPHONE_NUMBER,  --48Telephone Number
        ACCOUNT_NUMBER = r_gnr_quote_data.ACCOUNT_NUMBER,  --49Account Number
        CONTACT_PERSON_NAME = r_gnr_quote_data.CONTACT_PERSON_NAME,  --50Contact Person Name
        CONTACT_PERSON_EMAIL = r_gnr_quote_data.CONTACT_PERSON_EMAIL,  --51Contact Person Email
        CONTACT_PERSON_FAX = r_gnr_quote_data.CONTACT_PERSON_FAX,  --52Contact Person Fax Number
        CONTACT_PERSON_LINEID = r_gnr_quote_data.CONTACT_PERSON_LINEID,  --53Contact Person LINE ID
        CONTACT_PERSON_MOBILE = r_gnr_quote_data.CONTACT_PERSON_MOBILE,  --54Contact Person Mobile Number
        CONTACT_PERSON_PHONE = r_gnr_quote_data.CONTACT_PERSON_PHONE,  --55Contact Person Phone Number

        IMD = r_gnr_quote_data.IMD,  --56IMD
        QUOTATION_NUMBER = r_gnr_quote_data.QUOTATION_NUMBER,  --57Quotation Number
        QUOTATION_ISSUE_DATE = r_gnr_quote_data.QUOTATION_ISSUE_DATE,  --58Quotation Issue Date
        QUOTATION_VERSION = r_gnr_quote_data.QUOTATION_VERSION,  --59Quotation Version
        QUOTATION_STATUS = r_gnr_quote_data.QUOTATION_STATUS,  --60Quotation Status
        REF_QUOTATION_NUMBER = r_gnr_quote_data.REF_QUOTATION_NUMBER,  --61Reference Quotation Number
        PACKAGE_NAME = r_gnr_quote_data.PACKAGE_NAME,  --62Package Name
        COVER_PERIOD_DAYS = r_gnr_quote_data.COVER_PERIOD_DAYS,  --63Cover Period (Days)

        --COVER_PERIOD_YEAR = r_gnr_quote_data.COVER_PERIOD_YEAR,  --64Cover Period (Year)

        EXPIRY_DATE = r_gnr_quote_data.EXPIRY_DATE,  --65Expiry Date
        INCEPTION_DATE = r_gnr_quote_data.INCEPTION_DATE,  --66Inception Date
        DEED_NUMBER = r_gnr_quote_data.DEED_NUMBER,  --67Deed Number

        INSURED_OBJ_ADDR_NUMBER = r_gnr_quote_data.INSURED_OBJ_ADDR_NUMBER,  --68Insured Object Address Number
        INSURED_OBJ_BUILDING = r_gnr_quote_data.INSURED_OBJ_BUILDING,  --69Insured Object Building
        INSURED_OBJ_DISTRICT = r_gnr_quote_data.INSURED_OBJ_DISTRICT,  --70Insured Object District
        INSURED_OBJ_FULL_ADDR = r_gnr_quote_data.INSURED_OBJ_FULL_ADDR,  --71Insured Object Full Address
        INSURED_OBJ_MOO = r_gnr_quote_data.INSURED_OBJ_MOO,  --72Insured Object Moo
        INSURED_OBJ_POST_CODE = r_gnr_quote_data.INSURED_OBJ_POST_CODE,  --73Insured Object Post Code
        INSURED_OBJ_PROVINCE = r_gnr_quote_data.INSURED_OBJ_PROVINCE,  --74Insured Object Province
        INSURED_OBJ_ROAD = r_gnr_quote_data.INSURED_OBJ_ROAD,  --75Insured Object Road
        INSURED_OBJ_SOI = r_gnr_quote_data.INSURED_OBJ_SOI,  --76Insured Object Soi
        INSURED_OBJ_SUBDIST = r_gnr_quote_data.INSURED_OBJ_SUBDIST,  --77Insured Object Sub-District
        NUMBER_OF_FLOOR = r_gnr_quote_data.NUMBER_OF_FLOOR,  --78Number of Floor
        CONSTRUCTION_CLASS = r_gnr_quote_data.CONSTRUCTION_CLASS,  --79Construction Class

       -- REF1 = r_gnr_quote_data.REF1,  --80Payment Reference Number1
        RISK_CODE = r_gnr_quote_data.RISK_CODE,  --81Risk Code
        PURPOSED_OF_USE = r_gnr_quote_data.PURPOSED_OF_USE,  --82Purposed of Use
        ASSET_TYPE = r_gnr_quote_data.ASSET_TYPE,  --83Asset Type
        CAPITAL_TYPE = r_gnr_quote_data.CAPITAL_TYPE,  --84Capital Type

        Y1_TOTAL_SUM_INSURED = r_gnr_quote_data.Y1_TOTAL_SUM_INSURED,  --85Y1_total sum insured
        Y1_NET_PREMIUM = r_gnr_quote_data.Y1_NET_PREMIUM,  --86Y1_Net Premium
        Y1_DUTY = r_gnr_quote_data.Y1_DUTY,  --87Y1_Duty
        Y1_TAX = r_gnr_quote_data.Y1_TAX,  --88Y1_Tax
        Y1_TOTAL_PREMIUM = r_gnr_quote_data.Y1_TOTAL_PREMIUM,  --89Y1_Total Premium
        Y1_SI_BUILDING = r_gnr_quote_data.Y1_SI_BUILDING,  --90Y1_SI of Building
        Y1_SI_FURNITURE = r_gnr_quote_data.Y1_SI_FURNITURE,  --91Y1_SI of Furniture
        Y1_SI_MACHINERY = r_gnr_quote_data.Y1_SI_MACHINERY,  --92Y1_SI of Machinery
        Y1_SI_OTHERS = r_gnr_quote_data.Y1_SI_OTHERS,  --93Y1_SI of Others
        Y1_SI_STOCK = r_gnr_quote_data.Y1_SI_STOCK,  --94Y1_SI of Stock

        Y2_TOTAL_SUM_INSURED = r_gnr_quote_data.Y2_TOTAL_SUM_INSURED,  --95Y2_total sum insured
        Y2_NETPREMIUM = r_gnr_quote_data.Y2_NETPREMIUM,  --96Y2_Net Premium
        Y2_DUTY = r_gnr_quote_data.Y2_DUTY,  --97Y2_Duty
        Y2_TAX = r_gnr_quote_data.Y2_TAX,  --98Y2_Tax
        Y2_TOTAL_PREMIUM = r_gnr_quote_data.Y2_TOTAL_PREMIUM,  --99Y2_Total Premium
        Y2_SI_BUILDING = r_gnr_quote_data.Y2_SI_BUILDING,  --100Y2_SI of Building
        Y2_SI_FURNITURE = r_gnr_quote_data.Y2_SI_FURNITURE,  --101Y2_SI of Furniture
        Y2_SI_MACHINERY = r_gnr_quote_data.Y2_SI_MACHINERY,  --102Y2_SI of Machinery
        Y2_SI_OTHERS = r_gnr_quote_data.Y2_SI_OTHERS,  --103Y2_SI of Others
        Y2_SI_STOCK = r_gnr_quote_data.Y2_SI_STOCK,  --104Y2_SI of Stock
        Y3_TOTAL_SUM_INSURED = r_gnr_quote_data.Y3_TOTAL_SUM_INSURED,  --105Y3_total sum insured
        Y3_NET_PREMIUM = r_gnr_quote_data.Y3_NET_PREMIUM,  --106Y3_Net Premium
        Y3_DUTY = r_gnr_quote_data.Y3_DUTY,  --107Y3_Duty
        Y3_TAX = r_gnr_quote_data.Y3_TAX,  --108Y3_Tax

        Y3_TOTAL_PREMIUM = r_gnr_quote_data.Y3_TOTAL_PREMIUM,  --109Y3_Total Premium
        Y3_SI_BUILDING = r_gnr_quote_data.Y3_SI_BUILDING,  --110Y3_SI of Building
        Y3_SI_FURNITURE = r_gnr_quote_data.Y3_SI_FURNITURE,  --111Y3_SI of Furniture
        Y3_SI_MACHINERY = r_gnr_quote_data.Y3_SI_MACHINERY,  --112Y3_SI of Machinery
        Y3_SI_OTHERS = r_gnr_quote_data.Y3_SI_OTHERS,  --113Y3_SI of Others
        Y3_SI_STOCK = r_gnr_quote_data.Y3_SI_STOCK,  --114Y3_SI of Stock
        DATA_SOURCE = r_gnr_quote_data.data_source,--Data Source
        --REF2 = r_gnr_quote_data.REF2,  --115REF2
       -- AMOUNT = r_gnr_quote_data.AMOUNT,  --116AMOUNT
      --  NOTMATCH_STATUS = r_gnr_quote_data.null,  --117NOTMATCH_STATUS
       -- CREATED_DATE = r_gnr_quote_data.CREATE_DATE,  --118CREATED_DATE
       -- CREATED_BY = r_gnr_quote_data.CREATE_USER,  --119CREATED_BY
        UPDATED_DATE = SYSDATE,  --120UPDATED_DATE
        UPDATED_BY = USER  --121UPDATED_BY
       -- MATCH_STATUS = r_gnr_quote_data.null,  --122MATCH_STATUS
       -- DUP_STATUS = r_gnr_quote_data.null,  --123DUP_STATUS
       -- DIFF_STATUS = r_gnr_quote_data.null,  --124DIFF_STATUS
       -- CANCELED_STATUS = r_gnr_quote_data.null,  --125CANCELED_STATUS
       -- REMARK = r_gnr_quote_data.null,  --126REMARK
       -- LOAD_DATE = r_gnr_quote_data.LOAD_DATE  --127LOAD_DATE
     WHERE r.quote_data_id = r_gnr_quote_data.quote_data_id
     AND r.quote_data_ref_id = r_gnr_quote_data.quote_data_ref_id
     AND r.match_status IS NULL;--Upate quote match_status is null
     COMMIT;
   ----------------------------
 END LOOP;

 IF v_count = 0 THEN
   INSERT INTO GNR_QUOTE_DATA_REF
          (QUOTE_DATA_ID            , QUOTE_DATA_REF_ID         ,
           JOB_NUMBER               , Batch_Type                , File_Name                 , Upload_Date              , RM_ID                       ,
           RM_Name                  , Refer_ID                  , Refer_Name                , MKT_ID                   , MKT_NAME                    ,
           Branch_Code              , Branch_Name               , Hub_ID                    , Hub_Name                 , Team                        ,
           SEGMENT                  , Channel                   , Insurance_Class           , Sub_Class                , Sub_Class_Type              ,
           Sub_Channel_ID           , Partner_Ref_Number        , Previous_Policy_Number    , Job_Received_Date        ,  Job_Type                   ,
           Department_Code          , Title                     , Insured_FirstName         , Insured_LastName         , ID_Number                   ,
           ID_Type                  , Insured_Person            , Insured_Person_Type       , Customer_ID              , Customer_Name               ,
           Date_of_Birth            , Insured_Addr_Number       , Insured_Addr_Buiding      , Insured_Addr_Moo         , Insured_Addr_Soi            ,
           Insured_Addr_Road        , Sub_District              , District                  , Province                 , Post_Code                   ,
           Insured_Full_Addr        , Telephone_Number          , Account_Number            , Contact_Person_Name      , Contact_Person_Email        ,
           Contact_Person_Fax       , Contact_Person_LINEID     , Contact_Person_Mobile     , Contact_Person_Phone     , IMD                         ,
           Quotation_Number         , Quotation_Issue_Date      , Quotation_Version         , Quotation_Status         , Ref_Quotation_Number        ,
           Package_Name             , Cover_Period_Days         , Cover_Period_Year         , Expiry_Date              , Inception_Date              ,
           Deed_Number              , Insured_Obj_Addr_Number   , Insured_Obj_Building      , Insured_Obj_District     , Insured_Obj_Full_Addr       ,
           Insured_Obj_Moo          , Insured_Obj_Post_Code     , Insured_Obj_Province      , Insured_Obj_Road         , Insured_Obj_Soi             ,
           Insured_Obj_SubDist      , Number_of_Floor           , Construction_Class        , Ref1                     , RISK_CODE                   ,
           PURPOSED_OF_USE          , ASSET_TYPE                , CAPITAL_TYPE              , Y1_TOTAL_SUM_INSURED     , Y1_NET_PREMIUM              ,
           Y1_DUTY                  , Y1_TAX                    , Y1_TOTAL_PREMIUM          , Y1_SI_BUILDING           , Y1_SI_FURNITURE             ,
           Y1_SI_MACHINERY          , Y1_SI_OTHERS              , Y1_SI_STOCK               , Y2_TOTAL_SUM_INSURED     , Y2_NETPREMIUM               ,
           Y2_DUTY                  , Y2_TAX                    , Y2_TOTAL_PREMIUM          , Y2_SI_BUILDING           , Y2_SI_FURNITURE             ,
           Y2_SI_MACHINERY          , Y2_SI_OTHERS              , Y2_SI_STOCK               , Y3_TOTAL_SUM_INSURED     , Y3_NET_PREMIUM              ,
           Y3_DUTY                  , Y3_TAX                    , Y3_TOTAL_PREMIUM          , Y3_SI_BUILDING           , Y3_SI_FURNITURE             ,
           Y3_SI_MACHINERY          , Y3_SI_OTHERS              , Y3_SI_STOCK               , ref2                     , amount                      ,
           LOAD_DATE,data_source

           )
          SELECT p_data_ref_id       , v_seg2                   ,
           JOB_NUMBER                , Batch_Type                , File_Name                 , Upload_Date               , RM_ID                     ,
           RM_Name                   , Refer_ID                  , Refer_Name                , MKT_ID                    , MKT_NAME                  ,
           Branch_Code               , Branch_Name               , Hub_ID                    , Hub_Name                  , Team                      ,
           SEGMENT                   , Channel                   , Insurance_Class           , Sub_Class                 , Sub_Class_Type            ,
           Sub_Channel_ID            , Partner_Ref_Number        , Previous_Policy_Number    , Job_Received_Date         , Job_Type                  ,
           Department_Code           , Title                     , Insured_FirstName         , Insured_LastName          , ID_Number                 ,
           ID_Type                   , Insured_Person            , Insured_Person_Type       , Customer_ID               , Customer_Name             ,
           Date_of_Birth             , Insured_Addr_Number       , Insured_Addr_Buiding      , Insured_Addr_Moo          , Insured_Addr_Soi          ,
           Insured_Addr_Road         , Sub_District              , District                  , Province                  , Post_Code                 ,
           Insured_Full_Addr         , Telephone_Number          , Account_Number            , Contact_Person_Name       , Contact_Person_Email      ,
           Contact_Person_Fax        , Contact_Person_LINEID     , Contact_Person_Mobile     , Contact_Person_Phone      , IMD                       ,
           Quotation_Number          , Quotation_Issue_Date      , Quotation_Version         , Quotation_Status          , Ref_Quotation_Number      ,
           Package_Name              , Cover_Period_Days         , p_year                    , Expiry_Date               , Inception_Date            ,
           Deed_Number               , Insured_Obj_Addr_Number   , Insured_Obj_Building      , Insured_Obj_District      , Insured_Obj_Full_Addr     ,
           Insured_Obj_Moo           , Insured_Obj_Post_Code     , Insured_Obj_Province      , Insured_Obj_Road          , Insured_Obj_Soi           ,
           Insured_Obj_SubDist       , Number_of_Floor           , Construction_Class        , p_Ref1                    , RISK_CODE                 ,
           PURPOSED_OF_USE           , ASSET_TYPE                , CAPITAL_TYPE              , Y1_TOTAL_SUM_INSURED      , Y1_NET_PREMIUM            ,
           Y1_DUTY                   , Y1_TAX                    , Y1_TOTAL_PREMIUM          , Y1_SI_BUILDING            , Y1_SI_FURNITURE           ,
           Y1_SI_MACHINERY           , Y1_SI_OTHERS              , Y1_SI_STOCK               , Y2_TOTAL_SUM_INSURED      , Y2_NETPREMIUM             ,
           Y2_DUTY                   , Y2_TAX                    , Y2_TOTAL_PREMIUM          , Y2_SI_BUILDING            , Y2_SI_FURNITURE           ,
           Y2_SI_MACHINERY           , Y2_SI_OTHERS              , Y2_SI_STOCK               , Y3_TOTAL_SUM_INSURED      , Y3_NET_PREMIUM            ,
           Y3_DUTY                   , Y3_TAX                    , Y3_TOTAL_PREMIUM          , Y3_SI_BUILDING            , Y3_SI_FURNITURE           ,
           Y3_SI_MACHINERY           , Y3_SI_OTHERS              , Y3_SI_STOCK               , p_Ref2                    , p_amount                  ,
           trunc(SYSDATE),
           data_source
          FROM GNR_QUOTE_DATA d
          WHERE d.quote_data_id = p_data_ref_id;
          COMMIT;
  END IF;
   v_message_err := NULL;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  v_message_err := 'step('||v_state||') Cannot INSERT GNR_QUOTE_DATA_REF||'||SQLERRM ;
  az_pk0_general.LogTrace(v_func_name,userenv('sessionid'),v_message_err);
END p_insert_data_ref;
----------------------------------------------------------------------------------------------------
--Fix case Ref2 null 2021-10-BPI-500138 - TTB Project - Automatic Reconcile Phase 1.1(CHGXXXXXX)
PROCEDURE P_UPD_QUOTE_REF2(i_load_date DATE) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_func_name CONSTANT   VARCHAR2(300) := g_package_name||'p_upd_quote_ref2';
  v_message_err          VARCHAR2(1000) := NULL;
  v_state NUMBER := 0;
  v_count_quote_data_id NUMBER := 0;
  v_quote_data_id gnr_quote_data.quote_data_id%TYPE;
  v_ref2 GNR_QUOTE_DATA_ref.REF2%TYPE;
 BEGIN
    v_state := 1;
    FOR rec IN (SELECT tt.*,tt.rowid rowno_rec 
                FROM gnr_quote_data_ref tt 
                WHERE tt.REF2 IS NULL
                AND trunc(tt.LOAD_DATE) =i_load_date) LOOP
         FOR rec2 IN (SELECT d.* FROM GNR_QUOTE_DATA d 
            WHERE d.QUOTE_DATA_ID = rec.QUOTE_DATA_ID)
            LOOP
               v_state := 2;
               IF rec.REF2 IS NULL THEN
                  IF rec.COVER_PERIOD_YEAR = '1' THEN
                     v_ref2 := rec2.Y1_PAYREF_NUM2;
                  ELSIF rec.COVER_PERIOD_YEAR = '2' THEN
                     v_ref2 := rec2.Y2_PAYREF_NUM2;
                  ELSIF rec.COVER_PERIOD_YEAR = '3' THEN
                      v_ref2 := rec2.Y3_PAYREF_NUM2;
                 END IF;
                 v_state := 3;
                 UPDATE GNR_QUOTE_DATA_ref rr
                 SET rr.REF2 = v_ref2
                 WHERE rr.rowid = rec.rowno_rec;
                 COMMIT;
               END IF;
            END LOOP;
      END LOOP;
    v_message_err := NULL;
 EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  v_message_err := 'step('||v_state||') Cannot update GNR_QUOTE_DATA_REF||'||SQLERRM ;
  az_pk0_general.LogTrace(v_func_name,userenv('sessionid'),v_message_err);   
 END;
----------------------------------------------------------------------------------------------------    
PROCEDURE P_UPD_GNR_QUOTE_DATA(ir_gnr_quote_data IN gnr_quote_data%ROWTYPE
                               ,o_rec_no OUT NUMBER
                               ,o_message_error OUT VARCHAR2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_func_name CONSTANT   VARCHAR2(300) := g_package_name||'p_upd_gnr_quote_data';
  v_message_err          VARCHAR2(1000) := NULL;
  v_count_no NUMBER := 0;
  v_count_quote_data_id NUMBER := 0;
  v_quote_data_id gnr_quote_data.quote_data_id%TYPE;
 BEGIN
    FOR rec IN
    (SELECT * FROM gnr_quote_data d
    WHERE d.quotation_number = ir_gnr_quote_data.quotation_number) --Quotation number
    LOOP
      v_count_no := v_count_no + 1;
      v_quote_data_id := rec.quote_data_id;
      UPDATE gnr_quote_data SET
          --QUOTE_DATA_ID =ir_gnr_quote_data.QUOTE_DATA_ID,  --1QUOTE_DATA_ID
          JOB_NUMBER =ir_gnr_quote_data.JOB_NUMBER,  --2JOB NUMBER
          BATCH_TYPE =ir_gnr_quote_data.BATCH_TYPE,  --3Batch Type
          FILE_NAME =ir_gnr_quote_data.FILE_NAME,  --4File Name
          UPLOAD_DATE =ir_gnr_quote_data.UPLOAD_DATE,  --5Upload Date
          RM_ID =ir_gnr_quote_data.RM_ID,  --6RM ID
          RM_NAME =ir_gnr_quote_data.RM_NAME,  --7RM Name
          REFER_ID =ir_gnr_quote_data.REFER_ID,  --8Refer ID
          REFER_NAME =ir_gnr_quote_data.REFER_NAME,  --9Refer Name
          MKT_ID =ir_gnr_quote_data.MKT_ID,  --10MKT ID
          MKT_NAME =ir_gnr_quote_data.MKT_NAME,  --11MKT NAME
          BRANCH_CODE =ir_gnr_quote_data.BRANCH_CODE,  --12Branch Code
          BRANCH_NAME =ir_gnr_quote_data.BRANCH_NAME,  --13Branch Name
          HUB_ID =ir_gnr_quote_data.HUB_ID,  --14Hub ID
          HUB_NAME =ir_gnr_quote_data.HUB_NAME,  --15Hub Name
          TEAM =ir_gnr_quote_data.TEAM,  --16Team
          SEGMENT =ir_gnr_quote_data.SEGMENT,  --17Segment
          CHANNEL =ir_gnr_quote_data.CHANNEL,  --18Channel
          INSURANCE_CLASS =ir_gnr_quote_data.INSURANCE_CLASS,  --19Insurance Class
          SUB_CLASS =ir_gnr_quote_data.SUB_CLASS,  --20Sub Class
          SUB_CLASS_TYPE =ir_gnr_quote_data.SUB_CLASS_TYPE,  --21Sub Class Type
          SUB_CHANNEL_ID =ir_gnr_quote_data.SUB_CHANNEL_ID,  --22Sub-Channel ID
          PARTNER_REF_NUMBER =ir_gnr_quote_data.PARTNER_REF_NUMBER,  --23Partner Reference Number
          PREVIOUS_POLICY_NUMBER =ir_gnr_quote_data.PREVIOUS_POLICY_NUMBER,  --24Previous Policy Number
          JOB_RECEIVED_DATE =ir_gnr_quote_data.JOB_RECEIVED_DATE,  --25Job Received Date
          JOB_TYPE =ir_gnr_quote_data.JOB_TYPE,  --26Job Type
          DEPARTMENT_CODE =ir_gnr_quote_data.DEPARTMENT_CODE,  --27Department Code
          TITLE =ir_gnr_quote_data.TITLE,  --28Title
          INSURED_FIRSTNAME =ir_gnr_quote_data.INSURED_FIRSTNAME,  --29Insured First Name
          INSURED_LASTNAME =ir_gnr_quote_data.INSURED_LASTNAME,  --30Insured Last Name
          ID_NUMBER =ir_gnr_quote_data.ID_NUMBER,  --31ID Number
          ID_TYPE =ir_gnr_quote_data.ID_TYPE,  --32ID Type
          INSURED_PERSON =ir_gnr_quote_data.INSURED_PERSON,  --33Insured Person
          INSURED_PERSON_TYPE =ir_gnr_quote_data.INSURED_PERSON_TYPE,  --34Insured Person Type
          CUSTOMER_ID =ir_gnr_quote_data.CUSTOMER_ID,  --35Customer ID
          CUSTOMER_NAME =ir_gnr_quote_data.CUSTOMER_NAME,  --36Customer Name
          DATE_OF_BIRTH =ir_gnr_quote_data.DATE_OF_BIRTH,  --37Date of Birth
          INSURED_ADDR_NUMBER =ir_gnr_quote_data.INSURED_ADDR_NUMBER,  --38Insured Address Number
          INSURED_ADDR_BUIDING =ir_gnr_quote_data.INSURED_ADDR_BUIDING,  --39Insured Address Building
          INSURED_ADDR_MOO =ir_gnr_quote_data.INSURED_ADDR_MOO,  --40Insured Address Moo
          INSURED_ADDR_SOI =ir_gnr_quote_data.INSURED_ADDR_SOI,  --41Insured Address Soi
          INSURED_ADDR_ROAD =ir_gnr_quote_data.INSURED_ADDR_ROAD,  --42Insured Address Road
          SUB_DISTRICT =ir_gnr_quote_data.SUB_DISTRICT,  --43Sub-District
          DISTRICT =ir_gnr_quote_data.DISTRICT,  --44District
          PROVINCE =ir_gnr_quote_data.PROVINCE,  --45Province
          POST_CODE =ir_gnr_quote_data.POST_CODE,  --46Post Code
          INSURED_FULL_ADDR =ir_gnr_quote_data.INSURED_FULL_ADDR,  --47Insured Full Address
          TELEPHONE_NUMBER =ir_gnr_quote_data.TELEPHONE_NUMBER,  --48Telephone Number
          ACCOUNT_NUMBER =ir_gnr_quote_data.ACCOUNT_NUMBER,  --49Account Number
          CONTACT_PERSON_NAME =ir_gnr_quote_data.CONTACT_PERSON_NAME,  --50Contact Person Name
          CONTACT_PERSON_EMAIL =ir_gnr_quote_data.CONTACT_PERSON_EMAIL,  --51Contact Person Email
          CONTACT_PERSON_FAX =ir_gnr_quote_data.CONTACT_PERSON_FAX,  --52Contact Person Fax Number
          CONTACT_PERSON_LINEID =ir_gnr_quote_data.CONTACT_PERSON_LINEID,  --53Contact Person LINE ID
          CONTACT_PERSON_MOBILE =ir_gnr_quote_data.CONTACT_PERSON_MOBILE,  --54Contact Person Mobile Number
          CONTACT_PERSON_PHONE =ir_gnr_quote_data.CONTACT_PERSON_PHONE,  --55Contact Person Phone Number
          IMD =ir_gnr_quote_data.IMD,  --56IMD
          QUOTATION_NUMBER =ir_gnr_quote_data.QUOTATION_NUMBER,  --57Quotation Number
          QUOTATION_ISSUE_DATE =ir_gnr_quote_data.QUOTATION_ISSUE_DATE,  --58Quotation Issue Date
          QUOTATION_VERSION =ir_gnr_quote_data.QUOTATION_VERSION,  --59Quotation Version
          QUOTATION_STATUS =ir_gnr_quote_data.QUOTATION_STATUS,  --60Quotation Status
          REF_QUOTATION_NUMBER =ir_gnr_quote_data.REF_QUOTATION_NUMBER,  --61Reference Quotation Number
          PACKAGE_NAME =ir_gnr_quote_data.PACKAGE_NAME,  --62Package Name
          COVER_PERIOD_DAYS =ir_gnr_quote_data.COVER_PERIOD_DAYS,  --63Cover Period (Days)
          COVER_PERIOD_YEAR =ir_gnr_quote_data.COVER_PERIOD_YEAR,  --64Cover Period (Year)
          EXPIRY_DATE =ir_gnr_quote_data.EXPIRY_DATE,  --65Expiry Date
          INCEPTION_DATE =ir_gnr_quote_data.INCEPTION_DATE,  --66Inception Date
          DEED_NUMBER =ir_gnr_quote_data.DEED_NUMBER,  --67Deed Number
          INSURED_OBJ_ADDR_NUMBER =ir_gnr_quote_data.INSURED_OBJ_ADDR_NUMBER,  --68Insured Object Address Number
          INSURED_OBJ_BUILDING =ir_gnr_quote_data.INSURED_OBJ_BUILDING,  --69Insured Object Building
          INSURED_OBJ_DISTRICT =ir_gnr_quote_data.INSURED_OBJ_DISTRICT,  --70Insured Object District
          INSURED_OBJ_FULL_ADDR =ir_gnr_quote_data.INSURED_OBJ_FULL_ADDR,  --71Insured Object Full Address
          INSURED_OBJ_MOO =ir_gnr_quote_data.INSURED_OBJ_MOO,  --72Insured Object Moo
          INSURED_OBJ_POST_CODE =ir_gnr_quote_data.INSURED_OBJ_POST_CODE,  --73Insured Object Post Code
          INSURED_OBJ_PROVINCE =ir_gnr_quote_data.INSURED_OBJ_PROVINCE,  --74Insured Object Province
          INSURED_OBJ_ROAD =ir_gnr_quote_data.INSURED_OBJ_ROAD,  --75Insured Object Road
          INSURED_OBJ_SOI =ir_gnr_quote_data.INSURED_OBJ_SOI,  --76Insured Object Soi
          INSURED_OBJ_SUBDIST =ir_gnr_quote_data.INSURED_OBJ_SUBDIST,  --77Insured Object Sub-District
          NUMBER_OF_FLOOR =ir_gnr_quote_data.NUMBER_OF_FLOOR,  --78Number of Floor
          CONSTRUCTION_CLASS =ir_gnr_quote_data.CONSTRUCTION_CLASS,  --79Construction Class
          REF1 =ir_gnr_quote_data.REF1,  --80Payment Reference Number1
          Y1_PAYREF_NUM2 =ir_gnr_quote_data.Y1_PAYREF_NUM2,  --81Y1_Payment Reference Number2
          Y2_PAYREF_NUM2 =ir_gnr_quote_data.Y2_PAYREF_NUM2,  --82Y2_Payment Reference Number2
          Y3_PAYREF_NUM2 =ir_gnr_quote_data.Y3_PAYREF_NUM2,  --83Y3_Payment Reference Number2
          RISK_CODE =ir_gnr_quote_data.RISK_CODE,  --84Risk Code
          PURPOSED_OF_USE =ir_gnr_quote_data.PURPOSED_OF_USE,  --85Purposed of Use
          ASSET_TYPE =ir_gnr_quote_data.ASSET_TYPE,  --86Asset Type
          CAPITAL_TYPE =ir_gnr_quote_data.CAPITAL_TYPE,  --87Capital Type
          Y1_TOTAL_SUM_INSURED =ir_gnr_quote_data.Y1_TOTAL_SUM_INSURED,  --88Y1_total sum insured
          Y1_NET_PREMIUM =ir_gnr_quote_data.Y1_NET_PREMIUM,  --89Y1_Net Premium
          Y1_DUTY =ir_gnr_quote_data.Y1_DUTY,  --90Y1_Duty
          Y1_TAX =ir_gnr_quote_data.Y1_TAX,  --91Y1_Tax
          Y1_TOTAL_PREMIUM =ir_gnr_quote_data.Y1_TOTAL_PREMIUM,  --92Y1_Total Premium
          Y1_SI_BUILDING =ir_gnr_quote_data.Y1_SI_BUILDING,  --93Y1_SI of Building
          Y1_SI_FURNITURE =ir_gnr_quote_data.Y1_SI_FURNITURE,  --94Y1_SI of Furniture
          Y1_SI_MACHINERY =ir_gnr_quote_data.Y1_SI_MACHINERY,  --95Y1_SI of Machinery
          Y1_SI_OTHERS =ir_gnr_quote_data.Y1_SI_OTHERS,  --96Y1_SI of Others
          Y1_SI_STOCK =ir_gnr_quote_data.Y1_SI_STOCK,  --97Y1_SI of Stock
          Y2_TOTAL_SUM_INSURED =ir_gnr_quote_data.Y2_TOTAL_SUM_INSURED,  --98Y2_total sum insured
          Y2_NETPREMIUM =ir_gnr_quote_data.Y2_NETPREMIUM,  --99Y2_Net Premium
          Y2_DUTY =ir_gnr_quote_data.Y2_DUTY,  --100Y2_Duty
          Y2_TAX =ir_gnr_quote_data.Y2_TAX,  --101Y2_Tax
          Y2_TOTAL_PREMIUM =ir_gnr_quote_data.Y2_TOTAL_PREMIUM,  --102Y2_Total Premium
          Y2_SI_BUILDING =ir_gnr_quote_data.Y2_SI_BUILDING,  --103Y2_SI of Building
          Y2_SI_FURNITURE =ir_gnr_quote_data.Y2_SI_FURNITURE,  --104Y2_SI of Furniture
          Y2_SI_MACHINERY =ir_gnr_quote_data.Y2_SI_MACHINERY,  --105Y2_SI of Machinery
          Y2_SI_OTHERS =ir_gnr_quote_data.Y2_SI_OTHERS,  --106Y2_SI of Others
          Y2_SI_STOCK =ir_gnr_quote_data.Y2_SI_STOCK,  --107Y2_SI of Stock
          Y3_TOTAL_SUM_INSURED =ir_gnr_quote_data.Y3_TOTAL_SUM_INSURED,  --108Y3_total sum insured
          Y3_NET_PREMIUM =ir_gnr_quote_data.Y3_NET_PREMIUM,  --109Y3_Net Premium
          Y3_DUTY =ir_gnr_quote_data.Y3_DUTY,  --110Y3_Duty
          Y3_TAX =ir_gnr_quote_data.Y3_TAX,  --111Y3_Tax
          Y3_TOTAL_PREMIUM =ir_gnr_quote_data.Y3_TOTAL_PREMIUM,  --112Y3_Total Premium
          Y3_SI_BUILDING =ir_gnr_quote_data.Y3_SI_BUILDING,  --113Y3_SI of Building
          Y3_SI_FURNITURE =ir_gnr_quote_data.Y3_SI_FURNITURE,  --114Y3_SI of Furniture
          Y3_SI_MACHINERY =ir_gnr_quote_data.Y3_SI_MACHINERY,  --115Y3_SI of Machinery
          Y3_SI_OTHERS =ir_gnr_quote_data.Y3_SI_OTHERS,  --116Y3_SI of Others
          Y3_SI_STOCK =ir_gnr_quote_data.Y3_SI_STOCK,  --117Y3_SI of Stock
         -- LOAD_DATE = ir_gn          REF2 = ir_gnr_quote_data.REF2,  --118ref2
          --  r_quote_data.LOAD_DATE,  --119Load date
          update_user = USER,
          update_date = SYSDATE,
          message_error = ir_gnr_quote_data.message_error
      WHERE quote_data_id = rec.quote_data_id
      ;
      ----------------------------------------------------------------------------------------
      --Update gnr_quote_data_ref
      UPDATE gnr_quote_data_ref r
      SET
        --QUOTE_DATA_ID = ir_gnr_quote_data.QUOTE_DATA_ID,  --1QUOTE_DATA_ID
        JOB_NUMBER = ir_gnr_quote_data.JOB_NUMBER,  --2JOB NUMBER
        BATCH_TYPE = ir_gnr_quote_data.BATCH_TYPE,  --3Batch Type
        FILE_NAME = ir_gnr_quote_data.FILE_NAME,  --4File Name
        UPLOAD_DATE = ir_gnr_quote_data.UPLOAD_DATE,  --5Upload Date
        RM_ID = ir_gnr_quote_data.RM_ID,  --6RM ID
        RM_NAME = ir_gnr_quote_data.RM_NAME,  --7RM Name
        REFER_ID = ir_gnr_quote_data.REFER_ID,  --8Refer ID
        REFER_NAME = ir_gnr_quote_data.REFER_NAME,  --9Refer Name
        MKT_ID = ir_gnr_quote_data.MKT_ID,  --10MKT ID
        MKT_NAME = ir_gnr_quote_data.MKT_NAME,  --11MKT NAME
        BRANCH_CODE = ir_gnr_quote_data.BRANCH_CODE,  --12Branch Code
        BRANCH_NAME = ir_gnr_quote_data.BRANCH_NAME,  --13Branch Name
        HUB_ID = ir_gnr_quote_data.HUB_ID,  --14Hub ID
        HUB_NAME = ir_gnr_quote_data.HUB_NAME,  --15Hub Name
        TEAM = ir_gnr_quote_data.TEAM,  --16Team
        SEGMENT = ir_gnr_quote_data.SEGMENT,  --17Segment
        CHANNEL = ir_gnr_quote_data.CHANNEL,  --18Channel
        INSURANCE_CLASS = ir_gnr_quote_data.INSURANCE_CLASS,  --19Insurance Class
        SUB_CLASS = ir_gnr_quote_data.SUB_CLASS,  --20Sub Class
        SUB_CLASS_TYPE = ir_gnr_quote_data.SUB_CLASS_TYPE,  --21Sub Class Type
        SUB_CHANNEL_ID = ir_gnr_quote_data.SUB_CHANNEL_ID,  --22Sub-Channel ID
        PARTNER_REF_NUMBER = ir_gnr_quote_data.PARTNER_REF_NUMBER,  --23Partner Reference Number
        PREVIOUS_POLICY_NUMBER = ir_gnr_quote_data.PREVIOUS_POLICY_NUMBER,  --24Previous Policy Number
        JOB_RECEIVED_DATE = ir_gnr_quote_data.JOB_RECEIVED_DATE,  --25Job Received Date
        JOB_TYPE = ir_gnr_quote_data.JOB_TYPE,  --26Job Type
        DEPARTMENT_CODE = ir_gnr_quote_data.DEPARTMENT_CODE,  --27Department Code
        TITLE = ir_gnr_quote_data.TITLE,  --28Title
        INSURED_FIRSTNAME = ir_gnr_quote_data.INSURED_FIRSTNAME,  --29Insured First Name
        INSURED_LASTNAME = ir_gnr_quote_data.INSURED_LASTNAME,  --30Insured Last Name
        ID_NUMBER = ir_gnr_quote_data.ID_NUMBER,  --31ID Number
        ID_TYPE = ir_gnr_quote_data.ID_TYPE,  --32ID Type
        INSURED_PERSON = ir_gnr_quote_data.INSURED_PERSON,  --33Insured Person
        INSURED_PERSON_TYPE = ir_gnr_quote_data.INSURED_PERSON_TYPE,  --34Insured Person Type
        CUSTOMER_ID = ir_gnr_quote_data.CUSTOMER_ID,  --35Customer ID
        CUSTOMER_NAME = ir_gnr_quote_data.CUSTOMER_NAME,  --36Customer Name
        DATE_OF_BIRTH = ir_gnr_quote_data.DATE_OF_BIRTH,  --37Date of Birth

        INSURED_ADDR_NUMBER = ir_gnr_quote_data.INSURED_ADDR_NUMBER,  --38Insured Address Number
        INSURED_ADDR_BUIDING = ir_gnr_quote_data.INSURED_ADDR_BUIDING,  --39Insured Address Building
        INSURED_ADDR_MOO = ir_gnr_quote_data.INSURED_ADDR_MOO,  --40Insured Address Moo
        INSURED_ADDR_SOI = ir_gnr_quote_data.INSURED_ADDR_SOI,  --41Insured Address Soi
        INSURED_ADDR_ROAD = ir_gnr_quote_data.INSURED_ADDR_ROAD,  --42Insured Address Road
        SUB_DISTRICT = ir_gnr_quote_data.SUB_DISTRICT,  --43Sub-District
        DISTRICT = ir_gnr_quote_data.DISTRICT,  --44District
        PROVINCE = ir_gnr_quote_data.PROVINCE,  --45Province
        POST_CODE = ir_gnr_quote_data.POST_CODE,  --46Post Code

        INSURED_FULL_ADDR = ir_gnr_quote_data.INSURED_FULL_ADDR,  --47Insured Full Address
        TELEPHONE_NUMBER = ir_gnr_quote_data.TELEPHONE_NUMBER,  --48Telephone Number
        ACCOUNT_NUMBER = ir_gnr_quote_data.ACCOUNT_NUMBER,  --49Account Number
        CONTACT_PERSON_NAME = ir_gnr_quote_data.CONTACT_PERSON_NAME,  --50Contact Person Name
        CONTACT_PERSON_EMAIL = ir_gnr_quote_data.CONTACT_PERSON_EMAIL,  --51Contact Person Email
        CONTACT_PERSON_FAX = ir_gnr_quote_data.CONTACT_PERSON_FAX,  --52Contact Person Fax Number
        CONTACT_PERSON_LINEID = ir_gnr_quote_data.CONTACT_PERSON_LINEID,  --53Contact Person LINE ID
        CONTACT_PERSON_MOBILE = ir_gnr_quote_data.CONTACT_PERSON_MOBILE,  --54Contact Person Mobile Number
        CONTACT_PERSON_PHONE = ir_gnr_quote_data.CONTACT_PERSON_PHONE,  --55Contact Person Phone Number

        IMD = ir_gnr_quote_data.IMD,  --56IMD
        QUOTATION_NUMBER = ir_gnr_quote_data.QUOTATION_NUMBER,  --57Quotation Number
        QUOTATION_ISSUE_DATE = ir_gnr_quote_data.QUOTATION_ISSUE_DATE,  --58Quotation Issue Date
        QUOTATION_VERSION = ir_gnr_quote_data.QUOTATION_VERSION,  --59Quotation Version
        QUOTATION_STATUS = ir_gnr_quote_data.QUOTATION_STATUS,  --60Quotation Status
        REF_QUOTATION_NUMBER = ir_gnr_quote_data.REF_QUOTATION_NUMBER,  --61Reference Quotation Number
        PACKAGE_NAME = ir_gnr_quote_data.PACKAGE_NAME,  --62Package Name
        COVER_PERIOD_DAYS = ir_gnr_quote_data.COVER_PERIOD_DAYS,  --63Cover Period (Days)

        --COVER_PERIOD_YEAR = ir_gnr_quote_data.COVER_PERIOD_YEAR,  --64Cover Period (Year)

        EXPIRY_DATE = ir_gnr_quote_data.EXPIRY_DATE,  --65Expiry Date
        INCEPTION_DATE = ir_gnr_quote_data.INCEPTION_DATE,  --66Inception Date
        DEED_NUMBER = ir_gnr_quote_data.DEED_NUMBER,  --67Deed Number

        INSURED_OBJ_ADDR_NUMBER = ir_gnr_quote_data.INSURED_OBJ_ADDR_NUMBER,  --68Insured Object Address Number
        INSURED_OBJ_BUILDING = ir_gnr_quote_data.INSURED_OBJ_BUILDING,  --69Insured Object Building
        INSURED_OBJ_DISTRICT = ir_gnr_quote_data.INSURED_OBJ_DISTRICT,  --70Insured Object District
        INSURED_OBJ_FULL_ADDR = ir_gnr_quote_data.INSURED_OBJ_FULL_ADDR,  --71Insured Object Full Address
        INSURED_OBJ_MOO = ir_gnr_quote_data.INSURED_OBJ_MOO,  --72Insured Object Moo
        INSURED_OBJ_POST_CODE = ir_gnr_quote_data.INSURED_OBJ_POST_CODE,  --73Insured Object Post Code
        INSURED_OBJ_PROVINCE = ir_gnr_quote_data.INSURED_OBJ_PROVINCE,  --74Insured Object Province
        INSURED_OBJ_ROAD = ir_gnr_quote_data.INSURED_OBJ_ROAD,  --75Insured Object Road
        INSURED_OBJ_SOI = ir_gnr_quote_data.INSURED_OBJ_SOI,  --76Insured Object Soi
        INSURED_OBJ_SUBDIST = ir_gnr_quote_data.INSURED_OBJ_SUBDIST,  --77Insured Object Sub-District
        NUMBER_OF_FLOOR = ir_gnr_quote_data.NUMBER_OF_FLOOR,  --78Number of Floor
        CONSTRUCTION_CLASS = ir_gnr_quote_data.CONSTRUCTION_CLASS,  --79Construction Class

       -- REF1 = ir_gnr_quote_data.REF1,  --80Payment Reference Number1
        RISK_CODE = ir_gnr_quote_data.RISK_CODE,  --81Risk Code
        PURPOSED_OF_USE = ir_gnr_quote_data.PURPOSED_OF_USE,  --82Purposed of Use
        ASSET_TYPE = ir_gnr_quote_data.ASSET_TYPE,  --83Asset Type
        CAPITAL_TYPE = ir_gnr_quote_data.CAPITAL_TYPE,  --84Capital Type

        Y1_TOTAL_SUM_INSURED = ir_gnr_quote_data.Y1_TOTAL_SUM_INSURED,  --85Y1_total sum insured
        Y1_NET_PREMIUM = ir_gnr_quote_data.Y1_NET_PREMIUM,  --86Y1_Net Premium
        Y1_DUTY = ir_gnr_quote_data.Y1_DUTY,  --87Y1_Duty
        Y1_TAX = ir_gnr_quote_data.Y1_TAX,  --88Y1_Tax
        Y1_TOTAL_PREMIUM = ir_gnr_quote_data.Y1_TOTAL_PREMIUM,  --89Y1_Total Premium
        Y1_SI_BUILDING = ir_gnr_quote_data.Y1_SI_BUILDING,  --90Y1_SI of Building
        Y1_SI_FURNITURE = ir_gnr_quote_data.Y1_SI_FURNITURE,  --91Y1_SI of Furniture
        Y1_SI_MACHINERY = ir_gnr_quote_data.Y1_SI_MACHINERY,  --92Y1_SI of Machinery
        Y1_SI_OTHERS = ir_gnr_quote_data.Y1_SI_OTHERS,  --93Y1_SI of Others
        Y1_SI_STOCK = ir_gnr_quote_data.Y1_SI_STOCK,  --94Y1_SI of Stock

        Y2_TOTAL_SUM_INSURED = ir_gnr_quote_data.Y2_TOTAL_SUM_INSURED,  --95Y2_total sum insured
        Y2_NETPREMIUM = ir_gnr_quote_data.Y2_NETPREMIUM,  --96Y2_Net Premium
        Y2_DUTY = ir_gnr_quote_data.Y2_DUTY,  --97Y2_Duty
        Y2_TAX = ir_gnr_quote_data.Y2_TAX,  --98Y2_Tax
        Y2_TOTAL_PREMIUM = ir_gnr_quote_data.Y2_TOTAL_PREMIUM,  --99Y2_Total Premium
        Y2_SI_BUILDING = ir_gnr_quote_data.Y2_SI_BUILDING,  --100Y2_SI of Building
        Y2_SI_FURNITURE = ir_gnr_quote_data.Y2_SI_FURNITURE,  --101Y2_SI of Furniture
        Y2_SI_MACHINERY = ir_gnr_quote_data.Y2_SI_MACHINERY,  --102Y2_SI of Machinery
        Y2_SI_OTHERS = ir_gnr_quote_data.Y2_SI_OTHERS,  --103Y2_SI of Others
        Y2_SI_STOCK = ir_gnr_quote_data.Y2_SI_STOCK,  --104Y2_SI of Stock
        Y3_TOTAL_SUM_INSURED = ir_gnr_quote_data.Y3_TOTAL_SUM_INSURED,  --105Y3_total sum insured
        Y3_NET_PREMIUM = ir_gnr_quote_data.Y3_NET_PREMIUM,  --106Y3_Net Premium
        Y3_DUTY = ir_gnr_quote_data.Y3_DUTY,  --107Y3_Duty
        Y3_TAX = ir_gnr_quote_data.Y3_TAX,  --108Y3_Tax

        Y3_TOTAL_PREMIUM = ir_gnr_quote_data.Y3_TOTAL_PREMIUM,  --109Y3_Total Premium
        Y3_SI_BUILDING = ir_gnr_quote_data.Y3_SI_BUILDING,  --110Y3_SI of Building
        Y3_SI_FURNITURE = ir_gnr_quote_data.Y3_SI_FURNITURE,  --111Y3_SI of Furniture
        Y3_SI_MACHINERY = ir_gnr_quote_data.Y3_SI_MACHINERY,  --112Y3_SI of Machinery
        Y3_SI_OTHERS = ir_gnr_quote_data.Y3_SI_OTHERS,  --113Y3_SI of Others
        Y3_SI_STOCK = ir_gnr_quote_data.Y3_SI_STOCK,  --114Y3_SI of Stock
        --REF2 = ir_gnr_quote_data.REF2,  --115REF2
       -- AMOUNT = ir_gnr_quote_data.AMOUNT,  --116AMOUNT
      --  NOTMATCH_STATUS = ir_gnr_quote_data.null,  --117NOTMATCH_STATUS
       -- CREATED_DATE = ir_gnr_quote_data.CREATE_DATE,  --118CREATED_DATE
       -- CREATED_BY = ir_gnr_quote_data.CREATE_USER,  --119CREATED_BY
        UPDATED_DATE = ir_gnr_quote_data.UPDATE_DATE,  --120UPDATED_DATE
        UPDATED_BY = ir_gnr_quote_data.UPDATE_USER  --121UPDATED_BY
       -- MATCH_STATUS = ir_gnr_quote_data.null,  --122MATCH_STATUS
       -- DUP_STATUS = ir_gnr_quote_data.null,  --123DUP_STATUS
       -- DIFF_STATUS = ir_gnr_quote_data.null,  --124DIFF_STATUS
       -- CANCELED_STATUS = ir_gnr_quote_data.null,  --125CANCELED_STATUS
       -- REMARK = ir_gnr_quote_data.null,  --126REMARK
       -- LOAD_DATE = ir_gnr_quote_data.LOAD_DATE  --127LOAD_DATE
     WHERE r.quote_data_id = rec.quote_data_id
     AND r.match_status IS NULL;--Upate quote match_status is null
      ----------------------------------------------------------------------------------------

    IF ir_gnr_quote_data.COVER_PERIOD_YEAR  = '1&3' THEN
       UPDATE gnr_quote_data_ref r
       SET r.REF1 = ir_gnr_quote_data.REF1
       ,r.ref2 = ir_gnr_quote_data.REF2
       ,r.amount = ir_gnr_quote_data.Y1_TOTAL_PREMIUM
       WHERE r.quote_data_id = rec.quote_data_id
       AND r.cover_period_year = 1
       AND r.match_status IS NULL
       ;

       UPDATE gnr_quote_data_ref r
       SET r.REF1 = ir_gnr_quote_data.REF1
       ,r.ref2 = ir_gnr_quote_data.REF2
       ,r.amount = ir_gnr_quote_data.Y3_TOTAL_PREMIUM
       WHERE r.quote_data_id = rec.quote_data_id
       AND r.cover_period_year = 3
       AND r.match_status IS NULL
       ;
    ELSIF ir_gnr_quote_data.COVER_PERIOD_YEAR  = '1&2' THEN
       UPDATE gnr_quote_data_ref r
       SET r.REF1 = ir_gnr_quote_data.REF1
       ,r.ref2 = ir_gnr_quote_data.REF2
       ,r.amount = ir_gnr_quote_data.Y1_TOTAL_PREMIUM
       WHERE r.quote_data_id = rec.quote_data_id
       AND r.cover_period_year = 1
       AND r.match_status IS NULL
       ;

       UPDATE gnr_quote_data_ref r
       SET r.REF1 = ir_gnr_quote_data.REF1
       ,r.ref2 = ir_gnr_quote_data.REF2
       ,r.amount = ir_gnr_quote_data.y2_total_premium
       WHERE r.quote_data_id = rec.quote_data_id
       AND r.cover_period_year = 2
       AND r.match_status IS NULL
       ;
    ELSIF ir_gnr_quote_data.COVER_PERIOD_YEAR  = '1' THEN
       UPDATE gnr_quote_data_ref r
       SET r.REF1 = ir_gnr_quote_data.REF1
       ,r.ref2 = ir_gnr_quote_data.REF2
       ,r.amount = ir_gnr_quote_data.y1_total_premium
       WHERE r.quote_data_id = rec.quote_data_id
       AND r.cover_period_year = 1
       AND r.match_status IS NULL;
   ELSIF ir_gnr_quote_data.COVER_PERIOD_YEAR  = '2' THEN
       UPDATE gnr_quote_data_ref r
       SET r.REF1 = ir_gnr_quote_data.REF1
       ,r.ref2 = ir_gnr_quote_data.REF2
       ,r.amount = ir_gnr_quote_data.y2_total_premium
       WHERE r.quote_data_id = rec.quote_data_id
       AND r.cover_period_year = 2
       AND r.match_status IS NULL;
   ELSIF ir_gnr_quote_data.COVER_PERIOD_YEAR  = '3' THEN
       UPDATE gnr_quote_data_ref r
       SET r.REF1 = ir_gnr_quote_data.REF1
       ,r.ref2 = ir_gnr_quote_data.REF2
       ,r.amount = ir_gnr_quote_data.y3_total_premium
       WHERE r.quote_data_id = rec.quote_data_id
       AND r.cover_period_year = 3
       AND r.match_status IS NULL;
   END IF;
  END LOOP;
  ---Check insert
    --------------------------------------------------------
    v_count_quote_data_id := 0;
    FOR rec IN
    (SELECT COUNT(d.quote_data_id) FROM gnr_quote_data_ref d
    WHERE d.quotation_number = ir_gnr_quote_data.quotation_number) --Quotation number
    LOOP
      v_count_quote_data_id := v_count_quote_data_id + 1;
    END LOOP;

    IF v_count_quote_data_id = 0 THEN
      IF ir_gnr_quote_data.COVER_PERIOD_YEAR  = '1&3' THEN
        P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                           p_Ref1         => ir_gnr_quote_data.ref1,
                           p_Ref2         => ir_gnr_quote_data.ref2,
                           p_amount       => ir_gnr_quote_data.y1_total_premium,
                           p_year         =>  '1') ;

        P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                           p_Ref1         => ir_gnr_quote_data.ref1,
                           p_Ref2         => ir_gnr_quote_data.ref2,
                           p_amount       => ir_gnr_quote_data.y3_total_premium,
                           p_year         =>  '3') ;
      ELSIF ir_gnr_quote_data.COVER_PERIOD_YEAR  = '1&2' THEN
        P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                           p_Ref1         => ir_gnr_quote_data.ref1,
                           p_Ref2         => ir_gnr_quote_data.ref2,
                           p_amount       => ir_gnr_quote_data.y1_total_premium,
                           p_year         =>  '1') ;

        P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                           p_Ref1         => ir_gnr_quote_data.ref1,
                           p_Ref2         => ir_gnr_quote_data.ref2,
                           p_amount       => ir_gnr_quote_data.y2_total_premium,
                           p_year         =>  '2') ;
     ELSIF ir_gnr_quote_data.COVER_PERIOD_YEAR  = '1' THEN
         P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                           p_Ref1         => ir_gnr_quote_data.ref1,
                           p_Ref2         => ir_gnr_quote_data.ref2,
                           p_amount       => ir_gnr_quote_data.y1_total_premium,
                           p_year         =>  '1') ;
     ELSIF ir_gnr_quote_data.COVER_PERIOD_YEAR  = '2' THEN
         P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                           p_Ref1         => ir_gnr_quote_data.ref1,
                           p_Ref2         => ir_gnr_quote_data.ref2,
                           p_amount       => ir_gnr_quote_data.y2_total_premium,
                           p_year         =>  '2') ;
     ELSIF ir_gnr_quote_data.COVER_PERIOD_YEAR  = '3' THEN

         P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                           p_Ref1         => ir_gnr_quote_data.ref1,
                           p_Ref2         => ir_gnr_quote_data.ref2,
                           p_amount       => ir_gnr_quote_data.y3_total_premium,
                           p_year         =>  '3') ;
    ELSE--Default 1
       P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                           p_Ref1         => ir_gnr_quote_data.ref1,
                           p_Ref2         => ir_gnr_quote_data.ref2,
                           p_amount       => ir_gnr_quote_data.y1_total_premium,
                           p_year         =>  '1') ;
    END IF;
   END IF;
    --------------------------------------------------------
    COMMIT;
    o_rec_no := v_count_no;
    o_message_error := v_message_err;
 EXCEPTION WHEN OTHERS THEN
   az_pk0_general.logtrace(v_func_name,0,'Error p_upd_gnr_quote_data :'||SQLERRM);
   o_message_error :=  v_message_err;
   o_rec_no := 0;
   ROLLBACK;
 END;
----------------------------------------------------------------------------------------------------
PROCEDURE P_IMPORT_DATA_QUOTATION
IS
  --SET DEFINE OFF
-- DECLARE
-- 17/09/2021   Load data by AZTech
    v_file_name         VARCHAR2(100) := 'QUOTE_TTB_';
    --pfunction           varchar2(100) := 'TTB_RECONCILE';
    v_func_name CONSTANT   VARCHAR2(300) := g_package_name||'p_import_data_quotation';
    v_seq               NUMBER := 0;
    v_check             VARCHAR2(500) := NULL;
    v_quote             GNR_QUOTE_DATA.QUOTATION_NUMBER%TYPE;
    v_body              CLOB;
    v_sum_text          NUMBER;
    v_data              VARCHAR2(100) := NULL;
    v_data_err          NUMBER;
    v_data_success      NUMBER;
    v_data_detail       CLOB;
    v_state               NUMBER:= 0;
    v_message_err       VARCHAR2(200) := NULL;
    v_chk               VARCHAR2(1) := NULL;
    v_base              VARCHAR2(50) := NULL;
    v_subject_add       VARCHAR2(100) := NULL;


 v_subject_mail     GNR_SENDER_MAIL.SUBJECT%TYPE;
 /*v_from_email       GNR_SENDER_MAIL.FROM_EMAIL%TYPE;
 v_to_email         GNR_SENDER_MAIL.TO_EMAIL%TYPE;*/

 v_line        NUMBER:=0;
 v_slash_pos   NUMBER;
 v_fr_email    VARCHAR2(1000) := NULL;
 v_too_email   az_pk_mail1.t_email;
 v_cc_email    az_pk_mail1.t_email;
 v_cc_mail     VARCHAR2(100) := NULL;
 v_bcc_email   az_pk_mail1.t_email;
 v_subject_t   VARCHAR2(1000) := NULL;
 v_subject     VARCHAR2(1000) := NULL;
 v_message     az_pk_mail1.t_message;
 v_filename    VARCHAR2(1000) := NULL;
 v_tfilename   az_pk_mail1.t_filename;
 rm            GNR_SENDER_MAIL%ROWTYPE;
 v_location    VARCHAR2(1000);

  v_rec_no  NUMBER ;
  v_message_error VARCHAR2(2000) := NULL;
  CURSOR C_QUOTE_TXT IS SELECT * FROM develop.gnr_quote_text;
  C1 C_QUOTE_TXT%ROWTYPE;

  v_cover_year NUMBER :=0;
  v_cover_year1 NUMBER :=0;
  v_cover_year2 NUMBER :=0;
  v_cover_year3 NUMBER :=0;
  r_gnr_quote_data GNR_QUOTE_DATA%ROWTYPE;
  v_quote_data_id GNR_QUOTE_DATA.Quote_Data_Id%TYPE;

  v_total_error NUMBER :=0;
  v_total_success NUMBER :=0;
  v_all_rec NUMBER :=0;
  v_file VARCHAR2(1000) := NULL;
  v_file1 VARCHAR2(1000) := NULL;
  v_ttb_reconcile_path gnr_reference.value_text%TYPE;
  r_gnr_quote_data_err gnr_quote_data_err%ROWTYPE;
BEGIN

 az_pk0_general.logtrace('TTB_RECONCILE',1,'START: '||to_char(SYSDATE, 'dd/mm/yyyy hh:mi:ss'));

  v_state := 1;
  --v_file_name := REPLACE(v_file_name,'%d%',to_char(SYSDATE,'YYYYMMDD'));
  v_file_name := v_file_name||to_char(SYSDATE,'YYYYMMDD')||'.csv';
  v_data_success := 0;
  v_data_err := 0;
  v_chk := NULL;

 OPEN C_QUOTE_TXT;
 v_state := 2;
  LOOP FETCH C_QUOTE_TXT INTO C1;
 v_state := 3;
   EXIT WHEN C_QUOTE_TXT%NOTFOUND;
     v_data := NULL;
     v_check := NULL;
     v_quote := NULL;
     v_seq   := NULL;
     v_chk   := NULL;
     v_state := 4;

--Adding by Tik
--Check data in GNR_QUOTE_DATA before insert new record
  v_rec_no := 0;
  v_message_error := NULL;
  r_gnr_quote_data := NULL;
  v_rec_no := NULL;
  v_message_error := NULL;
  v_state := 46;
  P_ASSIGN_QUOTE_DATA(r_gnr_quote_text  => C1
  ,i_cover_year       => 0--Default
  ,o_gnr_quote_data   => r_gnr_quote_data
  ,o_message_error    => v_message_error
  );
  --dbms_output.put_line('P_ASSIGN_QUOTE_DATA'||' '||v_message_error);
  IF v_message_error IS NOT NULL THEN
    r_gnr_quote_data_err := NULL;
    r_gnr_quote_data_err.job_number             := c1.col_0001;
    r_gnr_quote_data_err.file_name              := c1.col_0003;
    r_gnr_quote_data_err.quotation_number       := c1.COL_0056;
    r_gnr_quote_data_err.data_source            := c1.col_0117;
    r_gnr_quote_data_err.load_date              := trunc(SYSDATE);
    r_gnr_quote_data_err.message_error          := v_message_error;
    
    p_ins_gnr_quote_data_err(ir_gnr_quote_data_err => r_gnr_quote_data_err
                             ,o_msgerror           => v_message_error);
    IF v_message_error IS NOT NULL THEN                               
         az_pk0_general.logtrace(v_func_name,userenv('sessionid'),v_message_error); 
    END IF; 
                                 
  END IF;
 
  P_VALIDATE_QUOTE(ir_gnr_quote_data => r_gnr_quote_data
                         ,o_msgerror => r_gnr_quote_data.message_error);
  --dbms_output.put_line('P_VALIDATE_QUOTE'||' '||r_gnr_quote_data.message_error);
  ----------------------------------------
  IF r_gnr_quote_data.message_error IS NOT NULL THEN
    r_gnr_quote_data_err := NULL;
    r_gnr_quote_data_err.job_number             := c1.col_0001;
    r_gnr_quote_data_err.file_name              := c1.col_0003;
    r_gnr_quote_data_err.quotation_number       := c1.COL_0056;
    r_gnr_quote_data_err.data_source            := c1.col_0117;
    r_gnr_quote_data_err.load_date              := trunc(SYSDATE);
    r_gnr_quote_data_err.message_error          := r_gnr_quote_data.message_error;
    
    p_ins_gnr_quote_data_err(ir_gnr_quote_data_err => r_gnr_quote_data_err
                                   ,o_msgerror =>v_message_error);
    IF v_message_error IS NOT NULL THEN                               
         az_pk0_general.logtrace(v_func_name,userenv('sessionid'),v_message_error); 
    END IF; 
                                 
  END IF;
  ----------------------------------------
  v_state := 47;
  v_message_error := NULL;
  P_UPD_GNR_QUOTE_DATA(ir_gnr_quote_data => r_gnr_quote_data
                      ,o_rec_no => v_rec_no
                      ,o_message_error => v_message_error);
  --dbms_output.put_line('P_UPD_GNR_QUOTE_DATA'||' '||v_message_error||' v_rec_no='||v_rec_no);
   ----------------------------------------
  IF v_message_error IS NOT NULL THEN
    r_gnr_quote_data_err := NULL;
    r_gnr_quote_data_err.job_number             := c1.col_0001;
    r_gnr_quote_data_err.file_name              := c1.col_0003;
    r_gnr_quote_data_err.quotation_number       := c1.COL_0056;
    r_gnr_quote_data_err.data_source            := c1.col_0117;
    r_gnr_quote_data_err.load_date              := trunc(SYSDATE);
    r_gnr_quote_data_err.message_error          := r_gnr_quote_data.message_error;
    
    p_ins_gnr_quote_data_err(ir_gnr_quote_data_err => r_gnr_quote_data_err
                                   ,o_msgerror =>v_message_error);
    IF v_message_error IS NOT NULL THEN                               
         az_pk0_general.logtrace(v_func_name,userenv('sessionid'),v_message_error); 
    END IF; 
                                 
  END IF;
  ----------------------------------------
  v_state := 48;
  IF  v_rec_no <> 0 THEN
        GOTO NEXT_REC ;
  ELSE
       v_state := 59;
       --dbms_output.put_line('COL_0064 '||' '||c1.COL_0064||' v_rec_no='||v_rec_no);
       --IF  c1.COL_0063 IS NOT NULL THEN
       IF  c1.col_0001 IS NOT NULL THEN
             r_gnr_quote_data := NULL;
             v_rec_no := NULL;
             v_message_error := NULL;
             v_quote_data_id := NULL;
             v_state := 60;
             P_ASSIGN_QUOTE_DATA(r_gnr_quote_text  => C1
                             ,i_cover_year       => 0
                             ,o_gnr_quote_data   => r_gnr_quote_data
                             ,o_message_error    => v_message_error
                             );
             --dbms_output.put_line('P_ASSIGN_QUOTE_DATA'||' '||v_message_error);
           IF v_message_error IS NOT NULL THEN
              r_gnr_quote_data_err := NULL;
              r_gnr_quote_data_err.job_number             := c1.col_0001;
              r_gnr_quote_data_err.file_name              := c1.col_0003;
              r_gnr_quote_data_err.quotation_number       := c1.COL_0056;
              r_gnr_quote_data_err.data_source            := c1.col_0117;
              r_gnr_quote_data_err.load_date              := SYSDATE;
              r_gnr_quote_data_err.message_error          := v_message_error;
              
              p_ins_gnr_quote_data_err(ir_gnr_quote_data_err => r_gnr_quote_data_err
                                             ,o_msgerror =>v_message_error);
            IF v_message_error IS NOT NULL THEN                               
                   az_pk0_general.logtrace(v_func_name,userenv('sessionid'),v_message_error); 
              END IF; 
                                           
            ELSE
               v_state := 61;
               v_message_error := NULL;
               p_ins_gnr_quote_data(ir_gnr_quote_data => r_gnr_quote_data
                                 ,o_quote_data_id  => v_quote_data_id
                                 ,o_msgerror  => v_message_error);
             IF v_message_error IS NOT NULL THEN   
                --dbms_output.put_line('P_INS_GNR_QUOTE_DATA'||' '||v_message_error);
                r_gnr_quote_data_err := NULL;
                r_gnr_quote_data_err.job_number             := c1.col_0001;
                r_gnr_quote_data_err.file_name              := c1.col_0003;
                r_gnr_quote_data_err.quotation_number       := c1.COL_0056;
                r_gnr_quote_data_err.data_source            := c1.col_0117;
                r_gnr_quote_data_err.load_date              := trunc(SYSDATE);
                r_gnr_quote_data_err.message_error          := v_message_error;
               
                
                p_ins_gnr_quote_data_err(ir_gnr_quote_data_err => r_gnr_quote_data_err
                                               ,o_msgerror =>v_message_error);
                IF v_message_error IS NOT NULL THEN                               
                     az_pk0_general.logtrace(v_func_name,userenv('sessionid'),v_message_error); 
                END IF;  
              ELSE
                  -------------------------------------------
                  IF r_gnr_quote_data.COVER_PERIOD_YEAR  = '1&3' THEN
                    P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                                       p_Ref1         => r_gnr_quote_data.ref1,
                                       p_Ref2         => r_gnr_quote_data.ref2,
                                       p_amount       => r_gnr_quote_data.y1_total_premium,
                                       p_year         =>  '1') ;

                    P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                                       p_Ref1         => r_gnr_quote_data.ref1,
                                       p_Ref2         => r_gnr_quote_data.ref2,
                                       p_amount       => r_gnr_quote_data.y3_total_premium,
                                       p_year         =>  '3') ;
                  ELSIF r_gnr_quote_data.COVER_PERIOD_YEAR  = '1&2' THEN
                    P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                                       p_Ref1         => r_gnr_quote_data.ref1,
                                       p_Ref2         => r_gnr_quote_data.ref2,
                                       p_amount       => r_gnr_quote_data.y1_total_premium,
                                       p_year         =>  '1') ;

                    P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                                       p_Ref1         => r_gnr_quote_data.ref1,
                                       p_Ref2         => r_gnr_quote_data.ref2,
                                       p_amount       => r_gnr_quote_data.y2_total_premium,
                                       p_year         =>  '2') ;
                 ELSIF r_gnr_quote_data.COVER_PERIOD_YEAR  = '1' THEN
                     P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                                       p_Ref1         => r_gnr_quote_data.ref1,
                                       p_Ref2         => r_gnr_quote_data.ref2,
                                       p_amount       => r_gnr_quote_data.y1_total_premium,
                                       p_year         =>  '1') ;
                 ELSIF r_gnr_quote_data.COVER_PERIOD_YEAR  = '2' THEN
                     P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                                       p_Ref1         => r_gnr_quote_data.ref1,
                                       p_Ref2         => r_gnr_quote_data.ref2,
                                       p_amount       => r_gnr_quote_data.y2_total_premium,
                                       p_year         =>  '2') ;
                 ELSIF r_gnr_quote_data.COVER_PERIOD_YEAR  = '3' THEN

                     P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                                       p_Ref1         => r_gnr_quote_data.ref1,
                                       p_Ref2         => r_gnr_quote_data.ref2,
                                       p_amount       => r_gnr_quote_data.y3_total_premium,
                                       p_year         =>  '3') ;
                ELSE--Default 1
                   P_INSERT_DATA_REF( p_data_ref_id  => v_quote_data_id,
                                       p_Ref1         => r_gnr_quote_data.ref1,
                                       p_Ref2         => r_gnr_quote_data.ref2,
                                       p_amount       => r_gnr_quote_data.y1_total_premium,
                                       p_year         =>  '1') ;
                END IF;
                  ------------------------------------------
               END IF;
            END IF;
          END IF;


    END IF;
--End Adding By Tik
--------------------------------------------------------------------
 <<NEXT_REC>>
  NULL;
     END LOOP;
    CLOSE C_QUOTE_TXT;
    --Fix case Ref2 null 2021-10-BPI-500138 - TTB Project - Automatic Reconcile Phase 1.1(CHGXXXXXX)
    P_UPD_QUOTE_REF2(trunc(SYSDATE)) ;
  <<NOT_LOAD>>
  NULL;
 -------------------------------------------------------------------------
 get_sender_mail('LOAD_QUOTE',rm);
 SELECT NAME INTO v_base FROM v$database;
     IF v_base !='PRODGEN' THEN
       v_subject_add := ' ( '||v_base||'Testing )';
     END IF;
  v_state := 78;
    v_subject_mail := REPLACE(REPLACE(rm.SUBJECT,'%F%  (%DB%)',v_file_name),'%DF%',trunc(SYSDATE));
    v_subject_mail := v_subject_mail||v_subject_add;
  v_state := 79;
    IF v_base != 'PRODGEN' THEN
    v_too_email := az_pk_mail1.email2array(REPLACE(rm.to_email, ' ', ''), ',');
    v_cc_email  := az_pk_mail1.email2array(REPLACE(rm.cc_email, ' ', ''), ',');
    ELSE
    v_too_email := az_pk_mail1.email2array(rm.to_email, ',');
    v_cc_email  := az_pk_mail1.email2array(rm.cc_email, ',');
    END IF;
  v_state := 79.1; v_fr_email  := rM.From_Email;
----------------------------------------------
v_state := 4;  v_file     := v_filename;
v_state := 5;  v_location := pk_gen_slk.get_jetform_path;
v_ttb_reconcile_path     := gnr_pk_description.get_reference_value_text('TTB_RECONCILE_PATH');
 -- Get File --
  v_state := 18;
  v_slash_pos := instr(v_location, '/', -1);
  v_state := 19;
  /*IF v_slash_pos = 0 THEN
     v_state := 20;
     v_file1 := v_location || '\'||v_file;
  ELSE
     v_state := 21;
     v_file1 := v_location || '/'||v_file;
  END IF;*/
  v_filename := 'gnr_quote_text_new.csv';
  IF  v_base != 'DEVGEN3' THEN --gnr_quote_text_new
      v_file1 := '\\thbkkwi014\data$'||'\TTB_RECONCILE\'||v_filename;
  ELSIF  v_base != 'DEVGEN' THEN
      v_file1 := '\\thbkkwi011\data$'||'\TTB_RECONCILE\'||v_filename;
  ELSE
      v_file1 := v_ttb_reconcile_path||'/'||v_filename;
  END IF;

----------------------------------------------
--v_line := 1;
IF v_message.count>0  THEN v_message.delete;   END IF;
  v_state := 80;
  v_line := v_line+ 1; v_message(v_line) :='<table style="border-collapse:collapse;border-spacing:0;table-layout: fixed; width: 365px" class="tg">';
  v_line := v_line+ 1; v_message(v_line) :='<colgroup>';
  v_line := v_line+ 1; v_message(v_line) :='<col style="width: 232px">';
  v_line := v_line+ 1; v_message(v_line) :='<col style="width: 50px">';
  v_line := v_line+ 1; v_message(v_line) :='<col style="width: 83px">';
  v_line := v_line+ 1; v_message(v_line) :='</colgroup>';
  v_line := v_line+ 1; v_message(v_line) :='<thead>';
  v_line := v_line+ 1; v_message(v_line) := '<tr>';
  v_line := v_line+ 1; v_message(v_line) :='<th style="background-color:#c0c0c0;border-color:#000000;border-style:solid;border-width:1px;color:#333333;font-family:Arial, sans-serif;font-size:14px;font-weight:bold;overflow:hidden;padding:10px 5px;text-align:center;vertical-align:top;word-break:normal" colspan="3">Result Import data from quotation as Date:'||SYSDATE ||'</th>';
  v_line := v_line+ 1; v_message(v_line) :=' </tr>';
  v_line := v_line+ 1; v_message(v_line) :='</thead>';
  v_line := v_line+ 1; v_message(v_line) :='<tbody>';
  v_line := v_line+ 1; v_message(v_line) :=' <tr>';
  v_state := 10;
  v_total_error := 0;
  v_total_success := 0;
  v_all_rec := 0;
  FOR rec IN (SELECT decode(d.message_error,NULL,'PASS','ERROR')AS Validate_flag
               ,COUNT(d.quotation_number) AS total_rec FROM gnr_quote_data d
              WHERE --trunc(d.load_date) = trunc(SYSDATE-1)
              trunc(d.load_date) = trunc(SYSDATE)
              OR trunc(d.upload_date) = trunc(SYSDATE)

              GROUP BY decode(d.message_error,NULL,'PASS','ERROR')
              )LOOP
       v_state := 82;
      IF rec.Validate_flag =  'ERROR' THEN
         v_total_error := rec.total_rec ;
      ELSE
        v_total_success :=   rec.total_rec;
      END IF;
  END LOOP;
   v_state := 83;
  v_all_rec := v_total_error + v_total_success;
  v_state := 84;
  v_line := v_line+ 1; v_message(v_line) := ' <td style="border-color:inherit;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;text-align:left;vertical-align:top;word-break:normal">Total Data valid conditions:</td>';
  v_line := v_line+ 1; v_message(v_line) :='  <td style="border-color:inherit;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;text-align:left;vertical-align:top;word-break:normal">'||v_total_success||'</td>';
  v_line := v_line+ 1; v_message(v_line) :=' <td style="border-color:inherit;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;text-align:left;vertical-align:top;word-break:normal">Record.</td>';
  v_line := v_line+ 1; v_message(v_line) :='</tr>';
  v_line := v_line+ 1; v_message(v_line) :=' <tr>';
  v_line := v_line+ 1; v_message(v_line) :='  <td style="border-color:inherit;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;text-align:left;vertical-align:top;word-break:normal">Total Data Invalid conditions:</td>';
  v_line := v_line+ 1; v_message(v_line) := '<td style="border-color:inherit;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;text-align:left;vertical-align:top;word-break:normal">'||v_total_error||'</td>';
  v_line := v_line+ 1; v_message(v_line) :=' <td style="border-color:inherit;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;text-align:left;vertical-align:top;word-break:normal">Record.</td>';
  v_line := v_line+ 1; v_message(v_line) :='</tr>';
  v_line := v_line+ 1; v_message(v_line) :='<tr>';
  v_line := v_line+ 1; v_message(v_line) :='  <td style="border-color:inherit;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;text-align:left;vertical-align:top;word-break:normal">Total import data :</td>';
  v_line := v_line+ 1; v_message(v_line) :=' <td style="border-color:inherit;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;text-align:left;vertical-align:top;word-break:normal">'||v_all_rec||'</td>';
  v_line := v_line+ 1; v_message(v_line) :=' <td style="border-color:inherit;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;text-align:left;vertical-align:top;word-break:normal">Record.</td>';
  v_line := v_line+ 1; v_message(v_line) :='</tr>';
  v_line := v_line+ 1; v_message(v_line) :='<tr>';
  v_line := v_line+ 1; v_message(v_line) := ' <td style="border-color:#000000;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:13px;overflow:hidden;padding:10px 5px;text-align:left;vertical-align:top;word-break:normal" colspan="3">Remark : if have some invalid data please check at<br>query: SELECT * FROM gnr_quote_data d <br>WHERE d.message_error IS NOT NULL<br>AND trunc(d.load_date) = trunc(SYSDATE)-1;</td>';
  v_line := v_line+ 1; v_message(v_line) := '</tr>';
  v_line := v_line+ 1; v_message(v_line) :='</tbody>';
  v_line := v_line+ 1; v_message(v_line) :='</table>';
   v_state := 85;
  --
  v_file1 := NULL;--no attacth
  v_tfilename := az_pk_mail1.filename2array(v_file1, ',');
   v_state := 86;
  -- Send mail --
  BEGIN
    v_state := 87;
  az_pk_mail1.send(p_fr_email  => v_fr_email,
                p_to_email  => v_too_email,
                p_cc_email  => v_cc_email,
                p_bcc_email => v_bcc_email,
                p_subject   => v_subject_mail,
                p_message   => v_message,
                p_filename  => v_tfilename,
                p_style => 'html');

  v_state := 88;
  EXCEPTION
  WHEN OTHERS THEN
  az_pk0_general.logtrace(v_func_name,userenv('sessionid'),v_message_error);
  --dbms_output.put_line(v_func_name||' '||v_message_error);
  END;
----------------------------------------------
EXCEPTION WHEN OTHERS THEN
 ROLLBACK;
 az_pk0_general.logtrace(v_func_name,userenv('sessionid'),v_state||'ERROR : '||SQLERRM);
 -- dbms_output.put_line(v_func_name||' '||v_message_error);
END;
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

