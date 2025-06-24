import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/firstAid/presentation/pages/firstaiddesc.dart';

class FirstAid extends StatefulWidget {
  const FirstAid({super.key});

  @override
  State<FirstAid> createState() => _FirstAidState();
}

class _FirstAidState extends State<FirstAid> {
  List<String> firstAid = [
    'Abrasions',
    'Allergic Reactions',
    'Allergic Reactions',
    'Animal Bites',
    'Ankle Sprains',
    'Asthma Attacks',
    'Vision Changes',
    'Bee Stings',
    'Bleeding (Severe)',
    'Bone Fractures',
    'Burns (Thermal, Chemical, Electrical',
    'Choking',
    'Concussions'
  ];
  List suggestAfirstaid = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      suggestAfirstaid = firstAid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0.1,
        title: Text(
          'First Aid',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Gap(20),
            SizedBox(
              height: 44,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 10),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  hintText: 'Search',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                onChanged: (value) {
                  searchbook(value);
                },
              ),
            ),
            const Gap(20),
            Expanded(
              child: ListView.builder(
                itemCount: suggestAfirstaid.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FirstAidDesc(title: suggestAfirstaid[index]),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                      ),
                      height: 44,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            suggestAfirstaid[index],
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              'images/iconright.png',
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchbook(String query) {
    final suggestion = firstAid.where((element) {
      final symptoms = element.toLowerCase();
      final input = query.toLowerCase();

      return symptoms.contains(input);
    }).toList();
    setState(() {
      suggestAfirstaid = suggestion;
    });
  }
}
