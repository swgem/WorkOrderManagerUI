import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/api/authentication_api_services.dart';

class RegisterPageUi extends StatefulWidget {
  const RegisterPageUi({super.key});

  @override
  State<RegisterPageUi> createState() => _RegisterPageUiState();
}

class _RegisterPageUiState extends State<RegisterPageUi> {
  late GlobalKey<FormState> _formKey;

  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmationController;
  bool _isRequestingFromServer = false;

  late TextStyle _textFieldLabelStyle;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmationController = TextEditingController();
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
    return AppBar(title: const Text('Cadastrar novo usuário'));
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
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 8.0),
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
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 25.0),
                      child: TextFormField(
                        controller: _passwordConfirmationController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            label: Text("Confirmação de senha",
                                style: _textFieldLabelStyle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: (_isRequestingFromServer)
                                ? null
                                : _requestUserLogin,
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Cadastrar",
                                    style: TextStyle(fontSize: 20)))),
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

  Future _requestUserLogin() async {
    try {
      setState(() => _isRequestingFromServer = true);
      bool success = await AuthenticationApiServices.register(
          _userNameController.text,
          _passwordController.text,
          _passwordConfirmationController.text);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Usuário registrado com sucesso"),
            duration: const Duration(seconds: 5)));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erro ao registrar usuário"),
            duration: const Duration(seconds: 5)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()), duration: const Duration(seconds: 5)));
    }
    setState(() => _isRequestingFromServer = false);
  }
}
