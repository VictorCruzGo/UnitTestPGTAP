************************************
--             PGTAP
************************************


--Referencias
-------------------------------------------------------------------------------------------------------
https://github.com/theory/pgtap
https://pgtap.org/
https://pgxn.org/dist/pgtap/


--Habilitar pgtap
-------------------------------------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS pgtap



--Funciones de prueba
-------------------------------------------------------------------------------------------------------
--Funcion de prueba para sumar dos numeros
create or replace function sre_recaudaciones.prueba_suma
(
	a integer,
	b integer
)
	returns integer
as
$$
declare 
	resultado integer;
begin
	resultado:=a+b;
	return resultado;
end
$$ language plpgsql;

--Funcion de prueba para multiplicar dos numeros
create or replace function sre_recaudaciones.prueba_multiplicacion
(
	a integer,
	b integer
)
	returns integer
as
$$
declare 
	resultado integer;
begin
	resultado:=a*b;
	return resultado;
end
$$ language plpgsql;


--Funcion de prueba para dividir dos numeros
create or replace function sre_recaudaciones.prueba_division
(
	a integer,
	b integer
)
	returns integer
as
$$
declare 
	resultado integer;
begin
	resultado:=a/b;
	return resultado;
end
$$ language plpgsql;

--Funcion de prueba para obtener una palabra
create or replace function sre_recaudaciones.prueba_texto()
	returns varchar
as
$$
declare 
	
begin
	return 'si';
end
$$ language plpgsql;


--Pasos para crear un plata de pruebas
-------------------------------------------------------------------------------------------------------
--1. Declarar un plan de pruebas
select plan(42); --(???)

--1.1 Declara que no hay un plan de pruebas (opcional)
select * from no_plan();

