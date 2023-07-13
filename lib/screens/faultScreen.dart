import 'package:flutter/material.dart';

class FaultScreen extends StatelessWidget {
  FaultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: Column(children: [
        Text(
          'there is a problem ',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        SizedBox(height: 24),
        TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Go back'))
      ]),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Somthing went Wrong'),
      ),
      body: body,
    );
  }
}
