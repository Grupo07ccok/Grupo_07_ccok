CREATE DATABASE termotech;

USE termotech;

show tables;

CREATE TABLE empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT, -- ID da Empresa (Autoincrementado)
    nomeFantasia VARCHAR(100), -- Nome fantasia da Empresa
	razaoSocial VARCHAR(100), -- Razão Social da Empresa
    cnpj CHAR(14) UNIQUE NOT NULL, -- CNPJ da Empresa
    cep CHAR(9), -- CEP da Empresa 
    numero VARCHAR(6), -- Número do endereço da Empresa
    complemento VARCHAR(100), -- Complemento
    emailResponsavel VARCHAR(100), -- Email do responsável para envio do token
    token VARCHAR(45)
);

INSERT INTO empresa VALUES
	(DEFAULT, 'Copper Cotia', 'Cobre Cia', '54808068000120', '06725120', '50', null, 'copper_cotia@email.com', '30102025'),
	(DEFAULT, 'Cobre Nosso', 'Mineradoras SA', '88614491000101', '02614100', '170', '10o andar', 'cobre_nosso@email.com', 'sprint2');

CREATE TABLE usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT, -- ID do Usuário (Autoincrementado)
    nome VARCHAR(200),
    telefone CHAR(11) NOT NULL,
    email VARCHAR(255) NOT NULL, -- Email para login do usuário
    senha VARCHAR(255) NOT NULL, -- Senha de acesso do usuário
    fkEmpresa INT, -- Será utilizado para pegar dados de email e senha da tabela empresa para verificar o login
    CONSTRAINT fkEmpresaUsuario
		FOREIGN KEY (fkEmpresa)
			REFERENCES empresa(idEmpresa)
	) AUTO_INCREMENT = 100;
    
INSERT INTO usuario VALUES
	(DEFAULT, 'Julia Lopes', '11987654321', 'julia@gmail.com', 'julia123', 1),
	(DEFAULT, 'Fernando Brandão', '11987654320', 'brandao@gmail.com', '12345678aA@', 1),
	(DEFAULT, 'João Dias', '11987654322', 'joao@gmail.com', 'Joao#2025', 2);
    
    CREATE TABLE mina(
		idMina INT PRIMARY KEY AUTO_INCREMENT,
        fkEmpresa INT,
        latitude DECIMAL(10,6),
        longitude DECIMAL(10,6),
        temperaturaAlerta DECIMAL(3,1),
        CONSTRAINT fkEmpresaMina
			FOREIGN KEY (fkEmpresa)
				REFERENCES empresa(idEmpresa)
) AUTO_INCREMENT = 300;

select * from mina;

INSERT INTO mina VALUES
	(DEFAULT, 1, '-19.810300' , '-42.863221', 25),
	(DEFAULT, 1, '-6.710625', '-52.706971', 27),
	(DEFAULT, 2, '-17.646297', '-43.170836', 26),
	(DEFAULT, 2, '-13.712354', '-50.070253', 23);
       
CREATE TABLE sensor (
	idSensor INT PRIMARY KEY AUTO_INCREMENT, -- ID do Sensor
    fkMina INT,
    setor VARCHAR(45),
    statusS VARCHAR(50), -- Status se está funcionando
	CONSTRAINT fkMinaSensor
			FOREIGN KEY (fkMina)
				REFERENCES mina(idMina),
	CONSTRAINT chkStatus
		CHECK (statusS IN ('funcionando', 'manutenção', 'parado')) 
) AUTO_INCREMENT = 500;

INSERT INTO sensor VALUES 
	(DEFAULT, 300, '1A', 'funcionando'),
	(DEFAULT, 300, '1A', 'funcionando'),
	(DEFAULT, 301, '2A', 'funcionando'),
	(DEFAULT, 301, '2A','funcionando'),
	(DEFAULT, 301, '2B', 'funcionando'),
	(DEFAULT, 302, '5A','funcionando'),
	(DEFAULT, 303, '1B','funcionando');
    
    select * from sensor;
CREATE TABLE coletaDados (
	idColeta INT AUTO_INCREMENT,
    fkSensor INT,
    CONSTRAINT pkSensorDados
		PRIMARY KEY (idColeta, fkSensor),
    CONSTRAINT fkSensorDados
			FOREIGN KEY (fkSensor)
				REFERENCES sensor(idSensor),
    temperatura DECIMAL(3,1),
	dataHoraColeta DATETIME DEFAULT current_timestamp, -- Data e Hora da temperatura (PEGAR DA API COM JAVASCRIPT)
    alerta TINYINT
) AUTO_INCREMENT = 700;


