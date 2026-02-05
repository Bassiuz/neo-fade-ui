import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';

/// Avatar with gradient ring.
///
/// An avatar component that displays an image, icon, or initials
/// with a Neo Fade gradient ring around it.
class NeoAvatar extends StatelessWidget {
  final String? imageUrl;
  final IconData? icon;
  final String? initials;
  final double size;
  final bool showRing;
  final double ringWidth;
  final VoidCallback? onTap;

  const NeoAvatar({
    super.key,
    this.imageUrl,
    this.icon,
    this.initials,
    this.size = 48,
    this.showRing = true,
    this.ringWidth = 2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final innerSize = size - (showRing ? ringWidth * 2 + 4 : 0);

    Widget avatar = ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: glass.blur,
          sigmaY: glass.blur,
        ),
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceVariant.withValues(alpha: glass.tintOpacity),
          ),
          child: _buildContent(context, innerSize),
        ),
      ),
    );

    if (showRing) {
      avatar = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.secondary, colors.tertiary],
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.all(ringWidth),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surface,
          ),
          padding: const EdgeInsets.all(2),
          child: avatar,
        ),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: avatar,
        ),
      );
    }

    return avatar;
  }

  Widget _buildContent(BuildContext context, double innerSize) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: innerSize,
        height: innerSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback(context, innerSize);
        },
      );
    }

    if (icon != null) {
      return Center(
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.secondary],
          ).createShader(bounds),
          child: Icon(
            icon,
            size: innerSize * 0.5,
            color: colors.onPrimary,
          ),
        ),
      );
    }

    if (initials != null) {
      return Center(
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.secondary],
          ).createShader(bounds),
          child: Text(
            initials!.toUpperCase(),
            style: theme.typography.titleMedium.copyWith(
              fontSize: innerSize * 0.4,
              color: colors.onPrimary,
            ),
          ),
        ),
      );
    }

    return _buildFallback(context, innerSize);
  }

  Widget _buildFallback(BuildContext context, double innerSize) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    return Center(
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.secondary],
        ).createShader(bounds),
        child: Icon(
          const IconData(0xe7fd, fontFamily: 'MaterialIcons'), // person
          size: innerSize * 0.5,
          color: colors.onPrimary,
        ),
      ),
    );
  }
}
