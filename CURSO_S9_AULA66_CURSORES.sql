-- CURSORES

SET SERVEROUTPUT ON
DECLARE
    -- Declara��o de vari�veis
    viDFunc HR.EMPLOYEES.EMPLOYEE_ID%type;
    vNome HR.EMPLOYEES.FIRST_NAME%type;
    VSalario HR.EMPLOYEES.SALARY%type;
    -- Declara��o de cursores
    CURSOR cs_salario_top_10 is
        SELECT a.EMPLOYEE_ID,a.FIRST_NAME,a.SALARY
            FROM HR.EMPLOYEES a
            order by a.salary desc;
BEGIN
    -- Abre cursor
    OPEN cs_salario_top_10;
    -- Executa um loop com 10 ciclos
        FOR i IN 1..10 LOOP
            -- Extrai dados o registro corrente do cursor e avan�a para o pr�ximo
            FETCH cs_salario_top_10 INTO viDFunc,vNome,VSalario;
            -- Imprime dados extra�dos na tela
            dbms_output.put_line(viDFunc||' - '||vNome||' - '||VSalario);
        END LOOP;
    --fecha cursor
    close cs_salario_top_10;
END;
/
-- EXERCICIO

DECLARE
    v_idFunc HR.employees.employee_id%TYPE;
    v_nomeFunc hr.employees.first_name%TYPE;
    v_salario hr.employees.salary%TYPE;
    
    cursor c_lstFunc is
        SELECT a.EMPLOYEE_ID,a.FIRST_NAME,a.SALARY
            FROM HR.EMPLOYEES a
            order by a.salary desc;
    r_lstFunc c_lstFunc%rowTYPE;
begin
    open c_lstFunc;
        loop
            fetch c_lstFunc into r_lstFunc;
                dbms_output.put_line(r_lstfunc.employee_id || ' ' || r_lstfunc.first_name  || ' ' || r_lstfunc.salary );
            
            exit when c_lstFunc%notfound;
        end loop;
    close c_lstFunc;    
end;