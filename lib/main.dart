import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

void main() {
  // Setup logging
  _setupLogging();
  runApp(const MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL; // Set the logging level
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatefulWidget {
  // Ajout du paramètre clé dans le constructeur
  const MyApp({super.key}); 

  @override
  MyAppState createState() => MyAppState();

  // La méthode 'of' permet d'accéder au 'MyAppState' via le 'context'
  static MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<MyAppState>()!;
  }
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  // Méthode pour changer le thème
  void changeTheme(ThemeMode newTheme) {
    setState(() {
      _themeMode = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduQuiz',
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // Ajoutez ici les routes
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
        '/login': (context) => const SimpleLoginScreen(),
        '/account': (context) => const AccountPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/security': (context) => const SecurityPage(),
        '/logout': (context) => const LogoutPage(),
        '/report-bug': (context) => const ReportBugPage(),
        '/send-feedback': (context) => const SendFeedbackPage(),
        '/about': (context) => const AboutPage(),
        '/get-support': (context) => const GetSupportPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> textAnimation;
  int _selectedIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Simuler si un utilisateur est connecté ou non
  bool isUserLoggedIn = true;

  // Liste des matières
  final List<Map<String, String>> subjects = [
    {'name': 'Économie', 'image': 'lib/Economie.png'},
    {'name': 'Français', 'image': 'lib/Francais.jpg'},
    {'name': 'Géographie', 'image': 'lib/Geographie.png'},
    {'name': 'Histoire', 'image': 'lib/Histoire.png'},
    {'name': 'Mathématiques', 'image': 'lib/Maths.jpg'},
    {'name': 'Sciences', 'image': 'lib/Sciences.jpg'},
  ];

  @override
  void initState() {
    super.initState();

    // Initialisation du contrôleur et de l'animation
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    textAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward(); // Démarrer l'animation du texte
  }

  // Gestion de la navigation par index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Logique de navigation
    if (index == 0) {
      Navigator.pushNamed(context, '/home'); // Naviguer vers la page d'accueil
    } else if (index == 1) {
      Navigator.pushNamed(context, '/settings'); // Naviguer vers la page des paramètres
    } else if (index == 2) {
      Navigator.pushNamed(context, '/login'); // Naviguer vers la page de connexion
    }
  }

  // Fonction pour gérer le clic sur une matière
  void _navigateToSubjectPage(String subject) {
    if (isUserLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubjectDetailPage(subject: subject), // Redirige vers SubjectDetailPage
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleLoginScreen(), // Page à définir
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Lier le scaffold pour le drawer
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'lib/EduQuiz.png', // Assurez-vous que ce chemin est correct
            height: 150,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Ouvrir le drawer
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Naviguer vers la page des notifications
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("Étudiant(e)"),
              accountEmail: Text("etudiant@exemple.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40), // Image d'avatar par défaut
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home'); // Naviguer vers Home
              },
            ),
            ListTile(
              leading: const Icon(Icons.explore),
              title: const Text('Explore'),
              onTap: () {
                Navigator.pushNamed(context, '/explore'); // Naviguer vers Explore
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings'); // Naviguer vers Settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushNamed(context, '/logout'); // Naviguer vers Logout
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              // Image avec texte centré "Bienvenue sur EduQuiz" et animation
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 230, 223, 213),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'lib/Education.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: textAnimation,
                    child: const Text(
                      'Bienvenue sur EduQuiz',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 2, 6, 70),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Description de l'application :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "EduQuiz est une plateforme interactive qui permet aux élèves du secondaire au Québec de tester leurs connaissances grâce à des quiz adaptés à leur niveau.",
              ),
              const SizedBox(height: 20),
              const Text(
                "Notre mission :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Fournir des outils éducatifs accessibles pour renforcer les compétences académiques et préparer les élèves pour leur avenir scolaire.",
              ),
              const SizedBox(height: 20),
              const Text(
                'Sélectionnez une matière pour commencer :',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Liste des matières sous forme de GridView avec ajustement des images
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Deux éléments par ligne
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _navigateToSubjectPage(subjects[index]['name']!),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          subjects[index]['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Appeler la fonction _onItemTapped
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;

  const InputField({
    this.labelText,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.autoFocus = false,
    this.obscureText = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class FormButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  const FormButton({this.text = '', this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class SimpleLoginScreen extends StatefulWidget {
  final Function(String? email, String? password)? onSubmitted;

  const SimpleLoginScreen({this.onSubmitted, super.key});

  @override
  State<SimpleLoginScreen> createState() => SimpleLoginScreenState();
}

class SimpleLoginScreenState extends State<SimpleLoginScreen> {
  late String email, password;
  String? emailError, passwordError;
  int _selectedIndex = 2; // Default to the login screen

  // Gérer la navigation entre les pages avec la barre de navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Logique de navigation
    if (index == 0) {
      Navigator.pushNamed(context, '/home'); // Naviguer vers la page d'accueil
    } else if (index == 1) {
      Navigator.pushNamed(context, '/settings'); // Naviguer vers la page des paramètres
    } else if (index == 2) {
      Navigator.pushNamed(context, '/login'); // Naviguer vers la page de connexion
    }
  }

  Function(String? email, String? password)? get onSubmitted =>
      widget.onSubmitted;

  @override
  void initState() {
    super.initState();
    email = '';
    password = '';
    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();
    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = 'Email invalide';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Veuillez saisir un mot de passe';
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted!(email, password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .12),
            const Text(
              'Bienvenue,',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              'Se connecter pour continuer!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(.6),
              ),
            ),
            SizedBox(height: screenHeight * .12),
            InputField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              labelText: 'Email',
              errorText: emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              onSubmitted: (val) => submit(),
              labelText: 'Mot de passe',
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Mot de passe oublié ?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * .075,
            ),
            FormButton(
              text: 'Se connecter',
              onPressed: submit,
            ),
            SizedBox(
              height: screenHeight * .15,
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SimpleRegisterScreen(),
                ),
              ),
              child: RichText(
                text: const TextSpan(
                  text: "Je suis un nouvel utilisateur, ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'S\'inscrire',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Appeler la fonction _onItemTapped pour gérer la navigation
      ),
    );
  }
}

class SimpleRegisterScreen extends StatefulWidget {
  final Function(String? email, String? password)? onSubmitted;

  const SimpleRegisterScreen({super.key, this.onSubmitted});

  @override
  State<SimpleRegisterScreen> createState() => _SimpleRegisterScreenState();
}

class _SimpleRegisterScreenState extends State<SimpleRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName, lastName, email, password, program, confirmPassword;
  String? emailError, passwordError, schoolLevel;
  bool isSocialMediaSignUp = false;
  bool showSchoolLevelDropdown = true;
  int _selectedIndex = 0;

  final List<String> schoolLevels = [
    'Secondaire 1',
    'Secondaire 2',
    'Secondaire 3',
    'Secondaire 4',
    'Secondaire 5',
  ];

  final List<String> programsForAdults = [
    'Programme Facile',
    'Programme Moyen',
    'Programme Difficile',
  ];

  @override
  void initState() {
    super.initState();
    firstName = '';
    lastName = '';
    email = '';
    password = '';
    confirmPassword = '';
    emailError = null;
    passwordError = null;
    program = '';
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    bool isValid = true;
    if (email.isEmpty) {
      setState(() {
        emailError = 'Email incorrecte';
      });
      isValid = false;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        passwordError = 'SVP entrez un mot de passe';
      });
      isValid = false;
    }

    if (password != confirmPassword) {
      setState(() {
        passwordError = 'Les mots de passe ne correspondent pas';
      });
      isValid = false;
    }

    return isValid;
  }

  void validateAge(String value) {
    final parsedAge = int.tryParse(value);
    if (parsedAge != null && parsedAge > 16) {
      setState(() {
        showSchoolLevelDropdown = false;
      });
    } else {
      setState(() {
        showSchoolLevelDropdown = true;
      });
    }
  }

  void _signUpWithSocialMedia() {
    setState(() {
      isSocialMediaSignUp = true;
    });
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmitted?.call(email, password);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Logique de navigation
    if (index == 0) {
      Navigator.pushNamed(context, '/home'); // Naviguer vers la page d'accueil
    } else if (index == 1) {
      Navigator.pushNamed(context, '/settings'); // Naviguer vers la page des paramètres
    } else if (index == 2) {
      Navigator.pushNamed(context, '/login'); // Naviguer vers la page de connexion
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .05),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ Nom
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nom(s)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir votre nom';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      lastName = value!;
                    },
                  ),
                  SizedBox(height: screenHeight * .02),

                  // Champ Prénom
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Prénom(s)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir votre prénom';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firstName = value!;
                    },
                  ),
                  SizedBox(height: screenHeight * .02),

                  // Champ Courriel
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Courriel'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir votre courriel';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                  SizedBox(height: screenHeight * .02),

                  // Champ Mot de passe
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir votre mot de passe';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                  SizedBox(height: screenHeight * .02),

                  // Champ Âge
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Âge'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir votre âge';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Veuillez entrer un âge valide';
                      }
                      return null;
                    },
                    onChanged: validateAge,
                  ),
                  SizedBox(height: screenHeight * .02),

                  // Dropdown pour le niveau scolaire ou un autre programme
                  if (showSchoolLevelDropdown)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Niveau Scolaire'),
                      value: schoolLevel,
                      items: schoolLevels
                          .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          schoolLevel = value;
                        });
                      },
                      onSaved: (value) {
                        schoolLevel = value;
                      },
                    )
                  else
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Programme pour adultes'),
                      value: program,
                      items: programsForAdults
                          .map((prog) => DropdownMenuItem(
                                value: prog,
                                child: Text(prog),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          program = value!;
                        });
                      },
                      onSaved: (value) {
                        program = value!;
                      },
                    ),
                  SizedBox(height: screenHeight * .05),

                  // Bouton d'inscription
                  Center(
                    child: ElevatedButton(
                      onPressed: submitForm,
                      child: const Text('S\'inscrire'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * .05),

            // Boutons pour s'inscrire via les réseaux sociaux
            const Center(
              child: Text(
                'Ou inscrivez-vous avec :',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: screenHeight * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.facebook, color: Colors.blue, size: 40),
                  onPressed: () {
                    _signUpWithSocialMedia();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.mail_outline, color: Colors.red, size: 40),
                  onPressed: () {
                    _signUpWithSocialMedia();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.account_circle, color: Colors.black, size: 40),
                  onPressed: () {
                    _signUpWithSocialMedia();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,  // Appeler la fonction _onItemTapped
      ),
    );
  }
}

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  // Liste des matières
  final List<String> subjects = const [
    'Mathématiques',
    'Français',
    'Histoire',
    'Géographie',
    'Économie',
    'Sciences'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matières'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Icon(Icons.book, color: Colors.blue.shade400),
                title: Text(
                  subjects[index],
                  style: const TextStyle(fontSize: 20),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SubjectDetailPage(subject: subjects[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: 0, // On reste sur la page matière, donc index 0
        selectedItemColor: Colors.blue,
        onTap: (index) {
          // Gérer la navigation vers d'autres pages si nécessaire
          if (index == 1) {
            // Navigate to settings page
          } else if (index == 2) {
            // Navigate to login page
          }
        },
      ),
    );
  }
}

