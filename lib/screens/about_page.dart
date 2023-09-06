import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About SKY Book'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/sky-logo.png',
              height: 120.0,
            ),
            const Text(
              'SKY Book',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Welcome to SKY Book, the ultimate diary app that goes beyond just keeping your thoughts and memories safe. SKY Book is more than just a digital journal; it\'s your trusted companion, a secure vault for your innermost thoughts, and a platform to engage with a friendly AI named SKY.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            _buildSectionWithBoldHeader(
              'What Sets SKY Book Apart:',
              <Widget>[
                _buildBulletPoint(
                  'Diary Creation',
                  'With SKY Book, you can create multiple books within the app, just like having different diaries for different aspects of your life. Each book can have its unique purpose and content, making it easy to organize your thoughts.',
                ),
                _buildBulletPoint(
                  'Page Customization',
                  'Within each book, you can create pages and customize them to your heart\'s content.',
                ),
                _buildBulletPoint(
                  'Chat with SKY',
                  'SKY is your virtual companion, always ready to listen, chat, and offer support. Share your thoughts, feelings, or simply have a friendly conversation. SKY is here for you 24/7.\nHe is more than friend he can write Code, Research, Generate Ideas, and many more.',
                ),
                _buildBulletPoint(
                  'Seamless Integration',
                  'SKY can help you document your conversations with a simple click. Easily add your conversations with SKY into your diary, creating a comprehensive record of your experiences and emotions.',
                ),
                _buildBulletPoint(
                  'Advanced Security',
                  'Your privacy matters. SKY Book ensures that all your data is encrypted, keeping your thoughts and memories safe from prying eyes. Additionally, you can lock each book individually for an extra layer of security.',
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildSectionWithBoldHeader(
              'Why Choose SKY Book:',
              <Widget>[
                _buildBulletPoint(
                  'Emotional Outlet',
                  'Express yourself freely without fear of judgment. SKY Book is your safe space to vent, reflect, and find solace.',
                ),
                _buildBulletPoint(
                  'Memory Preservation',
                  'Capture your life\'s moments, both big and small, to cherish them forever.',
                ),
                _buildBulletPoint(
                  'AI Companion',
                  'SKY provides a unique AI-driven interaction that can be therapeutic, offering emotional support when you need it most.',
                ),
                _buildBulletPoint(
                  'Organization and Accessibility',
                  'Keep your thoughts organized and easily accessible. Find what you need, when you need it.',
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '© Shravan',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.black,
                    ),
                    child: Image.asset(
                      'assets/SK.png',
                      height: 30,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('https://github.com/shravan-g-k'),
                          mode: LaunchMode.externalApplication);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      child: Image.asset(
                        'assets/github-logo.png',
                        height: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('https://twitter.com/Shravan_G_K'),
                          mode: LaunchMode.externalApplication);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      child: Image.asset(
                        'assets/x-logo.png',
                        height: 22,
                      ),
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

  Widget _buildBulletPoint(String header, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8.0),
        Text(
          header,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          description,
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget _buildSectionWithBoldHeader(String header, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          header,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ],
    );
  }
}
