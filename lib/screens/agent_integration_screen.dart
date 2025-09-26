import 'package:flutter/material.dart';
import '../models/property.dart';

/**
 * Agent Integration Screen
 * 
 * Provides functionality to connect with real estate agents and MLS systems.
 * Allows users to find agents, schedule viewings, and access MLS data.
 * 
 * @author Aibodes Development Team
 * @version 1.0.0
 * @since 2024-01-01
 */
class AgentIntegrationScreen extends StatefulWidget {
  /// Optional property for agent consultation
  final Property? property;

  const AgentIntegrationScreen({
    Key? key,
    this.property,
  }) : super(key: key);

  @override
  State<AgentIntegrationScreen> createState() => _AgentIntegrationScreenState();
}

/**
 * State class for Agent Integration Screen
 * 
 * Manages agent data, MLS connections, and user interactions.
 */
class _AgentIntegrationScreenState extends State<AgentIntegrationScreen>
    with TickerProviderStateMixin {
  /// Tab controller for different agent services
  late TabController _tabController;
  
  /// List of available agents
  List<RealEstateAgent> _agents = [];
  
  /// List of MLS systems
  List<MLSSystem> _mlsSystems = [];
  
  /// Loading state indicator
  bool _isLoading = true;
  
  /// Error message if data loading fails
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAgentData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /**
   * Loads agent and MLS data
   * 
   * In a real implementation, this would make API calls to fetch
   * agent information and MLS system data.
   */
  Future<void> _loadAgentData() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock agent and MLS data
      setState(() {
        _agents = _generateMockAgents();
        _mlsSystems = _generateMockMLSSystems();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load agent data: $e';
        _isLoading = false;
      });
    }
  }

  /**
   * Generates mock real estate agents for demonstration
   * 
   * @return List of mock RealEstateAgent objects
   */
  List<RealEstateAgent> _generateMockAgents() {
    return [
      RealEstateAgent(
        id: 'agent_001',
        name: 'Sarah Johnson',
        company: 'Premier Realty Group',
        phone: '(555) 123-4567',
        email: 'sarah.johnson@premierrealty.com',
        licenseNumber: 'RE123456',
        experience: 8,
        rating: 4.9,
        specialties: ['Residential', 'Luxury Homes', 'First-time Buyers'],
        languages: ['English', 'Spanish'],
        profileImage: 'https://via.placeholder.com/150',
        bio: 'With over 8 years of experience in the real estate market, Sarah specializes in helping first-time buyers find their dream homes.',
        recentSales: 45,
        averageDaysOnMarket: 12,
        isAvailable: true,
      ),
      RealEstateAgent(
        id: 'agent_002',
        name: 'Michael Chen',
        company: 'Elite Properties',
        phone: '(555) 987-6543',
        email: 'michael.chen@eliteproperties.com',
        licenseNumber: 'RE789012',
        experience: 12,
        rating: 4.8,
        specialties: ['Commercial', 'Investment Properties', 'Luxury Homes'],
        languages: ['English', 'Mandarin'],
        profileImage: 'https://via.placeholder.com/150',
        bio: 'Michael is a top-performing agent with expertise in commercial and investment properties.',
        recentSales: 78,
        averageDaysOnMarket: 8,
        isAvailable: true,
      ),
      RealEstateAgent(
        id: 'agent_003',
        name: 'Emily Rodriguez',
        company: 'Dream Home Realty',
        phone: '(555) 456-7890',
        email: 'emily.rodriguez@dreamhomerealty.com',
        licenseNumber: 'RE345678',
        experience: 5,
        rating: 4.7,
        specialties: ['Residential', 'Condos', 'Townhouses'],
        languages: ['English', 'Spanish', 'Portuguese'],
        profileImage: 'https://via.placeholder.com/150',
        bio: 'Emily focuses on residential properties and has a strong track record with condos and townhouses.',
        recentSales: 32,
        averageDaysOnMarket: 15,
        isAvailable: false,
      ),
    ];
  }

  /**
   * Generates mock MLS systems for demonstration
   * 
   * @return List of mock MLSSystem objects
   */
  List<MLSSystem> _generateMockMLSSystems() {
    return [
      MLSSystem(
        id: 'mls_001',
        name: 'Multiple Listing Service (MLS)',
        description: 'Comprehensive database of all active real estate listings',
        coverage: 'National',
        listingCount: 2500000,
        updateFrequency: 'Real-time',
        accessLevel: 'Professional',
        features: [
          'Complete property details',
          'Historical sales data',
          'Market analytics',
          'Agent contact information',
        ],
        isConnected: true,
      ),
      MLSSystem(
        id: 'mls_002',
        name: 'Regional MLS',
        description: 'Local market listings and data for the tri-state area',
        coverage: 'Tri-State Area',
        listingCount: 125000,
        updateFrequency: 'Every 15 minutes',
        accessLevel: 'Regional',
        features: [
          'Local market insights',
          'Neighborhood statistics',
          'School district information',
          'Commute time data',
        ],
        isConnected: true,
      ),
      MLSSystem(
        id: 'mls_003',
        name: 'Luxury Property Network',
        description: 'Exclusive listings for high-end properties',
        coverage: 'National',
        listingCount: 45000,
        updateFrequency: 'Daily',
        accessLevel: 'Premium',
        features: [
          'Luxury property listings',
          'Private showings',
          'Concierge services',
          'Investment analysis',
        ],
        isConnected: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent & MLS Integration'),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue[700],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.blue[700],
          tabs: const [
            Tab(text: 'Find Agents'),
            Tab(text: 'MLS Systems'),
            Tab(text: 'Schedule Viewing'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAgentsTab(),
                    _buildMLSTab(),
                    _buildScheduleTab(),
                  ],
                ),
    );
  }

  /**
   * Builds the error widget when data loading fails
   * 
   * @return Widget displaying error message and retry button
   */
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
              _loadAgentData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /**
   * Builds the agents tab with available real estate agents
   * 
   * @return Widget displaying agent information
   */
  Widget _buildAgentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _agents.length,
      itemBuilder: (context, index) {
        final agent = _agents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Agent header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(agent.profileImage),
                      child: agent.profileImage.isEmpty
                          ? const Icon(Icons.person, size: 30)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            agent.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            agent.company,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Row(
                            children: [
                              ...List.generate(5, (i) => Icon(
                                i < agent.rating.floor() ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              )),
                              const SizedBox(width: 8),
                              Text('${agent.rating} (${agent.recentSales} sales)'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: agent.isAvailable ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        agent.isAvailable ? 'Available' : 'Busy',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Agent bio
                Text(
                  agent.bio,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Specialties
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: agent.specialties.map((specialty) => 
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        specialty,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ).toList(),
                ),
                
                const SizedBox(height: 12),
                
                // Contact buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _contactAgent(agent, 'call'),
                        icon: const Icon(Icons.phone),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.blue[300]!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _contactAgent(agent, 'message'),
                        icon: const Icon(Icons.message),
                        label: const Text('Message'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /**
   * Builds the MLS systems tab
   * 
   * @return Widget displaying MLS system information
   */
  Widget _buildMLSTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mlsSystems.length,
      itemBuilder: (context, index) {
        final mls = _mlsSystems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MLS header
                Row(
                  children: [
                    Icon(
                      Icons.storage,
                      size: 32,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mls.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            mls.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: mls.isConnected ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        mls.isConnected ? 'Connected' : 'Available',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // MLS details
                _buildMLSDetail('Coverage', mls.coverage),
                _buildMLSDetail('Listings', '${mls.listingCount.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                )}'),
                _buildMLSDetail('Updates', mls.updateFrequency),
                _buildMLSDetail('Access Level', mls.accessLevel),
                
                const SizedBox(height: 12),
                
                // Features
                const Text(
                  'Features:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ...mls.features.map((feature) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        feature,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: 12),
                
                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: mls.isConnected ? null : () => _connectToMLS(mls),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mls.isConnected ? Colors.grey : Colors.blue[600],
                    ),
                    child: Text(
                      mls.isConnected ? 'Already Connected' : 'Connect to MLS',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /**
   * Builds the schedule viewing tab
   * 
   * @return Widget for scheduling property viewings
   */
  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property info (if available)
          if (widget.property != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Property for Viewing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.property!.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.property!.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      widget.property!.formattedPrice,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Schedule form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Schedule a Viewing',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Date picker
                  const Text('Preferred Date:'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _selectDate(),
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Select Date'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Time picker
                  const Text('Preferred Time:'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _selectTime(),
                    icon: const Icon(Icons.access_time),
                    label: const Text('Select Time'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Agent selection
                  const Text('Preferred Agent (Optional):'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select an agent',
                    ),
                    items: _agents.map((agent) => 
                      DropdownMenuItem(
                        value: agent.id,
                        child: Text(agent.name),
                      ),
                    ).toList(),
                    onChanged: (value) {
                      // Handle agent selection
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Notes
                  const Text('Additional Notes:'),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Any special requests or questions...',
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _submitViewingRequest(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Request Viewing',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Builds MLS detail row
   * 
   * @param label The label for the detail
   * @param value The value to display
   * @return Widget displaying the detail row
   */
  Widget _buildMLSDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  /**
   * Handles agent contact actions
   * 
   * @param agent The agent to contact
   * @param method The contact method (call or message)
   */
  void _contactAgent(RealEstateAgent agent, String method) {
    String message;
    if (method == 'call') {
      message = 'Calling ${agent.name} at ${agent.phone}...';
    } else {
      message = 'Opening message to ${agent.name}...';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue[600],
      ),
    );
  }

  /**
   * Handles MLS connection
   * 
   * @param mls The MLS system to connect to
   */
  void _connectToMLS(MLSSystem mls) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting to ${mls.name}...'),
        backgroundColor: Colors.blue[600],
      ),
    );
    
    // In a real implementation, this would initiate the connection process
    setState(() {
      mls.isConnected = true;
    });
  }

  /**
   * Handles date selection for viewing
   */
  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((date) {
      if (date != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected date: ${date.toString().split(' ')[0]}'),
            backgroundColor: Colors.blue[600],
          ),
        );
      }
    });
  }

  /**
   * Handles time selection for viewing
   */
  void _selectTime() {
    showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 14, minute: 0),
    ).then((time) {
      if (time != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected time: ${time.format(context)}'),
            backgroundColor: Colors.blue[600],
          ),
        );
      }
    });
  }

  /**
   * Handles viewing request submission
   */
  void _submitViewingRequest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Viewing request submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

/**
 * Real Estate Agent Model
 * 
 * Represents a real estate agent with their information and credentials.
 */
class RealEstateAgent {
  /// Unique identifier for the agent
  final String id;
  
  /// Agent's full name
  final String name;
  
  /// Real estate company
  final String company;
  
  /// Contact phone number
  final String phone;
  
  /// Contact email address
  final String email;
  
  /// Real estate license number
  final String licenseNumber;
  
  /// Years of experience
  final int experience;
  
  /// Customer rating (0-5)
  final double rating;
  
  /// Specialties and areas of expertise
  final List<String> specialties;
  
  /// Languages spoken
  final List<String> languages;
  
  /// Profile image URL
  final String profileImage;
  
  /// Agent biography
  final String bio;
  
  /// Number of recent sales
  final int recentSales;
  
  /// Average days on market for listings
  final int averageDaysOnMarket;
  
  /// Current availability status
  final bool isAvailable;

  /**
   * Constructor for RealEstateAgent
   */
  const RealEstateAgent({
    required this.id,
    required this.name,
    required this.company,
    required this.phone,
    required this.email,
    required this.licenseNumber,
    required this.experience,
    required this.rating,
    required this.specialties,
    required this.languages,
    required this.profileImage,
    required this.bio,
    required this.recentSales,
    required this.averageDaysOnMarket,
    required this.isAvailable,
  });
}

/**
 * MLS System Model
 * 
 * Represents a Multiple Listing Service system with its capabilities.
 */
class MLSSystem {
  /// Unique identifier for the MLS system
  final String id;
  
  /// MLS system name
  final String name;
  
  /// Description of the MLS system
  final String description;
  
  /// Geographic coverage area
  final String coverage;
  
  /// Number of active listings
  final int listingCount;
  
  /// How frequently data is updated
  final String updateFrequency;
  
  /// Access level required
  final String accessLevel;
  
  /// Available features
  final List<String> features;
  
  /// Connection status
  bool isConnected;

  /**
   * Constructor for MLSSystem
   */
  MLSSystem({
    required this.id,
    required this.name,
    required this.description,
    required this.coverage,
    required this.listingCount,
    required this.updateFrequency,
    required this.accessLevel,
    required this.features,
    required this.isConnected,
  });
}