--2. Calcular el numero de pruebas (opcional)
select plan(count(*) from sre_recaudaciones.prueba_multiplicacion(5,2)
select plan(count(*)) from foo;

--3. finalizar un plan de pruebas
select * from finish()

--4. Ejecutar pruebas unitarias
select * from runtests();





--Metodos de PGTAP
-------------------------------------------------------------------------------------------------------



--Metodo: ok()
------------------------------------------------------------------------------------------------------- 
--Esto esta bien
--si el resultado de la prueba pasa como NULL en lugar de TRUE o FALSE, ok() supondra un error de prueba
select ok(9*2=18, 'multiplicacion por dos');
select ok(9*3=18, 'multiplicacion por dos');

select ok(archivo_id=103, estado_id||'- conctenado')
from sre_recaudaciones.sre_fac_archivos


--Metodo: is() isnt() 
-------------------------------------------------------------------------------------------------------
--Esto es eso, esto no eso
select is(10,10,'valores actual, valor esperado');
select is(sre_recaudaciones.prueba_multiplicacion(5,2),10, 'funcion multiplicacion')
select is(sre_recaudaciones.prueba_texto(),'si', 'Se espera si como resultado')


--Leer parametros desde formulario  
SELECT is(:foo::text, :bar::text, 'Is foo the same as bar?' );

--Parametros para probar consultas
PREPARE pruebaplan (integer, integer) AS
    SELECT sre_recaudaciones.prueba_multiplicacion($1,$2);

EXECUTE pruebaplan(5, 6);

--Comparar el resultado de toda una fila
SELECT is(sre_recaudaciones.sre_fac_csv.*, ROW(1,'abc','txt','mime','AC')::sre_recaudaciones.sre_fac_csv) 
from sre_recaudaciones.sre_fac_csv 
where archivo_csv_id=1 


--Metodo: matches()
-------------------------------------------------------------------------------------------------------
--Esto coincide con eso
select plan(1)
select matches('Victor'::text,'^Vic', 'esto coincide con eso');
select imatches('VICtor'::text,'^Vic', 'esto coincide con eso'); --Coincidencia sin distinguir mayuscalas/minusculas


--Metodo: doesnt_match()/doesnt_imatch()
-------------------------------------------------------------------------------------------------------
--Verifican sino coinciden con el patron dado.
select doesnt_match('hola'::text, '^vi', 'esto no coincide con eso')


--Metodo: alike()
-------------------------------------------------------------------------------------------------------



--Metodo: ialike()
-------------------------------------------------------------------------------------------------------
--Esto es asi
--Esto coincide con eso (smiliar a like)
select alike('Hola victor como estas'::text,'%victor%','esto conincide con eso');


--Metodo: unalike()
-------------------------------------------------------------------------------------------------------


--Metodo: unialike()
-------------------------------------------------------------------------------------------------------
--Es no coincide con el patron
SELECT unalike('Hola victor como estas'::text,'%victor%','esto no conincide con el patron');



--Metodo: cmp_ok()
-------------------------------------------------------------------------------------------------------
--Permite comprar dos argumentos usando algun operador binario.
SELECT cmp_ok( 10, '=', 10, 'esto = eso' );
SELECT cmp_ok(null, '=', null, 'null'); --(no ejecuta)



--Metodo: pass() y fail()
-------------------------------------------------------------------------------------------------------
--Ha veces solo se quiere decir que las pruebas han pasado o han fallado
SELECT pass('la prueba ha pasado');
SELECT pass( );
SELECT fail('la prueba ha fallado');
SELECT fail( )



--Metodo: isa_ok()
-------------------------------------------------------------------------------------------------------
--Comprueba si el valor dado es de un tipo particular
SELECT isa_ok(sre_recaudaciones.prueba_multiplicacion(5,2), 'integer', 'El valor de retorno de prueba_multimplicacion es un entero');
SELECT isa_ok(sre_recaudaciones.prueba_texto(), 'integer', 'El valor de retorno de prueba_texto() es un entero');



--PERSIGUIENDO TUS CONSULTAS
--Metodo: results_eq()
-------------------------------------------------------------------------------------------------------
select results_eq(
	'resultado_1',
	'execute resultado_2(1)'
)

--Comparar el resultado de una columna 
--select q.x[1] from (select array(select archivo_csv_id from sre_recaudaciones.sre_fac_csv) as x) as q  
SELECT results_eq(
    'select archivo_csv_id::integer from sre_recaudaciones.sre_fac_csv',
    ARRAY[ 1, 2, 3, 4]
);


--Metodo: set_eq()
-------------------------------------------------------------------------------------------------------
--Comparanod los valores de una declaracion preparada
PREPARE misvalores AS VALUES (1, 2), (3, 4);

SELECT set_eq(
    'misvalores',
    'VALUES (2, 2), (3, 3)'
);


--EL ERROR ES HUMANO
--throws_ok()
-------------------------------------------------------------------------------------------------------
--Comprobar si una consulta genera un error

--https://www.postgresql.org/docs/current/errcodes-appendix.html
Clase 00 - Finalización exitosa
00000 	successful_completion
Clase 01 - Advertencia
01000 	warning
0100C 	dynamic_result_sets_returned
01008 	implicit_zero_bit_padding
01003 	null_value_eliminated_in_set_function
01007 	privilege_not_granted
01006 	privilege_not_revoked
01004 	string_data_right_truncation
01P01 	deprecated_feature
Clase 02: sin datos (también es una clase de advertencia según el estándar SQL)
02000 	no_data
02001 	no_additional_dynamic_result_sets_returned
Clase 23 - Violación de restricción de integridad
23505 	unique_violation


--Metodo: throws_ok()
-------------------------------------------------------------------------------------------------------
--Verifica si la funcion genera una excepcion
SELECT throws_ok('select sre_recaudaciones.prueba_division(10,0)');

--Probando is la declaracion preparada genera una excepcion
PREPARE mythrow AS SELECT sre_recaudaciones.prueba_division(10,0); --Declaracion preparada
SELECT throws_ok('mythrow'); 

--Probando si los resultado de las dos consultas son iguales
prepare "resultado_1" as select * from sre_recaudaciones.sre_fac_csv where archivo_csv_id=1;
prepare "resultado_2" as select * from sre_recaudaciones.sre_fac_csv where archivo_csv_id=$1;

--Verificar que lanze una excepcion cuando se intente insertar una valor repetido en la columna bigserial 'archivo_csv_id'
PREPARE my_thrower AS insert into sre_recaudaciones.sre_fac_csv(archivo_csv_id) values(1);
--Cuando se conoce el codigo de error y mensaje
SELECT throws_ok(
    'my_thrower',
    '23502',
    'null value in column "archivo" violates not-null constraint',
    'Deberia de insertar un valor unico'
);

--Cuando solo se conoce el codigo de error
SELECT throws_ok(
    'my_thrower',
    '23502'
);


--Metodo: throws_like()
-------------------------------------------------------------------------------------------------------
--Comprueba que un mensaje de error  coincide con un patron like
SELECT throws_like(
    'my_thrower',
    '%violates not-null%',
    'Deberia de insertar un valor unico.'
);



--Metodo: throws_matching()/throws_imatching()
-------------------------------------------------------------------------------------------------------
--Prueba que un mensaje de error coincide con una expresion regular
SELECT throws_matching(
    'my_thrower',
    '.+"violates not-null"',
    'Deberia de insertar un valor unico.'
);



--Metodo: lives_ok()
-------------------------------------------------------------------------------------------------------
--Los contrario de throws(). Asegura que una declaracion SQL no arroja una excepcion.

--Prueba que la sentencia insert no genere excepcion
SELECT lives_ok(
    'insert into sre_recaudaciones.sre_fac_csv(archivo_csv_id, archivo, extesion, mime, estado_id) values(102,''xyz'',''txt'',''mime'',''AC'')',
    'No deberia obtener un mensaje de violacion de clave primaria'
);



--Metodo: perform_ok()
-------------------------------------------------------------------------------------------------------
--Asegura que una sentencia sql funcione bien. lo hace sincronizando su ejecucion y fallando si la ejecucion toma mas tiempo que el numero especificado en milisengundos
PREPARE fast_query AS select * from  sre_recaudaciones.sre_fac_csv where archivo_csv_id >1;
SELECT performs_ok(
    'fast_query',
    1,
    'La consulta deberia de ejecutarse en menos de 1 ms'
);



--Metodo: perform_within()
-------------------------------------------------------------------------------------------------------
--Asegura que una sentencia sql en promedio se ejecute dentro de una ventana esperada.
--(:sql, :average_milliseconds, :within, :iterations, :description );
SELECT performs_within(
    'fast_query', --sql
    5, --promedio en milisengundos.
    10, --cantidad de ms que permite que la consulta varie.
    100, --numero de iteraciones de la consulta. Sino se proporcionar ejecutara 10 veces la consulta.
    'A select by name should be fast' --descripcion.
);




--TE IDENTIFICAS

--Metodo: result_eq()
-------------------------------------------------------------------------------------------------------
--Probar conjunto de resultados. Hace la comparacion fila por fila. 
--Los resultados de los dos argumentos deben estar exacatamente en el mismo orden, con los mismos tipos de datos.

--Probar que el conjunto de 'sistemas_activos' es igual al conjunto de los 'sistemas no activos'
SELECT results_eq(
    'select activos.* from  sre_recaudaciones.sre_fac_sistemas activos',
    'select noactivos.* from  sre_recaudaciones.sre_fac_sistemas noactivos',
    'Los sistemas activos debeiran ser igual los que los sistemas noactivos'
);


--Probar que la consulta retorna dos registros con los siguientes datos 
SELECT results_eq(
    'select archivo_csv_id::integer, extesion::varchar, mime::varchar, estado_id::varchar from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)',
    $$VALUES (1::integer,'txt'::varchar,'mime'::varchar,'AC'::varchar), (2::integer,'txt'::varchar,'mime'::varchar,'AC'::varchar)$$,
    'La consultas deberia retornar dos registros con los datos VALUES'
);

select archivo_csv_id::integer from sre_recaudaciones.sre_fac_csv order by 1
select archivo_csv_id::integer from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)
--Probar que el resultado de una columna coincida con el array
SELECT results_eq(
    'select archivo_csv_id::integer from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)',
    ARRAY[1,2]
);

