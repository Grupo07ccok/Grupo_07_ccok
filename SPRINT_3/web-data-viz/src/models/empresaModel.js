var database = require("../database/config");

function buscarPorId(id) {
  var instrucaoSql = `SELECT * FROM empresa WHERE id = '${id}'`;

  return database.executar(instrucaoSql);
}

function listar() {
  var instrucaoSql = `SELECT idEmpresa, razaoSocial, cnpj FROM empresa`;
  return database.executar(instrucaoSql);
}

function buscarPorCnpj(cnpj) {
  var instrucaoSql = `SELECT * FROM empresa WHERE cnpj = '${cnpj}'`;

  return database.executar(instrucaoSql);
}
function buscarToken(token) {
  var instrucaoSql = `SELECT * FROM empresa WHERE token = '${token}'`;

  return database.executar(instrucaoSql);
}

function cadastrar(nomeFantasia, razaoSocial, cnpj, cep, numero, complemento, emailResponsavel, token) {
  var instrucaoSql = `
    INSERT INTO empresa (nomeFantasia, razaoSocial, cnpj, cep, numero, complemento, emailResponsavel, token) VALUES
	  ('${nomeFantasia}', '${razaoSocial}', '${cnpj}', '${cep}', '${numero}', '${complemento}', '${emailResponsavel}', '${token}');
  `;

  return database.executar(instrucaoSql);
}

module.exports = { buscarPorCnpj, buscarPorId, cadastrar, listar, buscarToken };
