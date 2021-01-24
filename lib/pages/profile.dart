import 'package:Trip_bangladesh/blocs/notification_bloc.dart';
import 'package:Trip_bangladesh/blocs/sign_in_bloc.dart';
import 'package:Trip_bangladesh/config/config.dart';
import 'package:Trip_bangladesh/pages/edit_profile.dart';
import 'package:Trip_bangladesh/pages/notifications.dart';
import 'package:Trip_bangladesh/pages/sign_in.dart';
import 'package:Trip_bangladesh/utils/next_screen.dart';
import 'package:Trip_bangladesh/widgets/language.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:launch_review/launch_review.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  openAboutDialog() {
    final sb = context.read<SignInBloc>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'About Us',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w900),
                  ).tr(),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'The aim to design and develop the project is to produce a tourist guide for Bangladesh to facilitate domestic and '
                        ' international tourists. As traditional practice when a tourist visits new place '
                        'they have to engage professional tourist guides. The guides provide information about the city. But our tourist guide app can '
                        'show the map of the desired location, calculate distance between two locations and shows basic information of tourist spot using '
                        'android based smart phone',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ).tr(),
                    ),
                  ),
                  Center(
                    child: Text(
                      '\nTeam members'
                      '\nAbu Bakar Siddik, Idrish chwodhury'
                      '\n'
                      '\nSupervised By'
                      '\nSabbir Muhammad Saleh'
                      '\nAssistant Professor'
                      '\nDepartment of Computer Science & Engineering'
                      'City University, Dhaka',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<SignInBloc>();
    return Scaffold(
        appBar: AppBar(
          title: Text('profile').tr(),
          centerTitle: false,
          actions: [
            IconButton(
                icon: Icon(Feather.bell, size: 20),
                onPressed: () => nextScreen(context, NotificationsPage()))
          ],
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
          children: [
            sb.isSignedIn == false ? GuestUserUI() : UserUI(),
            Divider(
              height: 5,
            ),
            ListTile(
              title: Text('get notifications').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.bell, size: 20, color: Colors.white),
              ),
              trailing: Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: context.watch<NotificationBloc>().subscribed,
                  onChanged: (bool) {
                    context.read<NotificationBloc>().fcmSubscribe(bool);
                  }),
            ),
            Divider(
              height: 5,
            ),
            ListTile(
              title: Text('contact us').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.mail, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () async => await launch(
                  'mailto:${Config().supportEmail}?subject=About ${Config().appName} App&body='),
            ),
            Divider(
              height: 5,
            ),
            ListTile(
              title: Text('language').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.globe, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () => nextScreenPopup(context, LanguagePopup()),
            ),
            Divider(
              height: 5,
            ),
            ListTile(
              title: Text('rate this app').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.star, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () async => LaunchReview.launch(
                  androidAppId: sb.packageName, iOSAppId: Config().iOSAppId),
            ),
            Divider(
              height: 5,
            ),
            ListTile(
              title: Text('about us').tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.info, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () {
                openAboutDialog();
              },
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class GuestUserUI extends StatelessWidget {
  const GuestUserUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('login').tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.user, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          onTap: () => nextScreenPopup(
              context,
              SignInPage(
                tag: 'popup',
              )),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class UserUI extends StatelessWidget {
  const UserUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return Column(
      children: [
        Container(
          height: 200,
          child: Column(
            children: [
              CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: CachedNetworkImageProvider(sb.imageUrl)),
              SizedBox(
                height: 10,
              ),
              Text(
                sb.name,
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        ListTile(
          title: Text(sb.email),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.mail, size: 20, color: Colors.white),
          ),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
          title: Text(sb.joiningDate),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(5)),
            child: Icon(LineIcons.dashboard, size: 20, color: Colors.white),
          ),
        ),
        Divider(
          height: 5,
        ),
        ListTile(
            title: Text('edit profile').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(Feather.edit_3, size: 20, color: Colors.white),
            ),
            trailing: Icon(
              Feather.chevron_right,
              size: 20,
            ),
            onTap: () => nextScreen(
                context, EditProfile(name: sb.name, imageUrl: sb.imageUrl))),
        Divider(
          height: 5,
        ),
        ListTile(
          title: Text('logout').tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.log_out, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          onTap: () => openLogoutDialog(context),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  void openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('logout title').tr(),
            actions: [
              FlatButton(
                child: Text('no').tr(),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('yes').tr(),
                onPressed: () async {
                  Navigator.pop(context);
                  await context.read<SignInBloc>().userSignout().then(
                      (value) => nextScreenCloseOthers(context, SignInPage()));
                },
              )
            ],
          );
        });
  }
}
