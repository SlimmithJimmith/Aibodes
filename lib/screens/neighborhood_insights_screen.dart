import 'package:flutter/material.dart';
import '../models/neighborhood_data.dart';
import '../models/property.dart';

/**
 * Neighborhood Insights Screen
 * 
 * Displays comprehensive neighborhood data including schools, crime rates,
 * demographics, amenities, and transportation options for a specific property.
 * 
 * @author Aibodes Development Team
 * @version 1.0.0
 * @since 2024-01-01
 */
class NeighborhoodInsightsScreen extends StatefulWidget {
  /// The property for which to display neighborhood insights
  final Property property;

  const NeighborhoodInsightsScreen({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<NeighborhoodInsightsScreen> createState() => _NeighborhoodInsightsScreenState();
}

/**
 * State class for Neighborhood Insights Screen
 * 
 * Manages the state of neighborhood data and UI interactions.
 */
class _NeighborhoodInsightsScreenState extends State<NeighborhoodInsightsScreen>
    with TickerProviderStateMixin {
  /// Tab controller for managing different insight categories
  late TabController _tabController;
  
  /// Neighborhood data for the property
  NeighborhoodData? _neighborhoodData;
  
  /// Loading state indicator
  bool _isLoading = true;
  
  /// Error message if data loading fails
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadNeighborhoodData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /**
   * Loads neighborhood data for the property
   * 
   * In a real implementation, this would make an API call to fetch
   * neighborhood data based on the property's location.
   */
  Future<void> _loadNeighborhoodData() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock neighborhood data - in real app, this would come from API
      setState(() {
        _neighborhoodData = _generateMockNeighborhoodData();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load neighborhood data: $e';
        _isLoading = false;
      });
    }
  }

