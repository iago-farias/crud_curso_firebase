import 'package:flutter/material.dart';

import '../component/buildDropDown.dart';
import '../component/buildTextField.dart';
import '../controller/CursoController.dart';
import '../model/Curso.dart';
import './listaCurso.dart';

class CadastroCurso extends StatefulWidget {
  final Curso curso;
  CadastroCurso({this.curso});
  @override
  _CadastroCursoState createState() => _CadastroCursoState();
}

class _CadastroCursoState extends State<CadastroCurso> {
  CursoController _cursoController = CursoController();
  String _id;
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cargaHorariaController = TextEditingController();
  TextEditingController _modalidadeController = TextEditingController();
  var _modalidade = ["PRESENCIAL", "SEMI_PRESENCIAL", "EAD"];
  var _modalidadeSelecionada = "PRESENCIAL";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _alterarModalidade(String novaModalidadeSelecionada) {
    _dropDownModalidadeSelected(novaModalidadeSelecionada);
    setState(() {
      this._modalidadeSelecionada = novaModalidadeSelecionada;
      _modalidadeController.text = this._modalidadeSelecionada;
    });
  }

  _dropDownModalidadeSelected(String novaModalidade) {
    setState(() {
      this._modalidadeSelecionada = novaModalidade;
    });
  }

  _displaySnackBar(BuildContext context, String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
      backgroundColor: Colors.green[900],
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _salvar(BuildContext context) {
    Curso curso = Curso(_nomeController.text,
        int.parse(_cargaHorariaController.text), _modalidadeSelecionada,
        id: _id);
    setState(() {
      _cursoController.salvar(curso).then((res) {
        setState(() {
          _displaySnackBar(context, res.toString());
        });
      });
    });
  }

  @override
  void initState() {
    if (widget.curso != null) {
      _id = widget.curso.id;
      _nomeController.text = widget.curso.nome;
      _cargaHorariaController.text = widget.curso.cargaHoraria.toString();
      _modalidadeSelecionada = widget.curso.modalidade;
    } else {
      _id = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastro de curso"),
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListaCurso()),
              );
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildTextField("Nome", _nomeController, TextInputType.text),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildTextField("Carga horária", _cargaHorariaController,
                  TextInputType.number),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Modalidade:",
                    style: TextStyle(color: Colors.orange[800]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: buildDropDownButton(_modalidade, _alterarModalidade,
                        _modalidadeSelecionada),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: RaisedButton.icon(
                  onPressed: () {
                    _salvar(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  label: Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.green,
                  color: Colors.orange[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
