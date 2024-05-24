import 'package:chat_app/data/services/firebase_storage_service.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/auth/viewmodels/log_in_viewmodel.dart';
import 'package:chat_app/features/auth/viewmodels/registration_viewmodel.dart';
import 'package:chat_app/features/chat/viewmodel/chat_viewmodel.dart';
import 'package:chat_app/features/chat/viewmodel/notification_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProvidersList {
  static List<SingleChildWidget> getProviders() => [
        Provider<FirebaseStorageService>(
          create: (context) => FirebaseStorageService(),
        ),
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
        ChangeNotifierProvider(
          create: (context) => RegistrationViewModel(
            authViewModel: Provider.of<AuthViewmodel>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => LogInViewModel(
            authViewModel: Provider.of<AuthViewmodel>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationViewmodel(
            authViewModel: Provider.of<AuthViewmodel>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatViewmodel(
            authViewModel: Provider.of<AuthViewmodel>(context, listen: false),
            notificationViewmodel:
                Provider.of<NotificationViewmodel>(context, listen: false),
          ),
        ),
      ];
}
