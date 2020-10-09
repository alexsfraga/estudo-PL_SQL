-- PLANEJAMENTO PRODU��O

--PROCEDURE ORDEM_PROD
--SELECT * FROM PED_VENDAS
--SELECT * FROM PED_VENDAS_ITENS
--SELECT * FROM ORDEM_PROD
--MAT 1 QTD 35
--MAT 2 QTD 40

--OBJETIVO GERAR ORDENS DE PRODUCAO DE ACORDO COM DEMANDA DE VENDAS POR EMPRESA
--DROP PROCEDURE PROC_PLAN_ORDEM

CREATE OR REPLACE PROCEDURE PROC_PLAN_ORDEM (P_EMP NUMBER,
                                             P_MES  VARCHAR2, 
                                             P_ANO  VARCHAR2) 
IS
  V_EXCEPT_EXISTE_PEDIDO EXCEPTION;
  V_CONTA_PED NUMBER;
 BEGIN 
   
 --VERIFICANDO SE EXISTE PEDIDOS ABERTO PARA MES E ANO SELECIONADO
    SELECT COUNT(*) QTD INTO V_CONTA_PED
        FROM PED_VENDAS A
            INNER JOIN PED_VENDAS_ITENS B
                ON A.NUM_PEDIDO=B.NUM_PEDIDO
                AND A.COD_EMPRESA=B.COD_EMPRESA
        WHERE A.SITUACAO='A' --ABERTO
            AND A.COD_EMPRESA=P_EMP
            AND TO_CHAR(A.DATA_ENTREGA,'MM')=P_MES
            AND TO_CHAR(A.DATA_ENTREGA,'YYYY')=P_ANO;
    
    --SE FOR IGUAL NAO ZERO NAO TEM E TERMINA
    IF V_CONTA_PED=0
	THEN 
		RAISE V_EXCEPT_EXISTE_PEDIDO;
	END IF;


    --SELECIONANDO PEDIDOS PARA GERAR ORDENS DE PRODU��O DE ACORDO COM A DEMANDA.
    INSERT INTO ORDEM_PROD 
			SELECT A.COD_EMPRESA,
                   NULL,
                   B.COD_MAT,
                   SUM(B.QTD) AS QTD_PLAN,
                   0 QTD_PROD,
			       '01/'||P_MES||'/'||P_ANO AS DATA_INI,
                   LAST_DAY('01/'||P_MES||'/'||P_ANO) AS DATA_FIM,
                   'A'
			FROM PED_VENDAS A
				INNER JOIN PED_VENDAS_ITENS B
                    ON A.NUM_PEDIDO=B.NUM_PEDIDO
                        AND  A.COD_EMPRESA=B.COD_EMPRESA
            WHERE A.COD_EMPRESA=P_EMP 
                    AND TO_CHAR(A.DATA_ENTREGA,'MM')=P_MES
                    AND TO_CHAR(A.DATA_ENTREGA,'YYYY')=P_ANO
                     AND A.SITUACAO='A' --APENAS PEDIDO EM ABERTO
            GROUP BY A.COD_EMPRESA, B.COD_MAT, NULL, 0, '01/'||P_MES||'/'||P_ANO, 
                    LAST_DAY('01/'||P_MES||'/'||P_ANO), 'A';
                    -- FUN��O LAST DAY VAI PEGAR O ULTIMO DIA DO MES
		
               DBMS_OUTPUT.PUT_LINE('INSERT ORDEM PROD REALIZADO');
               
                --ATUALIZA STATUS PEDIDO DE A PARA P
            UPDATE PED_VENDAS  SET SITUACAO='P'
                WHERE COD_EMPRESA=P_EMP
                    AND TO_CHAR(DATA_ENTREGA,'MM')=P_MES
                    AND TO_CHAR(DATA_ENTREGA,'YYYY')=P_ANO
                    AND SITUACAO='A';
               
            DBMS_OUTPUT.PUT_LINE('STATUS ATUALIZADO DE ABERTO PARA PLANEJADO');
    
 EXCEPTION
 WHEN V_EXCEPT_EXISTE_PEDIDO THEN
      DBMS_OUTPUT.PUT_LINE('ATEN��O! NAO EXISTE PEDIDOS ABERTO PARA PLANEJAMENTO!');
 
  WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('OCORREU UM ERRO - '||SQLCODE||' -ERROR- '||SQLERRM);

END;

--SELECT * FROM PED_VENDAS
--SELECT * FROM PED_VENDAS_ITENS
--SELECT * FROM ORDEM_PROD 
--PARAMENTRO EMPRESA, MES, ANO
EXECUTE PROC_PLAN_ORDEM (1,'01','2018');
EXECUTE PROC_PLAN_ORDEM (1,'02','2018');
EXECUTE PROC_PLAN_ORDEM (2,'03','2018');
EXECUTE PROC_PLAN_ORDEM (1,'04','2018');

--DELETE FROM ORDEM_PROD;
