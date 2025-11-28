var empresaModel = require("../models/empresaModel");

function buscarPorCnpj(req, res) {
  var cnpj = req.query.cnpj;

  empresaModel.buscarPorCnpj(cnpj).then((resultado) => {
    res.status(200).json(resultado);
  });
}

function listar(req, res) {
  empresaModel.listar().then((resultado) => {
    res.status(200).json(resultado);
  });
}

function buscarPorId(req, res) {
  var id = req.params.id;

  empresaModel.buscarPorId(id).then((resultado) => {
    res.status(200).json(resultado);
  });
}

function cadastrar(req, res) {
  var nomeFantasia = req.body.nomeFantasiaServer
  var razaoSocial = req.body.razaoSocialServer
  var cnpj = req.body.cnpjServer
  var cep = req.body.cepServer
  var numero = req.body.numeroServer
  var complemento = req.body.complementoServer
  var emailResponsavel = req.body.emailResponsavelServer
  var token = req.body.tokenServer

  empresaModel.buscarPorCnpj(cnpj).then((resultado) => {
    if (resultado.length > 0) {
      res
        .status(401)
        .json({ mensagem: `a empresa com o cnpj ${cnpj} já existe` });
    } else {
      empresaModel.cadastrar(nomeFantasia, razaoSocial, cnpj, cep, numero, complemento, emailResponsavel, token)
      .then((resultado) => {
        res.status(201).json(resultado);
      });
    }
  });
}

function buscarToken(req, res) {
  var token = req.body.tokenServer;

  empresaModel.buscarToken(token)
    .then((resultado) => {
      console.log("Aqui está o results:", resultado);
      res.status(200).json(resultado);
    });
}

module.exports = {
  buscarPorCnpj,
  buscarPorId,
  cadastrar,
  listar,
  buscarToken
};
