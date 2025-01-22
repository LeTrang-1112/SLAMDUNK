import 'package:doanchuyennganh/Views/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:doanchuyennganh/Controller/Usercontroller.dart';
import 'package:doanchuyennganh/Model/LoginUserModel.dart';

class ManHinhDangNhap extends StatefulWidget {
  const ManHinhDangNhap({super.key});

  @override
  _ManHinhDangNhapState createState() => _ManHinhDangNhapState();
}

class _ManHinhDangNhapState extends State<ManHinhDangNhap> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Usercontroller _userController = Usercontroller();
  bool _isLoading = false;
  String? _errorMessage;

  bool _isConfirmPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF5E3023),
          elevation: 0,
          toolbarHeight: 110,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          flexibleSpace: Container(
              padding: const EdgeInsets.only(top: 50),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 10,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '3TL SLAMDUNK',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Welcome to the Basketball store',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email or username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/quenmatkhau');
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E3023),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 80),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'LOG IN',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                    const SizedBox(height: 20),
                    const Text('OR'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            onPressed: () {},
                            icon:
                                const Icon(Icons.facebook, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 20),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.lightBlue,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.email, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/dangKy');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Kiểm tra xem email và mật khẩu có trống không
      if (email.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Vui lòng nhập cả email và mật khẩu';
        });
        return;
      }

      // Kiểm tra định dạng email hợp lệ
      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
          .hasMatch(email)) {
        setState(() {
          _errorMessage = 'Vui lòng nhập email hợp lệ';
        });
        return;
      }

      // Kiểm tra độ dài mật khẩu
      if (password.length < 6) {
        setState(() {
          _errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự';
        });
        return;
      }

      // Thực hiện gọi API đăng nhập
      LoginResponseModel response =
          await _userController.login(email, password);

      // Kiểm tra kết quả đăng nhập
      if (response.message == "Đăng nhập thành công") {
        Navigator.pushReplacementNamed(context, '/trangChu');
      } else if (response.message == "Tài khoản bị khóa") {
        setState(() {
          _errorMessage =
              'Tài khoản của bạn đã bị khóa. Vui lòng liên hệ hỗ trợ.';
        });
      } else {
        setState(() {
          _errorMessage = 'Đăng nhập không thành công. Vui lòng thử lại.';
        });
        print(_errorMessage);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Email hoặc mật khẩu không đúng';
      });
      print(_errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
