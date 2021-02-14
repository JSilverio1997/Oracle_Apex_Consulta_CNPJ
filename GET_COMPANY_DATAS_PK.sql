CREATE OR REPLACE PACKAGE GET_COMPANY_DATAS_PK AS
-- +===================================================================================+
   -- |                   Copyright (c) 2021 DTT                                          |
   -- |            Sao Paulo, Brasil, All rights reserved.                                |
   -- +===================================================================================+
   -- | FILENAME                                                                          |
   -- |   'GET_COMPANY_DATAS_PK'.pls                                                      |
   -- |                                                                                   |
   -- | PURPOSE                                                                           |
   -- |   Package para obter dados de uma empresa através do CNPJ.                        |
   -- |                                                                                   |
   -- | DESCRIPTION                                                                       |
   -- |   Package para obter dados de uma empresa através do CNPJ.                        |
   -- |																					  |
   -- | CONFIRA AS MOEDAS DISPONIVEIS NO LINK ABAIXO                                      |
   -- |                                                                                   |
   -- | PARAMETERS                                                                        |
   -- |   'P_CNPJ'					          							                  |
   -- |                                                                                   |
   -- | CREATED BY                                                                        |
   -- |  'Joao Victor     11-FEV-21'                                                      |
   -- +===================================================================================+

    G_EXEC_LOCAL BOOLEAN := FALSE;
	
	GV_COMPANY_NAME  VARCHAR2(250);
    GV_FORMAT_CNPJ  VARCHAR2(250);
    GV_ACTIVITY_TEXT  VARCHAR2(250);
    GV_TYPE_COMPANY  VARCHAR2(250);
    GV_OPENED_DATE  VARCHAR2(250);
    GV_SITUATION  VARCHAR2(250);
    GV_COMPANY_STATUS     VARCHAR2(20);
    GV_ADDRESS  VARCHAR2(250);
    GV_COMPLEMENT  VARCHAR2(250);
    GV_NEIGHBORHOOD  VARCHAR2(250);
    GV_POSTAL_CODE  VARCHAR2(250);
    GV_COUNTY  VARCHAR2(250);
    GV_COMPANY_SIZE  VARCHAR2(250);
    GV_LEGAL_NATURE  VARCHAR2(250);
  
    PROCEDURE READ_COMPANY_DATAS_P (P_CNPJ IN VARCHAR2,
                                    P_COMPANY_NAME OUT VARCHAR2,
                                    P_FORMAT_CNPJ OUT VARCHAR2,
                                    P_ACTIVITY_TEXT OUT VARCHAR2,
                                    P_TYPE_COMPANY OUT VARCHAR2,
                                    P_OPENED_DATE OUT VARCHAR2,
                                    P_SITUATION OUT VARCHAR2,
                                    P_STATUS OUT VARCHAR2,
                                    P_ADDRESS OUT VARCHAR2,
                                    P_COMPLEMENT OUT VARCHAR2,
                                    P_NEIGHBORHOOD OUT VARCHAR2,
                                    P_POSTAL_CODE OUT VARCHAR2,
                                    P_COUNTY OUT VARCHAR2,
                                    P_SIZE OUT VARCHAR2,
                                    P_LEGAL_NATURE OUT VARCHAR2,
                                    P_ERROR_MSG OUT VARCHAR2
                                    );
    
    PROCEDURE MSG_P(P_MSG IN VARCHAR2,
                    P_SHOW IN VARCHAR2 DEFAULT NULL);

    PROCEDURE PRINT_LAYOUT_P;

