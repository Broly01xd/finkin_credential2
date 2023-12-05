import 'package:carousel_slider/carousel_slider.dart';
import 'package:finkin_credential/controller/login_controller.dart';
import 'package:finkin_credential/models/loan_model/grid_model/grid_model.dart';
import 'package:finkin_credential/pages/home_screen/bottom_nav.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/agent_model/agent_model.dart';
import '../../repository/agent_repository/agent_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AgentRepository agentRepository = Get.put(AgentRepository());
  final LoginController loginController = Get.put(LoginController());

  List<String> imagePaths = [
    'assets/images/caros.jpg',
    'assets/images/money.jpg',
    'assets/images/education.jpg',
  ];

  Future<String?> getAgentName(String agentId) async {
    try {
      print("Fetching agent with ID: $agentId");
      final AgentModel? agent = await agentRepository.getAgentById(agentId);
      print("Fetched agent: $agent");
      return agent?.name;
    } catch (e) {
      print('Error fetching agent name: $e');
      return null;
    }
  }

  String getGreeting() {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future<String?> getAgentImage(String agentId) async {
    try {
      print("Fetching agent image with ID: $agentId");
      final AgentModel? agent = await agentRepository.getAgentById(agentId);
      print("Fetched agent: $agent");
      return agent?.imageUrl;
    } catch (e) {
      print('Error fetching agent image: $e');
      return null;
    }
  }

  Future<List<String?>> _getAgentData(String agentId) async {
    try {
      String? agentName = await getAgentName(agentId);
      String? agentImage = await getAgentImage(agentId);
      return [agentName, agentImage];
    } catch (e) {
      print('Error fetching agent data: $e');
      return ["Default Name", null];
    }
  }

  @override
  Widget build(BuildContext context) {
    String id = loginController.agentId.value;
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: FutureBuilder<List<String?>>(
                future: _getAgentData(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    String agentName = snapshot.data?[0] ?? "Default Name";
                    String agentImage =
                        snapshot.data?[1] ?? "assets/images/default_image.jpg";

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              const Text(
                                'Hello!',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColor.textLight,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                agentName,
                                style: const TextStyle(
                                  color: AppColor.textLight,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                getGreeting()
                                // + ' Sir'
                                ,
                                style: const TextStyle(
                                  color: AppColor.textLight,
                                  //  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomNavBar(
                                    initialIndex: 3,
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage: agentImage != null
                                  ? NetworkImage(agentImage)
                                  : const AssetImage(
                                          'assets/images/default_image.jpg')
                                      as ImageProvider<Object>?,
                              radius: 30,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 130,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColor.textLight,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Explore Categories",
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 1.3,
                              ),
                              itemCount: categories.length,
                              itemBuilder: (BuildContext context, int index) {
                                Category category = categories[index];
                                String categoryTitle = "Home Loan";
                                return InkWell(
                                  onTap: () => category.onTap?.call(context),
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.textLight,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            category.imagePath,
                                            width: 60,
                                            height: 60,
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            category.text,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 3.0,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                      ),
                      items: imagePaths.map((imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: const BoxDecoration(
                                color: AppColor.textdivider,
                              ),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
