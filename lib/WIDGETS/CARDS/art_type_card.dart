import 'package:drawer_panel/EXTENSIONS/color_ext.dart';
import 'package:flutter/material.dart';

class ArtCategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const ArtCategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black54.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
          
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [.4,1.0],
                    colors: [
                      Colors.transparent, 
                      Colors.black,      
                    ],
                  ),
                ),
              ),
            ),
            // Text at the Bottom
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style:Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize:14,
                    color:  "fffafa".toColor(),
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
