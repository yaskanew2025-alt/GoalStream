
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const bg = Color(0xFF0A0D0B);
const panel = Color(0xFF151A17);
const lime = Color(0xFFB8F36B);

void main() => runApp(const GoalStreamApp());

class Match {
  final String home, away, league, time, homeCode, awayCode;

  const Match({
    required this.home,
    required this.away,
    required this.league,
    required this.time,
    required this.homeCode,
    required this.awayCode,
  });
}

const matches = <Match>[
  Match(
    home: 'Arsenal',
    away: 'Liverpool',
    league: 'Premier League',
    time: 'Today · 19:30',
    homeCode: 'ARS',
    awayCode: 'LIV',
  ),
  Match(
    home: 'Real Madrid',
    away: 'Barcelona',
    league: 'La Liga',
    time: 'Tomorrow · 20:00',
    homeCode: 'RMA',
    awayCode: 'BAR',
  ),
  Match(
    home: 'Bayern Munich',
    away: 'Dortmund',
    league: 'Bundesliga',
    time: 'Tomorrow · 18:30',
    homeCode: 'BAY',
    awayCode: 'BVB',
  ),
  Match(
    home: 'Inter',
    away: 'Juventus',
    league: 'Serie A',
    time: 'Saturday · 19:45',
    homeCode: 'INT',
    awayCode: 'JUV',
  ),
];

class GoalStreamApp extends StatelessWidget {
  const GoalStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoalStream',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: lime,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  String league = 'All';
  final Set<String> saved = {};

  final leagues = const [
    'All',
    'Premier League',
    'La Liga',
    'Bundesliga',
    'Serie A',
  ];

