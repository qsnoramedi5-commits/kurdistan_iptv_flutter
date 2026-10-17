import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const KurdistanIptvApp());

class TvChannel {
  final String name, url, group;
  const TvChannel(this.name, this.url, {this.group = 'Kurdish'});
}

// Add the rest of your authorized .m3u8 streams here using the same format.
const List<TvChannel> channels = [
  TvChannel('Rudaw TV', 'https://live.rudaw.net/hls/rudaw-tv/master.m3u8'),
  TvChannel('Ava Media TV', 'https://ava002.xyz/upload/images/1080.m3u8'),
  TvChannel('Kurdistan 24 TV', 'https://hlspackager.akamaized.net/live/DB/K24/HLS/K24.m3u8'),
  TvChannel('Speda TV HD', 'https://www.speda2.site/upload/images/spedahd.m3u8'),
  TvChannel('Gali Kurdistan TV', 'https://live.host247.net/gk/gksat/chunklist_w1879482920.m3u8'),
  TvChannel('Kurdsat News TV', 'https://hlspackager.akamaized.net/live/DB/KURDSAT_NEWS/HLS/KURDSAT_NEWS.m3u8', group: 'News'),
  TvChannel('Nuçe TV', 'https://hlspackager.akamaized.net/live/DB/NU_TV/HLS/NU_TV.m3u8', group: 'News'),
  TvChannel('NRT TV HD', 'https://hlspackager.akamaized.net/live/DB/NRT_HD/HLS/NRT_HD-avc1_2500000=10002,mp4a_128000=20000.m3u8', group: 'News'),
  TvChannel('Channel 8', 'https://live.channel8.com/Channel8-Kurdish/index.m3u8'),
  TvChannel('MMN News TV', 'http://mmn.mypsx.net:1935/live/mmnhdnews/playlist.m3u8', group: 'News'),
  TvChannel('Afarin TV HD', 'https://65f16f0fdfc51.streamlock.net/afarinTV/livestream/chunklist_w187911945.m3u8'),
  TvChannel('Kurdistan TV HD', 'https://5a3ed7a72ed4b.streamlock.net/live/SMIL:myStream.smil/playlist.m3u8'),
  TvChannel('Shar TV HD', 'http://avrstream.com:1935/live/SHARTV/playlist.m3u8'),
  TvChannel('Avar TV HD', 'https://avr.host247.net/live/AvarTv/playlist.m3u8'),
  TvChannel('Kurdsat TV HD', 'https://hlspackager.akamaized.net/live/DB/KURDSAT_HD/HLS/KURDSAT_HD.m3u8'),
  TvChannel('Welat TV HD', 'https://stream.badinan.xyz/welat/tv/playlist.m3u8'),
  TvChannel('GK+ TV HD', 'https://live.host247.net/gk/gkplus/playlist.m3u8'),
  TvChannel('GeWher TV', 'https://cdn.karwan.tv/gewher-tv/index.m3u8'),
  TvChannel('Ava Family TV', 'https://familyhls.avatv.live/hls/stream.m3u8', group: 'Family'),
  TvChannel('Barin Movies TV', 'https://cdn.karwan.tv/barin-movies/index.m3u8', group: 'Family'),
  TvChannel('New Family TV', 'https://cdn.karwan.tv/bnar-family/index.m3u8', group: 'Family'),
  TvChannel('New Movies TV', 'https://cdn.karwan.tv/bnar-movies/index.m3u8', group: 'Family'),
  TvChannel('Zarok TV Kurmanji', 'https://zindikurmanci.zaroktv.com.tr/hls/stream.m3u8', group: 'Kids'),
  TvChannel('Zarok TV HD', 'https://zindisorani.zaroktv.com.tr/hls/0/stream.m3u8', group: 'Kids'),
  TvChannel('Gewher Kids TV', 'https://cdn.karwan.tv/gewher-kids/index.m3u8', group: 'Kids'),
  TvChannel('Zoomoo TV HD', 'https://zoomoo-samsungau.amagi.tv/playlist.m3u8', group: 'Kids'),
  TvChannel('ABC Kids TV', 'https://c.mjh.nz/abc-kids.m3u8', group: 'Kids'),
  TvChannel('Qatar TV HD', 'https://qatartv.akamaized.net/hls/live/20000609/qtv1/master.m3u8', group: 'Arabic'),
  TvChannel('Qatar TV 2', 'https://qatartv.akamaized.net/hls/live/20000611/qtv2/master.m3u8', group: 'Arabic'),
  TvChannel('Al Arabiya News', 'https://live.kwikmotion.com/alaraby1live/alaraby_abr/playlist.m3u8', group: 'Arabic'),
  TvChannel('TRT 1', 'https://tv-trt1.medya.trt.com.tr/master.m3u8', group: 'International'),
  TvChannel('TRT Kurdî', 'https://tv-trtkurdi.medya.trt.com.tr/master.m3u8', group: 'International'),
  TvChannel('Sky News Arabia', 'https://stream.skynewsarabia.com/hls/sna.m3u8', group: 'News'),
  TvChannel('BBC News', 'https://vs-hls-push-ww-live.akamaized.net/x=4/i=urn:bbc:pips:service:bbc_news_channel_hd/t=3840/v=pv14/b=5070016/main.m3u8', group: 'News'),
  TvChannel('CNN TV HD', 'https://turnerlive.warnermediacdn.com/hls/live/586495/cnngo/cnn_slate/VIDEO_0_3564000.m3u8', group: 'News'),
  TvChannel('GeWher Sport TV', 'https://cdn.karwan.tv/gewher-sport/index.m3u8', group: 'Sports'),
  TvChannel('Bahrain Sports 1', 'https://5c7b683162943.streamlock.net/live/sportsone/playlist.m3u8', group: 'Sports'),
  TvChannel('Bahrain Sports 2', 'https://5c7b683162943.streamlock.net/live/bahrainsportstwo/playlist.m3u8', group: 'Sports'),
];

