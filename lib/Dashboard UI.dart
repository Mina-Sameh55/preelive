import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:untitled1/cubits/stream%20state.dart';
import 'package:untitled1/cubits/user%20_state.dart';

import 'package:untitled1/repo%20impl/stream%20impl.dart';
import 'package:untitled1/repo%20impl/user%20addition%20impl.dart';
import 'package:untitled1/repo%20impl/user%20shipping%20impl.dart';
import 'package:untitled1/repo%20impl/userimpl.dart';

import 'package:untitled1/repo/stream%20repo.dart';
import 'package:untitled1/repo/user%20repo.dart';
import 'package:untitled1/repo/users%20additoin.dart';
import 'package:untitled1/repo/usershipping%20repo.dart';

import 'cubits/stream cubit.dart';
import 'cubits/user_cubit.dart';
import 'cubits/useragent _addition cubit.dart';
import 'cubits/useragent_additon state.dart';
import 'cubits/useragent_shiping state.dart';
import 'cubits/useragent_shipping cubit.dart';
import 'model/life streaming model.dart';
import 'model/user model.dart';

class LiveStreamDashboardApp extends StatelessWidget {
  const LiveStreamDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepositoryImpl(),
        ),
        RepositoryProvider<StreamRepository>(
          create: (_) => StreamRepositoryImpl(),
        ),
        RepositoryProvider<AgentRepository>(
          create: (_) => AgentRepositoryImpl(),
        ),
        RepositoryProvider<ShippingAgentRepository>(
          create: (_) => ShippingAgentRepositoryImpl(),
        ),
      ],
      child: MaterialApp(
        title: 'PreeLive Admin ',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const DashboardLayout(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int _selectedIndex = 0;
  final List<DashboardItem> _menuItems = [
    DashboardItem('Dashboard', Icons.dashboard, const DashboardScreen()),
    DashboardItem('Users', Icons.people, const UsersScreen()),
    DashboardItem('Streams', Icons.live_tv, const StreamsScreen()),
    DashboardItem('Agents', Icons.payment, const mainagent()),
    DashboardItem('agency', Icons.local_shipping, const shipingagent()),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          NavigationDrawer(
            selectedIndex: _selectedIndex,
            menuItems: _menuItems,
            onItemSelected: (index) {
              setState(() => _selectedIndex = index);
            },
          ),

          // Main Content
          Expanded(
            child: _menuItems[_selectedIndex].screen,
          ),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final List<DashboardItem> menuItems;
  final Function(int) onItemSelected;

  const NavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.menuItems,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        children: [
          // Header
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Text(
                'PreeLive Admin',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  selected: selectedIndex == index,
                  selectedTileColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  onTap: () => onItemSelected(index),
                );
              },
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('v1.0.0'),
                Icon(Icons.power_settings_new),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final Widget screen;

  DashboardItem(this.title, this.icon, this.screen);
}

// =============== SCREENS =============== //

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          StatsOverview(),
          SizedBox(height: 20),
          RecentActivityPanel(),
        ],
      ),
    );
  }
}

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(
        repository: context.read<UserRepository>(),
      )..loadUsers(),
      child: const UsersManagementView(),
    );
  }
}

