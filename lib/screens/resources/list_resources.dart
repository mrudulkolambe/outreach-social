import 'package:flutter/material.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/widgets/navbar.dart';

class ListResources extends StatefulWidget {
  const ListResources({super.key});

  @override
  State<ListResources> createState() => _ListResourcesState();
}

class _ListResourcesState extends State<ListResources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Resource",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 20,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      fillColor: Color.fromRGBO(239, 239, 240, 1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: horizontal_p),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: Color.fromRGBO(239, 239, 240, 1),
                    ),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "Physical",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "Mental",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "Spiritual",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Column(
                children: [],
              )
            ],
          ),
        ),
      ),
    );
  }
}
