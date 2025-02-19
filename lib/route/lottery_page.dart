import 'package:flutter/material.dart';
import 'package:lottery/main.dart';

class LotteryPage extends StatelessWidget {
  const LotteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserListTile(),
            Divider(color: Colors.grey),
            Spacer(flex: 2),
            Center(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: '请输入链接或是参与码',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: InkWell(
                      onTap: () {
                        debugPrint('抽奖');
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryFixed,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryFixedDim,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            
                          ),
                          Text('参与抽奖', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.07,fontWeight: FontWeight.bold,color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
