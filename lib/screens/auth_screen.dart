import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  // final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SafeArea(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/logoalone.jpg'),
                  ),
                ),
                AuthCard(),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Signup;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  var _viewPassword = false;
  final _cPasswordNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  //late Animation<Size> _heightAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _opacityAnimation.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void _showSnackbarMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .signin(_authData['email']!, _authData['password']!);

        _showSnackbarMessage("User Logged in");
        // Log user in
      } else {
        print('trying to call signup');
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
        Navigator.of(context).pushNamed(VerifyEmailScreen.routeName,
            arguments: _authData['email']);
      }
    } on HttpException catch (error) {
      _showSnackbarMessage("Authentication failed. ${error.toString()}");
    } catch (error) {
      //print('error ti wa o');
      print(error.toString());
      const errorMessage = 'Could not Authenticate. Please try again later.';
      _showSnackbarMessage(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
      alignment: Alignment.center,
      width: deviceSize.width * 0.9,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _authMode == AuthMode.Signup ? "Sign Up." : "Log In.",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: deviceSize.height * 0.030,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  label: Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Invalid email!';
                }
                return null;
              },
              onSaved: (value) {
                _authData['email'] = value!;
              },
            ),
            SizedBox(
              height: deviceSize.height * 0.025,
            ),
            TextFormField(
              obscureText: _viewPassword ? false : true,
              textInputAction: _authMode == AuthMode.Signup
                  ? TextInputAction.next
                  : TextInputAction.done,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key),
                  suffixIcon: IconButton(
                      onPressed: () => setState(() {
                            _viewPassword = !_viewPassword;
                          }),
                      icon: _viewPassword
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off)),
                  label: Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              controller: _passwordController,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_cPasswordNode),
              validator: (value) {
                if (value!.isEmpty || value.length < 5) {
                  return 'Password must be at least 6 characters!';
                }
              },
              onSaved: (value) {
                _authData['password'] = value!;
              },
            ),
            SizedBox(
              height: deviceSize.height * 0.02,
            ),
            _authMode == AuthMode.Signup
                ? AnimatedContainer(
                    duration: Duration(milliseconds: 10),
                    curve: Curves.linear,
                    constraints: BoxConstraints(
                      //minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                    ),
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () => setState(() {
                                        _viewPassword = !_viewPassword;
                                      }),
                                  icon: _viewPassword
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off)),
                              // prefixIcon: Icon(Icons.key),
                              label: Text(
                                'Confirm Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                          obscureText: _viewPassword ? false : true,
                          focusNode: _cPasswordNode,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: _authMode == AuthMode.Login ? 0 : 6,
            ),
            _authMode == AuthMode.Signup
                ? Container()
                : TextButton(
                    child: Text('Forgot Password?'),
                    onPressed: () => Navigator.of(context).pushNamed(
                        ForgotPasswordScreen.routeName,
                        arguments: _emailController.text),
                    style: TextButton.styleFrom(
                      textStyle:
                          TextStyle(fontSize: 16, color: Color(0xffA18759)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
            TextButton(
                child: Text(
                    '${_authMode == AuthMode.Login ? 'New User? Sign Up' : 'Have an Account? Login.'}'),
                onPressed: _switchAuthMode,
                style: TextButton.styleFrom(
                  textStyle: TextStyle(fontSize: 16, color: Color(0xffA18759)),
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )),
            SizedBox(
              height:
                  _authMode == AuthMode.Login ? deviceSize.height * 0.03 : 6,
            ),
            Align(
              alignment: Alignment.center,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      //onPressed: () => Navigator.of(context).pushNamed('/'),
                      onPressed: _submit,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 50,
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(), padding: EdgeInsets.all(10)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
