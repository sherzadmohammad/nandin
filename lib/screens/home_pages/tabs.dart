import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nanden/providers/user_provider.dart';
import 'package:nanden/screens/constants/loading_data.dart';
import 'package:nanden/screens/home_pages/search_post_screen.dart';
import 'package:nanden/screens/home_pages/profile_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_screen.dart';
import 'saved_post_screen.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}
class _TabsScreenState extends ConsumerState<TabsScreen> {
  final Color _selectedColor = const Color(0xFF1A1A1A);
  final Color _unselectedColor = const Color(0xFF6C6C6C);
  int _currentScreen = 0;
  void _selectScreen(int index) {
    setState(() {
      _currentScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = AllPostsScreen();

    final userAsyncValue = ref.watch(userProvider);

    return userAsyncValue.when(
      data: (user) {
        if (_currentScreen == 0) {
          activeScreen = AllPostsScreen();
          
        } else if(_currentScreen == 1){
          activeScreen = SavedPostsScreen(
            userId: user.id,
          );
        }else if(_currentScreen ==2){
          activeScreen=MealPostsScreen();
        }
        else{
          activeScreen = ProfileSection(user: user);
        }
        return Scaffold(
          
          body: SafeArea(child: activeScreen),
          bottomNavigationBar:SizedBox(height: 80.0,
            child: BottomNavigationBar(
                selectedItemColor: _selectedColor,
                unselectedItemColor: _unselectedColor,
                backgroundColor: Colors.white,
                useLegacyColorScheme: false,
                type:BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500,fontSize: 12.0,),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400,fontSize: 12.0,),
                showSelectedLabels: true,
                showUnselectedLabels: true,
                iconSize: 20.0,
                currentIndex:_currentScreen,
                elevation: 20,
                onTap: _selectScreen,
                items:   [
                  BottomNavigationBarItem(
                    label: AppLocalizations.of(context)!.bottomNavigationItems_home,
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildSvgIcon('assets/icons/bottomSheet_home.svg',_currentScreen==0),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: AppLocalizations.of(context)!.bottomNavigationItems_schedule,
                    icon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildSvgIcon('assets/icons/star.svg', _currentScreen==1)
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: AppLocalizations.of(context)!.bottomNavigationItems_search,
                    icon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildSvgIcon('assets/icons/morning.svg', _currentScreen==2)
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: AppLocalizations.of(context)!.bottomNavigationItems_profile,
                    icon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child:_buildSvgIcon('assets/icons/bottom_profile.svg', _currentScreen==3)
                    ),
                  ),
                ]
            ),
          ),
        );
      },
      loading: () => const LoadingData(),
      error: (err, stack) => Center(
        child: Text(
          'Error: $err',
          style:Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.black),
          )
        ),
    );
  }
  Widget _buildSvgIcon(String assetName, bool isSelected) {
    return SvgPicture.asset(
      assetName,
      colorFilter: ColorFilter.mode(
        isSelected ? _selectedColor : _unselectedColor,
        BlendMode.srcIn,
      ),
      height: 20,
      width: 20,
    );
  }
}