--Comprar cursores
DECLARE cwant CURSOR FOR SELECT * FROM active_users();
DECLARE chave CURSOR FOR SELECT * FROM users WHERE active ORDER BY name;

SELECT results_eq(
    'cwant'::refcursor,
    'chave'::refcursor,
    'Gotta have those active users!'
);


--Comprar una sentencia preparada y cursor 
PREPARE users_test AS SELECT * FROM active_users();
MOVE BACKWARD ALL IN chave;

SELECT results_eq(
    'users_test',
    'chave'::refcursor,
    'Gotta have those active users!'
);


--Metodo: results_ne()
-------------------------------------------------------------------------------------------------------
--Lo inverso de results_eq(), esta funcion prueba que los resultados de la consultas no son equivalentes.
--El orden es importante.



--Metodo: set_eq()
-------------------------------------------------------------------------------------------------------
--Compara dos conjuntos de resultados sin importar el orden y sin importar si hay duplicados.
select archivo_csv_id::integer from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)

SELECT set_eq(
    'select archivo_csv_id::integer from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)',
    ARRAY[2,1,2,2,2,2,2]
);


--Metodo: set_ne()
-------------------------------------------------------------------------------------------------------
--La inversa de set_eq(). Comprueba que los resultado de dos consultas no son los mismos.



