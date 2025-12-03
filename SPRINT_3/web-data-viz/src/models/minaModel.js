var database = require("../database/config");

function buscarMinaPorEmpresa(id_empresa) {
  var instrucaoSql = `
     SELECT 
          mina.idMina, mina.temperaturaAlerta, MAX(temperatura) AS temperatura_maxima_atual
      FROM
          mina
              JOIN
          sensor ON mina.idMina = sensor.fkMina
              JOIN
          coletaDados ON sensor.idSensor = coletaDados.fkSensor
      WHERE
          DATE(coletaDados.dataHoraColeta) = DATE(NOW())
              AND fkEmpresa = ${id_empresa}
      GROUP BY mina.idMina;
  `;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}


function cadastrar_mina(idEmpresa, longitude, latitude, temperaturaAlerta) {

  var instrucaoSql = `INSERT INTO mina (latitude, longitude, temperaturaAlerta, fkEmpresa) VALUES (${latitude}, ${longitude}, ${temperaturaAlerta}, ${idEmpresa})`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}
function cadastrar_sensores(fkMina) {

  var instrucaoSql = `
    INSERT INTO sensor (fkMina, setor, statusS) VALUES
      (${fkMina}, '1A', 'funcionando'),
      (${fkMina}, '2A', 'funcionando'),
      (${fkMina}, '2A', 'funcionando'),
      (${fkMina}, '3A', 'funcionando'),
      (${fkMina}, '3B', 'funcionando');
  `;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}
function listar_sensores(fkMina) {
  var instrucaoSql = `
    SELECT idSensor FROM sensor JOIN mina ON fkMina = idMina WHERE fkMina = ${fkMina};
  `;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}



function buscar_kpi_qte_alertas_sensor(idSensor, idMina) {
  var instrucaoSql = `
    SELECT * FROM vwKpiTotalAlertasSensorEscolhido WHERE Sensor = ${idSensor} AND idMina = ${idMina};
  `;
  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}
function buscar_kpi_sensor_mais_alertas(idMina) {
  var instrucaoSql = `
    SELECT 
      *
    FROM
      vwKpiSensorMaisAlertas
      WHERE idMina = ${idMina}
      ORDER BY total_alertas DESC
      LIMIT 1; 
    `;
  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}



function buscar_kpi_temperatura_media(idMina) {
  var instrucaoSql = `
    SELECT * FROM vwKpiTemperaturaMedia WHERE idMina = ${idMina};
  `;
  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}


function buscar_kpi_produtividade_media(idMina) {
  var instrucaoSql = `
    SELECT * FROM vwKpiProdutividadeMedia WHERE idMina = ${idMina};
  `;
  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function obterDadosGraficoTemperaturaSensores(idMina) {
  var instrucaoSql = `
    SELECT * FROM vwGraficoTemperaturaSensores WHERE idMina = ${idMina};
  `;
  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}


function obterDadosGraficoAlertasSensores(idMina) {
  var instrucaoSql = `
    SELECT * FROM vwGraficoQteAlertasSensores WHERE idMina = ${idMina};
  `;
  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function obterDadosGraficoProducaoXTemperatura(idSensor) {
  var instrucaoSql = `
    SELECT * FROM vwGraficoProducaoTemperatura WHERE fkSensor = ${idSensor} AND DATE(diaColeta) = DATE(NOW());
  `;
  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function obterDadosGraficoMinMedMax(idSensor) {
  var instrucaoSql = `
    SELECT * FROM vwGraficoMinMedMax WHERE idSensor = ${idSensor};
  `;
  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function grafico_producao_tempo_real(idMina) {
  var instrucaoSql = `
    SELECT * FROM vwGraficoProducaoTemperatura WHERE idMina = ${idMina} AND DATE(diaColeta) = DATE(NOW()) ORDER BY horaColeta DESC LIMIT 1;
  `;
  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}
function grafico_min_med_max(idMina) {
  var instrucaoSql = `
    SELECT * FROM vwGraficoMinMedMax WHERE idMina = ${idMina} AND DATE(diaColeta) = DATE(NOW()) ORDER BY horaColeta DESC LIMIT 1;
  `;
  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

module.exports = {
  buscarMinaPorEmpresa,
  cadastrar_mina,
  cadastrar_sensores,
  listar_sensores,
  buscar_kpi_qte_alertas_sensor,
  buscar_kpi_sensor_mais_alertas,
  buscar_kpi_temperatura_media,
  buscar_kpi_produtividade_media,
  obterDadosGraficoTemperaturaSensores,
  obterDadosGraficoAlertasSensores,
  obterDadosGraficoProducaoXTemperatura,
  obterDadosGraficoMinMedMax,
  grafico_producao_tempo_real,
  grafico_min_med_max

}
