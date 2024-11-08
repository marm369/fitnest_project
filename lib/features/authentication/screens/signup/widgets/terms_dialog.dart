import 'package:flutter/material.dart';

const String privacyPolicyContent = '''
Your privacy is important to us. It is our policy to respect your privacy regarding any information we may collect from you across our website, and other sites we own and operate.

1. Information we collect
Log data: When you visit our website, our servers may automatically log the standard data provided by your web browser. It may include your computer’s Internet Protocol (IP) address, your browser type and version, the pages you visit, the time and date of your visit, the time spent on each page, and other details.

2. Use of information
We may use the information we collect from you to operate, maintain, and improve our site and services.

3. Sharing of information
We do not share your personal information with third parties except as necessary to provide our services or as required by law.

4. Security
We take reasonable steps to protect your personal information from loss, theft, misuse, and unauthorized access, disclosure, alteration, and destruction.

5. Changes to this policy
We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on our website.

If you have any questions about this Privacy Policy, please contact us.

''';

const String termsOfUseContent = '''
1. Acceptance of Terms
By accessing and using our services, you accept and agree to be bound by the terms and provision of this agreement.

2. Provision of Services
We are constantly innovating in order to provide the best possible experience for our users. You acknowledge and agree that the form and nature of the services which we provide may change from time to time without prior notice to you.

3. Use of Services
You agree to use the services only for purposes that are permitted by (a) the Terms and (b) any applicable law, regulation, or generally accepted practices or guidelines in the relevant jurisdictions.

4. Termination
We may terminate your access to the services at any time, without cause or notice, which may result in the forfeiture and destruction of all information associated with your account.

5. Changes to Terms
We reserve the right to update or modify these Terms at any time without prior notice. Your continued use of the service after any such changes constitutes your acceptance of the new Terms.

If you have any questions about these Terms, please contact us.

''';

class TermsDialog extends StatelessWidget {
  final String title;

  const TermsDialog({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String content;
    if (title == 'Privacy Policy') {
      content = privacyPolicyContent;
    } else if (title == 'Terms of Use') {
      content = termsOfUseContent;
    } else {
      content = 'No content available';
    }

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(content),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