  /**
   * Generates mock neighborhood data for demonstration
   * 
   * @return Mock NeighborhoodData object
   */
  NeighborhoodData _generateMockNeighborhoodData() {
    return NeighborhoodData(
      id: 'neighborhood_001',
      name: 'Downtown District',
      location: 'New York, NY 10001',
      timestamp: DateTime.now(),
      overallScore: 85,
      walkabilityScore: 85,
      bikeabilityScore: 72,
      transitScore: 78,
      schools: SchoolData(
        districtRating: 88,
        schools: [
          School(
            name: 'Lincoln Elementary School',
            type: SchoolType.elementary,
            rating: 85,
            distanceMiles: 0.3,
            studentCount: 450,
            address: '123 Lincoln Ave, New York, NY',
          ),
          School(
            name: 'Roosevelt High School',
            type: SchoolType.high,
            rating: 92,
            distanceMiles: 0.8,
            studentCount: 1200,
            address: '456 Roosevelt St, New York, NY',
          ),
          School(
            name: 'St. Mary\'s Academy',
            type: SchoolType.private,
            rating: 98,
            distanceMiles: 1.2,
            studentCount: 300,
            address: '789 St. Mary\'s Blvd, New York, NY',
          ),
        ],
        averageTestScores: TestScores(
          averageSAT: 1250,
          averageACT: 28,
          mathProficiency: 78.5,
          readingProficiency: 82.3,
        ),
        studentTeacherRatio: 15.2,
        advancedProgramsPercentage: 35.8,
      ),
      crime: CrimeData(
        overallScore: 75,
        violentCrimeRate: 1.8,
        propertyCrimeRate: 4.5,
        trend: CrimeTrend.decreasing,
        safetyComparison: SafetyComparison.safer,
      ),
      amenities: AmenitiesData(
        restaurants: [
          Amenity(
            name: 'Central Park',
            type: AmenityType.park,
            distanceMiles: 0.2,
            rating: 4.8,
            address: 'Central Park, New York, NY',
          ),
        ],
        shopping: [
          Amenity(
            name: 'Downtown Shopping Center',
            type: AmenityType.shopping,
            distanceMiles: 0.4,
            rating: 4.5,
            address: '100 Main St, New York, NY',
          ),
        ],
        parks: [
          Amenity(
            name: 'Central Park',
            type: AmenityType.park,
            distanceMiles: 0.2,
            rating: 4.8,
            address: 'Central Park, New York, NY',
          ),
        ],
        healthcare: [
          Amenity(
            name: 'City Hospital',
            type: AmenityType.healthcare,
            distanceMiles: 0.6,
            rating: 4.7,
            address: '200 Medical Dr, New York, NY',
          ),
        ],
        entertainment: [
          Amenity(
            name: 'Public Library',
            type: AmenityType.entertainment,
            distanceMiles: 0.3,
            rating: 4.6,
            address: '300 Library Ave, New York, NY',
          ),
        ],
        groceryStores: 5,
        gasStations: 3,
      ),
      demographics: DemographicsData(
        population: 15420,
        medianAge: 34.5,
        medianIncome: 75000,
        collegeEducationPercentage: 65.2,
        familiesWithChildrenPercentage: 42.8,
        diversityIndex: 78.0,
      ),
      transportation: TransportationData(
        averageCommuteTime: 25,
        publicTransitScore: 78,
        busStops: 12,
        trainStations: 3,
        airportDistance: 12.5,
        nearbyHighways: [
          'I-95 (2.1 mi)',
          'Route 101 (1.8 mi)',
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neighborhood Insights'),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.blue[700],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.blue[700],
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Schools'),
            Tab(text: 'Amenities'),
            Tab(text: 'Safety'),
            Tab(text: 'Transportation'),
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
                    _buildOverviewTab(),
                    _buildSchoolsTab(),
                    _buildAmenitiesTab(),
                    _buildSafetyTab(),
                    _buildTransportationTab(),
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
              _loadNeighborhoodData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /**
   * Builds the overview tab with key neighborhood metrics
   * 
   * @return Widget displaying neighborhood overview
   */
  Widget _buildOverviewTab() {
    final data = _neighborhoodData!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Neighborhood header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.blue[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Near ${widget.property.location}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Walkability scores
          _buildScoreCard(
            title: 'Walkability Scores',
            children: [
              _buildScoreItem('Walk Score', data.walkabilityScore, Colors.green),
              _buildScoreItem('Transit Score', data.transitScore, Colors.blue),
              _buildScoreItem('Bike Score', data.bikeabilityScore, Colors.orange),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Demographics
          _buildScoreCard(
            title: 'Demographics',
            children: [
              _buildInfoItem('Population', '${data.demographics.population.toStringAsFixed(0)}'),
              _buildInfoItem('Median Age', '${data.demographics.medianAge} years'),
              _buildInfoItem('Median Income', data.demographics.formattedMedianIncome),
              _buildInfoItem('College Education', '${data.demographics.collegeEducationPercentage.toStringAsFixed(1)}%'),
              _buildInfoItem('Diversity Index', '${data.demographics.diversityIndex.toStringAsFixed(1)}/100'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Quick stats
          _buildScoreCard(
            title: 'Quick Stats',
            children: [
              _buildInfoItem('Crime Score', '${data.crime.overallScore}/100 (${data.crime.trend.name})'),
              _buildInfoItem('Nearby Schools', '${data.schools.schools.length} schools'),
              _buildInfoItem('Grocery Stores', '${data.amenities.groceryStores} within 1 mile'),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * Builds the schools tab with school ratings and information
   * 
   * @return Widget displaying school information
   */
  Widget _buildSchoolsTab() {
    final schools = _neighborhoodData!.schools.schools;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schools.length,
      itemBuilder: (context, index) {
        final school = schools[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getSchoolColor(school.rating.toDouble()),
              child: Text(
                school.rating.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              school.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${school.distanceMiles} miles away'),
                Text(school.type.name),
              ],
            ),
            trailing: Icon(
              school.type == SchoolType.private ? Icons.school : Icons.public,
              color: Colors.blue[600],
            ),
          ),
        );
      },
    );
  }

  /**
   * Builds the amenities tab with nearby amenities
   * 
   * @return Widget displaying amenity information
   */
  Widget _buildAmenitiesTab() {
    final amenitiesData = _neighborhoodData!.amenities;
    final allAmenities = [
      ...amenitiesData.restaurants,
      ...amenitiesData.shopping,
      ...amenitiesData.parks,
      ...amenitiesData.healthcare,
      ...amenitiesData.entertainment,
    ];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allAmenities.length,
      itemBuilder: (context, index) {
        final amenity = allAmenities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(
                _getAmenityIcon(amenity.type.name),
                color: Colors.blue[700],
              ),
            ),
            title: Text(
              amenity.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${amenity.distanceMiles} miles away'),
                Row(
                  children: [
                    ...List.generate(5, (i) => Icon(
                      i < amenity.rating.floor() ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.amber,
                    )),
                    const SizedBox(width: 8),
                    Text('${amenity.rating}'),
                  ],
                ),
              ],
            ),
            trailing: Text(
              amenity.type.name,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }

  /**
   * Builds the safety tab with crime statistics
   * 
   * @return Widget displaying safety information
   */
  Widget _buildSafetyTab() {
    final crime = _neighborhoodData!.crime;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall crime rate
          _buildScoreCard(
            title: 'Crime Statistics',
            children: [
              _buildInfoItem('Overall Crime Score', '${crime.overallScore}/100'),
              _buildInfoItem('Violent Crime Rate', '${crime.violentCrimeRate}/1000 residents'),
              _buildInfoItem('Property Crime Rate', '${crime.propertyCrimeRate}/1000 residents'),
              _buildInfoItem('Trend', crime.trend.name),
              _buildInfoItem('Safety Comparison', crime.safetyComparison.name),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Safety tips
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.security, color: Colors.amber[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Safety Tips',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('• Keep doors and windows locked'),
                const Text('• Install security cameras if needed'),
                const Text('• Get to know your neighbors'),
                const Text('• Report suspicious activity'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Builds the transportation tab with transit options
   * 
   * @return Widget displaying transportation information
   */
  Widget _buildTransportationTab() {
    final transport = _neighborhoodData!.transportation;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transportation overview
          _buildScoreCard(
            title: 'Transportation Overview',
            children: [
              _buildInfoItem('Average Commute Time', '${transport.averageCommuteTime} minutes'),
              _buildInfoItem('Public Transit Score', '${transport.publicTransitScore}/100'),
              _buildInfoItem('Bus Stops', '${transport.busStops} nearby'),
              _buildInfoItem('Train Stations', '${transport.trainStations} nearby'),
              _buildInfoItem('Airport Distance', '${transport.airportDistance} miles'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Highways
          _buildScoreCard(
            title: 'Nearby Highways',
            children: transport.nearbyHighways.map((highway) => 
              _buildInfoItem('Highway', highway)
            ).toList(),
          ),
        ],
      ),
    );
  }

  /**
   * Builds a score card container
   * 
   * @param title The title of the card
   * @param children List of widgets to display in the card
   * @return Widget containing the score card
   */
  Widget _buildScoreCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  /**
   * Builds a score item with color-coded rating
   * 
   * @param label The label for the score
   * @param score The numerical score
   * @param color The color for the score indicator
   * @return Widget displaying the score item
   */
  Widget _buildScoreItem(String label, int score, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$score',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Builds an info item with label and value
   * 
   * @param label The label for the information
   * @param value The value to display
   * @return Widget displaying the info item
   */
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /**
   * Gets the color for school rating
   * 
   * @param rating The school rating
   * @return Color based on rating
   */
  Color _getSchoolColor(double rating) {
    if (rating >= 9) return Colors.green;
    if (rating >= 8) return Colors.blue;
    if (rating >= 7) return Colors.orange;
    return Colors.red;
  }

  /**
   * Gets the icon for amenity type
   * 
   * @param type The amenity type
   * @return IconData for the amenity type
   */
  IconData _getAmenityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'park':
        return Icons.park;
      case 'shopping':
        return Icons.shopping_cart;
      case 'healthcare':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      default:
        return Icons.place;
    }
  }
}