SHOW TABLES;

select * from coletaDados;
select * from sensor;
select * from mina;
select * from empresa;
select * from usuario;

INSERT INTO coletaDados VALUES
(DEFAULT, 500, 28.5, '2025-11-13 20:49', 1),
(DEFAULT, 500, 28, '2025-11-13 20:51', 1),
(DEFAULT, 500, 28.5, '2025-11-13 20:53', 1);

INSERT INTO coletaDados VALUES
(DEFAULT, 501, 28.5, '2025-11-13 20:49', 1),
(DEFAULT, 501, 28, '2025-11-13 20:51', 1),
(DEFAULT, 501, 28.5, '2025-11-13 20:53', 1);


SELECT 	nomeFantasia AS 'Nome da Empresa',
		cnpj AS CNPJ,
        idMina AS Mina,
        idSensor AS Sensor,
        temperatura AS Temperatura,
        dataHoraColeta AS 'Data e hora da coleta',
        alerta AS Alerta
			FROM usuario JOIN empresa 
            ON usuario.fkEmpresa = empresa.idEmpresa
				JOIN mina ON mina.fkEmpresa = idEmpresa
					JOIN sensor ON fkMina = idMina
						JOIN coletaDados ON fkSensor = idSensor;
                        
SELECT nomeFantasia AS 'Nome da Empresa',
		cnpj AS CNPJ,
        idMina AS Mina,
        setor AS 'Setor da mina',
        idSensor AS Sensor,
        temperaturaAlerta AS 'Temperatura para alerta',
        temperatura AS Temperatura,
        dataHoraColeta AS 'Data e hora da coleta',
        alerta AS Alerta
			FROM empresa JOIN mina ON mina.fkEmpresa = idEmpresa
				JOIN sensor ON fkMina = idMina
				JOIN coletaDados ON fkSensor = idSensor;
                
SELECT timediff(DAY,dataHoraColeta,now())
			FROM coletaDados;
            
            
SELECT day(dataHoraColeta)
			FROM coletaDados;


CREATE VIEW vwTotalAlertas AS            
	SELECT fkSensor,
		COUNT(*) AS total_alertas
			FROM coletaDados
				WHERE alerta = 1
					GROUP BY fkSensor
						ORDER BY total_alertas DESC
							LIMIT 2; -- LIMITAR PARA 1 PARA A KPI 'SENSOR COM MAIS ALERTAS'
                            
SELECT * FROM vwTotalAlertas;

SELECT 
    mina.idMina AS idMina,
    ROUND(AVG(coletaDados.temperatura), 1) AS kpiTemperaturaAtual
FROM
    coletaDados
        JOIN
    sensor ON coletadados.fkSensor = sensor.idSensor
        JOIN
    mina ON sensor.fkMina = mina.idMina
GROUP BY idMina;


-- VIEW PARA PEGAR A KPI DE TEMPERATURA MÉDIA ATUAL
CREATE OR REPLACE VIEW vwTemperaturaMedia AS
    SELECT 
        mina.idMina AS idMina,
        concat(ROUND(AVG(coletaDados.temperatura), 1), " Cº") AS kpiTemperaturaAtual
    FROM
        coletaDados
            JOIN
        sensor ON coletadados.fkSensor = sensor.idSensor
            JOIN
        mina ON sensor.fkMina = mina.idMina
    GROUP BY idMina;

-- SELECT PARA FAZER NA API, COLOCAR NO 300 O ID DA MINA QUE VIRÁ DO FRONT-END
SELECT * FROM vwTemperaturaMedia WHERE idMina = 300;

-- VIEW PARA PEGAR A KPI DE PRODUTIVIDADE MÉDIA ATUAL
CREATE OR REPLACE VIEW vwProdutividadeMedia AS
    SELECT 
		mina.idMina AS idMina,
        CONCAT(ROUND(AVG(100 - ((coletaDados.temperatura - 20) * 2.5)), 1), '%') AS kpiProdutividadeAtual
    FROM
        coletaDados
            JOIN
        sensor ON coletadados.fkSensor = sensor.idSensor
            JOIN
        mina ON sensor.fkMina = mina.idMina
        GROUP BY idMina;


