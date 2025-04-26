import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class SingupPage extends StatefulWidget {
  const SingupPage({super.key});

  @override
  State<SingupPage> createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    ),
                    Text("Create a new account and get started"),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? "Email cannot be empty." : null,
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Email"),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: TextFormField(
                    validator: (value) => value!.length < 8
                        ? "Password should have atleast 8 characters."
                        : null,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Password"),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          AuthService()
                              .createAccountWithEmail(_emailController.text,
                                  _passwordController.text)
                              .then((value) {
                            if (value == "Account Created") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Account Created")));
                              Navigator.restorablePushNamedAndRemoveUntil(
                                  context, "/home", (route) => false);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red.shade400,
                              ));
                            }
                          });
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16),
                      ))),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have and account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),*/

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 80),
                // Title Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Create a new account and get started",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Name Field
                _buildTextField(
                  label: "Name",
                  hintText: "Enter your full name",
                  controller: _nameController,
                  validator: (value) =>
                      value!.isEmpty ? "Name cannot be empty." : null,
                  icon: Icons.person,
                  obscureText: false,
                ),
                SizedBox(height: 20),
                // Mobile Field
                _buildTextField(
                  label: "Mobile Number",
                  hintText: "Enter your mobile number",
                  controller: _mobileController,
                  validator: (value) => value!.isEmpty || value.length != 10
                      ? "Enter a valid 10-digit mobile number."
                      : null,
                  icon: Icons.phone,
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                // Email Field
                _buildTextField(
                  label: "Email",
                  hintText: "Enter your email",
                  controller: _emailController,
                  validator: (value) =>
                      value!.isEmpty ? "Email cannot be empty." : null,
                  icon: Icons.email,
                  obscureText: false,
                ),
                SizedBox(height: 20),
                // Password Field
                _buildTextField(
                  label: "Password",
                  hintText: "Enter your password",
                  controller: _passwordController,
                  validator: (value) => value!.length > 8
                      ? "Password should have at least 8 characters."
                      : null,
                  icon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(height: 30),
                // Sign Up Button
                _buildSignUpButton(context),
                SizedBox(height: 20),
                // Login Redirect
                _buildLoginRedirect(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Text Field Widget with Icon
  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required IconData icon,
    required bool obscureText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon:
              Icon(icon, color: Colors.deepPurple.shade700), // Icon color
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12), // Rounded corners for input fields
          ),
          filled: true,
          fillColor: Colors.grey[100], // Light background for input fields
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  // Sign Up Button Widget
  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width * .9,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            AuthService()
                .createAccountWithEmail(
                    _emailController.text, _passwordController.text)
                .then((value) {
              if (value == "Account Created") {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Account Created")));
                Navigator.restorablePushNamedAndRemoveUntil(
                    context, "/home", (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red.shade400,
                  ),
                );
              }
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.shade700,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          "Sign Up",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Login Redirect Widget
  Widget _buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Login",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade700, // Make the Login text blue
            ),
          ),
        ),
      ],

//ghshdcvshfvd
    );
  }
}
