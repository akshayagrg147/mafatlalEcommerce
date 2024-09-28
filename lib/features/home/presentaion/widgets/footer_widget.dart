import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';

class Footer extends StatefulWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  List<bool> _isHoveringList = List.generate(7, (index) => false);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double aspectRatio;
        if (constraints.maxWidth > 1200) {
          aspectRatio = 4 / 1; // Desktop
        } else if (constraints.maxWidth > 800) {
          aspectRatio = 2 / 1; // Tablet
        } else {
          aspectRatio = 1 / 1.5; // Mobile
        }

        return AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Color(0x29000000),
                  offset: Offset(0, -2),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: _buildContent(constraints),
          ),
        );
      },
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    if (constraints.maxWidth > 1200) {
      return _desktopFooter();
    } else if (constraints.maxWidth > 800) {
      return _tabletFooter();
    } else {
      return _mobileFooter();
    }
  }

  Widget _desktopFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _footerContainer1()),
          Expanded(child: _footerContainer2()),
          Expanded(child: _footerContainer3()),
          Expanded(child: _footerContainer4()),
        ],
      ),
    );
  }

  Widget _tabletFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _footerContainer1()),
                Expanded(child: _footerContainer2()),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _footerContainer3()),
                Expanded(child: _footerContainer4()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileFooter() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _footerContainer1(),
            const SizedBox(height: 32),
            _footerContainer2(),
            const SizedBox(height: 32),
            _footerContainer3(),
            const SizedBox(height: 32),
            _footerContainer4(),
          ],
        ),
      ),
    );
  }

  Widget _footerContainer1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Image.asset('assets/Mafatlallogo.png'),
        ),
        const SizedBox(height: 16),
        const Text(
          AppStrings.mafatlaldescription,
          style: TextStyle(fontSize: 10, color: AppColors.kWhite),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _socialIcon(FontAwesomeIcons.facebook, 'Facebook'),
            SizedBox(width: 16 * SizeConfig.widthMultiplier),
            _socialIcon(FontAwesomeIcons.linkedin, 'LinkedIn'),
            SizedBox(width: 16 * SizeConfig.widthMultiplier),
            _socialIcon(FontAwesomeIcons.instagram, 'Instagram'),
          ],
        ),
      ],
    );
  }

  Widget _footerContainer2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.Headoffice,
          style: AppTextStyle.f10WhiteW600,
        ),
        const SizedBox(height: 8),
        const Text(
          AppStrings.address1,
          style: AppTextStyle.f10WhiteW600,
        ),
        const SizedBox(height: 16),
        _contactRow(Icons.phone, AppStrings.mobile1),
        const SizedBox(height: 8),
        _contactRow(Icons.mail, AppStrings.mobile2),
        const SizedBox(height: 16),
        const Text(
          AppStrings.registeroffice,
          style: AppTextStyle.f10WhiteW600,
        ),
        const SizedBox(height: 8),
        const Text(
          AppStrings.address2,
          style: AppTextStyle.f10WhiteW600,
        ),
        const SizedBox(height: 8),
        _contactRow(Icons.phone, AppStrings.mobile2),
      ],
    );
  }

  Widget _footerContainer3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.developmentoffice,
          style: AppTextStyle.f10WhiteW600,
        ),
        const SizedBox(height: 8),
        const Text(
          AppStrings.address1,
          style: AppTextStyle.f10WhiteW600,
        ),
        const SizedBox(height: 16),
        const Text(
          AppStrings.branchoffice,
          style: AppTextStyle.f10WhiteW600,
        ),
        const SizedBox(height: 8),
        const Text(
          AppStrings.address4,
          style: AppTextStyle.f10WhiteW600,
        ),
        const SizedBox(height: 8),
        _contactRow(Icons.phone, AppStrings.mobile3),
      ],
    );
  }

  Widget _footerContainer4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.product,
          style: AppTextStyle.f10WhiteW600,
        ),
        const SizedBox(height: 8),
        _productItem(AppStrings.digitalclassroom, 0),
        _productItem(AppStrings.lms, 1),
        _productItem(AppStrings.tma, 2),
        _productItem(AppStrings.erp, 3),
        _productItem(AppStrings.DCC, 4),
        _productItem(AppStrings.AE, 5),
        _productItem(AppStrings.SSCS, 6),
      ],
    );
  }

  Widget _socialIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            print('Tapped $label');
          },
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.kWhite,
          size: 10,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyle.f10WhiteW600,
        ),
      ],
    );
  }

  Widget _productItem(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHoveringList[index] = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHoveringList[index] = false;
          });
        },
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: _isHoveringList[index]
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white, // Underline color
                      width: 2.0, // Underline thickness
                    ),
                  ),
                )
              : null, // No underline when not hovering
          padding: const EdgeInsets.only(
              bottom: 2.0), // Space between text and underline
          child: Text(
            text,
            style: AppTextStyle.f10WhiteW600,
          ),
        ),
      ),
    );
  }
}
