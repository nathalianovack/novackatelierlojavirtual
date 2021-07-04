import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:novackatelierlojavirtual/models/section.dart';

class HomeManager extends ChangeNotifier{

  HomeManager(){
    _loadSections();
  }

  //declarando a lista como vazia
  final List<Section> _sections = [];

  //lista para duplicar e editar os itens da tela inicial
  List<Section> _editingSections = [];

  //variavel que indica se esta no modo de edição ou não
  bool editing = false;
  bool loading = false;

  final Firestore firestore = Firestore.instance;

  //buscar todas as seções do firebase
  Future<void> _loadSections() async{
    firestore.collection('home').orderBy('pos').snapshots().listen((snapshot) {
      //limpar a seção antes de adicionar a lista
      _sections.clear();
      //depois de limpar as seções ele carrega todas as seções novamente
      for(final DocumentSnapshot document in snapshot.documents){
        //adicionando o documento na seção
        _sections.add(Section.fromDocument(document));
      }
        notifyListeners();
    });

  }

  void addSection(Section section){
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section){
    _editingSections.remove(section);
    notifyListeners();
  }

  List<Section> get sections {
    if(editing)
      return _editingSections;
    else
      return _sections;
  }


  void enterEditing(){
    editing = true;

    //copiando os itens para aparecer na tela de edição da página inicial.
    _editingSections = _sections.map((s) => s.clone()).toList();

    notifyListeners();
  }

  Future<void> saveEditing() async{
    bool valid = true;
    for(final section in _editingSections){
      if(!section.valid()) valid = false;
    }
    if(!valid) return;

    loading = true;
    notifyListeners();

    int pos = 0;

    for (final section in _editingSections) {
      await section.save(pos);
      pos++;
    }
    
    for(final section in List<dynamic>.from(_sections)){
      if(!_editingSections.any((element) => element.id == section.id)){
        await section.delete();
      }
    }
    
    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing(){
    editing = false;
    notifyListeners();
  }
}