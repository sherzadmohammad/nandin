import 'package:flutter/material.dart';
import 'package:nanden/widgets/profile_tiles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/user_data.dart';
import '../../widgets/dialogs/logout_dialog.dart';
class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key, required this.user});
  final UserData user;
  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  static const Divider divider = Divider(color: Color(0xFFCFD6DD),thickness: 0.5,);
  static const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 11.0,vertical: 6.0) ;
  static  BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: const Color(0xFFFFFFFF),
      boxShadow: const [
        BoxShadow(
            blurRadius: 2,
            color: Color(0xff0a0c400f)
        )
      ]
  );
  bool hasNotification=false;
  void _changeNotification(){
    setState(() {
      hasNotification=!hasNotification;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior:const ScrollBehavior(
            
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 15.18, 15.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                        radius: 35.0,
                      ),
                      const SizedBox(width: 8.0,),
                        Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                         AppLocalizations.of(context)!.profile_hello,
                            style: const TextStyle(
                                fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF333333)
                            ),
                          ),
                          Text(
                            widget.user.name,
                            style: const TextStyle(
                                fontSize: 20.0,fontWeight: FontWeight.w600,color: Color(0xFF333333)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 36,),
                  Container(
                    padding: padding,
                    decoration: decoration,
                    child:   Column(
                      children: [
                        CustomProfileTiles(icon: Icons.person_outline_outlined, title: AppLocalizations.of(context)!.profile_profile,
                          onTap: (){},
                        ),
                        divider,
                        CustomProfileTiles(icon: Icons.password_outlined, title: AppLocalizations.of(context)!.profile_changePassword,
                            onTap: (){}
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0,),
                   Text(AppLocalizations.of(context)!.profile_courses_record,
                    style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xFF6C6C6C)),
                  ),
                  const SizedBox(height: 12.0,),
                  Container(
                    padding: padding,
                    decoration: decoration,
                    child: CustomProfileTiles(icon: Icons.bookmark_outline_outlined, title: AppLocalizations.of(context)!.profile_courses,
                      onTap: (){},
                    ),
                  ),
                  const SizedBox(height: 24.0,),
                  Container(
                    padding:padding,
                    decoration: decoration,
                    child:  Column(
                      children: [
                        CustomProfileTiles(
                          icon: Icons.translate_outlined,
                          title: AppLocalizations.of(context)!.profile_language,
                          onTap: (){},),
                        divider,
                        CustomProfileTiles(
                          icon: Icons.star_border_outlined,
                          title: AppLocalizations.of(context)!.profile_rating,
                          onTap: (){}),
                        divider,
                        CustomProfileTiles(
                          icon: Icons.info_outline_rounded,
                          title: AppLocalizations.of(context)!.profile_about,
                          onTap: (){})
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0,),
                  Container(
                    padding: padding,
                    decoration: decoration,
                    child: CustomProfileTiles(
                      icon: Icons.notifications_none_outlined,
                      title: AppLocalizations.of(context)!.profile_notifications,
                      isToggle: hasNotification, onTap:_changeNotification
                    ),
                  ),
                  const SizedBox(height: 8.0,),
                   Text(AppLocalizations.of(context)!.profile_notifications_off_text,
                  style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF6C6C6C)),
                  ),
                  const SizedBox(height: 24.0,),
                  Container(
                      padding: padding,
                      decoration: decoration,
                      child: CustomProfileTiles(
                        icon: Icons.logout_outlined,
                        title: AppLocalizations.of(context)!.logout_title_dialog,
                        onTap: (){
                        showDialog(context: context, builder: (context)=>const LogoutDialog(),);
                      }
                      ),
                  ),
                  const SizedBox(height: 12.0,),
                   Align(alignment: Alignment.center,
                    child: Text(AppLocalizations.of(context)!.profile_app_version,style: const TextStyle(fontSize: 10,fontWeight:
                    FontWeight.w400,color:Color(0xFF6C6C6C)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
