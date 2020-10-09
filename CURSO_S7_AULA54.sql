--ESCOPO DE VARIAVEIS 

SET SERVEROUTPUT ON
<<BLOCOPRINCIPAL>> --declaracao de label de escopo
DECLARE
    V_NUM1 NUMBER := 100;
    BEGIN
        DECLARE
            V_NUM1 NUMBER := 50;
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Impress�o 1 '||BLOCOPRINCIPAL.V_NUM1 || ' - BLOCOPRINCIPAL');
            DBMS_OUTPUT.PUT_LINE('Impress�o 2 '||V_NUM1|| ' - V_NUM1' );
        END;
        
        DBMS_OUTPUT.PUT_LINE('Impress�o 3 '||V_NUM1|| ' - V_NUM1');
        
    END;
/


--outro exemplo
DECLARE
    V_TEMP NUMBER:=100;
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_TEMP);
    
    DECLARE
        V_TEMP NUMBER:=200;
    BEGIN
         DBMS_OUTPUT.PUT_LINE(V_TEMP);
    END;
    
    DBMS_OUTPUT.PUT_LINE(V_TEMP);
END;
/