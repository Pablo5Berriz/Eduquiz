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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduQuiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Ajoutez ici les routes
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
        '/login': (context) => const SimpleLoginScreen(),
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Simuler si un utilisateur est connecté ou non
  bool isUserLoggedIn = true;
  // Liste des matières
  final List<String> subjects = [
    'Mathématiques',
    'Français',
    'Histoire',
    'Géographie',
    'Économie',
    'Sciences'
  ];

  @override
  void initState() {
    super.initState();

    // Initialisation du contrôleur et de l'animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
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
        builder: (context) => LevelPage(subject: subject),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleLoginScreen(),
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
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'lib/EduQuiz.png', // Assurez-vous que ce chemin est correct
            height: 200,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Vérifier si currentState n'est pas null avant d'ouvrir le Drawer
            if (scaffoldKey.currentState != null) {
              scaffoldKey.currentState!.openDrawer();
            } else {
              // Afficher une erreur si le ScaffoldState est null
              Logger("Erreur: ScaffoldState est null");
            }
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("Flutter UI"),
              accountEmail: Text("zach@flutterui.design"),
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
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Image.network(
                        'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: textAnimation,
                    child: const Text(
                      'Bienvenue sur EduQuiz',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                "EduQuiz est une plateforme d'apprentissage interactive qui permet "
                "aux élèves du secondaire de tester leurs connaissances grâce à des quiz.",
              ),
              const SizedBox(height: 20),
              const Text(
                "Notre mission :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Fournir des outils éducatifs accessibles pour renforcer les compétences académiques "
                "et préparer les élèves pour leur avenir scolaire.",
              ),
              const SizedBox(height: 20),
              const Text(
                'Sélectionnez une matière pour commencer :',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Liste des matières sous forme de GridView avec animation de survol
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return MouseRegion(
                    onEnter: (_) => _controller.forward(),
                    onExit: (_) => _controller.reverse(),
                    child: GestureDetector(
                      onTap: () => _navigateToSubjectPage(subjects[index]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3), // Changement d'ombre à chaque survol
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            subjects[index],
                            style: const TextStyle(fontSize: 18),
                          ),
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

  // Liste des niveaux scolaires
  final List<String> levels = const [
    'Secondaire 1',
    'Secondaire 2',
    'Secondaire 3',
    'Secondaire 4',
    'Secondaire 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$subject - Niveaux Scolaires'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: levels.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Icon(Icons.school, color: Colors.blue.shade400),
                title: Text(
                  levels[index],
                  style: const TextStyle(fontSize: 20),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Logique pour rediriger vers la page du quiz ou autre
                  if (_isUserLoggedIn()) {
                    // Naviguer vers la page du quiz ou autre page selon le niveau
                  } else {
                    Navigator.pushNamed(context, '/login'); // Page login
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isUserLoggedIn() {
    // Simuler un utilisateur connecté ou non
    // Retourner 'true' si l'utilisateur est connecté, 'false' sinon
    return false; // Remplacez par votre logique d'authentification
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
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _selectedIndex = 0;

  // Cette fonction gère la navigation entre les pages
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page de Quiz'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue à la page du quiz!',
          style: TextStyle(fontSize: 24.0),
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
        onTap: _onItemTapped,  // Appeler la fonction _onItemTapped pour gérer la navigation
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
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'GENERAL',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          _buildListTile(
            icon: Icons.account_circle,
            title: 'Account',
            onTap: () {},
          ),
          _buildListTile(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {},
          ),
          _buildListTile(
            icon: Icons.lock,
            title: 'Security',
            onTap: () {},
          ),
          _buildListTile(
            icon: Icons.visibility,
            title: 'Appearance',
            onTap: () {},
          ),
          _buildListTile(
            icon: Icons.logout,
            title: 'Logout',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {},
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
            title: 'Report a bug',
            onTap: () {},
          ),
          _buildListTile(
            icon: Icons.feedback,
            title: 'Send feedback',
            onTap: () {},
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
            title: 'About',
            onTap: () {},
          ),
          _buildListTile(
            icon: Icons.support,
            title: 'Get support',
            onTap: () {},
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