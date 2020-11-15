
--20190424
create table cats();
create table traits();

begin;
select plan(3);
select has_table('cats');
select has_table('traits');
select tables_are('public', array['cats','traits']);
select * from finish();
rollback;

-- basic test: existence
begin;
select plan(5);
select has_table('cats');
select has_pk('cats;');
select has_index('cats','cats_');
select has_check('cats');
select has_column('cats','id');
select * from finish();
rollback;


begin;
select plan(5);
select has_sequence('public','cats_id_seq', 'Column type serial therefore has a sequence');
select has_function('nicer_age')
select has_trigger('traits','updated');
select has_index('cats', 'cats_pkey');
select has_role('catsitter');
select * from finish();
rollback;


begin;
select plan(1)
select columns_are('cats',
ARRAY['id','picture','breed','origin','brithay']);
select * from finish();
rollback;

--Usado para configuracion
begin;
	select plan(1);
	select is(pg_settings.setting, '100')
	from pg_settings
	where name= 'max_connections';
	select * from finish();
rollback;


--Probando columnas
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


--Probando trigguers
begin;
	select plan(4);
	select has_function('my_timestamp');
	select function_lang_is('my_timestamp', 'plpgsql');
	select function_lang_is('my_timestamp', 'trigger');
	select trigger_is('traits','updated','my_timestamp'); 
	select * from finish();
rollback;

--Probando Store procedures
begin;
	select plan(5);
	select has_function('nicer_age');
	
	select matche(nicer_age(cats.brithday),'months')
	from cats where name='Kitty';
	
	select isa_ok(nicer_age('2014-10-09'), 'text', 'Function nicer_age returns text')
	
	select function_returns('nicer_age','text');
			
	select * from finish();
	
rollback;

--Mostrar consultas
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

--Verificar fallas ok
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

--Probando si realmente obtienes lo que quieres
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



-- Pruebas victor
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



create or replace function sre_recaudaciones.prueba_texto()
	returns varchar
as
$$
declare 
	
begin
	return 'si';
end
$$ language plpgsql;


select sre_recaudaciones.prueba_multiplicacion(5,2)

select sre_recaudaciones.prueba_texto()
--Declarar un plan de pruebas
select plan(42);

--Declara que no hay un plan de pruebas
select * from no_plan();

