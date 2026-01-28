import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';

class TermsOfServices extends StatefulWidget {
  const TermsOfServices({super.key});

  @override
  State<TermsOfServices> createState() => _TermsOfServicesState();
}

class _TermsOfServicesState extends State<TermsOfServices> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: Sizes.screenWidth,
          height: Sizes.screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.boardBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [

              SizedBox(height: Sizes.screenHeight * 0.05),

              const TextConst(
                title: "📄 Terms of Services",
                size: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: Sizes.screenHeight * 0.03),

              Expanded(
                child: Container(
                  width: Sizes.screenWidth * 0.9,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        _sectionTitle("1. Acceptance of Terms"),
                        _sectionText(
                          "By accessing and using this application, you agree to comply with and be bound by these terms and conditions.",
                        ),

                        _space(),

                        _sectionTitle("2. User Responsibilities"),
                        _bullet("You must not use the app for unlawful activities."),
                        _bullet("You agree to provide accurate information."),
                        _bullet("You must not attempt to hack or disrupt services."),

                        _space(),

                        _sectionTitle("3. In-App Behavior"),
                        _bullet("No harassment or abusive language."),
                        _bullet("Fair play is required in multiplayer modes."),
                        _bullet("Cheating, exploits, or unfair advantages are prohibited."),

                        _space(),

                        _sectionTitle("4. Intellectual Property"),
                        _sectionText(
                          "All assets, graphics, logos, and content belong to the app owner and are protected by copyright laws.",
                        ),

                        _space(),

                        _sectionTitle("5. Account & Data"),
                        _bullet("We may store limited gameplay or profile data."),
                        _bullet("We do not share personal information without consent."),
                        _bullet("Data may be used to improve gameplay experience."),

                        _space(),

                        _sectionTitle("6. Termination"),
                        _sectionText(
                          "We reserve the right to suspend accounts violating the terms without prior notice.",
                        ),

                        _space(),

                        _sectionTitle("7. Disclaimer"),
                        _sectionText(
                          "We are not liable for technical issues, data loss, or damages arising from using this app.",
                        ),

                        _space(),

                        _sectionTitle("8. Changes to Terms"),
                        _sectionText(
                          "Terms may be updated occasionally. Continued usage implies acceptance of revised terms.",
                        ),

                        _space(),

                        _sectionTitle("9. Contact Information"),
                        _sectionText(
                          "If you have questions about these terms, please contact us through support or email.",
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: Sizes.screenHeight * 0.02),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: Sizes.screenWidth * 0.9,
                  height: Sizes.screenHeight * 0.065,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.blue.withOpacity(0.85),
                  ),
                  child: const TextConst(
                    title: "ACCEPT & CONTINUE",
                    size: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: Sizes.screenHeight * 0.025),
            ],
          ),
        ),
      ),
    );
  }

  /// UI HELPERS
  Widget _sectionTitle(String title) => TextConst(
    title: title,
    size: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  Widget _sectionText(String text) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: TextConst(
      title: text,
      size: 15,
      color: Colors.white70,
    ),
  );

  Widget _bullet(String text) => Padding(
    padding: const EdgeInsets.only(left: 8, top: 6),
    child: TextConst(
      title: "• $text",
      size: 15,
      color: Colors.white70,
    ),
  );

  Widget _space() => const SizedBox(height: 14);
}
