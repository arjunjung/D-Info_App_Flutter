import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:testing_book/services.dart';

class Welcome extends StatelessWidget {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Map<String, String> getArguments = ModalRoute.of(context).settings.arguments;
    print("GET ARguments Welcome Screen: $getArguments");

    return Scaffold(
        appBar: AppBar(
          title: Text("Device Infos"),
          actions: [
            ElevatedButton(
              child: Text("Logout"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login', arguments: <String, String>{'message': "You must log in first."});
              },
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: _welcomeBody(getArguments),
        ));
  }

  Widget _welcomeBody(Map<String, String> getArguments) {
    return FutureBuilder(
        future: getAndroidinfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) return Text("Active");
          if (snapshot.connectionState == ConnectionState.done)
            return Scrollbar(
                          child: ListView(
                padding: const EdgeInsets.all(5),
                children: [
                  _buildTile(new Icon(Icons.android_rounded, color: Colors.green[300]), "Android UUID", snapshot.data['androidId']),
                  _buildTile(new Icon(Icons.mobile_friendly, color: Colors.blue[300]), "Android Model", snapshot.data['model']),
                  _buildTile(new Icon(Icons.mobile_friendly, color: Colors.blue[300]), "Manufacturer", snapshot.data['manufacturer']),
                  _buildTile(new Icon(Icons.mobile_friendly, color: Colors.green[300]), "Product", snapshot.data['product']),
                  _buildTile(new Icon(Icons.branding_watermark, color: Colors.orange[300]), "Brand", snapshot.data['brand']),
                  _buildTile(new Icon(Icons.perm_device_info, color: Colors.green[300]), "Device", snapshot.data['device']),
                  _buildTile(new Icon(Icons.vpn_key_rounded, color: Colors.green[300]), "Device Id", snapshot.data['id']),
                  _buildTile(new Icon(Icons.supervised_user_circle, color: Colors.blue[300]), "D-Link User", getArguments['user']),
                  _buildTile(new Icon(Icons.developer_board, color: Colors.blue[300]), "Board", snapshot.data['board']),
                  _buildTile(new Icon(Icons.local_fire_department, color: Colors.orange[300]), "Bootloader", snapshot.data['bootloader']),
                  _buildTile(new Icon(Icons.settings_display_rounded, color: Colors.green[300]), "Display", snapshot.data['display']),
                  _buildTile(new Icon(Icons.fingerprint, color: Colors.brown[150]), "Fingerprint", snapshot.data['fingerprint']),
                  _buildTile(new Icon(Icons.hardware, color: Colors.black), "Hardware", snapshot.data['hardware']),
                  _buildTile(new Icon(Icons.home, color: Colors.orange[300]), "Host", snapshot.data['host']),
                  _buildTile(new Icon(Icons.tag, color: Colors.orange[300]), "Tags", snapshot.data['tags']),
                  _buildTile(new Icon(Icons.merge_type, color: Colors.blue[300]), "Type", snapshot.data['type']),
                  _buildTile(new Icon(Icons.settings, color: Colors.blue[300]), "Version Release", snapshot.data['version.release']),
                  _buildTile(new Icon(Icons.settings, color: Colors.blue[300]), "Version Incremental", snapshot.data['version.incremental']),
                  _buildTile(new Icon(Icons.settings, color: Colors.blue[300]), "Version Code Name", snapshot.data['version.codename']),

                  _buildTile(new Icon(Icons.settings, color: Colors.blue[300]), "System Features", "See Below :"), //List<String>
                  _buildListItemCard(new Icon(Icons.settings, color: Colors.blue[300]), snapshot.data['systemFeatures']), //List<String>

                  _buildTile(
                      new Icon(Icons.settings, color: Colors.blue[300]), "IsPhysicalDevice", snapshot.data['isPhysicalDevice'].toString()), //bool
                ],
              ),
            );

          if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        });
  }

  Card _buildTile(Icon leading, String title, String subtitle) {
    return Card(
      child: ListTile(
        isThreeLine: true,
        leading: leading,
        title: Text(
          "" + title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
        ),
        subtitle: Text("" + subtitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
        onLongPress: () {
          return AlertDialog(
            content: Text(title),
          );
        },
      ),
    );
  }

  Widget _buildListItemCard(Icon leading, List<String> data) {
    return Container(
      height: 200,
      child: ListView.builder(
          // shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: data.length-1,
          padding: const EdgeInsets.all(15),
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                leading: leading,
                title: Text("" + data[index], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300)),
              ),
            );
          }),
    );
  }

  void showInSnackBar(String value) {
    final SnackBar snackBar = new SnackBar(
      content: Text("You are now successfully logged in into D-Link"),
      backgroundColor: Colors.blue[25],
      duration: Duration(
        seconds: 5,
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<Map<String, dynamic>> getAndroidinfo() async {
    DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    Map<String, dynamic> _fullDeviceInfo = getDeviceInfoFuture(await deviceInfoPlugin.androidInfo);
    return _fullDeviceInfo;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
}
