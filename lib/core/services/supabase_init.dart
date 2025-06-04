import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> supabaseInit() async {
  await Supabase.initialize(
    url: 'https://rnyzefjhvgyoilciapuh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJueXplZmpodmd5b2lsY2lhcHVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg0NDI5ODYsImV4cCI6MjA2NDAxODk4Nn0.QDn_ADW8wo9CqglON2WTrTWl2iNed2GL74pwmnBAtpI',
  );
}
// Get a reference your Supabase client
// final supabase = Supabase.instance.client;