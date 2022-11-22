import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/api/authentication_api_services.dart';
import 'package:work_order_manager_ui/ui/pages/routes.dart';

class LoginPageUi extends StatefulWidget {
  static const String routeName = "/loginPage";
  const LoginPageUi({super.key});

  @override
  State<LoginPageUi> createState() => _LoginPageUiState();
}

class _LoginPageUiState extends State<LoginPageUi> {
  late GlobalKey<FormState> _formKey;

  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  bool _isRequestingFromServer = false;

  late TextStyle _textFieldLabelStyle;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
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
                        controller: _userNameController,
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
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            label: Text("Senha", style: _textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(220, 0)),
                          onPressed: (_isRequestingFromServer)
                              ? null
                              : _requestUserLogin,
                          child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Login",
                                  style: TextStyle(fontSize: 20)))),
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
}
