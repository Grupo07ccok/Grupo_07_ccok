var database = require("../database/config");

function buscarMinaPorEmpresa(id_empresa) {
  var instrucaoSql = `SELECT * FROM mina  WHERE fkEmpresa = ${id_empresa}`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function cadastrar_mina(idEmpresa, longitude, latitude, temperaturaAlerta) {
  
  var instrucaoSql = `INSERT INTO mina (latitude, longitude, temperaturaAlerta, fkEmpresa) VALUES (${latitude}, ${longitude}, ${temperaturaAlerta}, ${idEmpresa})`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}


module.exports = {
  buscarMinaPorEmpresa,
  cadastrar_mina
}
