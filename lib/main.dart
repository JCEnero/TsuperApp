import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/supabase/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.initialize();

  runApp(const TsuperApp());
}
