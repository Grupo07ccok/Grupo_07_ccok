-- GRAFICO MIN MED E MAX
CREATE OR REPLACE VIEW vwGraficoMinMedMax AS
    SELECT 
        m.idMina AS idMina,
        s.idSensor AS idSensor,
        DATE(cd.dataHoraColeta) AS diaColeta,
        HOUR(cd.dataHoraColeta) AS horaColeta,
        (FLOOR((MINUTE(cd.dataHoraColeta) / 10)) * 10) AS minutoBloco,
        MAX(cd.temperatura) AS temperaturaMaxima,
        ROUND(AVG(cd.temperatura), 1) AS temperaturaMedia,
        MIN(cd.temperatura) AS temperaturaMinima
    FROM
        ((coletaDados cd
        JOIN sensor s ON ((cd.fkSensor = s.idSensor)))
        JOIN mina m ON ((s.fkMina = m.idMina)))
    GROUP BY m.idMina , s.idSensor , DATE(cd.dataHoraColeta) , HOUR(cd.dataHoraColeta) , (FLOOR((MINUTE(cd.dataHoraColeta) / 10)) * 10);

-- GRAFICO DE PRODUÇÃO X TEMPERATURA
CREATE OR REPLACE VIEW vwGraficoProducaoTemperatura AS
    SELECT 
        mina.idMina AS idMina,
        coletaDados.fkSensor AS fkSensor,
        coletaDados.temperatura AS temperatura,
        (100 - ((coletaDados.temperatura - 20) * 2.5)) AS producao,
        TIME(coletaDados.dataHoraColeta) AS horaColeta,
        DATE(coletaDados.dataHoraColeta) AS diaColeta
    FROM
        ((coletaDados
        JOIN sensor ON ((coletaDados.fkSensor = sensor.idSensor)))
        JOIN mina ON ((mina.idMina = sensor.fkMina)));

-- GRAFICO QUANTIDADE DE ALERTAS X SENSOR
CREATE OR REPLACE VIEW vwGraficoQteAlertasSensores AS
    SELECT 
        mina.idMina AS idMina,
        sensor.idSensor AS idSensor,
        COUNT(coletaDados.alerta) AS qteAlerta
    FROM
        ((coletaDados
        JOIN sensor ON ((coletaDados.fkSensor = sensor.idSensor)))
        JOIN mina ON ((sensor.fkMina = mina.idMina)))
    WHERE
        (coletaDados.alerta = 1)
    GROUP BY sensor.idSensor;

-- GRAFICO TEMPERATURA X SENSOR
CREATE OR REPLACE VIEW vwGraficoTemperaturaSensores AS
    SELECT 
        mina.idMina AS idMina,
        sensor.idSensor AS idSensor,
        coletaDados.temperatura AS temperatura,
        mina.temperaturaAlerta AS temperaturaAlerta
    FROM
        (((coletaDados
        JOIN (SELECT 
            coletaDados.fkSensor AS fkSensor,
                MAX(coletaDados.dataHoraColeta) AS ultimaColeta
        FROM
            coletaDados
        GROUP BY coletaDados.fkSensor) ult ON (((coletaDados.fkSensor = ult.fkSensor)
            AND (coletaDados.dataHoraColeta = ult.ultimaColeta))))
        JOIN sensor ON ((sensor.idSensor = coletaDados.fkSensor)))
        JOIN mina ON ((sensor.fkMina = mina.idMina)));

-- KPI SENSOR COM MAIS ALERTAS
CREATE OR REPLACE VIEW vwKpiSensorMaisAlertas AS
    SELECT 
        coletaDados.fkSensor AS fkSensor,
        mina.idMina AS idMina,
        COUNT(*) AS total_alertas
    FROM
        ((coletaDados
        JOIN sensor ON ((coletaDados.fkSensor = sensor.idSensor)))
        JOIN mina ON ((sensor.fkMina = mina.idMina)))
    WHERE
        (coletaDados.alerta = 1)
    GROUP BY coletaDados.fkSensor , mina.idMina;

-- KPI TOTAL DE ALERTAS DO SENSOR ESCOLHIDO NO SELECT 
CREATE OR REPLACE VIEW vwKpiTotalAlertasSensorEscolhido AS
    SELECT 
        coletaDados.fkSensor AS Sensor,
        COUNT(*) AS total_alertas,
        mina.idMina AS idMina
    FROM
        ((coletaDados
        JOIN sensor ON ((coletaDados.fkSensor = sensor.idSensor)))
        JOIN mina ON ((sensor.fkMina = mina.idMina)))
    WHERE
        (coletaDados.alerta = 1)
    GROUP BY Sensor , mina.idMina;

-- KPI TEMPERATURA MEDIA
CREATE OR REPLACE VIEW vwKpiTemperaturaMedia AS
    SELECT 
        mina.idMina AS idMina,
        CONCAT(ROUND(AVG(coletaDados.temperatura),
                        1),
                ' Cº') AS kpiTemperaturaAtual
    FROM
        (((coletaDados
        JOIN (SELECT 
            coletaDados.fkSensor AS fkSensor,
                MAX(coletaDados.dataHoraColeta) AS ultimaColeta
        FROM
            coletaDados
        GROUP BY coletaDados.fkSensor) ult ON (((coletaDados.fkSensor = ult.fkSensor)
            AND (coletaDados.dataHoraColeta = ult.ultimaColeta))))
        JOIN sensor ON ((coletaDados.fkSensor = sensor.idSensor)))
        JOIN mina ON ((sensor.fkMina = mina.idMina)))
    GROUP BY mina.idMina;

-- KPI PRODUTIVIDADE MEDIA
CREATE OR REPLACE VIEW vwKpiProdutividadeMedia AS
    SELECT 
        mina.idMina AS idMina,
        CONCAT(ROUND(AVG((100 - ((coletaDados.temperatura - 20) * 2.5))),
                        1),
                '%') AS kpiProdutividadeAtual
    FROM
        (((coletaDados
        JOIN (SELECT 
            coletaDados.fkSensor AS fkSensor,
                MAX(coletaDados.dataHoraColeta) AS ultimaColeta
        FROM
            coletaDados
        GROUP BY coletaDados.fkSensor) ult ON (((coletaDados.fkSensor = ult.fkSensor)
            AND (coletaDados.dataHoraColeta = ult.ultimaColeta))))
        JOIN sensor ON ((coletaDados.fkSensor = sensor.idSensor)))
        JOIN mina ON ((sensor.fkMina = mina.idMina)))
    GROUP BY mina.idMina;