class KurdistanIptvApp extends StatelessWidget {
  const KurdistanIptvApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Kurdistan IPTV',
    theme: ThemeData(useMaterial3: true, brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF050D19),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFC928), brightness: Brightness.dark),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF071321), foregroundColor: Colors.white),
      cardColor: const Color(0xFF0D1A2A)),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState() => _HomePageState(); }
class _HomePageState extends State<HomePage> {
  int tab = 0;
  String query = '';
  String category = 'All';
  Set<String> favorites = {};
  @override void initState() { super.initState(); _loadFavorites(); }
  Future<void> _loadFavorites() async { final p = await SharedPreferences.getInstance(); if (mounted) setState(() => favorites = (p.getStringList('favorites') ?? []).toSet()); }
  Future<void> _toggleFavorite(TvChannel c) async { setState(() { if (!favorites.add(c.url)) favorites.remove(c.url); }); final p = await SharedPreferences.getInstance(); await p.setStringList('favorites', favorites.toList()); }
  List<String> get categories => const ['All','Kurdish','News','Arabic','Sports','Kids','Family','International'];
  List<TvChannel> get shown {
    Iterable<TvChannel> list = tab == 1 ? channels.where((c) => favorites.contains(c.url)) : channels;
    if (category != 'All' && tab != 1) list = list.where((c) => c.group == category);
    if (query.trim().isNotEmpty) list = list.where((c) => c.name.toLowerCase().contains(query.toLowerCase()));
    return list.toList();
  }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('KURDISTAN ', style: TextStyle(fontWeight: FontWeight.w900)),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      actions: [IconButton(icon: const Icon(Icons.search), onPressed: () => showSearch(context: context, delegate: ChannelSearch(channels, favorites, _toggleFavorite, _play))), IconButton(icon: const Icon(Icons.settings_outlined), onPressed: _settings)]),
    body: tab == 2 ? _settingsBody() : Column(children: [
      if (tab == 0) _hero(),
      SizedBox(height: 54, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), children: categories.map((c) => Padding(padding: const EdgeInsets.only(right: 7), child: ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() => category = c)))).toList())),
      Expanded(child: shown.isEmpty ? const Center(child: Text('No channels found')) : ListView.builder(padding: const EdgeInsets.fromLTRB(12, 2, 12, 12), itemCount: shown.length, itemBuilder: (_, i) => _channelTile(shown[i]))),
    ]),
    bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (v) => setState(() { tab = v; if (v != 1) category = 'All'; }), destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'), NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Favorites'), NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings')]),
  );
  Widget _hero() => Container(margin: const EdgeInsets.fromLTRB(12, 10, 12, 4), padding: const EdgeInsets.all(18), decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFF142D4A), Color(0xFF091320)], begin: Alignment.topLeft, end: Alignment.bottomRight)), child: Row(children: [Container(width: 62, height: 62, decoration: BoxDecoration(color: const Color(0xFF10223A), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.live_tv, color: Color(0xFFFFC928), size: 38)), const SizedBox(width: 14), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('KURDISTAN IPTV', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), SizedBox(height: 5), Text('Live Kurdish channels and more', style: TextStyle(color: Colors.white70))])), const Icon(Icons.circle, size: 9, color: Colors.red), const SizedBox(width: 4), const Text('LIVE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))]));
  Widget _channelTile(TvChannel c) => Card(margin: const EdgeInsets.symmetric(vertical: 5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), leading: Container(width: 52, height: 52, decoration: BoxDecoration(color: const Color(0xFF142A43), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.live_tv, color: Color(0xFFFFC928), size: 28)), title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text('${c.group} • LIVE', style: const TextStyle(color: Colors.white60, fontSize: 12)), trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(tooltip: 'Favorite', icon: Icon(favorites.contains(c.url) ? Icons.favorite : Icons.favorite_border, color: favorites.contains(c.url) ? Colors.redAccent : Colors.white70), onPressed: () => _toggleFavorite(c)), const Icon(Icons.chevron_right, color: Colors.white54)]), onTap: () => _play(c));
  void _play(TvChannel c) { Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayerPage(channel: c, isFavorite: favorites.contains(c.url), onFavorite: () => _toggleFavorite(c)))); }
  void _settings() => setState(() => tab = 2);
  Widget _settingsBody() => ListView(padding: const EdgeInsets.all(18), children: [const SizedBox(height: 20), const Icon(Icons.settings, size: 48, color: Color(0xFFFFC928)), const SizedBox(height: 12), const Center(child: Text('KURDISTAN IPTV', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22))), const Center(child: Text('Version 1.0.0', style: TextStyle(color: Colors.white60))), const SizedBox(height: 25), const ListTile(leading: Icon(Icons.language), title: Text('Language'), subtitle: Text('Kurdish / English')), const ListTile(leading: Icon(Icons.high_quality), title: Text('Video quality'), subtitle: Text('Auto (controlled by stream provider)')), const ListTile(leading: Icon(Icons.info_outline), title: Text('About'), subtitle: Text('Live TV player using HLS streams. Stream availability depends on each provider.'))]);
}

