import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:language_world/controllers/picture_perfil_controller.dart';
import 'package:language_world/models/profile_icon.dart';
import 'package:language_world/routes/routes.dart';

class SelectIconPerfil extends StatefulWidget {
  final List<ProfileIcon> icons;
  final ProfileIcon? initialIcon;
  final String userId;

  const SelectIconPerfil({
    super.key,
    required this.icons,
    this.initialIcon,
    required this.userId,
  });

  @override
  State<SelectIconPerfil> createState() => _SelectIconPerfilState();
}

class _SelectIconPerfilState extends State<SelectIconPerfil> {
  ProfileIcon? selectedIcon;
  bool showIcons = false;

  @override
  void initState() {
    super.initState();
    selectedIcon = widget.initialIcon;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PicturePerfilController>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showIcons = !showIcons;
            });
          },
          child: CircleAvatar(
            radius: 48,
            backgroundColor: Theme.of(context).primaryColor.withAlpha(25),
            child: selectedIcon != null
                ? CircleAvatar(
                    radius: 44,
                    backgroundImage: NetworkImage(selectedIcon!.imageUrl),
                  )
                : Icon(
                    Icons.add,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutBack)).animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          child: showIcons
              ? Container(
                  key: const ValueKey('icon-grid'),
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: widget.icons.length,
                    itemBuilder: (context, index) {
                      final icon = widget.icons[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIcon = icon;
                            showIcons = false;
                          });
                        },
                        child: CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(icon.imageUrl),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ),
        if (!showIcons && selectedIcon != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 4,
              ),
              onPressed: () async {
                try {
                  await controller.saveProfileIcon(selectedIcon!.imageUrl);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.selectIdiom,
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al guardar el icono: $e')),
                  );
                }
              },
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}
