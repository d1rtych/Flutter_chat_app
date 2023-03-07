import 'package:flutter/material.dart';
import 'package:flutter_learn/services/auth_service.dart';
import 'package:flutter_learn/utils/spaces.dart';
import 'package:flutter_learn/widgets/login_text_field.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final Uri _uri = Uri.parse('https://google.com');

  Future<void> loginUser(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      await context.read<AuthService>().loginUser(userNameController.text);

      Navigator.pushReplacementNamed(context, '/chat',
          arguments: userNameController.text);
    } else {
      print('Not allowed');
    }
  }

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Let\'s sign you in!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Colors.brown,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const Text(
          'Welcome back! \n You\'ve been missed!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.blueGrey,
          ),
        ),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              image: const DecorationImage(
                  fit: BoxFit.fitWidth, image: AssetImage('assets/anime.jpg')),
              borderRadius: BorderRadius.circular(12)),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        verticalSpacing(20),
        GestureDetector(
          onTap: () async {
            print('onTap');
            if (!await launchUrl(_uri)) {
              throw Exception('Could not launch this!');
            }
          },
          child: Column(
            children: [
              const Text('Find us on'),
              Text(_uri.toString()),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SocialMediaButton.twitter(
                size: 30,
                color: Colors.blue,
                url: 'http://twitter.com/elonmusk'),
            SocialMediaButton.linkedin(
                size: 30,
                color: Colors.blue,
                url: 'https://www.linkedin.com/in/elon-musk-57b6a622b'),
          ],
        )
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              LoginTextField(
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 5) {
                    return 'Your username should be more than 5 characters';
                  } else if (value != null && value.isEmpty) {
                    return 'Please type your username';
                  }
                  return null;
                },
                controller: userNameController,
                hintText: 'Username',
              ),
              verticalSpacing(20),
              LoginTextField(
                controller: passwordController,
                hintText: 'Password',
                hasAsterisks: true,
              ),
            ],
          ),
        ),
        verticalSpacing(20),
        ElevatedButton(
            onPressed: () async {
              await loginUser(context);
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 1000) {
              return Row(
                children: [
                  const Spacer(flex: 1),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_buildHeader(context), _buildFooter(context)],
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(child: _buildForm(context)),
                  const Spacer(flex: 1),
                ],
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                _buildForm(context),
                _buildFooter(context),
              ],
            );
          }),
        ),
      ),
    );
  }
}
