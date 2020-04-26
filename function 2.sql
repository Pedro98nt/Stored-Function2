-- (1) Crie uma stored function, que liste todos os campos da tabela “produtos”, mostrando todos os seus campos na listagem.
CREATE OR REPLACE FUNCTION listar_produtos()
RETURNS text AS
$$
DECLARE
	lista RECORD;
	retorno TEXT DEFAULT '';
BEGIN
	FOR lista IN
		SELECT id, descricao, valor, unidade FROM produtos
		LOOP
		
		retorno = retorno || ' ' || lista.id || ' - ' || lista.descricao || ' - ' || lista.valor || ' - ' || lista.unidade;
		
	END LOOP;
	return retorno;
END;
$$
	LANGUAGE plpgsql VOLATILE
	COST 100;
ALTER FUNCTION listar_produtos()
	OWNER TO postgres;
	
-- (2) Crie uma stored function, que liste todos os campos da tabela “municipios”, mostrando todos os seus campos na listagem
CREATE OR REPLACE FUNCTION listar_municipios()
RETURNS text AS
$$
DECLARE
	lista RECORD;
	retorno TEXT DEFAULT '';
BEGIN
	FOR lista IN
		SELECT id, nome, codg_ibge FROM municipios
		LOOP
		
		retorno = retorno || ' ' || lista.id || ' - ' || lista.nome || ' - ' || lista.codg_ibge;
		
	END LOOP;
	return retorno;
END;
$$
	LANGUAGE plpgsql VOLATILE
	COST 100;
ALTER FUNCTION listar_municipios()
	OWNER TO postgres;
	
	
-- (3) Crie uma stored function, que liste todos os campos da tabela “alunos”, porém, o campo “nota_media_final”, 
--      será calculado no instante em que os dados forem mostrados e atualizado na tabela em questão. Durante a 
--      listagem das notas, se a média for < 7, então ecrever “fazer N3” e a nota mínima que o aluno necessita tirar, 
--      senão escrever “Aprovado!!”
CREATE OR REPLACE FUNCTION calcular_media()
RETURNS text AS
$$
DECLARE
	lista RECORD;
	retorno TEXT DEFAULT '';
	media NUMERIC(5,2);
	nota_restante_n3 NUMERIC(5,2);
	resultado TEXT DEFAULT '';
BEGIN

	FOR lista IN
		SELECT id, nome, nota_n1, nota_n2 FROM aluno
		LOOP
		
		media = ( (lista.nota_n1 * 0.4) + (lista.nota_n2 * 0.6) );
		
		UPDATE aluno SET nota_media_final = media WHERE id = lista.id;
		
		IF (media < 7) THEN
			resultado = 'Fazer N3';
			nota_restante_n3 = 10 - media;
		ELSE
			resultado = 'Aprovado';
			nota_restante_n3 = 0;
		END IF;
		
		retorno = retorno || ' ' || lista.id || ' - ' || lista.nome || ' - ' || lista.nota_n1 || ' - ' || lista.nota_n2 || ' - ' || media || ' - ' || resultado;

		IF (nota_restante_n3 > 0) THEN
			retorno = retorno || ' Nota Restante N3: ' || nota_restante_n3;
		END IF;

		
	END LOOP;
	return retorno;
END;
$$
	LANGUAGE plpgsql VOLATILE
	COST 100;
ALTER FUNCTION calcular_media()
	OWNER TO postgres;	


-- (4) Crie uma stored function, que liste todos os campos da tabela “produtos”, somente para os produtos com valor > 100
CREATE OR REPLACE FUNCTION listar_produtos_valor()
RETURNS text AS
$$
DECLARE
	lista RECORD;
	retorno TEXT DEFAULT '';
BEGIN
	FOR lista IN
		SELECT id, descricao, valor, unidade FROM produtos
		LOOP
		
		IF(lista.valor > 100) THEN
			retorno = retorno || ' ' || lista.id || ' - ' || lista.descricao || ' - ' || lista.valor || ' - ' || lista.unidade;
		END IF;
		
	END LOOP;
	return retorno;
END;
$$
	LANGUAGE plpgsql VOLATILE
	COST 100;
ALTER FUNCTION listar_produtos_valor2()
	OWNER TO postgres;
	

-- (5) Crie uma stored function, que liste todos os campos da tabela “aluno”, mas que traga somente os alunos com média >= 7
CREATE OR REPLACE FUNCTION listar_aluno_media7()
RETURNS text AS
$$
DECLARE
	lista RECORD;
	retorno TEXT DEFAULT '';
BEGIN

	FOR lista IN
		SELECT id, nome, nota_n1, nota_n2, nota_media_final FROM aluno
		LOOP
		
		IF (lista.nota_media_final >= 7) THEN
			retorno = retorno || ' ' || lista.id || ' - ' || lista.nome || ' - ' || lista.nota_n1 || ' - ' || lista.nota_n2 || ' - ' || lista.nota_media_final;
		END IF;
		
	END LOOP;
	return retorno;
END;
$$
	LANGUAGE plpgsql VOLATILE
	COST 100;
ALTER FUNCTION listar_aluno_media7()
	OWNER TO postgres;

-- (6) idem (5)