// Page qui affiche les niveaux scolaires d'une matière sélectionnée
class SubjectDetailPage extends StatelessWidget { 
  final String subject;
  const SubjectDetailPage({required this.subject, super.key});

  // Liste des niveaux scolaires avec descriptions
  final List<Map<String, String>> levels = const [
    {
      'name': 'Secondaire 1',
      'description': 'Introduction aux concepts de base pour cette matière.',
      'image' : 'lib/Francais.jpg',
    },
    {
      'name': 'Secondaire 2',
      'description': 'Consolidation des notions apprises avec quelques approfondissements.',
      'image' : 'lib/Francais.jpg',
    },
    {
      'name': 'Secondaire 3',
      'description': 'Développement de compétences intermédiaires dans cette matière.',
      'image' : 'lib/Francais.jpg',
    },
    {
      'name': 'Secondaire 4',
      'description': 'Préparation aux examens avec des concepts avancés.',
      'image' : 'lib/Francais.jpg',
    },
    {
      'name': 'Secondaire 5',
      'description': 'Finalisation des compétences pour passer à un niveau supérieur ou à l’université.',
      'image' : 'lib/Francais.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$subject - Niveaux Scolaires'),
        backgroundColor: const Color.fromARGB(15, 233, 217, 182), // Couleur du titre de l'app bar
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions pour guider l'utilisateur
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF45F0DF), // Couleur douce pour mettre en avant l'instruction
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111D4A),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Veuillez sélectionner un niveau scolaire pour commencer le quiz sur cette matière. Chaque niveau vous permet de renforcer vos compétences avec des questions adaptées.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Liste des niveaux scolaires
            Expanded(
          child: ListView.builder(
            itemCount: levels.length,
            itemBuilder: (context, index) {
              return Card(
                color: const Color(0xFFC2CAE8), // Couleur de fond des cartes
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ExpansionTile(
                  leading: const Icon(Icons.school, color:  Color(0xFF3A6D8C)), // Couleur de l'icône
                  title: Text(
                    levels[index]['name']!,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF8380B6), // Couleur du texte des niveaux
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF111D4A)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        levels[index]['description']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF111D4A), // Couleur de la description
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF111D4A), // Couleur du bouton
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_isUserLoggedIn()) {
                          // Logique pour naviguer vers la page du quiz pour ce niveau
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizPage(
                                level: levels[index]['name']!,
                                subject: subject,
                              ),
                            ),
                          );
                        } else {
                          Navigator.pushNamed(context, '/login'); // Redirection vers la page de login
                        }
                      },
                      child: const Text(
                        'Commencer le quiz',
                        style: TextStyle(color: Colors.white), // Couleur du texte du bouton
                      ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Ajout du BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: 0, // On reste sur la page matière, donc index 0
        selectedItemColor: Colors.blue,
        onTap: (index) {
          // Gérer la navigation vers d'autres pages si nécessaire
          if (index == 1) {
            Navigator.pushNamed(context, '/settings'); // Navigation vers la page des paramètres
          } else if (index == 2) {
            Navigator.pushNamed(context, '/login'); // Navigation vers la page de connexion
          }
        },
      ),
    );
  }

  bool _isUserLoggedIn() {
    // Simuler un utilisateur connecté ou non
    return true; // Remplacez par votre logique d'authentification
  }
}

