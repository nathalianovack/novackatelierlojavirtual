import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/helpers/validators.dart';
import 'package:novackatelierlojavirtual/models/user.dart';
import 'package:novackatelierlojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final User user = User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            //SizedBox(height: 140,),
            Container(
              height: 120.0,
              width: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fill,
                ),
                //  shape: BoxShape.circle,
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white30,
              elevation: 50,
              child: Form(
                key: formKey,
                child: Consumer<UserManager>(
                    builder: (_, userManager, __){
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Nome Completo', prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                            ),hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                            enabled: !userManager.loading,
                            validator: (name){
                              if(name.isEmpty)
                                return 'Campo obrigatório';
                              else if(name.trim().split(' ').length <= 1)
                                return 'Preencha seu Nome completo';
                              return null;
                            },
                            style: TextStyle(color: Colors.white),
                            onSaved: (name) => user.name = name,
                          ),
                          const SizedBox(height: 16,),
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'E-mail', prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                            ),hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                            enabled: !userManager.loading,
                            keyboardType: TextInputType.emailAddress,
                            validator: (email){
                              if(email.isEmpty)
                                return 'Campo obrigatório';
                              else if(!emailValid(email))
                                return 'E-mail inválido';
                              return null;
                            },
                            style: TextStyle(color: Colors.white),
                            onSaved: (email) => user.email = email,
                          ),
                          const SizedBox(height: 16,),
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Senha', prefixIcon: Icon(
                              Icons.vpn_key_outlined,
                              color: Colors.white,
                            ),hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                            enabled: !userManager.loading,
                            obscureText: true,
                            validator: (pass){
                              if(pass.isEmpty)
                                return 'Campo obrigatório';
                              else if(pass.length < 6)
                                return 'Senha muito curta';
                              return null;
                            },
                            style: TextStyle(color: Colors.white),
                            onSaved: (pass) => user.password = pass,
                          ),
                          const SizedBox(height: 16,),
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Repita a Senha', prefixIcon: Icon(
                              Icons.vpn_key_outlined,
                              color: Colors.white,
                            ),hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                            enabled: !userManager.loading,
                            obscureText: true,
                            validator: (pass){
                              if(pass.isEmpty)
                                return 'Campo obrigatório';
                              else if(pass.length < 6)
                                return 'Senha muito curta';
                              return null;
                            },
                            style: TextStyle(color: Colors.white),
                            onSaved: (pass) => user.confirmPassword = pass,
                          ),
                          const SizedBox(height: 16,),

                          SizedBox(
                            height: 44,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              disabledColor: Theme.of(context).primaryColor
                                  .withAlpha(100),
                              textColor: Colors.white,
                              onPressed: userManager.loading ? null : (){
                                if(formKey.currentState.validate()){
                                  formKey.currentState.save();
                                  if(user.password != user.confirmPassword){
                                    scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content: const Text('Senhas não coincidem!'),
                                          backgroundColor: Colors.red,
                                        )
                                    );
                                    return;
                                  }
                                  userManager.signUp(
                                      user: user,
                                      onSuccess: (){
                                        debugPrint('sucesso');
                                        // TODO: POP
                                        Navigator.of(context).pop();
                                      },
                                      onFail: (String e){
                                        scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                              content: Text('Falha ao cadastrar: $e'),
                                              backgroundColor: Colors.red,
                                            )
                                        );
                                      }
                                  );
                                }
                              },
                              child: userManager.loading ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              )
                              : const Text(
                                'Criar Conta',
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}