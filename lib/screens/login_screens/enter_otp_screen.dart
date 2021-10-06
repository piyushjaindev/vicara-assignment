part of 'login_screen.dart';

class EnterOTPScreen extends StatefulWidget {
  EnterOTPScreen({Key? key}) : super(key: key);

  @override
  _EnterOTPScreenState createState() => _EnterOTPScreenState();
}

class _EnterOTPScreenState extends State<EnterOTPScreen> {
  final _formKey = GlobalKey<FormState>();

  late String otp;

  void submitOTP() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      context.read<LoginCubit>().verifyOTP(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF3441D3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'OTP',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_sharp,
                color: kWhiteColor,
                size: 270,
              ),
              SizedBox(height: 50),
              TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().length != 6)
                    return 'Please enter 6 digit OTP';
                  if (int.tryParse(value.trim()) == null)
                    return 'OTP is invalid';
                  return null;
                },
                onSaved: (value) {
                  otp = value!.trim();
                },
                decoration: InputDecoration(
                  fillColor: kWhiteColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter OTP',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: submitOTP,
                child: Text('Verify'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF7188E1),
                  onPrimary: kWhiteColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
