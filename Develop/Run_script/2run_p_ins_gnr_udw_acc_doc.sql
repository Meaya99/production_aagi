--Check authority user print 
Declare
  vOutMsg      varchar2(100):=null;
  v_policy      varchar2(100):=null;
  vResult NUMBER:=null;
  v_recSucces number:=0;  vChkAutoPrint number:=0;
  v_recFail number:=0;
Begin
  For Rec in ( Select  a.*
                      From   gnr_outsource_acc  a
                      Where  a.flag_status ='N'
                      --and  a.contract_id between 6477671 and 6477675
                      )
                      --And    trunc(a.create_date)  = trunc(sysdate) )
   Loop                  
          gnr_pk_outsource_acc.p_ins_gnr_udw_acc_doc (i_contract_id => rec.contract_id
                                                   ,i_version_no => rec.version_no
                                                   ,o_result      => vResult);
                                                  -- , o_message_txt => vOutMsg);
   --     v_policy   := az_pk2_general.Get_Policy_No (rec.contract_id , rec.version_no);
      --  dbms_output.put_line ( v_policy ||'  Done  Insert UDW Acc ' || ' : contract_id = '||rec.contract_id||' : version_no = '||rec.version_no );
     --dbms_output.put_line (v_policy ||': Result (0 is success )  = '|| vResult ||':'||vOutMsg );
   --  az_pk0_general.logtrace(v_policy,rec.contract_id,': Result (0 is success )  = '|| vResult||':'||vOutMsg );
   --End Loop;
       Begin
          If vresult = 0 Then
            Begin
             Select count(*)
             into   vChkAutoPrint
              from  gnr_auto_printing 
             where   1=1
             and contract_id = rec.contract_id  --6477673
             and version_no = rec.version_no
             and product_id = rec.product_id
             and doc_name ='RCPT'
             and doc_type ='ORG'
             and printer_name = 'GREMOTE13'
             and Nvl(print_flag,'N') = 'N' 
             and print_by ='ACC';
            end;
             if vChkAutoPrint  != 0 then
                 v_recSucces := v_recSucces +1;
             else
                 v_recFail  := v_recFail +1;
             end if;
          else   -- v_result =1  or null
                 v_recFail  := v_recFail +1;
          end if;
          --End If; 
       End;
    End Loop;
    --dbms_output.put_line ( 'Insert AutoPrint Success := '||v_recSucces ||' , And Fail = '|| v_recFail);
End;
