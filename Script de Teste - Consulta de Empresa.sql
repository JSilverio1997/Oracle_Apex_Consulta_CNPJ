DECLARE

 GV_COMPANY_NAME  VARCHAR2(250);
 GV_FORMAT_CNPJ  VARCHAR2(250);
 GV_ACTIVITY_TEXT  VARCHAR2(250);
 GV_TYPE_COMPANY  VARCHAR2(250);
 GV_OPENED_DATE  VARCHAR2(250);
 GV_SITUATION  VARCHAR2(250);
 GV_STATUS VARCHAR2(10);
 GV_ADDRESS  VARCHAR2(250);
 GV_COMPLEMENT  VARCHAR2(250);
 GV_NEIGHBORHOOD  VARCHAR2(250);
 GV_POSTAL_CODE  VARCHAR2(250);
 GV_COUNTY  VARCHAR2(250);
 GV_SIZE  VARCHAR2(250);
 GV_LEGAL_NATURE  VARCHAR2(250);
 GV_ERROR_MSG VARCHAR2(250);

BEGIN

  GET_COMPANY_DATAS_PK.G_EXEC_LOCAL := TRUE;

  GET_COMPANY_DATAS_PK.READ_COMPANY_DATAS_P (P_CNPJ           => '61797924000317',
                                             P_COMPANY_NAME   => GV_COMPANY_NAME,
                                             P_FORMAT_CNPJ    => GV_FORMAT_CNPJ,
                                             P_ACTIVITY_TEXT  => GV_ACTIVITY_TEXT,
                                             P_TYPE_COMPANY   => GV_TYPE_COMPANY,
                                             P_OPENED_DATE      => GV_OPENED_DATE,
                                             P_SITUATION      => GV_SITUATION,
                                             P_STATUS         => GV_STATUS,
                                             P_ADDRESS        => GV_ADDRESS,
                                             P_COMPLEMENT     => GV_COMPLEMENT,
                                             P_NEIGHBORHOOD   => GV_NEIGHBORHOOD,
                                             P_POSTAL_CODE    => GV_POSTAL_CODE,
                                             P_COUNTY         => GV_COUNTY,
                                             P_SIZE           => GV_SIZE,
                                             P_LEGAL_NATURE   => GV_LEGAL_NATURE,
                                             P_ERROR_MSG      => GV_ERROR_MSG
                                            );


END;