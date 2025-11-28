var express = require("express");
var router = express.Router();

var minasController = require("../controllers/minaController");

router.get("/listar_minas/:empresaId", function (req, res) {
  minasController.buscarMinaPorEmpresa(req, res);
});

router.post("/cadastrar", function (req, res) {
  minasController.cadastrar_mina(req, res);
})

module.exports = router;