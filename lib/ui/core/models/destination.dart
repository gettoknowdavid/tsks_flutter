import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';

class Destination {
  const Destination(this.icon, this.label, this.path);
  final IconData icon;
  final String label;
  final String path;
}

List<Destination> destinations = <Destination>[
  Destination(
    PhosphorIconsBold.squaresFour,
    'Dashboard',
    const DashboardRoute().location,
  ),
  Destination(
    PhosphorIconsBold.cards,
    'Collections',
    const CollectionsRoute().location,
  ),
  Destination(
    PhosphorIconsBold.magnifyingGlass,
    'Search',
    const SearchRoute().location,
  ),
  Destination(
    PhosphorIconsBold.bell,
    'Notification',
    const NotificationsRoute().location,
  ),
];

List<Destination> appBarDestinations = <Destination>[
  Destination(
    PhosphorIconsBold.squaresFour,
    'Dashboard',
    const DashboardRoute().location,
  ),
  Destination(
    PhosphorIconsBold.cards,
    'Collections',
    const CollectionsRoute().location,
  ),
];
