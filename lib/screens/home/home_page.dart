import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<HomePageProvider>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: Text(
          "Craft Party",
          textAlign: TextAlign.center,
        ),
      ),
      body: Form(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    enabled: !provider.isLoading,
                    controller: provider.controller,
                    onChanged: (value) => provider.onTextFieldChanged(context, value),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                    ],
                    style: Theme.of(context).textTheme.headlineLarge,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: "Enter room code",
                      hintStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Theme.of(context).splashColor),
                      label: Center(child: Text("Enter room code")),
                      labelStyle: Theme.of(context).textTheme.headlineLarge
                    ),
                  )
                ],
              ),
            ),
            provider.isLoading
            ? Positioned(
              child: Container(
                height: 5,
                width: MediaQuery.of(context).size.width,
                child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary), backgroundColor: Colors.transparent,)
              ), 
              bottom: MediaQuery.of(context).padding.bottom,
            )
            : Container(),
          ],
        ),
      ),
    );
  }
}