--calcular el numero de pruebas
select plan(count(*)  from sre_recaudaciones.prueba_multiplicacion(5,2)

select plan(count(*)) from foo;

--finalizar un plan de pruebas
select * from finish()

--Ejecutar pruebas
select * from runtests();

--Todas las funciones de prueba toman un argumento de descripcion.


--ok() --Esto esta bien
--si el resultado de la prueba pasa como NULL en lugar de TRUE o FALSE, ok() supondra un error de prueba
select ok(9*2=18, 'multiplicacion por dos');
select ok(9*3=18, 'multiplicacion por dos');

select ok(archivo_id=103, estado_id||'- conctenado')
from sre_recaudaciones.sre_fac_archivos


--is() isnt() --Esto es eso, esto no eso
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


--20190424
--matches()
--Esto coincide con eso
select plan(1)
select matches('Victor'::text,'^Vic', 'esto coincide con eso');
select imatches('VICtor'::text,'^Vic', 'esto coincide con eso'); --Coincidencia sin distinguir mayuscalas/minusculas


--doesnt_match()/doesnt_imatch()
--Verifican sino coinciden con el patron dado.
select doesnt_match('hola'::text, '^vi', 'esto no coincide con eso')



--alike()
--ialike()
--Esto es asi
--Esto coincide con eso (smiliar a like)
select alike('Hola victor como estas'::text,'%victor%','esto conincide con eso');



--unalike()
--unialike()
--Es no coincide con el patron
SELECT unalike('Hola victor como estas'::text,'%victor%','esto no conincide con el patron');


--cmp_ok()
--Permite comprar dos argumentos usando algun operador binario.
SELECT cmp_ok( 10, '=', 10, 'esto = eso' );
SELECT cmp_ok(null, '=', null, 'null'); --(no ejecuta)


--pass() y fail()
--Ha veces solo se quiere decir que las pruebas han pasado o han fallado
SELECT pass('la prueba ha pasado');
SELECT pass( );
SELECT fail('la prueba ha fallado');
SELECT fail( )



--isa_ok()
--Comprueba si el valor dado es de un tipo particular
SELECT isa_ok(sre_recaudaciones.prueba_multiplicacion(5,2), 'integer', 'El valor de retorno de prueba_multimplicacion es un entero');
SELECT isa_ok(sre_recaudaciones.prueba_texto(), 'integer', 'El valor de retorno de prueba_texto() es un entero');


--PERSIGUIENDO TUS CONSULTAS

--Verifica si la funcion genera una excepcion
SELECT throws_ok('select sre_recaudaciones.prueba_division(10,0)');


--Probando is la declaracion preparada genera una excepcion
PREPARE mythrow AS SELECT sre_recaudaciones.prueba_division(10,0); --Declaracion preparada
SELECT throws_ok('mythrow'); 


--Probando si los resultado de las dos consultas son iguales
prepare "resultado_1" as select * from sre_recaudaciones.sre_fac_csv where archivo_csv_id=1;
prepare "resultado_2" as select * from sre_recaudaciones.sre_fac_csv where archivo_csv_id=$1;

select results_eq(
	'resultado_1',
	'execute resultado_2(1)'
)


--Comparanod los valores de una declaracion preparada
PREPARE misvalores AS VALUES (1, 2), (3, 4);
SELECT set_eq(
    'misvalores',
    'VALUES (1, 2), (3, 4)'
);


--Comparar el resultado de una columna 
--select q.x[1] from (select array(select archivo_csv_id from sre_recaudaciones.sre_fac_csv) as x) as q  
SELECT results_eq(
    'select archivo_csv_id::integer from sre_recaudaciones.sre_fac_csv',
    ARRAY[ 1, 2, 3, 4]
);



--EL ERROR ES HUMANO
--throws_ok()
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

--throws_like()
--Comprueba que un mensaje de error  coincide con un patron like
SELECT throws_like(
    'my_thrower',
    '%violates not-null%',
    'Deberia de insertar un valor unico.'
);




--throws_matching() throws_imatching()
--Prueba que un mensaje de error coincide con una expresion regular
SELECT throws_matching(
    'my_thrower',
    '.+"violates not-null"',
    'Deberia de insertar un valor unico.'
);




--lives_ok()
--Los contrario de throws(). Asegura que una declaracion SQL no arroja una excepcion.

--Prueba que la sentencia insert no genere excepcion
SELECT lives_ok(
    'insert into sre_recaudaciones.sre_fac_csv(archivo_csv_id, archivo, extesion, mime, estado_id) values(102,''xyz'',''txt'',''mime'',''AC'')',
    'No deberia obtener un mensaje de violacion de clave primaria'
);



--perform_ok()
--Asegura que una sentencia sql funcione bien. lo hace sincronizando su ejecucion y fallando si la ejecucion toma mas tiempo que el numero especificado en milisengundos
PREPARE fast_query AS select * from  sre_recaudaciones.sre_fac_csv where archivo_csv_id >1;
SELECT performs_ok(
    'fast_query',
    1,
    'La consulta deberia de ejecutarse en menos de 1 ms'
);



--perform_within()
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

--result_eq()
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



--results_ne()
--Lo inverso de results_eq(), esta funcion prueba que los resultados de la consultas no son equivalentes.
--El orden es importante.



--set_eq()
--Compara doso conjuntos de resultados sin importar el orden y sin importar si hay duplicados.

SELECT set_eq(
    'select archivo_csv_id::integer from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)',
    ARRAY[2,1,2]
);



--set_ne()
--La inversa de set_eq(). Comprueba que los resultado de dos consultas no son los mismos.




--set_has()
--Comprueba que los resultados de una consulta continen al menos los resultados devueltos por otra consulta.
--La segunda consulta puede incluso devolver un cojunto vacio, en cuyo caso la prueba psasra sin importar lo que devuleva la primera consulta.
SELECT set_has(
'select * from sre_recaudaciones.sre_fac_csv', --primera consulta 
'select * from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (1,2)', --segunda consulta 
'La primera consultas contine el subconjunto de la segunda consulta'); --mensaje



--set_hasnt()
--Comprueba la invers de set_has().
--La prueba pasa ccuando los resultado de la primera consulta no tienene ningunos de los resulatdo de la segunda consulta
SELECT set_hasnt( 
'select * from sre_recaudaciones.sre_fac_csv',
'select * from sre_recaudaciones.sre_fac_csv where archivo_csv_id in (0)' 
);



--bag_eq()
--Similar a  set_eq(), excepto que considera los resultado coo bolsas en lugar de conjuntos.
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



--bag_ne()
--A la ivnersa de bag_eq(), esta funcion prueba que los resultados de dos consultas no son los mismos, ciluidos los duplicados.



--bag_has()
SELECT bag_has( :sql, :sql, :description );
SELECT bag_has( :sql, :sql );

--bag_hasnt()
SELECT bag_hasnt( :sql, :sql, :description );
SELECT bag_hasnt( :sql, :sql );

--is_empty()
SELECT is_empty( :sql, :description );
SELECT is_empty( :sql );
--isnt_empty()
SELECT isnt_empty( :sql, :description );
SELECT isnt_empty( :sql );
--row_eq()
SELECT row_eq( :sql, :record, :description );
SELECT row_eq( :sql, :record );

SELECT row_eq( $$ SELECT 1, 'foo' $$, ROW(1, 'foo') );

--
CREATE TYPE sometype AS (
    id    INT,
    name  TEXT
);

SELECT row_eq( $$ SELECT 1, 'foo' $$, ROW(1, 'foo')::sometype );
--
CREATE TABLE users (
    id   INT,
    name TEXT
);

INSERT INTO users VALUES (1, 'theory');
PREPARE get_user AS SELECT * FROM users LIMIT 1;

SELECT row_eq( 'get_user', ROW(1, 'theory')::users );

--
SELECT row_eq(
    $$ SELECT id, name FROM users $$,
    ROW(1, 'theory')::sometype
);

--LAS COSAS DEL ESQUEMA