  void openMatch(Match match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MatchPage(
          match: match,
          isSaved: saved.contains(match.homeCode),
          onSave: () {
            setState(() {
              if (!saved.add(match.homeCode)) {
                saved.remove(match.homeCode);
              }
            });
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final visible = matches.where((m) {
      if (tab == 1) return false; // No live feed connected yet.
      if (tab == 2) return m.league == league || league == 'All';
      if (tab == 3) return saved.contains(m.homeCode);
      return league == 'All' || m.league == league;
    }).toList();

    final titles = ['Discover', 'Live Matches', 'Leagues', 'Favorites'];
    final shown = tab == 1 ? <Match>[] : visible;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.sports_soccer, color: lime, size: 28),
            const SizedBox(width: 9),
            const Text(
              'GOALSTREAM',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'About',
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'GoalStream',
              applicationVersion: '0.1.0',
              children: const [
                Text(
                  'Football app prototype. Fixtures are demo data. '
                  'No live broadcast provider is connected yet.',
                ),
              ],
            ),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF242D23),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: lime.withAlpha(70)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.science_outlined, color: lime),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'DEMO VERSION · Sample fixtures only',
                      style: TextStyle(
                        color: lime,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              titles[tab],
              style: const TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              tab == 1
                  ? 'Authorized streams will appear here.'
                  : 'Your football, all in one place.',
              style: const TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 20),
            if (tab == 0) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR MATCHDAY',
                      style: TextStyle(
                        color: lime,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.4,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Every match.\nOne destination.',
                      style: TextStyle(
                        fontSize: 27,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Browse fixtures and open a match to '
                      'explore its viewing options.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
            ],
            if (tab != 1) ...[
              const Text(
                'COMPETITIONS',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: leagues.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final item = leagues[i];
                    final selected = item == league;
                    return ChoiceChip(
                      label: Text(item),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => league = item),
                      selectedColor: lime,
                      labelStyle: TextStyle(
                        color: selected ? bg : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 22),
            ],
            if (tab == 1)
              const EmptyState(
                icon: Icons.live_tv_outlined,
                title: 'No live stream connected',
                message:
                    'This section is ready for a licensed '
                    'broadcast provider. No real matches are '
                    'being streamed yet.',
              )
            else if (shown.isEmpty)
              EmptyState(
                icon: tab == 3
                    ? Icons.bookmark_border
                    : Icons.sports_soccer,
                title: tab == 3
                    ? 'No saved matches yet'
                    : 'No matches found',
                message: tab == 3
                    ? 'Open a match and save it to find it here.'
                    : 'Try another competition.',
              )
            else ...[
              Row(
                children: [
                  const Text(
                    'FIXTURES',
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${shown.length} matches',
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final match in shown)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MatchCard(
                    match: match,
                    saved: saved.contains(match.homeCode),
                    onTap: () => openMatch(match),
                  ),
                ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: panel,
        indicatorColor: lime.withAlpha(35),
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.live_tv_outlined),
            selectedIcon: Icon(Icons.live_tv),
            label: 'Live',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Leagues',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final Match match;
  final bool saved;
  final VoidCallback onTap;

  const MatchCard({
    super.key,
    required this.match,
    required this.saved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: panel,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF28302A)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    color: lime,
                    size: 17,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      match.league,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (saved)
                    const Icon(Icons.bookmark, color: lime, size: 18),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TeamLabel(
                      code: match.homeCode,
                      name: match.home,
                    ),
                  ),
                  const Text(
                    'VS',
                    style: TextStyle(
                      color: lime,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  Expanded(
                    child: TeamLabel(
                      code: match.awayCode,
                      name: match.away,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 15,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    match.time,
                    style: const TextStyle(color: Colors.white60),
                  ),
                  const Spacer(),
                  const Text(
                    'DETAILS',
                    style: TextStyle(
                      color: lime,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: lime),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamLabel extends StatelessWidget {
  final String code;
  final String name;

  const TeamLabel({
    super.key,
    required this.code,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF29332A),
          child: Text(
            code,
            style: const TextStyle(
              color: lime,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, message;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: lime),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class MatchPage extends StatelessWidget {
  final Match match;
  final bool isSaved;
  final VoidCallback onSave;

  const MatchPage({
    super.key,
    required this.match,
    required this.isSaved,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(match.league)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'MATCH CENTRE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: lime,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TeamLabel(
                  code: match.homeCode,
                  name: match.home,
                ),
              ),
              const Text(
                'VS',
                style: TextStyle(
                  color: lime,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
              Expanded(
                child: TeamLabel(
                  code: match.awayCode,
                  name: match.away,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.calendar_month, color: lime, size: 30),
                const SizedBox(height: 8),
                Text(match.time),
                const SizedBox(height: 5),
                const Text(
                  'Sample fixture — not verified live data',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: lime,
              foregroundColor: bg,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PlayerPage(),
              ),
            ),
            icon: const Icon(Icons.play_circle_outline),
            label: const Text(
              'TEST VIDEO PLAYER',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onSave,
            icon: Icon(
              isSaved ? Icons.bookmark_remove : Icons.bookmark_add_outlined,
            ),
            label: Text(isSaved ? 'Saved already' : 'Save match'),
          ),
          const SizedBox(height: 15),
          const Text(
            'Live broadcasts are not connected yet. '
            'The player currently uses a sample video, not football footage.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final VideoPlayerController controller;
  late final Future<void> initialized;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
    );
    initialized = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player Test')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF352D17),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'DEMO CLIP — NOT A LIVE FOOTBALL MATCH',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFD36A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: FutureBuilder<void>(
                future: initialized,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text(
                        'Video unavailable. Check your connection.',
                        textAlign: TextAlign.center,
                      );
                    }
                    return const CircularProgressIndicator(color: lime);
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        controller.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(controller),
                        Icon(
                          controller.value.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          color: Colors.white,
                          size: 56,
                        ),
                        Positioned(
                          left: 8,
                          right: 8,
                          bottom: 4,
                          child: VideoProgressIndicator(
                            controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: lime,
                              bufferedColor: Colors.white38,
                              backgroundColor: Colors.white12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Playback test',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This confirms that the video-player component can load '
            'an internet video. Later, we can connect an authorized '
            'football stream using its approved playback URL.',
            style: TextStyle(color: Colors.white60, height: 1.5),
          ),
        ],
      ),
    );
  }
}