END GET_COMPANY_DATAS_PK;
/
create or replace PACKAGE BODY GET_COMPANY_DATAS_PK AS 
-- +===================================================================================+ 
   -- |                   Copyright (c) 2021 DTT                                          | 
   -- |            Sao Paulo, Brasil, All rights reserved.                                | 
   -- +===================================================================================+ 
   -- | FILENAME                                                                          | 
   -- |   'GET_COMPANY_DATAS_PK'.pls                                                      | 
   -- |                                                                                   | 
   -- | PURPOSE                                                                           | 
   -- |   Package para obter dados de uma empresa através do CNPJ.                        | 
   -- |                                                                                   | 
   -- | DESCRIPTION                                                                       | 
   -- |   Package para obter dados de uma empresa através do CNPJ.                        | 
   -- |																					  | 
   -- | CONFIRA AS MOEDAS DISPONIVEIS NO LINK ABAIXO                                      | 
   -- |                                                                                   | 
   -- | PARAMETERS                                                                        | 
   -- |   'P_CNPJ'					          							                  | 
   -- |                                                                                   | 
   -- | CREATED BY                                                                        | 
   -- |  'Joao Victor     11-FEV-21'                                                      | 
   -- +===================================================================================+ 
 
    PROCEDURE READ_COMPANY_DATAS_P (P_CNPJ IN VARCHAR2, 
                                    P_COMPANY_NAME OUT VARCHAR2, 
                                    P_FORMAT_CNPJ OUT VARCHAR2, 
                                    P_ACTIVITY_TEXT OUT VARCHAR2, 
                                    P_TYPE_COMPANY OUT VARCHAR2, 
                                    P_OPENED_DATE OUT VARCHAR2, 
                                    P_SITUATION OUT VARCHAR2, 
                                    P_STATUS OUT VARCHAR2, 
                                    P_ADDRESS OUT VARCHAR2, 
                                    P_COMPLEMENT OUT VARCHAR2, 
                                    P_NEIGHBORHOOD OUT VARCHAR2, 
                                    P_POSTAL_CODE OUT VARCHAR2, 
                                    P_COUNTY OUT VARCHAR2, 
                                    P_SIZE OUT VARCHAR2, 
                                    P_LEGAL_NATURE OUT VARCHAR2, 
                                    P_ERROR_MSG OUT VARCHAR2 
                                    )IS 
 
         LV_FORMATED_CNPJ VARCHAR2(14) := TRIM(REPLACE(REPLACE(REPLACE(P_CNPJ, '/', ''),'.', '' ), '-','')); 
         LV_URL_WEB_SERVICE VARCHAR2(4000); 
         LN_STATUS_CODE NUMBER; 
         LV_RETURN_DATAS_CNPJ VARCHAR2(32767);   
         LN_CONT_REG_COMPANY NUMBER := 0;		 
 
    BEGIN 
            
          IF LENGTH(TRIM(LV_FORMATED_CNPJ)) = 14 THEN  
			
		   BEGIN
		   
			SELECT COUNT(*)
			 INTO LN_CONT_REG_COMPANY
			 FROM COMPANIES_SEARCHEDS
			 WHERE TRIM(REPLACE(REPLACE(REPLACE(CNPJ, '/', ''),'.', '' ), '-','')) = LV_FORMATED_CNPJ;
           
		   END;
		   
		   IF LN_CONT_REG_COMPANY = 0 THEN
		   
			LV_URL_WEB_SERVICE := 'https://www.receitaws.com.br/v1/cnpj/'||LV_FORMATED_CNPJ; 
			 
            GET_COMPANY_DATAS_PK.MSG_P(P_MSG => 'URL: '||LV_URL_WEB_SERVICE||CHR(13), 
                                       P_SHOW => 'N'); 
				 
			LV_RETURN_DATAS_CNPJ := APEX_WEB_SERVICE.MAKE_REST_REQUEST(P_URL         => LV_URL_WEB_SERVICE, 
			   		             									   P_HTTP_METHOD => 'GET');  
                    
            LN_STATUS_CODE := APEX_WEB_SERVICE.G_STATUS_CODE; 
 
            GET_COMPANY_DATAS_PK.MSG_P(P_MSG => CHR (9) ||' * Status Code: '||LN_STATUS_CODE||CHR(13)); 
 
			IF LN_STATUS_CODE = 200 THEN 
 
              GET_COMPANY_DATAS_PK.MSG_P(P_MSG => LV_RETURN_DATAS_CNPJ, 
                                        P_SHOW => 'N'); 
 
			  BEGIN 
				    
				APEX_JSON.PARSE(LV_RETURN_DATAS_CNPJ); 
					 
				FOR REC IN 1 .. APEX_JSON.GET_COUNT ('atividade_principal') LOOP 
					   
					P_COMPANY_NAME   := INITCAP(APEX_JSON.GET_VARCHAR2 ('nome', REC)); 
					P_FORMAT_CNPJ    := INITCAP(APEX_JSON.GET_VARCHAR2 ('cnpj', REC)); 
					P_ACTIVITY_TEXT  := INITCAP(APEX_JSON.GET_VARCHAR2 ('atividade_principal[%d].text', REC)); 
					P_TYPE_COMPANY   := INITCAP(APEX_JSON.GET_VARCHAR2 ('tipo', REC)); 
					P_OPENED_DATE    := INITCAP(APEX_JSON.GET_VARCHAR2 ('abertura', REC)); 
					P_SITUATION      := INITCAP(APEX_JSON.GET_VARCHAR2 ('situacao', REC)); 
                    P_STATUS         := INITCAP(APEX_JSON.GET_VARCHAR2 ('status', REC)); 
					P_ADDRESS  	     := INITCAP(APEX_JSON.GET_VARCHAR2 ('logradouro', REC)||' Nº '||APEX_JSON.GET_VARCHAR2 ('numero', REC)); 
					P_COMPLEMENT     := INITCAP(APEX_JSON.GET_VARCHAR2 ('complemento', REC)); 
					P_NEIGHBORHOOD   := INITCAP(APEX_JSON.GET_VARCHAR2 ('bairro', REC)); 
					P_POSTAL_CODE    := INITCAP(APEX_JSON.GET_VARCHAR2 ('cep', REC)); 
					P_COUNTY  	     := INITCAP(APEX_JSON.GET_VARCHAR2 ('municipio', REC)); 
					P_SIZE  		 := INITCAP(APEX_JSON.GET_VARCHAR2 ('porte', REC)); 
					P_LEGAL_NATURE   := INITCAP(APEX_JSON.GET_VARCHAR2 ('natureza_juridica', REC));  
 
				END LOOP;  
				    
				GV_COMPANY_NAME   := P_COMPANY_NAME; 
				GV_FORMAT_CNPJ    := P_FORMAT_CNPJ; 
				GV_ACTIVITY_TEXT  := P_ACTIVITY_TEXT; 
				GV_TYPE_COMPANY   := P_TYPE_COMPANY; 
				GV_OPENED_DATE    := P_OPENED_DATE; 
				GV_SITUATION      := P_SITUATION; 
                GV_COMPANY_STATUS := P_STATUS; 
				GV_ADDRESS        := P_ADDRESS; 
				GV_COMPLEMENT     := P_COMPLEMENT; 
				GV_NEIGHBORHOOD   := P_NEIGHBORHOOD; 
				GV_POSTAL_CODE    := P_POSTAL_CODE; 
				GV_COUNTY         := P_COUNTY; 
				GV_COMPANY_SIZE   := P_SIZE; 
   				GV_LEGAL_NATURE   := P_LEGAL_NATURE; 
				    
				GET_COMPANY_DATAS_PK.PRINT_LAYOUT_P; 
				
				INSERT INTO COMPANIES_SEARCHEDS
				(ID_COMPANY
				,COMPANY_NAME
				,CNPJ
				,ACTIVITY_TEXT
				,TYPE_COMPANY
				,OPENED_DATE
				,SITUATION
				,COMPANY_STATUS
				,ADDRESS
				,COMPLEMENT
				,NEIGHBORHOOD
				,POSTAL_CODE
				,COUNTY
				,COMPANY_SIZE
				,LEGAL_NATURE
				) 
				VALUES
				(COMPANIES_SEARCHEDS_S.NEXTVAL,
				 GV_COMPANY_NAME, 
				 GV_FORMAT_CNPJ, 
				 GV_ACTIVITY_TEXT, 
				 GV_TYPE_COMPANY, 
				 GV_OPENED_DATE,
				 GV_SITUATION,
				 GV_COMPANY_STATUS,
				 GV_ADDRESS,
				 GV_COMPLEMENT,
				 GV_NEIGHBORHOOD,
				 GV_POSTAL_CODE,
				 GV_COUNTY,
				 GV_COMPANY_SIZE,
				 GV_LEGAL_NATURE
				);
				COMMIT;
 
			 EXCEPTION 
			  WHEN OTHERS THEN 
                  P_ERROR_MSG := INITCAP('ERRO AO TENTAR RECUPERAR OS DADOS DA EMPRESA. '); 
				  RAISE_APPLICATION_ERROR(-20003, 'ERRO AO TENTAR RECUPERAR OS DADOS DA EMPRESA. '||SQLCODE||' - '||SQLERRM); 
			 END; 
             
            END IF; 
           
		   ELSE 
		   
		       SELECT CS.COMPANY_NAME
					 ,CS.CNPJ
					 ,CS.ACTIVITY_TEXT
				     ,CS.TYPE_COMPANY
					 ,CS.OPENED_DATE
					 ,CS.SITUATION
					 ,CS.COMPANY_STATUS
					 ,CS.ADDRESS
					 ,CS.COMPLEMENT
					 ,CS.NEIGHBORHOOD
					 ,CS.POSTAL_CODE
					 ,CS.COUNTY
					 ,CS.COMPANY_SIZE
					 ,CS.LEGAL_NATURE
				INTO P_COMPANY_NAME
				    ,P_FORMAT_CNPJ
					,P_ACTIVITY_TEXT
					,P_TYPE_COMPANY
					,P_OPENED_DATE
					,P_SITUATION
					,P_STATUS
					,P_ADDRESS
					,P_COMPLEMENT
					,P_NEIGHBORHOOD
					,P_POSTAL_CODE
					,P_COUNTY
					,P_SIZE
					,P_LEGAL_NATURE
				FROM COMPANIES_SEARCHEDS CS
				WHERE TRIM(REPLACE(REPLACE(REPLACE(CNPJ, '/', ''),'.', '' ), '-','')) = LV_FORMATED_CNPJ; 
				
			    GV_COMPANY_NAME   := P_COMPANY_NAME; 
				GV_FORMAT_CNPJ    := P_FORMAT_CNPJ; 
				GV_ACTIVITY_TEXT  := P_ACTIVITY_TEXT; 
				GV_TYPE_COMPANY   := P_TYPE_COMPANY; 
				GV_OPENED_DATE    := P_OPENED_DATE; 
				GV_SITUATION      := P_SITUATION; 
                GV_COMPANY_STATUS         := P_STATUS; 
				GV_ADDRESS        := P_ADDRESS; 
				GV_COMPLEMENT     := P_COMPLEMENT; 
				GV_NEIGHBORHOOD   := P_NEIGHBORHOOD; 
				GV_POSTAL_CODE    := P_POSTAL_CODE; 
				GV_COUNTY         := P_COUNTY; 
				GV_COMPANY_SIZE   := P_SIZE; 
   				GV_LEGAL_NATURE   := P_LEGAL_NATURE; 
				    
				GET_COMPANY_DATAS_PK.PRINT_LAYOUT_P; 
				
		   END IF;
		   
		  END IF; 
			 
    EXCEPTION 
     WHEN OTHERS THEN 
       P_ERROR_MSG := INITCAP('ERRO AO TENTAR EXECUTAR A PROCEDURE READ_COMPANY_DATAS_P. . VERIFQUE SE O CNPJ NAO ESTA INVALIDO.'); 
       RAISE_APPLICATION_ERROR(-20004, 'ERRO AO TENTAR EXECUTAR A PROCEDURE READ_COMPANY_DATAS_P. VERIFQUE SE O CNPJ NAO ESTA INVALIDO '
	                                   ||'CNPJ: '||LV_FORMATED_CNPJ||' ' ||SQLCODE||' - '||SQLERRM); 
    END READ_COMPANY_DATAS_P; 
 
    PROCEDURE MSG_P(P_MSG IN VARCHAR2, 
                    P_SHOW IN VARCHAR2 DEFAULT NULL)IS 
 
 
    BEGIN 
        
        IF G_EXEC_LOCAL AND P_SHOW IS NULL THEN 
          DBMS_OUTPUT.PUT_LINE(P_MSG); 
         
        ELSIF G_EXEC_LOCAL AND P_SHOW = 'Y' THEN 
          DBMS_OUTPUT.PUT_LINE(P_MSG); 
        END IF; 
 
    EXCEPTION 
      WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20005, 'ERRO AO TENTAR EXECUTAR A PROCEDURE MSG_P. '||SQLCODE||' - '||SQLERRM); 
    END MSG_P; 
 
    PROCEDURE PRINT_LAYOUT_P IS 
 
 
    BEGIN 
        
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || '           Layout do Arquivo    '); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || LPAD('_', 100, '_')); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * NOME: '||GV_COMPANY_NAME); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * CNPJ: ' ||GV_FORMAT_CNPJ); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * RAMO DE ATIVIDADE: ' ||GV_ACTIVITY_TEXT); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * TIPO: ' ||GV_TYPE_COMPANY); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * DATA DA ABERTURA: ' ||GV_OPENED_DATE); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * SITUAÇÃO: ' ||GV_SITUATION); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * STATUS: ' ||GV_COMPANY_STATUS); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * ENDEREÇO: ' ||GV_ADDRESS); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * COMPLEMENTO: ' ||GV_COMPLEMENT); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * BAIRRO: ' ||GV_NEIGHBORHOOD); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * CEP: ' ||GV_POSTAL_CODE); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * MUNICÍPIO: ' ||GV_COUNTY); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * PORTE: ' ||GV_COMPANY_SIZE); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || ' * NATUREZA JURÍDICA: ' ||GV_LEGAL_NATURE); 
        GET_COMPANY_DATAS_PK.MSG_P(P_MSG =>  CHR (9) || LPAD('_', 100, '_')); 
    EXCEPTION 
      WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20006, 'ERRO AO TENTAR EXECUTAR A PROCEDURE PRINT_LAYOUT_P. '||SQLCODE||' - '||SQLERRM); 
    END PRINT_LAYOUT_P; 
 
END GET_COMPANY_DATAS_PK; 
/