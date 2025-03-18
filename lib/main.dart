import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tip Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TipCalculator(),
    );
  }
}

class TipCalculator extends StatefulWidget {
  @override
  _TipCalculatorState createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  late VideoPlayerController _videoController;
  TextEditingController _billController = TextEditingController();
  double _tipPercentage = 15;
  double _tipAmount = 0.0;
  double _totalBill = 0.0;
  List<String> _tipHistory = [];

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset("assets/images/tip1.mp4")
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _calculateTip() {
    double billAmount = double.tryParse(_billController.text) ?? 0.0;
    _tipAmount = billAmount * _tipPercentage / 100;
    _totalBill = billAmount + _tipAmount;
    setState(() {});
  }

  void _submitTip() {
    String tipRecord =
        'Bill: ₱${_billController.text}, Tip: ₱${_tipAmount.toStringAsFixed(2)}, Total: ₱${_totalBill.toStringAsFixed(2)}';
    setState(() {
      _tipHistory.add(tipRecord);
    });
    _billController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galarosa, Rugay', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/images/grey.jpg", fit: BoxFit.cover),
            ),
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/profile2.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  accountName:
                      Text('Welcome!', style: TextStyle(color: Colors.white)),
                  accountEmail:
                      Text('Sir Jayson', style: TextStyle(color: Colors.white)),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/profile1.jpg"),
                  ),
                ),
                ListTile(
                  title: Text('Tip History',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TipHistoryScreen(tipHistory: _tipHistory)),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _videoController.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : Container(color: Colors.black),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Tip Calculator',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 20),
                Text('Enter Bill Amount:',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                TextField(
                  controller: _billController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter amount',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Text('Select Tip Percentage:',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                Slider(
                  value: _tipPercentage,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: '${_tipPercentage.toStringAsFixed(0)}%',
                  onChanged: (value) {
                    setState(() {
                      _tipPercentage = value;
                    });
                    _calculateTip();
                  },
                ),
                SizedBox(height: 20),
                Text('Tip Amount: ₱${_tipAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 10),
                Text('Total Bill: ₱${_totalBill.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _calculateTip, child: Text('Calculate Tip')),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _submitTip, child: Text('Submit Tip')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TipHistoryScreen extends StatelessWidget {
  final List<String> tipHistory;

  TipHistoryScreen({required this.tipHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tip History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/tip.jpg", fit: BoxFit.cover),
          ),
          ListView.builder(
            itemCount: tipHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(tipHistory[index],
                      style: TextStyle(color: Colors.white)));
            },
          ),
        ],
      ),
    );
  }
}
