use MedicinaDesporto;

DELIMITER $$
CREATE PROCEDURE addClinica(IN cod_clinica VARCHAR(45), IN clinica_nome VARCHAR(45), 
							IN localidade VARCHAR(45), IN id_staff INT, 
                            IN staff_nome VARCHAR(45), IN cargo VARCHAR(45), 
                            IN especialidade VARCHAR(45), IN data_ini_servico DATETIME)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
    END;
    
	START TRANSACTION;
    SET autocommit = 0;
    -- criar Staff
    INSERT INTO Staff(id_staff,nome,cargo,especialidade,data_ini_servico) 
    values (id_staff,staff_nome,cargo,especialidade,data_ini_servico);
    -- criar clinica
    INSERT INTO Clinica(cod_clinica,nome,localidade,id_staff) 
    values (cod_clinica,clinica_nome,localidade,id_staff);
    
    COMMIT;
END $$
DELIMITER ;

call addClinica(400, 'bla', 'nheca', 300, 'blhsags', 'g','meh', '2018-01-01');

select * from Clinica;
select * from Staff;

delete from Clinica where cod_clinica = 400;
delete from Staff where id_staff = 300;

DELIMITER $$
CREATE PROCEDURE addAtleta(IN nif INT, IN cod_postal VARCHAR(45), IN DOB DATETIME,
                           IN nome VARCHAR(45), IN sexo VARCHAR(1), IN peso INT,
                           IN modalidade_designacao VARCHAR(45), IN clube_designacao VARCHAR(45),
                           IN altura DECIMAL(3, 2))
BEGIN

    DECLARE codigo_clube INT;
    DECLARE maximo_clube INT;
    DECLARE quantos_clube INT;
    DECLARE proximo_clube INT;
    DECLARE codigo_modalidade INT;
    DECLARE maximo_modalidade INT;
    DECLARE quantos_modalidade INT;
    DECLARE proximo_modalidade INT;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
	END;

    START TRANSACTION;
    SET autocommit = 0;
    SET codigo_clube = (select cod_clube from Clube where Clube.designacao = clube_designacao);
    SET quantos_clube = (select count(*) from Clube where cod_clube = codigo_clube);
    SET maximo_clube = (select cod_clube from Clube order by cod_clube DESC limit 1);
    SET proximo_clube = maximo_clube + 1;
    SET codigo_modalidade = (select cod_modalidade from Modalidade where Modalidade.designacao = modalidade_designacao);
    SET quantos_modalidade = (select count(*) from Modalidade where cod_modalidade = codigo_modalidade);
    SET maximo_modalidade = (select cod_modalidade from Modalidade order by cod_modalidade DESC limit 1);
    SET proximo_modalidade = maximo_modalidade + 1;

    IF (quantos_modalidade = 0) THEN
        INSERT INTO Modalidade(cod_modalidade, designacao)
        values (proximo_modalidade, modalidade_designacao);
        SET codigo_modalidade = proximo_modalidade;
    END IF;

    IF (quantos_clube = 0) THEN
        INSERT INTO Clube(cod_clube, designacao)
        values (proximo_clube, clube_designacao);
        SET codigo_clube = proximo_clube;
    END IF;

    INSERT INTO Atleta(nif, cod_postal, DOB, nome, sexo, peso, cod_modalidade, cod_clube, altura)
    values (nif, cod_postal, DOB, nome, sexo, peso, codigo_modalidade, codigo_clube, altura);

    COMMIT;
END $$
DELIMITER ;

call addAtleta(0,'n','2000-10-10','d','H',78,'ble','has',1.90);

select * from Atleta;
select * from Clube;
select * from Modalidade;

delete from Atleta where nif=0;
delete from Clube where cod_clube = 10;
delete from Modalidade where cod_modalidade = 10;

/*DELIMITER $$
CREATE PROCEDURE addCompeticao (IN idCompeticao INT, IN designacao_competicao VARCHAR(45), 
								IN cod_modalidade INT, IN nome VARCHAR(45), IN data DATE, 
                                IN local VARCHAR(45), IN hora TIME, IN designacao_modalidade VARCHAR(45))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
    END;
    
	START TRANSACTION;
    SET autocommit = 0;
    
    -- CRIAR MODALIDADE
    INSERT INTO Modalidade (cod_modalidade,designacao)
    VALUES (cod_modalidade,designacao_modalidade);
    
    -- CRIAR COMPETICAO
    INSERT INTO Competicao(id_competicao,designacao,cod_modalidade,nome,data,local,hora)
    VALUES (id_competicao,designacao_competicao,cod_modalidade,nome,data,local,hora);
    
    COMMIT;
    
END $$
DELIMITER ;
    
select * from Modalidade;
select * from Competicao;*/