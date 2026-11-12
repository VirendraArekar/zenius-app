import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette
  static const Color primary = Color(0xFF4F46E5);       // Indigo
  static const Color primaryLight = Color(0xFF6366F1);  // Light Indigo
  static const Color primaryDark = Color(0xFF3730A3);   // Dark Indigo
  static const Color secondary = Color(0xFF06B6D4);     // Cyan Electric
  static const Color accent = Color(0xFFF59E0B);        // Amber Gold
  static const Color violet = Color(0xFF8B5CF6);        // Purple / Violet

  // Semantic Status Colors
  static const Color success = Color(0xFF10B981);       // Emerald
  static const Color warning = Color(0xFFF97316);       // Orange
  static const Color danger = Color(0xFFEF4444);        // Rose Red
  static const Color info = Color(0xFF3B82F6);          // Sky Blue

  // Dark Mode Canvas & Surfaces
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1F2937);
  static const Color darkBorder = Color(0xFF374151);

  // Light Mode Canvas & Surfaces
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textDarkPrimary = Color(0xFFF9FAFB);
  static const Color textDarkSecondary = Color(0xFF9CA3AF);
  static const Color textLightPrimary = Color(0xFF0F172A);
  static const Color textLightSecondary = Color(0xFF64748B);

  // Stage Specific Colors for CRM Deal Funnel
  static const Map<String, Color> dealStageColors = {
    'Prospect': Color(0xFF3B82F6),        // Blue
    'Qualification': Color(0xFF06B6D4),   // Cyan
    'Needs Analysis': Color(0xFF8B5CF6),  // Violet
    'Value Proposition': Color(0xFF6366F1),// Indigo
    'Proposal': Color(0xFFF59E0B),        // Amber
    'Negotiation': Color(0xFFF97316),     // Orange
    'Closed Won': Color(0xFF10B981),      // Emerald
    'Closed Lost': Color(0xFFEF4444),     // Red
  };

  static Color getStageColor(String stageName) {
    return dealStageColors[stageName] ?? primary;
  }
}
