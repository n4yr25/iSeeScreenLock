import 'package:flutter/material.dart';

void main() {
  runApp(LockScreen());
}

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => LockScreenState();
}

class LockScreenState extends State<LockScreen> {

  var number = [1,2,3,4,5,6,7,8,9,0];
  var setlock = "";
  var actives = [false, false, false, false];
  var clears = [false, false, false, false];
  var values = [1, 2, 3, 4];
  var curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Screen Lock'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for(int i = 0; i < actives.length; i++) 
                        AnimationBoxItem(
                          clear: clears[i],    
                          active: actives[i],       
                          value: values[i],             
                        )
                      
                      ,
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / .7,
                ), 
                itemBuilder: (_, index) => Container(
                  margin: EdgeInsets.all(5),
                  width: 50,
                  height: 50,
                  child: index == 9 ?
                  SizedBox() 
                  : Center(
                    child: MaterialButton(
                      onPressed: () {
                        
                        
                        if(index == 11) {
                          setlock = setlock.substring(0, setlock.length - 1);

                          clears = clears.map((e) => false).toList();
                          curIndex--;
                          if(curIndex >= 0)
                          setState(() {
                            clears[curIndex] = true;
                            actives[curIndex] = false;
                          });
                          else {
                            curIndex = 0;
                          }
                          return;
                        } else {
                          setlock += number[index == 10 ? index - 1 : index].toString();

                          if(setlock.length == 4) {
                            /*
                            if(condition) {
                              go to next screen
                            }
                            */

                            setState(() {
                              clears = clears.map((e) => true).toList();
                              actives = actives.map((e) => false).toList();
                            });
                            setlock = "";
                            curIndex = 0;
                            return;
                          }
                          clears = clears.map((e) => false).toList();
                          setState(() {
                            actives[curIndex] = true;
                            curIndex++;
                          });

                        }
                        print(setlock);
                        },
                      color: Colors.blue,
                      minWidth: 60,
                      height: 60,
                      child: index == 11
                      ? Icon(Icons.backspace)
                      : Text("${number[index == 10 ? index - 1 : index]}",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      ),
                  ),
                  ),
                  itemCount: 12,
                )
            )
          ],
        ),
      ),
    );
  }
}

class AnimationBoxItem extends StatefulWidget {
  final clear;
  final value;
  final active;
  const AnimationBoxItem({super.key, this.clear = false, this.active = false, this.value});

  @override
  State<AnimationBoxItem> createState() => _AnimationBoxItemState();
}

class _AnimationBoxItemState extends State<AnimationBoxItem> with TickerProviderStateMixin {

  late AnimationController animationController;

 
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this, 
      duration: Duration(
        seconds: 2
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    if(widget.clear) {
      animationController?.forward(from: 0);
    }
    return AnimatedBuilder(
      animation: animationController,
      builder: (_, child) => Container(
        margin: EdgeInsets.all(8),
        child: Stack(
          children: [
            Container(),
            AnimatedContainer(
              duration: Duration(seconds: 2),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.active ? Colors.black : Colors.grey,
              ),
            ),
            Align(
              alignment: Alignment(0, animationController.value / widget.value -1),
              child: Opacity(
                opacity: 1 - animationController.value,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.active ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}