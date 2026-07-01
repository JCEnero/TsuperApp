import 'package:flutter/material.dart';
import 'app.dart';
import 'core/config/supabase/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase before anything else.
  // All services (auth, database) depend on this being ready.
  await SupabaseService.initialize();

  runApp(const TsuperApp());
}