class LevelPage extends StatefulWidget {
  final String subject;
  const LevelPage({required this.subject, super.key});

  @override
  LevelPageState createState() => LevelPageState();
}

class LevelPageState extends State<LevelPage> {
  int _selectedIndex = 0; // Pour garder la trace de l'élément sélectionné dans la barre de navigation

  // Cette fonction gère les actions lorsqu'un utilisateur appuie sur la barre de navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Logique de navigation
    if (index == 0) {
      Navigator.pushNamed(context, '/home'); // Naviguer vers la page d'accueil
    } else if (index == 1) {
      Navigator.pushNamed(context, '/settings'); // Naviguer vers la page des paramètres
    } else if (index == 2) {
      Navigator.pushNamed(context, '/login'); // Naviguer vers la page de connexion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} - Niveaux Scolaires'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Secondaire 1'),
            onTap: () {
              // Logique de navigation pour le niveau scolaire
            },
          ),
          ListTile(
            title: const Text('Secondaire 2'),
            onTap: () {
              // Logique de navigation pour le niveau scolaire
            },
          ),
          ListTile(
            title: const Text('Secondaire 3'),
            onTap: () {
              // Logique de navigation pour le niveau scolaire
            },
          ),
          ListTile(
            title: const Text('Secondaire 4'),
            onTap: () {
              // Logique de navigation pour le niveau scolaire
            },
          ),
          ListTile(
            title: const Text('Secondaire 5'),
            onTap: () {
              // Logique de navigation pour le niveau scolaire
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Appeler la fonction _onItemTapped pour gérer la navigation
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final String level;
  final String subject;

  const QuizPage({required this.level, required this.subject, super.key});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  int _selectedIndex = 0;
  int _currentQuestionIndex = 0; // Index de la question courante
  int _score = 0; // Score de l'utilisateur
  bool _isQuizFinished = false; // Indicateur pour savoir si le quiz est terminé

  // Exemple de questions pour le quiz (ajustez selon vos besoins)
  final List<Map<String, Object>> _questions = [
    {
      'question': 'Quelle est la capitale du Québec?',
      'options': ['Montréal', 'Québec', 'Gatineau', 'Sherbrooke'],
      'answer': 'Québec',
    },
    {
      'question': 'Quel est le fleuve qui traverse le Québec?',
      'options': ['Fleuve Saint-Laurent', 'Rivière Richelieu', 'Rivière des Prairies', 'Rivière Ottawa'],
      'answer': 'Fleuve Saint-Laurent',
    },
    {
      'question': 'Quel est le symbole du Québec?',
      'options': ['Le castor', 'Le caribou', 'Le drapeau bleu et blanc', 'Le sirop d\'érable'],
      'answer': 'Le drapeau bleu et blanc',
    },
  ];

  // Fonction pour gérer la navigation entre les pages (BottomNavigationBar)
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SimpleLoginScreen()),
      );
    }
  }

  // Fonction pour passer à la question suivante
  void _nextQuestion(String selectedOption) {
    if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
      _score++; // Incrémenter le score si la réponse est correcte
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _isQuizFinished = true; // Terminer le quiz
      }
    });
  }

  // Fonction pour recommencer le quiz
  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _isQuizFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} - ${widget.level} Quiz'),
        backgroundColor: const Color(0xFF111D4A),
      ),
      body: _isQuizFinished
          ? _buildQuizResults() // Afficher les résultats si le quiz est terminé
          : _buildQuizContent(), // Afficher les questions sinon

      // BottomNavigationBar pour la navigation
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Gérer la navigation entre les pages
      ),
    );
  }

  // Contenu du quiz avec les questions et les options
  Widget _buildQuizContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_currentQuestionIndex + 1}/${_questions.length}',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF111D4A),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _questions[_currentQuestionIndex]['question'] as String,
            style: const TextStyle(
              fontSize: 22,
              color: Color(0xFF8380B6),
            ),
          ),
          const SizedBox(height: 30),
          // Affichage des options sous forme de boutons
          ...(_questions[_currentQuestionIndex]['options'] as List<String>)
              .map((option) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF45F0DF),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _nextQuestion(option),
                    child: Text(
                      option,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ))
                ],
              ),
            );
          }

          // Afficher les résultats une fois le quiz terminé
          // Afficher les résultats une fois le quiz terminé
  Widget _buildQuizResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Quiz Terminé!',
            style: TextStyle(
              fontSize: 28,
              color: Color(0xFF111D4A),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Votre score : $_score/${_questions.length}',
            style: const TextStyle(
              fontSize: 22,
              color: Color(0xFF8380B6),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF45F0DF),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _restartQuiz,
            child: const Text(
              'Recommencer le quiz',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
  
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 1; // Index par défaut sur Settings

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Logique de navigation
    if (index == 0) {
      Navigator.pushNamed(context, '/home'); // Naviguer vers la page d'accueil
    } else if (index == 1) {
      Navigator.pushNamed(context, '/settings'); // Naviguer vers la page des paramètres
    } else if (index == 2) {
      Navigator.pushNamed(context, '/login'); // Naviguer vers la page de connexion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'GÉNÉRALITÉS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          _buildListTile(
            icon: Icons.account_circle,
            title: 'Compte',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.lock,
            title: 'Sécurité',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecurityPage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.logout,
            title: 'Déconnexion',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              Navigator.pushNamed(context, '/logout');
            },
          ),
          const SizedBox(height: 30),
          const Text(
            'FEEDBACK',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          _buildListTile(
            icon: Icons.bug_report,
            title: 'Signaler un bogue',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportBugPage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.feedback,
            title: 'Envoyer un retour d\'information',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SendFeedbackPage()),
              ); 
            },
          ),
          const SizedBox(height: 30),
          const Text(
            'INFO',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          _buildListTile(
            icon: Icons.info,
            title: 'A propos de',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.support,
            title: 'Obtenir de l\'aide',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GetSupportPage()),
              );
            },
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'VERSION 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Appeler la fonction _onItemTapped pour gérer la navigation
      ),
    );
  }

  ListTile _buildListTile({
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
} 

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  bool _isNotificationsEnabled = true; // État des notifications
  bool _isDarkTheme = false; // État du thème sombre

  // Fonction pour basculer entre le thème clair et sombre
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
      // Mettre à jour le thème de l'application
      if (_isDarkTheme) {
        // Appliquer le thème sombre à l'application
        MyApp.of(context).changeTheme(ThemeMode.dark);
      } else {
        // Appliquer le thème clair à l'application
        MyApp.of(context).changeTheme(ThemeMode.light);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres du compte'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section d'informations de profil
          const Text(
            'Profil',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150', // Image placeholder
              ),
            ),
            title: const Text(
              'Nom Utilisateur',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('email@exemple.com'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Logique pour éditer le profil
                showEditProfileDialog(context);
              },
            ),
          ),
          const Divider(height: 20, thickness: 1),
          
          // Section de sécurité et de confidentialité
          const Text(
            'Sécurité et Confidentialité',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Changer le mot de passe'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Logique pour changer le mot de passe
              showChangePasswordDialog(context);
            },
          ),
          const Divider(height: 20, thickness: 1),

          // Section de préférences utilisateur
          const Text(
            'Préférences Utilisateur',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: _isNotificationsEnabled, // Simuler que les notifications sont activées
              onChanged: (bool value) {
                setState(() {
                  _isNotificationsEnabled = value; // Activer/désactiver les notifications
                });
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Thème'),
            trailing: DropdownButton<String>(
              value: _isDarkTheme ? 'Sombre' : 'Clair', // Thème actuel
              items: <String>['Clair', 'Sombre'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Basculer entre le thème clair et sombre
                if (newValue == 'Clair') {
                  _toggleTheme();
                } else if (newValue == 'Sombre') {
                  _toggleTheme();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  // Fonction pour afficher le dialogue de modification du profil
  void showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier le profil'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nom Utilisateur'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique pour sauvegarder le profil
                Navigator.of(context).pop();
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher le dialogue de changement de mot de passe
  void showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Changer le mot de passe'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Ancien mot de passe'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique pour changer le mot de passe
                Navigator.of(context).pop();
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }
}

  // Fonction pour afficher le dialogue de modification du profil
  void showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier le profil'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nom Utilisateur'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique pour sauvegarder le profil
                Navigator.of(context).pop();
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher le dialogue de changement de mot de passe
  void showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Changer le mot de passe'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Ancien mot de passe'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique pour changer le mot de passe
                Navigator.of(context).pop();
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }


class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {  // Réception des notifications promotionnelles
  bool _receiveUpdates = true;     // Réception des mises à jour
  bool _receiveReminders = false;  // Réception des rappels
  String _frequency = 'Quotidien'; // Fréquence de réception des notifications

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Paramètres de notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Notifications de mises à jour
            SwitchListTile(
              title: const Text('Recevoir des mises à jour'),
              value: _receiveUpdates,
              onChanged: (bool value) {
                setState(() {
                  _receiveUpdates = value;
                });
              },
            ),
            
            // Notifications de rappels
            SwitchListTile(
              title: const Text('Recevoir des rappels'),
              value: _receiveReminders,
              onChanged: (bool value) {
                setState(() {
                  _receiveReminders = value;
                });
              },
            ),
            
            const SizedBox(height: 20),
            const Text(
              'Fréquence des notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Dropdown pour la fréquence des notifications
            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Fréquence',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Quotidien',
                  child: Text('Quotidien'),
                ),
                DropdownMenuItem(
                  value: 'Hebdomadaire',
                  child: Text('Hebdomadaire'),
                ),
                DropdownMenuItem(
                  value: 'Mensuel',
                  child: Text('Mensuel'),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _frequency = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Logique de sauvegarde des préférences de notification
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Préférences de notifications mises à jour.')),
                );
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  SecurityPageState createState() => SecurityPageState();
}

class SecurityPageState extends State<SecurityPage> {
  bool _twoFactorAuthEnabled = false; // Authentification à deux facteurs
  bool _biometricAuthEnabled = false; // Authentification biométrique

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sécurité'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Paramètres de sécurité',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Authentification à deux facteurs
            SwitchListTile(
              title: const Text('Activer l\'authentification à deux facteurs'),
              subtitle: const Text('Augmente la sécurité de votre compte en ajoutant une étape supplémentaire de vérification.'),
              value: _twoFactorAuthEnabled,
              onChanged: (bool value) {
                setState(() {
                  _twoFactorAuthEnabled = value;
                });
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentification à deux facteurs activée.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentification à deux facteurs désactivée.')),
                  );
                }
              },
            ),

            // Authentification biométrique
            SwitchListTile(
              title: const Text('Activer l\'authentification biométrique'),
              subtitle: const Text('Utilisez votre empreinte digitale ou la reconnaissance faciale pour vous connecter.'),
              value: _biometricAuthEnabled,
              onChanged: (bool value) {
                setState(() {
                  _biometricAuthEnabled = value;
                });
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentification biométrique activée.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentification biométrique désactivée.')),
                  );
                }
              },
            ),

            const SizedBox(height: 20),
            const Text(
              'Sécurité du mot de passe',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Bouton pour changer le mot de passe
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Changer le mot de passe'),
              onTap: () {
                _showChangePasswordDialog(context);
              },
            ),

            const Divider(),
            
            const SizedBox(height: 20),
            const Text(
              'Sécurité des appareils',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Gestion des appareils connectés
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Gérer les appareils connectés'),
              subtitle: const Text('Voir et gérer les appareils connectés à votre compte.'),
              onTap: () {
                _showConnectedDevicesDialog(context);
              },
            ),

            const Divider(),

            ElevatedButton(
              onPressed: () {
                // Logique pour sauvegarder les paramètres de sécurité
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Paramètres de sécurité sauvegardés.')),
                );
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour afficher le dialogue de changement de mot de passe
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Changer le mot de passe'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Ancien mot de passe'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique pour changer le mot de passe
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mot de passe changé avec succès.')),
                );
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher le dialogue des appareils connectés
  void _showConnectedDevicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Appareils connectés'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.phone_android),
                title: Text('Appareil 1'),
                subtitle: Text('Dernière connexion: 12/08/2024'),
              ),
              ListTile(
                leading: Icon(Icons.computer),
                title: Text('Appareil 2'),
                subtitle: Text('Dernière connexion: 10/08/2024'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Êtes-vous sûr de vouloir vous déconnecter ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique de déconnexion
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Se déconnecter',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Retourner à la page précédente
              },
              child: const Text(
                'Annuler',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportBugPage extends StatefulWidget {
  const ReportBugPage({super.key});

  @override
  ReportBugPageState createState() => ReportBugPageState();
}

class ReportBugPageState extends State<ReportBugPage> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _includeScreenshot = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signaler un bogue'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Décrivez le problème que vous avez rencontré :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Champ pour entrer la description du bogue
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Détaillez le problème rencontré...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Option d'inclure une capture d'écran
            SwitchListTile(
              title: const Text('Inclure une capture d\'écran'),
              value: _includeScreenshot,
              onChanged: (bool value) {
                setState(() {
                  _includeScreenshot = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Bouton pour soumettre le rapport
            ElevatedButton.icon(
              onPressed: () {
                _submitBugReport();
              },
              icon: const Icon(Icons.send),
              label: const Text('Envoyer le rapport'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour soumettre le rapport de bogue
  void _submitBugReport() {
    final description = _descriptionController.text;

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez fournir une description du bogue.'),
        ),
      );
      return;
    }

    // Logique pour envoyer le rapport du bogue
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre rapport de bogue a été envoyé. Merci !'),
      ),
    );

    // Réinitialiser le formulaire
    setState(() {
      _descriptionController.clear();
      _includeScreenshot = false;
    });
  }
}

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({super.key});

  @override
  SendFeedbackPageState createState() => SendFeedbackPageState();
}

class SendFeedbackPageState extends State<SendFeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _includeEmail = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envoyer un commentaire'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Votre avis nous intéresse !',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Champ pour entrer le commentaire
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Écrivez ici votre commentaire...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Option d'inclure l'email
            SwitchListTile(
              title: const Text('Inclure mon email pour être contacté'),
              value: _includeEmail,
              onChanged: (bool value) {
                setState(() {
                  _includeEmail = value;
                });
              },
            ),

            if (_includeEmail)
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Entrez votre adresse email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Bouton pour soumettre le commentaire
            ElevatedButton.icon(
              onPressed: () {
                _submitFeedback();
              },
              icon: const Icon(Icons.send),
              label: const Text('Envoyer'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour soumettre le commentaire
  void _submitFeedback() {
    final feedback = _feedbackController.text;
    final email = _includeEmail ? _emailController.text : null;

    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un commentaire.'),
        ),
      );
      return;
    }

    if (_includeEmail && (email == null || email.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer une adresse email valide.'),
        ),
      );
      return;
    }

    // Logique pour envoyer le commentaire
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Merci pour votre commentaire !'),
      ),
    );

    // Réinitialiser le formulaire
    setState(() {
      _feedbackController.clear();
      _emailController.clear();
      _includeEmail = false;
    });
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos de EduQuiz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Logo ou Image représentative
            Center(
              child: Image.asset(
                'lib/Eduquiz.png', // Assurez-vous d'avoir le bon chemin du logo
                height: 150,
              ),
            ),
            const SizedBox(height: 20),

            // Titre de l'application
            const Text(
              'EduQuiz',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 2, 6, 70),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description de l'application
            const Text(
              'EduQuiz est une plateforme d\'apprentissage interactive qui permet aux '
              'élèves du secondaire de tester leurs connaissances à travers divers quiz. '
              'Notre mission est de fournir des outils éducatifs accessibles pour renforcer '
              'les compétences académiques des élèves.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Informations sur l'équipe de développement
            const Text(
              'Développé par :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'L\'équipe EduQuiz est composée de passionnés d\'éducation et de technologie. '
              'Nous croyons en l\'apprentissage interactif pour améliorer l\'expérience scolaire.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Fonctionnalités principales
            const Text(
              'Fonctionnalités principales :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.check, color: Colors.blue),
              title: Text('Quiz interactifs pour différentes matières.'),
            ),
            const ListTile(
              leading: Icon(Icons.check, color: Colors.blue),
              title: Text('Suivi de progression des élèves.'),
            ),
            const ListTile(
              leading: Icon(Icons.check, color: Colors.blue),
              title: Text('Classements pour encourager la compétition.'),
            ),
            const ListTile(
              leading: Icon(Icons.check, color: Colors.blue),
              title: Text('Possibilité de défier d\'autres utilisateurs.'),
            ),
            const SizedBox(height: 20),

            // Version de l'application
            const Text(
              'Version de l\'application :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Liens ou contact (email support)
            const Text(
              'Contactez-nous :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text('support@eduquiz.com'),
            ),
            const ListTile(
              leading: Icon(Icons.link, color: Colors.blue),
              title: Text('Visitez notre site web'),
              subtitle: Text('www.eduquiz.com'),
            ),
          ],
        ),
      ),
    );
  }
}