class RecentActivityPanel extends StatelessWidget {
  const RecentActivityPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => StreamCubit(
              repository: context.read<StreamRepository>(),
            ),
        child: BlocBuilder<StreamCubit, StreamState>(
          builder: (context, state) {
            final activities = _generateRecentActivities(state);

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Recent Streaming Activity',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    if (activities.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: Text('No recent activity')),
                      ),
                    if (activities.isNotEmpty)
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(2),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Time',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Activity',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('User',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ...activities.map((activity) {
                            return TableRow(
                              decoration: BoxDecoration(
                                color: activities.indexOf(activity).isOdd
                                    ? Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant
                                        .withOpacity(0.3)
                                    : Colors.transparent,
                              ),
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(activity['time']!),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(activity['activity']!),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(activity['user']!),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text('View All Activity'),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  List<Map<String, String>> _generateRecentActivities(StreamState state) {
    final activities = <Map<String, String>>[];
    final now = DateTime.now();

    if (state is StreamLoaded) {
      // Add stream termination activities
      for (final stream in state.streams) {
        if (!stream.isActive) {
          final timeDiff = now.difference(stream.startTime);
          activities.add({
            'time': _formatTimeDifference(timeDiff),
            'activity': 'Stream ended: ${stream.title}',
            'user': stream.hostName,
          });
        }
      }

      // Add new streams
      for (final stream in state.streams) {
        if (stream.isActive) {
          final timeDiff = now.difference(stream.startTime);
          activities.add({
            'time': _formatTimeDifference(timeDiff),
            'activity': 'Stream started: ${stream.title}',
            'user': stream.hostName,
          });
        }
      }

      // Add popular streams
      final popularStreams =
          state.streams.where((s) => s.viewers > 1000).toList();
      for (final stream in popularStreams) {
        final timeDiff = now.difference(stream.startTime);
        activities.add({
          'time': _formatTimeDifference(timeDiff),
          'activity': 'Popular stream: ${stream.viewers} viewers',
          'user': stream.hostName,
        });
      }

      // Add high diamond streams
      final diamondStreams =
          state.streams.where((s) => s.diamonds > 500).toList();
      for (final stream in diamondStreams) {
        final timeDiff = now.difference(stream.startTime);
        activities.add({
          'time': _formatTimeDifference(timeDiff),
          'activity': 'High diamonds: ${stream.diamonds} 💎',
          'user': stream.hostName,
        });
      }
    }

    // Sort by time (newest first)
    activities.sort((a, b) {
      // Implement sorting logic based on actual time if needed
      return 0;
    });

    // Take only last 5
    return activities.take(5).toList();
  }

  String _formatTimeDifference(Duration duration) {
    if (duration.inSeconds < 60) {
      return 'Just now';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} mins ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hours ago';
    } else {
      return '${duration.inDays} days ago';
    }
  }
}


class StreamsScreen extends StatelessWidget {
  const StreamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StreamCubit(
        repository: context.read<StreamRepository>(),
      ),
      child: const StreamsManagementView(),
    );
  }
}
class StreamsManagementView extends StatefulWidget {
  const StreamsManagementView({super.key});

  @override
  State<StreamsManagementView> createState() => _StreamsManagementViewState();
}

class _StreamsManagementViewState extends State<StreamsManagementView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<StreamCubit>().loadInitialData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isEmpty) {
        context.read<StreamCubit>().refreshStreams();
      } else {
        context.read<StreamCubit>().searchStreams(value);
      }
    });
  }

  void _showCreateDialog() {
    final titleController = TextEditingController();
    final hostIdController = TextEditingController();
    final hostNameController = TextEditingController();
    final partyController = TextEditingController();
    final channelController = TextEditingController();
    final viewersController = TextEditingController(text: '0');
    final diamondsController = TextEditingController(text: '0');
    String liveType = 'audio';
    String battleStatus = 'inactive';
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Stream'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: hostIdController, decoration: const InputDecoration(labelText: 'Host ID')),
              TextField(controller: hostNameController, decoration: const InputDecoration(labelText: 'Host Name')),
              TextField(controller: viewersController, decoration: const InputDecoration(labelText: 'Viewers')),
              TextField(controller: diamondsController, decoration: const InputDecoration(labelText: 'Diamonds')),
              TextField(controller: partyController, decoration: const InputDecoration(labelText: 'Party Type')),
              TextField(controller: channelController, decoration: const InputDecoration(labelText: 'Streaming Channel')),
              DropdownButton<String>(
                value: liveType,
                items: ['audio', 'video'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => liveType = val!),
              ),
              DropdownButton<String>(
                value: battleStatus,
                items: ['active', 'inactive'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => battleStatus = val!),
              ),
              SwitchListTile(
                title: const Text('Private'),
                value: isPrivate,
                onChanged: (val) => setState(() => isPrivate = val),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final stream = LiveStream(
                id: '',
                title: titleController.text,
                hostId: hostIdController.text,
                hostName: hostNameController.text,
                viewers: int.tryParse(viewersController.text) ?? 0,
                startTime: DateTime.now(),
                thumbnailUrl: '',
                isActive: true,
                diamonds: int.tryParse(diamondsController.text) ?? 0,
                battleStatus: battleStatus,
                liveType: liveType,
                isPrivate: isPrivate,
                hashtags: [],
                numberOfChairs: 0,
                partyType: partyController.text,
                streamingChannel: channelController.text,
              );
              context.read<StreamCubit>().repository.createStream(stream);
              context.read<StreamCubit>().refreshStreams();
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamCubit, StreamState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildFilters(context, state),
              const SizedBox(height: 16),
              _buildStatsRow(),
              const SizedBox(height: 24),
              Expanded(child: _buildStreamsGrid(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Active Live Streams', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<StreamCubit>().refreshStreams(),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showCreateDialog,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search streams...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            context.read<StreamCubit>().refreshStreams();
          },
        ),
      ),
      onChanged: _onSearchChanged,
    );
  }

  Widget _buildFilters(BuildContext context, StreamState state) {
    final currentFilter = (state is StreamLoaded) ? state.filter ?? 'all' : 'all';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in ['all', 'battle', 'private', 'audio', 'popular'])
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(filter[0].toUpperCase() + filter.substring(1)),
                selected: currentFilter == filter,
                onSelected: (_) => context.read<StreamCubit>().filterStreams(filter),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return BlocSelector<StreamCubit, StreamState, int>(
      selector: (state) => state is StreamLoaded ? state.streams.fold(0, (sum, s) => sum + s.viewers) : 0,
      builder: (context, totalViewers) {
        return BlocSelector<StreamCubit, StreamState, int>(
          selector: (state) => state is StreamLoaded ? state.streams.length : 0,
          builder: (context, activeStreams) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Active Streams', activeStreams.toString(), Icons.live_tv),
                _buildStatCard('Total Viewers', totalViewers.toString(), Icons.people),
                _buildStatCard('Live Battles', (activeStreams ~/ 3).toString(), Icons.sports_esports),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamsGrid(BuildContext context, StreamState state) {
    if (state is StreamInitial || state is StreamLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is StreamError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<StreamCubit>().refreshStreams(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is StreamLoaded) {
      if (state.streams.isEmpty) {
        return const Center(child: Text('No active streams found', style: TextStyle(fontSize: 18)));
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.pixels == notification.metrics.maxScrollExtent) {
            context.read<StreamCubit>().loadMore();
          }
          return false;
        },
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: state.streams.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.streams.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final stream = state.streams[index];
            return StreamCard(stream: stream);
          },
        ),
      );
    }

    return const Center(child: Text('Unknown state'));
  }
} // ✅ تم دمج التعديلات المطلوبة بالكامل: // - Dialog لإنشاء بث جديد // - تأكيد عند إنهاء البث // - شاشة تفاصيل البث // - Action لتحديث حالة الباتل

