import 'package:Trip_bangladesh/pages/bookmark.dart';
import 'package:Trip_bangladesh/pages/home.dart';
import 'package:Trip_bangladesh/pages/profile.dart';
import 'package:Trip_bangladesh/pages/sign_in.dart';
import 'package:Trip_bangladesh/pages/states.dart';
import 'package:Trip_bangladesh/weather/map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Trip Bangladesh',
                style: GoogleFonts.lato(fontSize: 30),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1591152073494-0b166075650a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1480&q=80'),
                  fit: BoxFit.cover),
              color: Colors.teal.shade600,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.black12,
            ),
            title: Text(
              'Home',
              style: GoogleFonts.lato(fontSize: 20),
            ), //Home menu
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.location_city,
              color: Colors.black12,
            ),
            title: Text(
              'Divisions',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StatesPage()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.location_on,
              color: Colors.black12,
            ),
            title: Text(
              'Map ',
              style: GoogleFonts.lato(fontSize: 20),
            ), //Division wise Places
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewGoogleMaps()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.bookmarks_rounded,
              color: Colors.black12,
            ),
            title: Text(
              'Bookmark Location',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BookmarkPage()));
            },
          ),
          //Here is a divider for divide the menu in two parts

          Divider(
            color: Colors.black,
            thickness: 0.2,
          ),
          ListTile(
            leading: const Icon(
              Icons.login,
              color: Colors.black12,
            ),
            title: Text(
              'Log In',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SignInPage();
              }));

              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              color: Colors.black12,
            ),
            title: Text(
              'Profile ',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.backup_rounded,
              color: Colors.black12,
            ),
            title: Text(
              'Weather ',
              style: GoogleFonts.lato(fontSize: 20),
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 0.2,
          ),

          /* This is another divider
            which divide categories from profile
             */

          ListTile(
            title: Text(
              'Categoris',
              style: GoogleFonts.lato(fontSize: 20),
            ),
          ),
          /* This is for category menu

             */

          ListTile(
            leading: const Icon(
              Icons.restaurant,
              color: Colors.black12,
            ),
            title: Text(
              'Restaurants',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.food_bank_outlined,
              color: Colors.black12,
            ),
            title: Text(
              'Banks',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black12,
            ),
            title: Text(
              'Shops',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.bus_alert,
              color: Colors.black12,
            ),
            title: Text(
              'Bus Information',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(
            color: Colors.teal.shade900,
            thickness: 0.5,
          ),
          /* This is our Last divider in
            this menu
             */
          ListTile(
            title: Text(
              'Share',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.share,
              color: Colors.black12,
            ),
            title: Text(
              'Share',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              Navigator.pop(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.star_border,
              color: Colors.black12,
            ),
            title: Text(
              'Rate Us',
              style: GoogleFonts.lato(fontSize: 20),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