--Metodo: set_has()
-------------------------------------------------------------------------------------------------------
--Comprueba que los resultados de una consulta continen al menos los resultados devueltos por otra consulta.
--La segunda consulta puede incluso devolver un cojunto vacio, en cuyo caso la prueba psasra sin importar lo que devuleva la primera consulta.
SELECT set_has(
'select * from sre_recaudaciones.sre_fac_csv', --primera consulta 
'select * from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)', --segunda consulta 
'La primera consultas contine el subconjunto de la segunda consulta'); --mensaje



--Metodo: set_hasnt()
-------------------------------------------------------------------------------------------------------
--Comprueba la invers de set_has().
--La prueba pasa ccuando los resultado de la primera consulta no tienene ningunos de los resulatdo de la segunda consulta
SELECT set_hasnt( 
'select * from sre_recaudaciones.sre_fac_csv',
'select * from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (0)' 
);



--Metodo: bag_eq()
-------------------------------------------------------------------------------------------------------
--Similar a  set_eq(), excepto que considera los resultado como bolsas en lugar de conjuntos.
--Un bolsa es un conjuto que permite duplicados.
--En la pricatica, significa que puede usar para probar conjunto de resultado donde el orden no importa, pero SI la duplicacion.
--Si dos filas son iguales en el primer cojunto de resultado, la misma fila debe apreces dos veces en en el segundo conjunto de resultados.

select archivo_csv_id, extesion, mime, estado_id from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2) union all select archivo_csv_id, extesion, mime, estado_id  from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)

--ok
SELECT bag_eq(
'select archivo_csv_id, extesion, mime, estado_id from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)',
'select archivo_csv_id, extesion, mime, estado_id from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)', 
'Compara dos conjutno sin importar el orden pero SI la duplicacion de registros' );

--Not ok
SELECT bag_eq(
'select archivo_csv_id, extesion, mime, estado_id from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)',
'select archivo_csv_id, extesion, mime, estado_id from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2) union all select archivo_csv_id, extesion, mime, estado_id  from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)', 
'Compara dos conjutno sin importar el orden pero SI la duplicacion de registros' );


--Metodo: bag_ne()
-------------------------------------------------------------------------------------------------------
--A la ivnersa de bag_eq(), esta funcion prueba que los resultados de dos consultas no son los mismos, ciluidos los duplicados.




--Metodo: bag_has()
-------------------------------------------------------------------------------------------------------
--Es como set_has(), excepto que considera los resultados como bolsas en lugar de conjuntos. Una bolsa es un conjunto con duplicados.
--Probar conjunto de resultados donde el orden no importa, per si la duplicacin.
SELECT bag_has(
'select archivo_csv_id, extesion, mime, estado_id from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2) union all select archivo_csv_id, extesion, mime, estado_id  from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)',
'select archivo_csv_id, extesion, mime, estado_id from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)' 
);