class StreamCard extends StatelessWidget {
  final LiveStream stream;
  const StreamCard({super.key, required this.stream});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showStreamDetails(context, stream),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildThumbnail(context),
            _buildStreamInfo(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color: Colors.grey[200],
            image: stream.thumbnailUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(stream.thumbnailUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: stream.thumbnailUrl.isEmpty
              ? const Center(
                  child: Icon(Icons.live_tv, size: 50, color: Colors.red))
              : null,
        ),
        if (stream.isActive)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('LIVE',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ),
        if (stream.battleStatus == 'active')
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('BATTLE',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ),
      ],
    );
  }

  Widget _buildStreamInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stream.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundImage: stream.thumbnailUrl.isNotEmpty
                    ? NetworkImage(stream.thumbnailUrl)
                    : null,
                child: stream.thumbnailUrl.isEmpty
                    ? const Icon(Icons.person, size: 12)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(stream.hostName,
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildStatIcon(Icons.people, '${stream.viewers}'),
              const SizedBox(width: 8),
              _buildStatIcon(Icons.diamond, '${stream.diamonds}'),
              if (stream.isPrivate) const SizedBox(width: 8),
              if (stream.isPrivate)
                const Icon(Icons.lock, size: 16, color: Colors.purple),
            ],
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 20),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'view', child: Text('View Stream')),
              const PopupMenuItem(value: 'report', child: Text('Report')),
              const PopupMenuItem(
                  value: 'battle', child: Text('Update Battle')),
              const PopupMenuItem(value: 'terminate', child: Text('Terminate')),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
    if (value == 'view') {
    _showStreamDetails(context, stream);
    }

    if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure you want to delete this stream?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          context.read<StreamCubit>().deleteStream(stream.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deleted stream: ${stream.title}'),
                              backgroundColor: Colors.black87,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              }
    if (value == 'terminate') {
      final confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Termination'),
          content: Text(
              'Are you sure you want to terminate: ${stream.title}?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Terminate')),
          ],
        ),
      );
      if (confirmed ?? false) {
        context.read<StreamCubit>().terminateStream(stream.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Terminated stream: ${stream.title}'),
            backgroundColor: Colors.red));
      }
    }
    if (value == 'battle') {
    showDialog(
    context: context,
    builder: (_) => BattleUpdateDialog(stream: stream),
    );
    }

            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showStreamDetails(BuildContext context, LiveStream stream) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stream.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Host: ${stream.hostName}'),
            Text('Viewers: ${stream.viewers}'),
            Text('Diamonds: ${stream.diamonds}'),
            Text('Private: ${stream.isPrivate}'),
            Text('Battle Status: ${stream.battleStatus}'),
            Text('Hashtags: ${stream.hashtags.join(", ")}'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
        ],
      ),
    );
  }
}
class BattleUpdateDialog extends StatefulWidget {
  final LiveStream stream;
  const BattleUpdateDialog({super.key, required this.stream});

  @override
  State<BattleUpdateDialog> createState() => _BattleUpdateDialogState();
}

class _BattleUpdateDialogState extends State<BattleUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  String battleStatus = 'ended';
  int myPoints = 0;
  int hisPoints = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Battle Status'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: battleStatus,
              items: const [
                DropdownMenuItem(value: 'started', child: Text('Started')),
                DropdownMenuItem(value: 'ongoing', child: Text('Ongoing')),
                DropdownMenuItem(value: 'ended', child: Text('Ended')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => battleStatus = val);
              },
              decoration: const InputDecoration(labelText: 'Battle Status'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'My Points'),
              keyboardType: TextInputType.number,
              onChanged: (val) => myPoints = int.tryParse(val) ?? 0,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'His Points'),
              keyboardType: TextInputType.number,
              onChanged: (val) => hisPoints = int.tryParse(val) ?? 0,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<StreamCubit>().updateBattleStatus(
              widget.stream.id,
              battleStatus,
              myPoints,
              hisPoints,
            );
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Battle status updated')),
            );
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
class StatsOverview extends StatelessWidget {
  const StatsOverview({super.key});

