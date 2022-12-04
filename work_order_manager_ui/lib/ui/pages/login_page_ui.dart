import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/api/authentication_api_services.dart';
import 'package:work_order_manager_ui/ui/pages/register_page_ui.dart';
import 'package:work_order_manager_ui/ui/pages/routes.dart';

class LoginPageUi extends StatefulWidget {
  static const String routeName = "/loginPage";
  const LoginPageUi({super.key});

  @override
  State<LoginPageUi> createState() => _LoginPageUiState();
}

class _LoginPageUiState extends State<LoginPageUi> {
  late GlobalKey<FormState> _formKey;

  late FocusNode _userNameFocusNode;

  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  bool _isRequestingFromServer = false;

  late TextStyle _textFieldLabelStyle;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _userNameFocusNode = FocusNode()
      ..addListener(() {
        if (!_userNameFocusNode.hasFocus) {
          _userNameController.text = _userNameController.text.trim();
        }
      });
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _textFieldLabelStyle = Theme.of(context).textTheme.titleMedium!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Login'));
  }

  Widget _buildBody() {
    return Align(
      alignment: Alignment.topCenter,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 260,
                  child: Center(
                    child: Text(
                      "Sevencar Gerenciador",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary),
                    ),
                  )),
              Container(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 8.0),
                      child: TextFormField(
                        focusNode: _userNameFocusNode,
                        controller: _userNameController,
                        validator: (value) => _userNameController.text.isEmpty
                            ? "Insira o usuário"
                            : null,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            label: Text("Usuário", style: _textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 25.0),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) => _passwordController.text.isEmpty
                            ? "Insira a senha"
                            : null,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_isRequestingFromServer)
                            ? null
                            : ((value) => _handleLogin()),
                        decoration: InputDecoration(
                            label: Text("Senha", style: _textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed:
                                (_isRequestingFromServer) ? null : _handleLogin,
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Login",
                                    style: TextStyle(fontSize: 20)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                            onPressed: (_isRequestingFromServer)
                                ? null
                                : _navigateToRegisterPage,
                            child: const Text("Cadastrar novo usuário")),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Visibility(
                          visible: _isRequestingFromServer,
                          child: const CircularProgressIndicator()),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _requestUserLogin();
    }
  }

  Future _requestUserLogin() async {
    try {
      setState(() => _isRequestingFromServer = true);
      bool success = await AuthenticationApiServices.login(
          _userNameController.text, _passwordController.text);

      if (success) {
        Navigator.pushReplacementNamed(context, Routes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erro ao realizar login"),
            duration: const Duration(seconds: 5)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()), duration: const Duration(seconds: 5)));
    }
    setState(() => _isRequestingFromServer = false);
  }

  void _navigateToRegisterPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const RegisterPageUi())));
  }
}