--Metodo: bag_hasnt()
-------------------------------------------------------------------------------------------------------
--Inversa de de bag_hasnt().
--La prueba pasa cuando los resultados de la primera consulta no tienen ninguno de los resultado de la segundna consulta.




--Metodo: is_empty()
-------------------------------------------------------------------------------------------------------
--Prueba que la consulta  no devuelva registros
SELECT is_empty('select * from sre_recaudaciones.sre_fac_csv where archivo_csv_id=-1', 'El resultado deberia ser vacio');




--Metodo: isnt_empty()
-------------------------------------------------------------------------------------------------------
--Inversa de is_empty(). La prueba pasa si la consulta especificada, cunado se ejecuta, devuelve al menos una fila.
SELECT isnt_empty('select * from sre_recaudaciones.sre_fac_csv', 'El resultado no deberia ser vacio');





--Metodo: row_eq()
-------------------------------------------------------------------------------------------------------
--Comprar el contenido de una sola fila a un registro.
select extesion, mime, estado_id from sre_recaudaciones.sre_fac_csv where archivo_csv_id=1

SELECT row_eq( 
'select extesion, mime, estado_id from sre_recaudaciones.sre_fac_csv where archivo_csv_id=1', 
ROW('txt'::varchar, 'mime'::varchar, 'AC'::varchar) );

SELECT row_eq( $$SELECT 1::integer, 'foo'::varchar $$, ROW(1::integer, 'foo'::varchar) );

--compara el resultado de una consulta con una fila utilizando tipos de datos.
CREATE TYPE alguntipo AS (
    id    INT,
    name  TEXT
);
SELECT row_eq( $$ SELECT 1, 'foo' $$, ROW(1, 'foo')::alguntipo );

--Compara el resultado de una consulta preparada con una fila utilizando el tipo de datos de la tabla. 
CREATE TABLE usuarios (
    id   INT,
    name TEXT
);

INSERT INTO usuarios VALUES (1, 'theory');
PREPARE get_usuario AS SELECT * FROM usuarios LIMIT 1;

SELECT row_eq('get_usuario', ROW(1, 'theory')::usuarios);



--LAS COSAS DEL ESQUEMA
CREATE TABLE Foo (id integer);

--Metodo: has_table()
-------------------------------------------------------------------------------------------------------
SELECT has_table('foo');


--Metodo: diag()
-------------------------------------------------------------------------------------------------------
--Devuelve un mensaje de diagnostico que garantiza que no interfiere con la salida de prueba.
SELECT diag(
     E'These tests expect LC_COLLATE to be en_US.UTF-8,\n',
     'but yours is set to -----> ', extesion, E'.\n',
     'As a result, some tests may fail. YMMV.'
)
from sre_recaudaciones.sre_fac_csv



--Ejecutar un conjunto de pruebas
create or replace function mis_pruebas_numero_1()
returns setof text 
as
$$
begin
	return next pass('plpgsql simple 1');
end
$$
language plpgsql

create or replace function mis_pruebas_numero_2()
returns setof text 
as
$$
begin
	return next pass('plpgsql simple 1');
end
$$
language plpgsql


select plan(1000);
select * from mis_pruebas();
select * from finish();



--Metodo: do_tap()
-------------------------------------------------------------------------------------------------------
--SELECT do_tap( :schema, :pattern )
--Ejecuta todas las pruebas almacenadas como funcion
select * from do_tap('public','mis_prueb*')



--Metodo: runtests()
-------------------------------------------------------------------------------------------------------
--Similar a do_tap(). Utilizar para que pgTAP ejecute todas sus funciones de prueba y finalice.

select * from no_plan()

 SELECT * FROM runtests('public', '^mis_prueb*' ); 


 --Metodo: check_test()
-------------------------------------------------------------------------------------------------------

 
 
 

