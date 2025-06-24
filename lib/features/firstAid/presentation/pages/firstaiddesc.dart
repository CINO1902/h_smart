import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../medical_record/presentation/widgets/separator.dart';

class FirstAidDesc extends StatefulWidget {
  FirstAidDesc({super.key, required this.title});
  String title;

  @override
  State<FirstAidDesc> createState() => _FirstAidDescState();
}

class _FirstAidDescState extends State<FirstAidDesc> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: Text(
            widget.title,
            style: const TextStyle(fontSize: 16),
          )),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 44,
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset(
                        'images/firstaid_opacity.png',
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Quick First Aid Tips',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(80),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const Gap(20),
                Text(
                  'Symptoms',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const Gap(10),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Nunc pharetra massa velit consectetur lectus erat. Tincidunt dis egestas aliquet adipiscing donec. Sed cras vulputate amet scelerisque. Varius etiam frementum at.',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
                const Gap(20),
                Text(
                  'First Aid Steps',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        height: 125,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          color: theme.colorScheme.primary.withOpacity(0.1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Step ${index + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              'Lorem ipsum dolor sit amet consectetur. Nunc pharetra massa velit consectetur lectus erat.',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