class GetSupportPage extends StatelessWidget {
  const GetSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obtenir de l\'aide'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Image ou illustration de support
            Center(
              child: Image.asset(
                'assets/support.png', // Assurez-vous d'ajuster le chemin de l'image
                height: 150,
              ),
            ),
            const SizedBox(height: 20),

            // Titre
            const Text(
              'Besoin d\'aide ?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 2, 6, 70),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description du support
            const Text(
              'Si vous rencontrez des problèmes ou avez des questions, notre équipe de support est là pour vous aider.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Option pour envoyer un email au support
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('Envoyer un email au support'),
              subtitle: const Text('support@eduquiz.com'),
              onTap: () {
                // Logique pour envoyer un email ou rediriger vers l'application d'email
              },
            ),

            // Option pour accéder à la FAQ
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.blue),
              title: const Text('Consulter la FAQ'),
              subtitle: const Text('Questions fréquentes'),
              onTap: () {
                // Logique pour ouvrir la page FAQ (ou redirection vers une URL)
              },
            ),

            // Option pour consulter les guides d'utilisation
            ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: const Text('Consulter les guides d\'utilisation'),
              subtitle: const Text('Découvrez comment utiliser EduQuiz'),
              onTap: () {
                // Logique pour rediriger vers les guides d'utilisation
              },
            ),

            // Option pour appeler le support (si disponible)
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text('Appeler le support'),
              subtitle: const Text('+1 800 123 456'),
              onTap: () {
                // Logique pour passer un appel au support (exemple)
              },
            ),

            const SizedBox(height: 20),

            // Centre du support
            const Text(
              'Heures d\'ouverture du support :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Du lundi au vendredi : 9h00 - 18h00\nSamedi : 10h00 - 14h00',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
