import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zybo_cart/bloc/profile_bloc.dart';
import 'package:zybo_cart/bloc/profile_event.dart';
import 'package:zybo_cart/bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _firstName = '';
  String _phoneNumber = '';
  bool _localDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  void _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('first_name') ?? 'John Mathew';
      _phoneNumber = prefs.getString('phone_number') ?? '+91 9476575738';
      _localDataLoaded = true;
    });

    // Only load profile from API after local data is loaded
    if (mounted) {
      context.read<ProfileBloc>().add(LoadProfile());
    }
  }

  String _getDisplayName(ProfileState state) {
    if (state is ProfileLoaded && state.user.firstName.isNotEmpty) {
      return state.user.firstName;
    }
    return _firstName;
  }

  String _getDisplayPhone(ProfileState state) {
    if (state is ProfileLoaded && state.user.phoneNumber.isNotEmpty) {
      return state.user.phoneNumber;
    }
    return _phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            fontSize: screenSize.width * 0.045,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          // Don't render until local data is loaded
          if (!_localDataLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.all(screenSize.width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenSize.height * 0.02),
                // Name Section
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.035,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  _getDisplayName(state),
                  style: TextStyle(
                    fontSize: screenSize.width * 0.045,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),

                // Phone Section
                Text(
                  'Phone',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.035,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  _getDisplayPhone(state),
                  style: TextStyle(
                    fontSize: screenSize.width * 0.045,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Debug information (remove in production)
                if (state is ProfileError) ...[
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    'API Error: ${state.message}',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.03,
                      color: Colors.red,
                    ),
                  ),
                ],

                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
