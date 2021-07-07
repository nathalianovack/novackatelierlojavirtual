import 'package:novackatelierlojavirtual/helpers/validators.dart';
import 'package:novackatelierlojavirtual/models/user.dart';
import 'package:novackatelierlojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
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
                  builder: (_, userManager, child){
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      children: <Widget>[
                        TextFormField(
                          controller: emailController,
                          enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'E-mail', prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.brown
                                  )
                              )
                          ),
                      cursorColor: Colors.brown,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: (email){
                            if(!emailValid(email))
                              return 'E-mail inválido';
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          controller: passController,
                          enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'Senha', prefixIcon: Icon(
                            Icons.vpn_key_outlined,
                            color: Colors.white,
                          ),hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.brown
                                  )
                              )
                          ),
                          cursorColor: Colors.brown,
                          autocorrect: false,
                          obscureText: true,
                          validator: (pass){
                            if(pass.isEmpty || pass.length < 6)
                              return 'Senha inválida';
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                        ),
                        child,
                        const SizedBox(height: 16,),
                        SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: userManager.loading ? null : (){
                              if(formKey.currentState.validate()){
                                userManager.signIn(
                                    user: User(
                                        email: emailController.text,
                                        password: passController.text
                                    ),
                                    onFail: (String e){
                                      scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text('Falha ao entrar: $e'),
                                            backgroundColor: Colors.red,
                                            duration: const Duration(seconds: 30),
                                          )
                                      );
                                    },
                                    onSuccess: (){
                                      Navigator.of(context).pop();
                                    }
                                );
                              }
                            },
                            color: primaryColor,
                            disabledColor: primaryColor.withAlpha(100),
                            textColor: Colors.white,
                            child: userManager.loading ?
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ) :
                            const Text(
                              'Entrar',
                              style: TextStyle(
                                  fontSize: 18,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20,),
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Text('   Ainda não possui uma conta ?  ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              ),),
                            ),
                            RaisedButton(
                              onPressed: (){
                                Navigator.of(context).pushReplacementNamed('/signup');
                              },
                              color: primaryColor,
                              textColor: Colors.white,
                              child: const Text(
                                'CADASTRE-SE',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300,)
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: (){
                      },
                      padding: EdgeInsets.zero,
                      child: const Text(
                          'Esqueci minha senha',
                        style: TextStyle(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}