--Ejecucion de una prueba unitaria
-------------------------------------------------------------------------------------------------------
begin;
--Plan the test
select plan(9);
--SELECT * FROM no_plan();

SELECT isnt_empty('select * from sre_recaudaciones.sre_fac_csv', 'El resultado no deberia ser vacio');

--Clean up
select * from finish();
rollback;





--Mas ejemplos de pruebas unitarias.
-------------------------------------------------------------------------------------------------------
--Creacion de tablas de ejemplo
create table cats();
create table traits();

--Ejemplos de pruebas unitarias
begin;
select plan(3);
select has_table('cats');
select has_table('traits');
select tables_are('public', array['cats','traits']);
select * from finish();
rollback;

--Ejemplos de pruebas unitarias
begin;
select plan(60);
select has_table('cats');
select has_pk('cats;');
select has_index('cats','cats_');
select has_check('cats');
select has_column('cats','id');
select * from finish();
rollback;

--Ejemplos de pruebas unitarias
begin;
select plan(5);
select has_sequence('public','cats_id_seq', 'Column type serial therefore has a sequence');
select has_function('nicer_age')
select has_trigger('traits','updated');
select has_index('cats', 'cats_pkey');
select has_role('catsitter');
select * from finish();
rollback;

--Ejemplos de pruebas unitarias
begin;
select plan(1)
select columns_are('cats',
ARRAY['id','picture','breed','origin','brithay']);
select * from finish();
rollback;

--Ejemplos de pruebas unitarias - usado para configuracion
begin;
	select plan(1);
	select is(pg_settings.setting, '100')
	from pg_settings
	where name= 'max_connections';
	select * from finish();
rollback;


--Ejemplos de pruebas unitarias - probando columnas
begin;
	select plan(6);
	select has_column('cats','birthay');
	select col_not_null('cats', 'birthday');
	select col_has_default('cats','birthday');
	select col_default_is('cats','birthday','now()');
	select col_type_is('cats','birthday','date')
	select col_has_check('cats','origin')
	select * from finish();
rollback;


--Ejemplos de pruebas unitarias - probando trigguers
begin;
	select plan(4);
	select has_function('my_timestamp');
	select function_lang_is('my_timestamp', 'plpgsql');
	select function_lang_is('my_timestamp', 'trigger');
	select trigger_is('traits','updated','my_timestamp'); 
	select * from finish();
rollback;

--Ejemplos de pruebas unitarias - probando Store procedures
begin;
	select plan(5);
	select has_function('nicer_age');
	
	select matche(nicer_age(cats.brithday),'months')
	from cats where name='Kitty';
	
	select isa_ok(nicer_age('2014-10-09'), 'text', 'Function nicer_age returns text')
	
	select function_returns('nicer_age','text');
			
	select * from finish();
	
rollback;

----Ejemplos de pruebas unitarias - probar que se inserte correctamente
begin;
	select plan(1);
	select lives_ok(
		'INSERT INTO cats(name, breed, origin)
		 VALUES
		($$hISSY$$, $$sIAMESE$$, $$th$$);',
		'inserting a new cat should be ok'
	);
		
	select * from finish();	
rollback;

--Ejemplos de pruebas unitarias - probando que genere una excepcion
begin;
	select plan(1);
	select throws_ok(
		'INSERT INTO cats(name, breed, origin)
		 VALUES
		($$MaoMao$$, $$Ordinary Housecat$$, $$Germany$$);',
		'new row for relation "cats" violates check constraint "cats_or"',
		'inserting origin as count name should violate a check constraint'
	);
		
	select * from finish();	
rollback;


--Ejemplos de pruebas unitarias - probando si realmente obtienes lo que quieres
begin;
	select plan(1);
	prepare basic_select as
		select name, breed, origin
		from cats
		where breed='Burmese';
		
	select results_eq(
		'basic_select',
		$$VALUES('kitty'::text, 'Burmese'::text, 'TH'::text)$$,
		'sholud select all cats of Burmese breed'
	);

	select * from finish();	
rollback;


