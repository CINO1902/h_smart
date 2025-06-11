import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/support/presentation/widgets/faqs.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: const Text(
            'Feedback',
            style: TextStyle(fontSize: 16),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          const Text(
            'We\'ve compiled the most frequently asked questions to help you find quick answers and make the most of our services.',
            style: TextStyle(fontSize: 13),
          ),
          const Gap(20),
          const Text(
            'Get Started',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Gap(15),
          facdoc(
            title: 'What is H-Smart?',
            decr:
                'H-Smart is an integrated system designed to enhance the patient experience and improve healthcare accessibility. It offers a range of features and services such as appointment scheduling, doctor-patient communication, emergency services, rating capabilities, complaint management, and the provision of quick first aid or prescriptions.',
          ),
          const Gap(15),
          facdoc(
            title: 'How do I schedule an appointment?',
            decr:
                'H-Smart is an integrated system designed to enhance the patient experience and improve healthcare accessibility. It offers a range of features and services such as appointment scheduling, doctor-patient communication, emergency services, rating capabilities, complaint management, and the provision of quick first aid or prescriptions.',
          ),
          const Gap(15),
          facdoc(
            title: 'Is my personal health data secure?',
            decr:
                'H-Smart is an integrated system designed to enhance the patient experience and improve healthcare accessibility. It offers a range of features and services such as appointment scheduling, doctor-patient communication, emergency services, rating capabilities, complaint management, and the provision of quick first aid or prescriptions.',
          ),
          const Gap(15),
          facdoc(
            title: 'How do I access my medical records?',
            decr:
                'H-Smart is an integrated system designed to enhance the patient experience and improve healthcare accessibility. It offers a range of features and services such as appointment scheduling, doctor-patient communication, emergency services, rating capabilities, complaint management, and the provision of quick first aid or prescriptions.',
          ),
          const Gap(15),
          facdoc(
            title: 'Can I rate and review healthcare providers?',
            decr:
                'H-Smart is an integrated system designed to enhance the patient experience and improve healthcare accessibility. It offers a range of features and services such as appointment scheduling, doctor-patient communication, emergency services, rating capabilities, complaint management, and the provision of quick first aid or prescriptions.',
          ),
          const Gap(30),
          const Text(
            'Emergency and Urgent Care',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Gap(15),
          facdoc(
            title: 'How do I get urgent medical assistance?',
            decr:
                'H-Smart is an integrated system designed to enhance the patient experience and improve healthcare accessibility. It offers a range of features and services such as appointment scheduling, doctor-patient communication, emergency services, rating capabilities, complaint management, and the provision of quick first aid or prescriptions.',
          ),
          const Gap(30),
          const Text(
            'Account and Settings',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Gap(15),
          facdoc(
            title: 'How do I reset my password?',
            decr:
                'H-Smart is an integrated system designed to enhance the patient experience and improve healthcare accessibility. It offers a range of features and services such as appointment scheduling, doctor-patient communication, emergency services, rating capabilities, complaint management, and the provision of quick first aid or prescriptions.',
          ),
        ]),
      ),
    );
  }
}
