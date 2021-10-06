part of 'login_screen.dart';

class EnterPhoneScreen extends StatefulWidget {
  EnterPhoneScreen({Key? key}) : super(key: key);

  @override
  _EnterPhoneScreenState createState() => _EnterPhoneScreenState();
}

class _EnterPhoneScreenState extends State<EnterPhoneScreen> {
  final _formKey = GlobalKey<FormState>();

  late String phone;

  void sendOTP() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      context.read<LoginCubit>().sendOTP(phone);
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
          'Login',
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
                Icons.account_box_sharp,
                color: kWhiteColor,
                size: 270,
              ),
              SizedBox(height: 50),
              TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().length != 10)
                    return 'Please enter 10 digit phone number';
                  if (int.tryParse(value.trim()) == null)
                    return 'Phone number is invalid';
                  return null;
                },
                onSaved: (value) {
                  phone = value!.trim();
                },
                decoration: InputDecoration(
                  fillColor: kWhiteColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Your Phone Number',
                  prefixText: '+91 ',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: sendOTP,
                child: Text('Send OTP'),
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
