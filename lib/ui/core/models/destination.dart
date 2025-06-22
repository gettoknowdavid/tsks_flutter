import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/collections/pages/collections_page.dart';
import 'package:tsks_flutter/ui/notifications/pages/notifications_page.dart';
import 'package:tsks_flutter/ui/search/pages/search_page.dart';
import 'package:tsks_flutter/ui/tasks/pages/dashboard_page.dart';

class Destination {
  const Destination({
    required this.icon,
    required this.label,
    required this.path,
    required this.widget,
  });

  final IconData icon;
  final String label;
  final String path;
  final Widget widget;
}

List<Destination> destinations = <Destination>[
  Destination(
    icon: PhosphorIconsBold.squaresFour,
    label: 'Dashboard',
    path: const DashboardRoute().location,
    widget: const DashboardPage(),
  ),
  Destination(
    icon: PhosphorIconsBold.cards,
    label: 'Collections',
    path: const CollectionsRoute().location,
    widget: const CollectionsPage(),
  ),
  Destination(
    icon: PhosphorIconsBold.magnifyingGlass,
    label: 'Search',
    path: const SearchRoute().location,
    widget: const SearchPage(),
  ),
  Destination(
    icon: PhosphorIconsBold.bell,
    label: 'Notification',
    path: const NotificationsRoute().location,
    widget: const NotificationsPage(),
  ),
];

List<Destination> appBarDestinations = <Destination>[
  Destination(
    icon: PhosphorIconsBold.squaresFour,
    label: 'Dashboard',
    path: const DashboardRoute().location,
    widget: const DashboardPage(),
  ),
  Destination(
    icon: PhosphorIconsBold.cards,
    label: 'Collections',
    path: const CollectionsRoute().location,
    widget: const CollectionsPage(),
  ),
];