-- SELECT PARA FAZER NA API SUBISTITUINDO O 300 PELO ID QUE VIER DO FRONT-END
SELECT * FROM vwProdutividadeMedia WHERE idMina = 300;

CREATE OR REPLACE VIEW vwGraficoQteAlertasSensores AS 
	SELECT 
		mina.idMina,
		sensor.idSensor, 
		COUNT(coletadados.alerta) AS qteAlerta
        FROM
        coletaDados
            JOIN
        sensor ON coletadados.fkSensor = sensor.idSensor
            JOIN
        mina ON sensor.fkMina = mina.idMina
        WHERE alerta = 1
        GROUP BY idSensor;
        
-- SELECT PARA COLOCAR NA API PARA PUXAR AS INFORMAÇÕES PRO GRAFICO DE Quantidade de alertas de todos os sensores
SELECT * FROM vwGraficoQteAlertasSensores WHERE idMina = 300;

CREATE OR REPLACE VIEW vwGraficoMinMedMax AS 
	SELECT
		mina.idMina,
		sensor.idSensor, 
        DAYNAME(dataHoraColeta) AS diaSemana,
		MAX(coletadados.temperatura) AS temperaturaMaxima,
		ROUND(AVG(coletadados.temperatura), 1) AS temperaturaMedia,
		MIN(coletadados.temperatura) AS temperaturaMinima
        FROM
        coletaDados
            JOIN
        sensor ON coletadados.fkSensor = sensor.idSensor
        JOIN
        mina ON sensor.fkMina = mina.idMina
        
        GROUP BY sensor.idSensor, diaSemana;
        
-- SELECT PARA O GRÁFICO DE MÁXIMA, MÍNIMA E MÉDIA, FAZER DESSA FORMA (ACREDITO QUE ESTEJA CERTO)
SELECT 
    *
FROM
    vwGraficoMinMedMax
WHERE
    idMina = 300
ORDER BY diaSemana
LIMIT 7;

-- VIEW PARA PEGAR A KPI DE SENSOR COM MAIS ALERTAS

 
CREATE VIEW vwSensorMaisAlertas AS            
SELECT fkSensor as Sensor,
COUNT(*) AS total_alertas
FROM coletaDados
WHERE alerta = 1
GROUP BY Sensor
ORDER BY total_alertas DESC
LIMIT 1;
   
-- VIEW PARA PEGAR A KPI DE QTD. DE ALERTAS DO SENSOR ESCOLHIDO   
   
CREATE VIEW vwTotalAlertasSensorEscolhido AS            
SELECT fkSensor as Sensor,
COUNT(*) AS total_alertas
FROM coletaDados
WHERE alerta = 1
GROUP BY Sensor;

                        
-- VIEW PARA MOSTRAR O GRÁFICO DA TEMPERATURA ATUAL DE TODOS OS SENSORES   
  
CREATE OR REPLACE VIEW vwTemperaturaAtual AS
SELECT 
    c.fkSensor AS Sensor,
    c.temperatura AS Temperatura,
    c.dataHoraColeta
FROM coletaDados c
JOIN (
    SELECT fkSensor, MAX(dataHoraColeta) AS ultimaColeta
    FROM coletaDados
    GROUP BY fkSensor
) AS ult
    ON c.fkSensor = ult.fkSensor
    AND c.dataHoraColeta = ult.ultimaColeta
ORDER BY Sensor;

        
 -- VIEW PARA MOSTRAR O GRÁFICO DE PRODUÇÃO X TEMPERATURA DO SENSOR ESCOLHIDO
 
CREATE or replace VIEW vwProducaoTemperatura AS
SELECT fkSensor as Sensor,
temperatura AS Temperatura,
(100 - ((temperatura - 20) * 2.5)) AS Producao,
HOUR(dataHoraColeta)
FROM coletaDados;

-- SELECT SENSOR COM MAIS ALERTAS
        
SELECT * FROM vwSensorMaisAlertas;

-- SELECT QTD. DE ALERTAS DO SENSOR ESCOLHIDO

SELECT * FROM vwTotalAlertasSensorEscolhido;
WHERE Sensor = ${fkSensor};

-- SELECT GRÁFICO DA TEMPERATURA ATUAL DE TODOS OS SENSORES

select * from vwTemperaturaAtual;

-- SELECT GRÁFICO DE PRODUÇÃO X TEMPERATURA DO SENSOR ESCOLHIDO

select * from vwProducaoTemperatura
WHERE Sensor =  ${fkSensor};