  Future<Map<String, int>> fetchStats() async {
    final userQuery = QueryBuilder<ParseObject>(ParseObject('_User'));
    final userCount = await userQuery.count();

    final streamQuery = QueryBuilder<ParseObject>(ParseObject('Streaming'))
      ..whereEqualTo('streaming', true);
    final activeStreamsCount = await streamQuery.count();

    return {
      'users': userCount.count ?? 0,
      'activeStreams': activeStreamsCount.count ?? 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: fetchStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Failed to load statistics');
        }

        final stats = snapshot.data!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Platform Statistics', style: TextStyle(fontSize: 18)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Total Users', '${stats['users']}', Icons.people),
                    _buildStatItem('Active Streams', '${stats['activeStreams']}', Icons.live_tv),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 40),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 24)),
      ],
    );
  }
}
class UsersManagementView extends StatefulWidget {
  const UsersManagementView({super.key});

  @override
  State<UsersManagementView> createState() => _UsersManagementViewState();
}

class _UsersManagementViewState extends State<UsersManagementView> {
  String? selectedUserId;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUsers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = _searchController.text.trim();
      if (query.isEmpty) {
        context.read<UserCubit>().loadUsers();
      } else {
        context.read<UserCubit>().searchUsers(query);
      }
    });
  }

  UserModel? _getSelectedUser(UserState state) {
    if (selectedUserId == null || state is! UserLoaded) return null;
    return state.users.firstWhere(
          (u) => u.id == selectedUserId,
      orElse: () => UserModel.empty(),
    );
  }

  void _refreshSelection(UserModel updatedUser) {
    setState(() {
      selectedUserId = updatedUser.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final selectedUser = _getSelectedUser(state);
        final isLoading = state is UserLoading || state is UserActionInProgress;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search users...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();           // امسح البحث
                            FocusScope.of(context).unfocus();    // اقفل الكيبورد
                            context.read<UserCubit>().loadUsers(); // رجع الجدول كامل (لو عندك method زي دي)
                          },
                        ),
                    ],
                  ),
                ),
                onChanged: (value) {
                  context.read<UserCubit>().searchUsers(value); // لو عندك سيرش مباشر
                },
              ),
            ),
            _buildActionsBar(context, selectedUser),
            const SizedBox(height: 12),
            Expanded(child: _buildMainContent(context, state, selectedUser)),
          ],
        );
      },
    );
  }

  Widget _buildActionsBar(BuildContext context, UserModel? selectedUser) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ActionButton(
          icon: selectedUser?.isBlocked == true ? Icons.lock_open : Icons.block,
          label:
          selectedUser?.isBlocked == true ? 'Unblock User' : 'Block User',
          onPressed: selectedUser == null
              ? null
              : () {
            if (selectedUser.isBlocked) {
              context.read<UserCubit>().unblockUser(selectedUser.id);
            } else {
              _showBlockDialog(context, selectedUser);
            }
          },
        ),
    ActionButton(
    icon: selectedUser?.isBanned == true ? Icons.lock_open : Icons.gavel,
    label: selectedUser?.isBanned == true ? 'Unban User' : 'Ban User',
    color: Colors.red,
    onPressed: selectedUser == null
    ? null
        : () {
    if (selectedUser.isBanned) {
    context.read<UserCubit>().unbanUser(selectedUser.id);
    } else {
    _showBanDialog(context, selectedUser);
    }
    },),
        ActionButton(
          icon: Icons.edit,
          label: 'Edit User',
          onPressed: selectedUser == null
              ? null
              : () {
            _showEditUserDialog(context, selectedUser);
          },
        ),
        ActionButton(
          icon: Icons.delete,
          label: 'Delete User',
          color: Colors.red,
          onPressed: selectedUser == null
              ? null
              : () {
            _showDeleteUserDialog(context, selectedUser);
          },
        ),
        ActionButton(
          icon: Icons.phone_android,
          label: selectedUser?.isDeviceBlocked == true
              ? 'Unblock Device'
              : 'Block Device',
          color: Colors.deepOrange,
          onPressed: selectedUser == null
              ? null
              : () {
            if (selectedUser.isDeviceBlocked) {
              context.read<UserCubit>().unblockDevice(
                selectedUser.id,
                selectedUser.deviceId,
              );
            } else {
              _showBlockDeviceDialog(context, selectedUser);
            }
          },
        ),
        ActionButton(
          icon: Icons.add,
          label: 'Create User',
          color: Colors.green,
          onPressed: () => _showCreateUserDialog(context),
        ),
      ],
    );
  }

  Widget _buildMainContent(
      BuildContext context, UserState state, UserModel? selectedUser) {
    if (state is UserInitial ||
        state is UserLoading ||
        state is UserActionInProgress) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is UserError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<UserCubit>().loadUsers(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is UserLoaded) {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: UserDataTable(
              users: state.users,
              selectedUserId: selectedUserId,
              onUserSelected: (userId) {
                setState(() => selectedUserId = userId);
              },
            ),
          ),
          if (selectedUser != null)
            Expanded(
              flex: 2,
              child:
   UserProfile(
    user: selectedUser!,
    onClose: () {
    setState(() => selectedUser = null);
    },
    )
            ),
        ],
      );
    }

    return const Center(child: Text('Unknown state'));
  }

  // ==== Dialogs below ====

  void _showBlockDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => BlockDurationDialog(
        onBlock: (duration) async {
          await context.read<UserCubit>().blockUser(user.id, duration);
          if (mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showBanDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => BlockDurationDialog(
        onBlock: (duration) async {
          await context.read<UserCubit>().banUser(user.id, duration);
          if (mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showBlockDeviceDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => BlockDurationDialog(
        onBlock: (duration) async {
          await context
              .read<UserCubit>()
              .blockDevice(user.id, user.deviceId, duration);
          if (mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showDeleteUserDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await context.read<UserCubit>().deleteUser(user.id);
              setState(() => selectedUserId = null);
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CreateUserDialog(
        onCreate: (userData) async {
          await context.read<UserCubit>().createUser(userData);
          if (mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => EditUserDialog(
        user: user,
        onUpdate: (updates) async {
          await context.read<UserCubit>().updateUser(user.id, updates);
          if (mounted) Navigator.pop(ctx);
        },
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  const ActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onPressed: onPressed,
    );
  }
}

class BlockDurationDialog extends StatelessWidget {
  final Function(Duration) onBlock;

  const BlockDurationDialog({required this.onBlock});

  @override
  Widget build(BuildContext context) {
    Duration selectedDuration = const Duration(days: 1);

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Select Block Duration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('1 Hour'),
                leading: Radio<Duration>(
                  value: const Duration(hours: 1),
                  groupValue: selectedDuration,
                  onChanged: (value) =>
                      setState(() => selectedDuration = value!),
                ),
              ),
              ListTile(
                title: const Text('1 Day'),
                leading: Radio<Duration>(
                  value: const Duration(days: 1),
                  groupValue: selectedDuration,
                  onChanged: (value) =>
                      setState(() => selectedDuration = value!),
                ),
              ),
              ListTile(
                title: const Text('1 Week'),
                leading: Radio<Duration>(
                  value: const Duration(days: 7),
                  groupValue: selectedDuration,
                  onChanged: (value) =>
                      setState(() => selectedDuration = value!),
                ),
              ),
              ListTile(
                title: const Text('1 Month'),
                leading: Radio<Duration>(
                  value: const Duration(days: 30),
                  groupValue: selectedDuration,
                  onChanged: (value) =>
                      setState(() => selectedDuration = value!),
                ),
              ),
              ListTile(
                title: const Text('Permanent'),
                leading: Radio<Duration>(
                  value: const Duration(days: 365 * 100), // 100 years
                  groupValue: selectedDuration,
                  onChanged: (value) =>
                      setState(() => selectedDuration = value!),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onBlock(selectedDuration);
                Navigator.pop(context);
              },
              child: const Text('Block'),
            ),
          ],
        );
      },
    );
  }
}

class BlockDeviceDialog extends StatefulWidget {
  final Function(Duration) onBlock;

  const BlockDeviceDialog({required this.onBlock});

  @override
  _BlockDeviceDialogState createState() => _BlockDeviceDialogState();
}

class _BlockDeviceDialogState extends State<BlockDeviceDialog> {
  Duration _duration = const Duration(days: 1);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Block Device'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select blocking duration:'),
          DropdownButton<Duration>(
            value: _duration,
            items: const [
              DropdownMenuItem(
                value: Duration(hours: 1),
                child: Text('1 Hour'),
              ),
              DropdownMenuItem(
                value: Duration(days: 1),
                child: Text('1 Day'),
              ),
              DropdownMenuItem(
                value: Duration(days: 7),
                child: Text('1 Week'),
              ),
              DropdownMenuItem(
                value: Duration(days: 30),
                child: Text('1 Month'),
              ),
              DropdownMenuItem(
                value: Duration(days: 365),
                child: Text('Permanent'),
              ),
            ],
            onChanged: (v) => setState(() => _duration = v!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onBlock(_duration);
            Navigator.pop(context);
          },
          child: const Text('Block'),
        ),
      ],
    );
  }
}
// // ================ CreateUserDialog ================
class CreateUserDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onCreate;

  const CreateUserDialog({required this.onCreate});

  @override
  _CreateUserDialogState createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _userData = {
    'username': '',
    'password': '',
    'email': '',
    'name': '',
    'role': 'user',
    'country': '',
    'diamonds': 0,
    'userPoints': 0,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New User'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                onChanged: (v) => _userData['username'] = v.trim(),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (v) => _userData['password'] = v,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => _userData['email'] = v.trim(),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                onChanged: (v) => _userData['name'] = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Country'),
                onChanged: (v) => _userData['country'] = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Diamonds'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _userData['diamonds'] = int.tryParse(v) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Points'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _userData['userPoints'] = int.tryParse(v) ?? 0,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _userData['role'],
                decoration: const InputDecoration(labelText: 'Role'),
                items: ['user', 'admin', 'agent'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _userData['role'] = value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onCreate(_userData);
              Navigator.pop(context);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
// ================ EditUserDialog ================
class EditUserDialog extends StatefulWidget {
  final UserModel user;
  final Function(Map<String, dynamic>) onUpdate;

  const EditUserDialog({required this.user, required this.onUpdate});

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late Map<String, dynamic> _updates;

  @override
  void initState() {
    super.initState();
    _updates = {
      'name': widget.user.name,
      'role': widget.user.role,
      'diamonds': widget.user.diamonds,
      'credit': widget.user.credit,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.user.name}'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // TextFormField(
            //   initialValue: _updates['name'] ?? '',
            //   decoration: const InputDecoration(labelText: 'Full Name'),
            //   onChanged: (v) => _updates['name'] = v,
            // ),
            TextFormField(
              initialValue: _updates['credit']?.toString() ?? '',
              decoration: const InputDecoration(labelText: 'credit'),
              keyboardType: TextInputType.number,
              onChanged: (v) => _updates['credit'] = int.tryParse(v) ?? 0,
            ),
            // TextFormField(
            //   initialValue: _updates['email'] ?? '',
            //   decoration: const InputDecoration(labelText: 'Email'),
            //   keyboardType: TextInputType.emailAddress,
            //   onChanged: (v) => _updates['email'] = v,
            // ),
            TextFormField(
              initialValue: _updates['diamonds']?.toString() ?? '',
              decoration: const InputDecoration(labelText: 'Diamonds'),
              keyboardType: TextInputType.number,
              onChanged: (v) => _updates['diamonds'] = int.tryParse(v) ?? 0,
            ),
            DropdownButtonFormField<String>(
              value: ['user', 'admin', 'moderator'].contains(_updates['role'])
                  ? _updates['role']
                  : null,
              items: ['user', 'admin', 'moderator']
                  .map((role) => DropdownMenuItem(
                value: role,
                child: Text(role),
              ))
                  .toList(),
              onChanged: (v) => _updates['role'] = v,
              decoration: const InputDecoration(labelText: 'Role'),
              validator: (v) => v == null ? 'Please select a role' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onUpdate(_updates);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class UserDataTable extends StatelessWidget {
  final List<UserModel> users;
  final String? selectedUserId;
  final void Function(String?) onUserSelected;

  const UserDataTable({
    required this.users,
    required this.selectedUserId,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 16,
      horizontalMargin: 12,
      minWidth: 1000,
      headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
      showCheckboxColumn: false,
      columns: const [
        DataColumn2(label: Text('ID'), size: ColumnSize.S),
        DataColumn2(label: Text('Avatar'), size: ColumnSize.S),
        DataColumn2(label: Text('Name')),
        DataColumn2(label: Text('Username')),
        DataColumn2(label: Text('Email')),
        DataColumn2(label: Text('Country')),
        DataColumn2(label: Text('Role')),
        DataColumn2(label: Text('Diamonds')),
        DataColumn2(label: Text('Points')),
        DataColumn2(label: Text('Status')),
      ],
      rows: users.map((user) {
        final isSelected = selectedUserId == user.id;
        return DataRow2(
          selected: isSelected,
          onTap: () {
            final newSelection = isSelected ? null : user.id;
            onUserSelected(newSelection);
          },
          cells: [
            DataCell(Text(user.uid.toString())),
            DataCell(
              user.avatarUrl.isNotEmpty
                  ? CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl))
                  : const CircleAvatar(child: Icon(Icons.person)),
            ),
            DataCell(Text(user.name)),
            DataCell(Text(user.username)),
            DataCell(Text(user.email)),
            DataCell(Text(user.country)),
            DataCell(Text(user.role)),
            DataCell(Text(user.diamonds.toString())),
            DataCell(Text(user.userPoints.toString())),
            DataCell(_buildStatusChip(user)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatusChip(UserModel user) {
    if (user.isBanned) {
      return const Chip(
          label: Text('Banned'),
          backgroundColor: Colors.red,
          labelStyle: TextStyle(color: Colors.white));
    } else if (user.isBlocked) {
      return const Chip(
          label: Text('Blocked'),
          backgroundColor: Colors.orange,
          labelStyle: TextStyle(color: Colors.white));
    } else if (user.isDeviceBlocked) {
      return const Chip(
          label: Text('Device Blocked'),
          backgroundColor: Colors.deepOrange,
          labelStyle: TextStyle(color: Colors.white));
    }
    return const Chip(
        label: Text('Active'),
        backgroundColor: Colors.green,
        labelStyle: TextStyle(color: Colors.white));
  }
}

class UserProfile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onClose; // أضفنا ده

  const UserProfile({super.key, required this.user, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Align(
              //   alignment: Alignment.topRight,
              //   child: IconButton(
              //     icon: const Icon(Icons.close),
              //     onPressed: onClose,
              //     tooltip: 'Close Profile',
              //   ),
              // ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: user.avatarUrl.isNotEmpty
                            ? NetworkImage(user.avatarUrl)
                            : null,
                        child: user.avatarUrl.isEmpty
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(user.name, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text('@${user.username}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                      const Divider(height: 30),

                      _buildInfoRow('Email', user.email),
                      _buildInfoRow('Phone Number', user.phoneNumber),
                      _buildInfoRow('Email Verified', user.emailVerified.toString()),
                      _buildInfoRow('Photo Verified', user.photoVerified.toString()),
                      const Divider(height: 30),

                      _buildInfoRow('First Name', user.firstName),
                      _buildInfoRow('Last Name', user.lastName),
                      _buildInfoRow('Country', user.country),
                      _buildInfoRow('Gender', user.gender),
                      _buildInfoRow('Birthday', user.birthday?.toIso8601String() ?? '-'),
                      const Divider(height: 30),

                      _buildInfoRow('Diamonds', user.diamonds.toString()),
                      _buildInfoRow('User Points', user.userPoints.toString()),
                      _buildInfoRow('Credit', user.credit.toString()),
                      const Divider(height: 30),

                      _buildInfoRow('Role', user.role),
                      _buildInfoRow('Agency Role', user.agencyRole),
                      _buildInfoRow('Device ID', user.deviceId),
                      _buildInfoRow('Uid', user.uid.toString()),
                      const Divider(height: 30),

                      _buildInfoRow('Followers', user.followers.toString()),
                      _buildInfoRow('Following', user.following.toString()),
                      const Divider(height: 30),

                      _buildInfoRow('Bio', user.bio),
                      _buildInfoRow('MVP Member', user.mvpMember.toString()),
                      _buildInfoRow('Account Created At', user.createdAt?.toIso8601String() ?? '-'),
                      const SizedBox(height: 16),
                      _buildStatusChip(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    if (user.isBanned) {
      return const Chip(
        label: Text('Banned'),
        backgroundColor: Colors.red,
        labelStyle: TextStyle(color: Colors.white),
      );
    } else if (user.isBlocked) {
      return const Chip(
        label: Text('Blocked'),
        backgroundColor: Colors.orange,
        labelStyle: TextStyle(color: Colors.white),
      );
    } else if (user.isDeviceBlocked) {
      return const Chip(
        label: Text('Device Blocked'),
        backgroundColor: Colors.deepOrange,
        labelStyle: TextStyle(color: Colors.white),
      );
    }
    return const Chip(
      label: Text('Active'),
      backgroundColor: Colors.green,
      labelStyle: TextStyle(color: Colors.white),
    );
  }
}
class mainagent extends StatelessWidget {
  const mainagent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AgentCubit(
          agentRepository: context.read<AgentRepository>(),
    )..loadAgents(),
    child:AgentsScreen());}}
class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  UserModel? _selectedUser;

  @override
  void initState() {
    super.initState();
    context.read<AgentCubit>().loadAgents();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Users',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<AgentCubit>().searchUsers(value);
                  },
                ),
              ),
              const SizedBox(width: 7),
              ElevatedButton.icon(
                onPressed: _selectedUser == null
                    ? null
                    : () {
                  context.read<AgentCubit>().assignAgentRole(_selectedUser!);
                },
                icon: const Icon(Icons.person_add),
                label: const Text("Create Agent"),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _selectedUser == null
                    ? null
                    : () {
                  context.read<AgentCubit>().removeAgentRole(_selectedUser!);
                },
                icon: const Icon(Icons.remove_circle),
                label: const Text("Remove Agent"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<AgentCubit, AgentState>(
              builder: (context, state) {
                if (state is AgentLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AgentLoaded) {
                  final users = state.users;

                  return DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 1000,
                    headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn2(label: Text('Avatar'), size: ColumnSize.S),
                      DataColumn2(label: Text('Name')),
                      DataColumn2(label: Text('User ID'), size: ColumnSize.S),
                      DataColumn2(label: Text('Username')),
                      DataColumn2(label: Text('Role / Status')),
                    ],
                    rows: users.map((user) {
                      final isSelected = _selectedUser?.id == user.id;
                      return DataRow2(
                        selected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedUser = isSelected ? null : user;
                          });
                        },
                        cells: [
                          DataCell(
                            user.avatarUrl.isNotEmpty
                                ? CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl))
                                : const CircleAvatar(child: Icon(Icons.person)),
                          ),
                          DataCell(Text(user.name ?? '-')),
                          DataCell(Text(user.id.substring(0, 6))),
                          DataCell(Text(user.username ?? '-')),
                          DataCell(
                            user.agencyRole != null
                                ? Text(user.agencyRole!, style: const TextStyle(color: Colors.green))
                                : const Text("Available", style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                } else if (state is AgentError) {
                  return Center(child: Text(state.message));
                }else {
                  // حالة غير متوقعة: نحاول نرجّع الداتا تاني
                  context.read<AgentCubit>().loadAgents();
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class shipingagent extends StatelessWidget {
  const shipingagent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ShippingAgentCubit(
          repository: context.read<ShippingAgentRepository>(),
        )..loadUsers(),
        child:ShippingPointsScreen());}}
class ShippingPointsScreen extends StatefulWidget {
  const ShippingPointsScreen({super.key});

  @override
  State<ShippingPointsScreen> createState() => _ShippingPointsScreenState();
}

class _ShippingPointsScreenState extends State<ShippingPointsScreen> {
  String? selectedUserId;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _searchController.text.isEmpty) {
        context.read<ShippingAgentCubit>().loadUsers();
      }
    });

  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showEditDialog(UserModel user, TextEditingController controller) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final pointsController = TextEditingController(text: controller.text);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: pointsController,
              decoration: const InputDecoration(labelText: 'Points'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final int? newPoints = int.tryParse(pointsController.text);
              if (newPoints != null) {
                context.read<ShippingAgentCubit>().updatePoints(user.id, newPoints);
                controller.text = newPoints.toString();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter valid points')),
                );
              }
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Search Users',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        context.read<ShippingAgentCubit>().loadUsers(); // يرجع كل المستخدمين
                        setState(() {}); // علشان يخفي زر X
                      },
                    )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<ShippingAgentCubit>().searchUsers(value);
                    setState(() {}); // لتحديث حالة زر X
                  },
                ),
              ),
              const SizedBox(width: 12),
              // ElevatedButton.icon(
              //   onPressed: selectedUserId == null
              //       ? null
              //       : () {
              //     final userId = selectedUserId!;
              //     final state = context.read<ShippingAgentCubit>().state;
              //     if (state is! ShippingAgentLoaded) return;
              //
              //     final user = state.users.firstWhere((u) => u.id == userId);
              //     final controller = context
              //         .findAncestorStateOfType<_ShippingPointsTableState>()
              //         ?._controllers[userId];
              //
              //     if (controller != null) {
              //       _showEditDialog(user, controller);
              //     }
              //   },
              //   icon: const Icon(Icons.edit),
              //   label: const Text('Edit Selected'),
              // ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child:BlocBuilder<ShippingAgentCubit, ShippingAgentState>(
              builder: (context, state) {
                if (state is ShippingAgentLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ShippingAgentLoaded) {
                  return ShippingPointsTable(
                    users: state.users,
                    selectedUserId: selectedUserId,
                    onUserSelected: (id) {
                      setState(() {
                        selectedUserId = (selectedUserId == id) ? null : id;
                      });
                    },
                    onUpdatePressed: (userId, points) {
                      context.read<ShippingAgentCubit>().updatePoints(userId, points);
                    },
                  );
                } else {
                  // حالة غير متوقعة: نحاول نرجّع الداتا تاني
                  context.read<ShippingAgentCubit>().loadUsers();
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
class ShippingPointsTable extends StatefulWidget {
  final List<UserModel> users;
  final String? selectedUserId;
  final void Function(String userId, int points) onUpdatePressed;
  final void Function(String?) onUserSelected;

  const ShippingPointsTable({
    super.key,
    required this.users,
    required this.selectedUserId,
    required this.onUpdatePressed,
    required this.onUserSelected,
  });

  @override
  State<ShippingPointsTable> createState() => _ShippingPointsTableState();
}

class _ShippingPointsTableState extends State<ShippingPointsTable> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 1100,
      headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
      showCheckboxColumn: false,
      columns: const [
        DataColumn2(label: Text('Avatar'), size: ColumnSize.S),
        DataColumn2(label: Text('Name')),
        DataColumn2(label: Text('User ID')),
        DataColumn2(size:ColumnSize.L,label: Text('Points')),
        DataColumn2(label: Text('Update')),
      ],
      rows: widget.users.map((user) {
        final isSelected = widget.selectedUserId == user.id;
        if (_controllers.containsKey(user.id)) {
          _controllers[user.id]!.text = user.userPoints.toString();
        } else {
          _controllers[user.id] = TextEditingController(text: user.userPoints.toString());
        }

        return DataRow2(
          selected: isSelected,
          onTap: () {
            final selected = widget.selectedUserId == user.id ? null : user.id;
            widget.onUserSelected(selected);
          },
          cells: [
            DataCell(
              user.avatarUrl.isNotEmpty
                  ? CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl))
                  : const CircleAvatar(child: Icon(Icons.person)),
            ),
            DataCell(Text(user.name ?? '-')),
            DataCell(Text(user.id.substring(0, 6))),
            DataCell(
              SizedBox(
                width: 150,
                child: TextField(
                  controller: _controllers[user.id],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
            ),
            DataCell(
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  final controller = _controllers[user.id]!;
                  final newPoints = int.tryParse(controller.text);
                  if (newPoints != null) {
                    widget.onUpdatePressed(user.id, newPoints);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Points updated')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid points')),
                    );
                  }
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}