class ChannelSearch extends SearchDelegate<TvChannel?> {
  final List<TvChannel> all; final Set<String> favorites; final Future<void> Function(TvChannel) toggle; final void Function(TvChannel) play;
  ChannelSearch(this.all, this.favorites, this.toggle, this.play);
  @override List<Widget>? buildActions(BuildContext context) => [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  @override Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));
  @override Widget buildResults(BuildContext context) => _results(context);
  @override Widget buildSuggestions(BuildContext context) => _results(context);
  Widget _results(BuildContext context) { final list = all.where((c) => c.name.toLowerCase().contains(query.toLowerCase())).toList(); return ListView(children: list.map((c) => ListTile(leading: const Icon(Icons.live_tv), title: Text(c.name), subtitle: Text(c.group), trailing: IconButton(icon: Icon(favorites.contains(c.url) ? Icons.favorite : Icons.favorite_border), onPressed: () => toggle(c)), onTap: () { close(context, c); play(c); })).toList()); }
}

class PlayerPage extends StatefulWidget { final TvChannel channel; final bool isFavorite; final VoidCallback onFavorite; const PlayerPage({super.key, required this.channel, required this.isFavorite, required this.onFavorite}); @override State<PlayerPage> createState() => _PlayerPageState(); }
class _PlayerPageState extends State<PlayerPage> {
  VideoPlayerController? controller; String error = ''; bool loading = true; Timer? retryTimer; int attempts = 0;
  @override void initState() { super.initState(); _initialize(); }
  Future<void> _initialize() async {
    final old = controller; controller = null; await old?.dispose();
    if (!mounted) return; setState(() { loading = true; error = ''; });
    final c = VideoPlayerController.networkUrl(Uri.parse(widget.channel.url), videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false));
    controller = c;
    try { await c.initialize().timeout(const Duration(seconds: 25)); await c.setLooping(false); await c.play(); if (!mounted) return; setState(() { loading = false; attempts = 0; }); }
    catch (e) { await c.dispose(); if (!mounted) return; setState(() { loading = false; error = 'Unable to play this stream. Check the link or try again.'; }); }
  }
  @override void dispose() { retryTimer?.cancel(); controller?.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(widget.channel.name, maxLines: 1, overflow: TextOverflow.ellipsis), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _initialize)]), body: Column(children: [AspectRatio(aspectRatio: 16/9, child: Container(color: Colors.black, child: Center(child: loading ? const CircularProgressIndicator() : error.isNotEmpty ? Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.signal_wifi_connected_no_internet_4, size: 42), const SizedBox(height: 10), Text(error, textAlign: TextAlign.center), const SizedBox(height: 10), FilledButton.icon(onPressed: _initialize, icon: const Icon(Icons.refresh), label: const Text('Retry'))])) : controller != null && controller!.value.isInitialized ? AspectRatio(aspectRatio: controller!.value.aspectRatio, child: VideoPlayer(controller!)) : const Icon(Icons.live_tv, size: 55)))), ListTile(leading: const Icon(Icons.live_tv, color: Color(0xFFFFC928)), title: Text(widget.channel.name), subtitle: Text('${widget.channel.group} • LIVE'), trailing: IconButton(icon: const Icon(Icons.fullscreen), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FullscreenPlayer(controller: controller, title: widget.channel.name))))), if (controller != null && controller!.value.isInitialized) Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Row(children: [IconButton(onPressed: () { setState(() { controller!.value.isPlaying ? controller!.pause() : controller!.play(); }); }, icon: Icon(controller!.value.isPlaying ? Icons.pause : Icons.play_arrow)), const Expanded(child: Text('Live stream')), IconButton(onPressed: () => controller!.setVolume(controller!.value.volume == 0 ? 1 : 0), icon: Icon(controller!.value.volume == 0 ? Icons.volume_off : Icons.volume_up))])), const Divider(), const Padding(padding: EdgeInsets.all(16), child: Text('If playback fails, the provider may be offline, geo-restricted, or using a format not supported by this device.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60))) ]));
}

class FullscreenPlayer extends StatelessWidget { final VideoPlayerController? controller; final String title; const FullscreenPlayer({super.key, required this.controller, required this.title}); @override Widget build(BuildContext context) => Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text(title)), body: Center(child: controller != null && controller!.value.isInitialized ? AspectRatio(aspectRatio: controller!.value.aspectRatio, child: VideoPlayer(controller!)) : const CircularProgressIndicator())); }