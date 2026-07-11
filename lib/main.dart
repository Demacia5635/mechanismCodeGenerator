import 'package:flutter/material.dart';

import 'dart:io';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MechanismGeneratorApp());
}

// ==========================================
// DATA MODELS
// ==========================================

class MotorModel {
  String name = '';
  
  String id = '';
  bool todoId = false;
  
  String motorType = 'TalonFX'; 
  
  String canBus = 'Rio'; 
  bool todoCanBus = false;
  
  bool inverted = false;
  bool todoInverted = false;
  
  bool brakeMode = true;
  bool todoBrakeMode = false;

  double maxVolt = 12.0; 
  bool useMaxVolt = false;
  bool todoMaxVolt = false;
  
  double maxCurrent = 40.0; 
  bool useMaxCurrent = false;
  bool todoMaxCurrent = false;
  
  double rampUpTime = 0.3; 
  bool useRampUpTime = false;
  bool todoRampUpTime = false;

  bool useRadiansMotor = false;
  double gearRatio = 1.0;
  bool todoGearRatio = false;

  bool useMeterMotor = false;
  double diameter = 1.0;
  bool todoDiameter = false;

  // Grouped PID+FF
  double kP = 0.0;
  double kI = 0.0;
  double kD = 0.0;
  double kS = 0.0;
  double kV = 0.0;
  double kA = 0.0;
  double kG = 0.0;
  bool usePIDFF = false;
  bool todoPIDFF = false;
  
  // Grouped Advanced Feed Forward
  double kV2 = 0.0;
  double kSin = 0.0;
  bool useAdvancedFF = false; 
  bool todoAdvancedFF = false;

  // Grouped Motion Magic
  double maxVelocity = 0.0; 
  double maxAcceleration = 0.0;
  double maxJerk = 0.0;
  double maxPositionError = 0.5; 
  bool useMotionMagic = false;
  bool todoMotionMagic = false;
  
  // Grouped Stall Detection
  double highCurrentThreshold = 0.0; 
  double lowVelocityThreshold = 0.0;
  double secondsThreshold = 0.0;
  bool useStallDetection = false;
  bool todoStallDetection = false;
}

class SensorModel {
  String name = '';
  
  String sensorType = 'Cancoder'; 
  
  String idOrPort = ''; 
  bool todoId = false;
  
  String canBus = 'Rio'; 
  bool todoCanBus = false;
  
  bool inverted = false;
  bool todoInverted = false;
  
  double offset = 0.0; bool useOffset = false; bool todoOffset = false;
  double fullRange = 6.28318; bool useFullRange = false; bool todoFullRange = false; 
  double minRange = 0.0; bool useMinRange = false; bool todoMinRange = false;
  double maxRange = 1.0; bool useMaxRange = false; bool todoMaxRange = false;
  
  double frequency = 1000.0; bool useFrequency = false; bool todoFrequency = false;
  
  // Grouped Pigeon Offsets
  double pitchOffset = 0.0; 
  double rollOffset = 0.0; 
  double yawOffset = 0.0; 
  bool useOffsets = false; 
  bool todoOffsets = false;
  
  // Grouped Pigeon Scalars
  double xScalar = 1.0; 
  double yScalar = 1.0; 
  double zScalar = 1.0; 
  bool useScalars = false; 
  bool todoScalars = false;
  
  bool compass = false; bool todoCompass = false;
  bool tempCompensation = false; bool todoTempComp = false;
  bool noMotionCalibration = false; bool todoNoMotion = false;
  
  String pingChannel = ''; bool todoPingChannel = false;
}

class PowerCommandConfig {
  String motorName = '';
  String supplier = 'Controller rightX';
}

class LimitConfig {
  String motorName = '';
  double minLimit = 0.0;
  bool todoMinLimit = false;
  double maxLimit = 0.0;
  bool todoMaxLimit = false;
}

class AutoCalibConfig {
  String motorName = '';
  String atResetPosMethod = 'other';
  String sensorName = '';
  double resetPos = 0.0;
  bool todoResetPos = false;
}

class CalibCmdConfig {
  String motorName = '';
  String atResetPosMethod = 'other';
  String sensorName = '';
  double power = 0.0;
  bool todoPower = false;
  double resetPos = 0.0;
  bool todoResetPos = false;
  bool useStartDelay = false;
  double startPower = 0.0;
  bool todoStartPower = false;
  double startDelaySec = 0.0;
  bool todoStartDelay = false;
}

class StateConfig {
  String name = '';
  
  Map<String, double> motorValues = {};
  Map<String, bool> todoMotorValues = {};
}

class MechanismModel {
  String name = '';
  List<MotorModel> motors = [];
  List<SensorModel> sensors = [];
  
  List<PowerCommandConfig> powerCommands = [];
  List<LimitConfig> limits = [];
  List<AutoCalibConfig> autoCalibrations = [];
  List<CalibCmdConfig> calibrationCommands = [];

  // --- States ---
  bool useStates = false;
  String statesType = "fixed states";
  List<StateConfig> states = [];

  // --- Default Command ---
  bool useDefaultCommand = false;
  Map<String, String> defaultControlModes = {};

  List<String> getMotorNames() {
    List<String> names = [];
    for (int i = 0; i < motors.length; i++) {
      String n = motors[i].name.trim();
      names.add(n.isEmpty ? 'Unnamed Motor ${i + 1}' : n);
    }
    return names.isEmpty ? ['No Motors Available'] : names;
  }

  List<String> getSensorNames() {
    List<String> names = [];
    for (int i = 0; i < sensors.length; i++) {
      String n = sensors[i].name.trim();
      names.add(n.isEmpty ? 'Unnamed Sensor ${i + 1}' : n);
    }
    return names.isEmpty ? ['No Sensors Available'] : names;
  }
}

class ChassisModel {
  bool makeChassis = false;

  String name = 'robot';
  
  String pigeonId = ''; bool todoPigeonId = false;
  String canBus = 'CANivore'; bool todoCanBus = false;
  String pigeonCanBus = 'CANivore'; bool todoPigeonCanBus = false;
  
  double steerGearRatio = 287.0 / 11.0; bool todoSteerGearRatio = false;
  double driveGearRatio = 6.03; bool todoDriveGearRatio = false;
  double wheelDiameter = 4 * 0.0254; bool todoWheelDiameter = false;

  bool todoSteerPIDFF = false;
  double steerKP = 0;
  double steerKI = 0;
  double steerKD = 0;
  double steerKS = 0;
  double steerKV = 0;
  double steerKA = 0;

  bool todoDrivePIDFF = false;
  double driveKP = 0;
  double driveKI = 0;
  double driveKD = 0;
  double driveKS = 0;
  double driveKV = 0;
  double driveKA = 0;

  bool todoMotionMagic = false;
  double motionMagicVel = 100;
  double motionMagicAccel = 50;
  double motionMagicJerk = 1000;

  double maxDriveVelocity = 5; bool todoMaxDriveVelocity = false;
  double rampTimeSteer = 0.25; bool todoRampTimeSteer = false;

  // Locations (X, Y)
  double flX = 0; bool todoFlX = false;
  double flY = 0; bool todoFlY = false;
  double frX = 0; bool todoFrX = false;
  double frY = 0; bool todoFrY = false;
  double blX = 0; bool todoBlX = false;
  double blY = 0; bool todoBlY = false;
  double brX = 0; bool todoBrX = false;
  double brY = 0; bool todoBrY = false;

  // Offsets
  double flOffset = 0; bool todoFlOffset = true;
  double frOffset = 0; bool todoFrOffset = true;
  double blOffset = 0; bool todoBlOffset = true;
  double brOffset = 0; bool todoBrOffset = true;
}

// ==========================================
// MAIN APP
// ==========================================

class MechanismGeneratorApp extends StatelessWidget {
  const MechanismGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demacia 5635 Mechanism Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ==========================================
// PAGE 1: HOME PAGE
// ==========================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<MechanismModel> _mechanisms = [];
  final ChassisModel _chassis = ChassisModel();

  void _addNewMechanismDialog() {
    String tempName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Mechanism'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Mechanism Name',
              hintText: 'e.g. Intake',
            ),
            onChanged: (val) => tempName = val,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (tempName.isNotEmpty) {
                  setState(() {
                    _mechanisms.add(MechanismModel()..name = tempName);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _openMechanismEditor(MechanismModel mech) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MechanismEditorPage(mechanism: mech)),
    );
    setState(() {});
  }

  Future<void> _generateAllCode() async {
    
    Map<String, String> allFiles = {};
    for (var mech in _mechanisms) {
      allFiles.addAll(JavaCodeGenerator.generateMechanismFiles(mech));
    }

    if (_chassis.makeChassis) {
      String className = _chassis.name.replaceAll(' ', '');
      if (className.isNotEmpty) {
        className = className[0].toUpperCase() + className.substring(1);
      } else {
        className = "Robot";
      }
      allFiles['chassis/${className}ChassisConstants.java'] = JavaCodeGenerator.generateChassisConstants(_chassis);
    }

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      return;
    }

    try {
      for (var entry in allFiles.entries) {
        String relativePath = entry.key;
        String content = entry.value;

        File file = File('$selectedDirectory/$relativePath');

        await file.parent.create(recursive: true);

        await file.writeAsString(content);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved ${allFiles.length} files successfully to:\n$selectedDirectory'),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving files: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Robot Mechanisms - Demacia 5635'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              color: Colors.grey[900],
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Generate Built-in Chassis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    value: _chassis.makeChassis,
                    onChanged: (val) => setState(() => _chassis.makeChassis = val),
                  ),
                  if (_chassis.makeChassis)
                    ExpansionTile(
                      title: const Text('Chassis Configuration'),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _chassis.name,
                                      decoration: const InputDecoration(labelText: 'Chassis Name', border: OutlineInputBorder()),
                                      onChanged: (val) => _chassis.name = val,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  _buildTodoFlag(
                                    isTodo: _chassis.todoPigeonId,
                                    onChanged: (val) => setState(() => _chassis.todoPigeonId = val),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _chassis.pigeonId,
                                      decoration: const InputDecoration(labelText: 'Pigeon ID', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => _chassis.pigeonId = val,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildTodoFlag(
                                    isTodo: _chassis.todoCanBus,
                                    onChanged: (val) => setState(() => _chassis.todoCanBus = val),
                                  ),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _chassis.canBus,
                                      decoration: const InputDecoration(labelText: 'CAN Bus', border: OutlineInputBorder()),
                                      items: ['CANivore', 'Rio'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                                      onChanged: (val) => setState(() => _chassis.canBus = val!),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  _buildTodoFlag(
                                    isTodo: _chassis.todoPigeonCanBus,
                                    onChanged: (val) => setState(() => _chassis.todoPigeonCanBus = val),
                                  ),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _chassis.pigeonCanBus,
                                      decoration: const InputDecoration(labelText: 'Pigeon CAN Bus', border: OutlineInputBorder()),
                                      items: ['CANivore', 'Rio'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                                      onChanged: (val) => setState(() => _chassis.pigeonCanBus = val!),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildTodoFlag(
                                    isTodo: _chassis.todoSteerGearRatio,
                                    onChanged: (val) => setState(() => _chassis.todoSteerGearRatio = val),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _chassis.steerGearRatio.toString(),
                                      decoration: const InputDecoration(labelText: 'Steer Gear Ratio', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => _chassis.steerGearRatio = double.parse(val),
                                    ),
                                  ),
                                ]
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildTodoFlag(
                                    isTodo: _chassis.todoDriveGearRatio,
                                    onChanged: (val) => setState(() => _chassis.todoDriveGearRatio = val),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _chassis.driveGearRatio.toString(),
                                      decoration: const InputDecoration(labelText: 'Drive Gear Ratio', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => _chassis.driveGearRatio = double.parse(val),
                                    ),
                                  ),
                                ]
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildTodoFlag(
                                    isTodo: _chassis.todoWheelDiameter,
                                    onChanged: (val) => setState(() => _chassis.todoWheelDiameter = val),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _chassis.wheelDiameter.toString(),
                                      decoration: const InputDecoration(labelText: 'Wheel Diameter', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => _chassis.wheelDiameter = double.parse(val),
                                    ),
                                  ),
                                ]
                              ),
                              const SizedBox(height: 16),
                              _buildGroupHeader(
                                title: 'Steer PID Constants',
                                isTodo: _chassis.todoSteerPIDFF,
                                onTodoChanged: (val) => setState(() => _chassis.todoSteerPIDFF = val),
                              ),
                              Wrap(
                                spacing: 16, runSpacing: 16,
                                children: [
                                  _buildGroupedTextField(
                                    label: 'steer kP', initialValue: _chassis.steerKP, defaultValue: 0.0,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'steer kI', initialValue: _chassis.steerKI, defaultValue: 0.0,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'steer kD', initialValue: _chassis.steerKD, defaultValue: 0.0,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'steer kS', initialValue: _chassis.steerKS, defaultValue: 0.0,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'steer kV', initialValue: _chassis.steerKV, defaultValue: 0.0,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'steer kA', initialValue: _chassis.steerKA, defaultValue: 0.0,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildGroupHeader(
                                title: 'Drive PID Constants',
                                isTodo: _chassis.todoDrivePIDFF,
                                onTodoChanged: (val) => setState(() => _chassis.todoDrivePIDFF = val),
                              ),
                              Wrap(
                                spacing: 16, runSpacing: 16,
                                children: [
                                  _buildGroupedTextField(
                                    label: 'drive kP', initialValue: _chassis.driveKP, defaultValue: 0.0,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'drive kI', initialValue: _chassis.driveKI, defaultValue: 0.0,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'drive kD', initialValue: _chassis.driveKD, defaultValue: 0.0,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'drive kS', initialValue: _chassis.driveKS, defaultValue: 0.0,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'drive kV', initialValue: _chassis.driveKV, defaultValue: 0.0,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'drive kA', initialValue: _chassis.driveKA, defaultValue: 0.0,
                                  ),
                                ],
                              ),

                              const Divider(height: 32),

                              _buildGroupHeader(
                                title: 'Motion Magic Parameters',
                                isTodo: _chassis.todoMotionMagic,
                                onTodoChanged: (val) => setState(() => _chassis.todoMotionMagic = val),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 16, runSpacing: 16,
                                children: [
                                  _buildGroupedTextField(
                                    label: 'Max Velocity', initialValue: _chassis.motionMagicVel, defaultValue: 100,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'Max Acceleration', initialValue: _chassis.motionMagicAccel, defaultValue: 50,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'Max Jerk', initialValue: _chassis.motionMagicJerk, defaultValue: 1000,
                                  )
                                ],
                              ),
                            
                              const Divider(height: 32),

                              Row(
                                children: [
                                  _buildTodoFlag(
                                    isTodo: _chassis.todoMaxDriveVelocity,
                                    onChanged: (val) => setState(() => _chassis.todoMaxDriveVelocity = val),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _chassis.maxDriveVelocity.toString(),
                                      decoration: const InputDecoration(labelText: 'Max Drive Velocity', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => _chassis.maxDriveVelocity = double.parse(val),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  _buildTodoFlag(
                                    isTodo: _chassis.todoRampTimeSteer,
                                    onChanged: (val) => setState(() => _chassis.todoRampTimeSteer = val),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _chassis.rampTimeSteer.toString(),
                                      decoration: const InputDecoration(labelText: 'Ramp Time (Steer)', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => _chassis.rampTimeSteer = double.parse(val),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text('Swerve Modules (Locations & Offsets)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const Divider(),
                              const SizedBox(height: 8),

                              // --- Front Left ---
                              const Text('Front Left', style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildTodoFlag(isTodo: _chassis.todoFlX, onChanged: (val) => setState(() => _chassis.todoFlX = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.flX.toString(), decoration: const InputDecoration(labelText: 'X Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.flX = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoFlY, onChanged: (val) => setState(() => _chassis.todoFlY = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.flY.toString(), decoration: const InputDecoration(labelText: 'Y Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.flY = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoFlOffset, onChanged: (val) => setState(() => _chassis.todoFlOffset = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.flOffset.toString(), decoration: const InputDecoration(labelText: 'Offset', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.flOffset = double.tryParse(val) ?? 0.0)),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // --- Front Right ---
                              const Text('Front Right', style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildTodoFlag(isTodo: _chassis.todoFrX, onChanged: (val) => setState(() => _chassis.todoFrX = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.frX.toString(), decoration: const InputDecoration(labelText: 'X Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.frX = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoFrY, onChanged: (val) => setState(() => _chassis.todoFrY = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.frY.toString(), decoration: const InputDecoration(labelText: 'Y Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.frY = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoFrOffset, onChanged: (val) => setState(() => _chassis.todoFrOffset = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.frOffset.toString(), decoration: const InputDecoration(labelText: 'Offset', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.frOffset = double.tryParse(val) ?? 0.0)),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // --- Back Left ---
                              const Text('Back Left', style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildTodoFlag(isTodo: _chassis.todoBlX, onChanged: (val) => setState(() => _chassis.todoBlX = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.blX.toString(), decoration: const InputDecoration(labelText: 'X Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.blX = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoBlY, onChanged: (val) => setState(() => _chassis.todoBlY = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.blY.toString(), decoration: const InputDecoration(labelText: 'Y Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.blY = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoBlOffset, onChanged: (val) => setState(() => _chassis.todoBlOffset = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.blOffset.toString(), decoration: const InputDecoration(labelText: 'Offset', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.blOffset = double.tryParse(val) ?? 0.0)),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // --- Back Right ---
                              const Text('Back Right', style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildTodoFlag(isTodo: _chassis.todoBrX, onChanged: (val) => setState(() => _chassis.todoBrX = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.brX.toString(), decoration: const InputDecoration(labelText: 'X Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.brX = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoBrY, onChanged: (val) => setState(() => _chassis.todoBrY = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.brY.toString(), decoration: const InputDecoration(labelText: 'Y Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.brY = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoBrOffset, onChanged: (val) => setState(() => _chassis.todoBrOffset = val)),
                                  Expanded(child: TextFormField(initialValue: _chassis.brOffset.toString(), decoration: const InputDecoration(labelText: 'Offset', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.brOffset = double.tryParse(val) ?? 0.0)),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            
            if (_mechanisms.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No mechanisms yet. Click + to add.'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _mechanisms.length,
                itemBuilder: (context, index) {
                  final mech = _mechanisms[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(mech.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Text('${mech.motors.length} Motors | ${mech.sensors.length} Sensors'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _openMechanismEditor(mech),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_mech',
            onPressed: _addNewMechanismDialog,
            tooltip: 'Add Mechanism',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'generate',
            onPressed: _generateAllCode,
            icon: const Icon(Icons.code),
            label: const Text('Generate Code'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildTodoFlag({required bool isTodo, required Function(bool) onChanged}) {
    return IconButton(
      icon: Icon(
        isTodo ? Icons.flag : Icons.outlined_flag,
        color: isTodo ? Colors.orange : Colors.grey,
      ),
      tooltip: 'Mark as TODO',
      onPressed: () => onChanged(!isTodo),
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.only(right: 8.0),
    );
  }

  Widget _buildGroupHeader({
    required String title,
    required bool isTodo,
    required Function(bool) onTodoChanged,
  }) {
    return Row(
      children: [
        _buildTodoFlag(
          isTodo: isTodo,
          onChanged: onTodoChanged,
        ),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGroupedTextField({
    required String label,
    required double? initialValue,
    required double defaultValue,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 32,
      child: TextFormField(
        initialValue: initialValue?.toString() ?? defaultValue.toString(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      ),
    );
  }
}

// ==========================================
// PAGE 2: MECHANISM EDITOR
// ==========================================

class MechanismEditorPage extends StatefulWidget {
  final MechanismModel mechanism;
  const MechanismEditorPage({super.key, required this.mechanism});

  @override
  State<MechanismEditorPage> createState() => _MechanismEditorPageState();
}

class _MechanismEditorPageState extends State<MechanismEditorPage> {
  void _addNewMotor() {
    final newMotor = MotorModel();
    setState(() {
      widget.mechanism.motors.add(newMotor);
    });
    _openMotorEditor(newMotor);
  }

  void _openMotorEditor(MotorModel motor) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MotorEditorPage(motor: motor)),
    );
    setState(() {});
  }

  void _addNewSensor() {
    final newSensor = SensorModel();
    setState(() {
      widget.mechanism.sensors.add(newSensor);
    });
    _openSensorEditor(newSensor);
  }

  void _openSensorEditor(SensorModel sensor) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SensorEditorPage(sensor: sensor)),
    );
    setState(() {});
  }

  Widget _buildTodoFlag({required bool isTodo, required Function(bool) onChanged}) {
    return IconButton(
      icon: Icon(
        isTodo ? Icons.flag : Icons.outlined_flag,
        color: isTodo ? Colors.orange : Colors.grey,
      ),
      tooltip: 'Mark as TODO',
      onPressed: () => onChanged(!isTodo),
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.only(right: 8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> motorNames = widget.mechanism.getMotorNames();
    List<String> sensorNames = widget.mechanism.getSensorNames();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit: ${widget.mechanism.name}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            initialValue: widget.mechanism.name,
            decoration: const InputDecoration(
              labelText: 'Mechanism Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => widget.mechanism.name = val.isEmpty ? 'Unnamed' : val,
          ),
          const SizedBox(height: 24),

          // --- MOTORS SECTION ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Motors', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: _addNewMotor,
                icon: const Icon(Icons.add),
                label: const Text('Add Motor'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.mechanism.motors.isEmpty)
             const Text('No motors added yet.', style: TextStyle(color: Colors.grey)),
          ...widget.mechanism.motors.map((motor) => Card(
            color: Colors.grey[850],
            child: ListTile(
              title: Text(motor.name.isEmpty ? 'Unnamed Motor' : motor.name),
              subtitle: Text('${motor.motorType} | ID: ${motor.id} | Bus: ${motor.canBus}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  setState(() {
                    widget.mechanism.motors.remove(motor);
                  });
                },
              ),
              onTap: () => _openMotorEditor(motor),
            ),
          )),

          const SizedBox(height: 32),

          // --- SENSORS SECTION ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sensors', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: _addNewSensor,
                icon: const Icon(Icons.add),
                label: const Text('Add Sensor'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.mechanism.sensors.isEmpty)
             const Text('No sensors added yet.', style: TextStyle(color: Colors.grey)),
          ...widget.mechanism.sensors.map((sensor) => Card(
            color: Colors.grey[850],
            child: ListTile(
              title: Text(sensor.name.isEmpty ? 'Unnamed Sensor' : sensor.name),
              subtitle: Text('${sensor.sensorType} | ID/Port: ${sensor.idOrPort}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  setState(() {
                    widget.mechanism.sensors.remove(sensor);
                  });
                },
              ),
              onTap: () => _openSensorEditor(sensor),
            ),
          )),
          
          const SizedBox(height: 32),

          // --- STATES ---
          Card(
            color: Colors.grey[900],
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Use States Mechanism'),
                  value: widget.mechanism.useStates,
                  onChanged: (val) => setState(() => widget.mechanism.useStates = val),
                ),
                if (widget.mechanism.useStates) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      value: widget.mechanism.statesType,
                      decoration: const InputDecoration(labelText: 'States Type', border: OutlineInputBorder()),
                      items: ['fixed states', 'dynamic states']
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (val) => setState(() => widget.mechanism.statesType = val!),
                    ),
                  ),
                  ...widget.mechanism.states.map((stateCfg) => Card(
                    color: Colors.grey[850],
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: stateCfg.name,
                                  decoration: const InputDecoration(labelText: 'State Name', border: OutlineInputBorder(), isDense: true),
                                  onChanged: (val) => stateCfg.name = val,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => setState(() => widget.mechanism.states.remove(stateCfg)),
                              ),
                            ],
                          ),
                          if (widget.mechanism.statesType == 'fixed states' && motorNames.isNotEmpty && motorNames.first != 'No Motors Available') ...[
                            const SizedBox(height: 16),
                            const Text('Motor Values for this State:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...motorNames.map((mName) {
                              stateCfg.motorValues.putIfAbsent(mName, () => 0.0);
                              stateCfg.todoMotorValues.putIfAbsent(mName, () => false);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(mName)),
                                    _buildTodoFlag(
                                      isTodo: stateCfg.todoMotorValues[mName]!,
                                      onChanged: (val) => setState(() => stateCfg.todoMotorValues[mName] = val),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: TextFormField(
                                        initialValue: stateCfg.motorValues[mName].toString(),
                                        decoration: const InputDecoration(labelText: 'Value', border: OutlineInputBorder(), isDense: true),
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) => stateCfg.motorValues[mName] = double.tryParse(val) ?? 0.0,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  )),
                  TextButton.icon(
                    onPressed: () => setState(() => widget.mechanism.states.add(StateConfig())), 
                    icon: const Icon(Icons.add), label: const Text('Add State')
                  ),
                ]
              ],
            ),
          ),

          const Divider(height: 40),
          const Text('Mechanism Configuration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // --- LIMITS ---
          Card(
            color: Colors.grey[900],
            child: ExpansionTile(
              title: const Text('Limits', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                ...widget.mechanism.limits.map((limit) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: motorNames.contains(limit.motorName) ? limit.motorName : motorNames.first,
                          decoration: const InputDecoration(labelText: 'Motor', border: OutlineInputBorder(), isDense: true),
                          items: motorNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                          onChanged: (val) => setState(() => limit.motorName = val!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildTodoFlag(
                        isTodo: limit.todoMinLimit,
                        onChanged: (val) => setState(() => limit.todoMinLimit = val),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: limit.minLimit.toString(),
                          decoration: const InputDecoration(labelText: 'Min Limit', border: OutlineInputBorder(), isDense: true),
                          keyboardType: TextInputType.number,
                          onChanged: (val) => limit.minLimit = double.tryParse(val) ?? 0.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildTodoFlag(
                        isTodo: limit.todoMaxLimit,
                        onChanged: (val) => setState(() => limit.todoMaxLimit = val),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: limit.maxLimit.toString(),
                          decoration: const InputDecoration(labelText: 'Max Limit', border: OutlineInputBorder(), isDense: true),
                          keyboardType: TextInputType.number,
                          onChanged: (val) => limit.maxLimit = double.tryParse(val) ?? 0.0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => setState(() => widget.mechanism.limits.remove(limit)),
                      ),
                    ],
                  ),
                )),
                TextButton.icon(
                  onPressed: () => setState(() => widget.mechanism.limits.add(LimitConfig()..motorName = motorNames.first)), 
                  icon: const Icon(Icons.add), label: const Text('Add Limit')
                ),
              ],
            ),
          ),

          // --- POWER COMMANDS ---
          Card(
            color: Colors.grey[900],
            child: ExpansionTile(
              title: const Text('Power Commands', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                ...widget.mechanism.powerCommands.map((pCmd) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: motorNames.contains(pCmd.motorName) ? pCmd.motorName : motorNames.first,
                          decoration: const InputDecoration(labelText: 'Motor', border: OutlineInputBorder(), isDense: true),
                          items: motorNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                          onChanged: (val) => setState(() => pCmd.motorName = val!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: pCmd.supplier,
                          decoration: const InputDecoration(labelText: 'Supplier', border: OutlineInputBorder(), isDense: true),
                          items: ['Controller rightX', 'Controller rightY', 'Controller leftX', 'Controller leftY', 'Other']
                              .map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                          onChanged: (val) => setState(() => pCmd.supplier = val!),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => setState(() => widget.mechanism.powerCommands.remove(pCmd)),
                      ),
                    ],
                  ),
                )),
                TextButton.icon(
                  onPressed: () => setState(() => widget.mechanism.powerCommands.add(PowerCommandConfig()..motorName = motorNames.first)), 
                  icon: const Icon(Icons.add), label: const Text('Add Power Command')
                ),
              ],
            ),
          ),

          // --- AUTO CALIBRATIONS ---
          Card(
            color: Colors.grey[900],
            child: ExpansionTile(
              title: const Text('Auto Calibrations', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                ...widget.mechanism.autoCalibrations.map((calib) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: motorNames.contains(calib.motorName) ? calib.motorName : motorNames.first,
                          decoration: const InputDecoration(labelText: 'Motor', border: OutlineInputBorder(), isDense: true),
                          items: motorNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                          onChanged: (val) => setState(() => calib.motorName = val!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: calib.atResetPosMethod,
                          decoration: const InputDecoration(
                            labelText: 'at ResetPos Method',
                            border: OutlineInputBorder(),
                          ),
                          items: ['when sensor true', 'other']
                              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                              .toList(),
                          onChanged: (val) => setState(() => calib.atResetPosMethod = val!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (calib.atResetPosMethod == "when sensor true")
                          Expanded(
                          child: DropdownButtonFormField<String>(
                            value: sensorNames.contains(calib.sensorName) ? calib.sensorName : sensorNames.first,
                            decoration: const InputDecoration(labelText: 'Sensor', border: OutlineInputBorder(), isDense: true),
                            items: sensorNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                            onChanged: (val) => setState(() => calib.sensorName = val!),
                          ),
                        ),
                      const SizedBox(width: 8),
                      _buildTodoFlag(
                        isTodo: calib.todoResetPos,
                        onChanged: (val) => setState(() => calib.todoResetPos = val),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: calib.resetPos.toString(),
                          decoration: const InputDecoration(labelText: 'Reset Pos', border: OutlineInputBorder(), isDense: true),
                          keyboardType: TextInputType.number,
                          onChanged: (val) => calib.resetPos = double.tryParse(val) ?? 0.0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => setState(() => widget.mechanism.autoCalibrations.remove(calib)),
                      ),
                    ],
                  ),
                )),
                TextButton.icon(
                  onPressed: () => setState(() => widget.mechanism.autoCalibrations.add(AutoCalibConfig()..motorName = motorNames.first..sensorName = sensorNames.first)), 
                  icon: const Icon(Icons.add), label: const Text('Add Auto Calibration')
                ),
              ],
            ),
          ),

          // --- CALIBRATION COMMANDS ---
          Card(
            color: Colors.grey[900],
            child: ExpansionTile(
              title: const Text('Calibration Commands', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                ...widget.mechanism.calibrationCommands.map((cmd) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: motorNames.contains(cmd.motorName) ? cmd.motorName : motorNames.first,
                              decoration: const InputDecoration(labelText: 'Motor', border: OutlineInputBorder(), isDense: true),
                              items: motorNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                              onChanged: (val) => setState(() => cmd.motorName = val!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: cmd.atResetPosMethod,
                              decoration: const InputDecoration(
                                labelText: 'at ResetPos Method',
                                border: OutlineInputBorder(),
                              ),
                              items: ['when sensor true', 'other']
                                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                  .toList(),
                              onChanged: (val) => setState(() => cmd.atResetPosMethod = val!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (cmd.atResetPosMethod == "when sensor true")
                              Expanded(
                              child: DropdownButtonFormField<String>(
                                value: sensorNames.contains(cmd.sensorName) ? cmd.sensorName : sensorNames.first,
                                decoration: const InputDecoration(labelText: 'Sensor', border: OutlineInputBorder(), isDense: true),
                                items: sensorNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                                onChanged: (val) => setState(() => cmd.sensorName = val!),
                              ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => setState(() => widget.mechanism.calibrationCommands.remove(cmd)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildTodoFlag(
                            isTodo: cmd.todoPower,
                            onChanged: (val) => setState(() => cmd.todoPower = val),
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: cmd.power.toString(),
                              decoration: const InputDecoration(labelText: 'Power', border: OutlineInputBorder(), isDense: true),
                              keyboardType: TextInputType.number,
                              onChanged: (val) => cmd.power = double.tryParse(val) ?? 0.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildTodoFlag(
                            isTodo: cmd.todoResetPos,
                            onChanged: (val) => setState(() => cmd.todoResetPos = val),
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: cmd.resetPos.toString(),
                              decoration: const InputDecoration(labelText: 'Reset Pos', border: OutlineInputBorder(), isDense: true),
                              keyboardType: TextInputType.number,
                              onChanged: (val) => cmd.resetPos = double.tryParse(val) ?? 0.0,
                            ),
                          ),
                        ],
                      ),
                      SwitchListTile(
                        title: const Text('Use Start Delay'),
                        value: cmd.useStartDelay,
                        onChanged: (val) => setState(() => cmd.useStartDelay = val),
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (cmd.useStartDelay)
                        Row(
                          children: [
                            _buildTodoFlag(
                              isTodo: cmd.todoStartPower,
                              onChanged: (val) => setState(() => cmd.todoStartPower = val),
                            ),
                            Expanded(
                              child: TextFormField(
                                initialValue: cmd.startPower.toString(),
                                decoration: const InputDecoration(labelText: 'Start Power', border: OutlineInputBorder(), isDense: true),
                                keyboardType: TextInputType.number,
                                onChanged: (val) => cmd.startPower = double.tryParse(val) ?? 0.0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildTodoFlag(
                              isTodo: cmd.todoStartDelay,
                              onChanged: (val) => setState(() => cmd.todoStartDelay = val),
                            ),
                            Expanded(
                              child: TextFormField(
                                initialValue: cmd.startDelaySec.toString(),
                                decoration: const InputDecoration(labelText: 'Start Delay (sec)', border: OutlineInputBorder(), isDense: true),
                                keyboardType: TextInputType.number,
                                onChanged: (val) => cmd.startDelaySec = double.tryParse(val) ?? 0.0,
                              ),
                            ),
                          ],
                        ),
                      const Divider(),
                    ],
                  ),
                )),
                TextButton.icon(
                  onPressed: () => setState(() => widget.mechanism.calibrationCommands.add(CalibCmdConfig()..motorName = motorNames.first..sensorName = sensorNames.first)), 
                  icon: const Icon(Icons.add), label: const Text('Add Calibration Command')
                ),
              ],
            ),
          ),

          // --- DEFAULT COMMAND ---
          Card(
            color: Colors.grey[900],
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Generate Default Command'),
                  value: widget.mechanism.useDefaultCommand,
                  onChanged: (val) => setState(() => widget.mechanism.useDefaultCommand = val),
                ),
                if (widget.mechanism.useDefaultCommand && motorNames.isNotEmpty && motorNames.first != 'No Motors Available')
                  ...motorNames.map((mName) {
                    widget.mechanism.defaultControlModes.putIfAbsent(mName, () => 'DUTYCYCLE');
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(child: Text(mName)),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: widget.mechanism.defaultControlModes[mName],
                              decoration: const InputDecoration(
                                labelText: 'Control Mode', 
                                border: OutlineInputBorder(), 
                                isDense: true
                              ),
                              items: [
                                'DUTYCYCLE', 'VOLTAGE', 'VELOCITY', 
                                'POSITION_VOLTAGE', 'MAGIC_MOTION', 'ANGLE'
                              ].map((mode) => DropdownMenuItem(value: mode, child: Text(mode))).toList(),
                              onChanged: (val) => setState(() => widget.mechanism.defaultControlModes[mName] = val!),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                if (widget.mechanism.useDefaultCommand && (motorNames.isEmpty || motorNames.first == 'No Motors Available'))
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Add motors to assign control modes.', style: TextStyle(color: Colors.grey)),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PAGE 3: MOTOR EDITOR
// ==========================================

class MotorEditorPage extends StatefulWidget {
  final MotorModel motor;
  const MotorEditorPage({super.key, required this.motor});

  @override
  State<MotorEditorPage> createState() => _MotorEditorPageState();
}

class _MotorEditorPageState extends State<MotorEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motor Configuration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: widget.motor.name,
                  decoration: const InputDecoration(labelText: 'Motor Name', border: OutlineInputBorder()),
                  onChanged: (val) => widget.motor.name = val,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    _buildTodoFlag(
                      isTodo: widget.motor.todoId,
                      onChanged: (val) => setState(() => widget.motor.todoId = val),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.motor.id,
                        decoration: const InputDecoration(labelText: 'ID', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => widget.motor.id = val,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: widget.motor.motorType,
                  decoration: const InputDecoration(
                    labelText: 'Motor Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['TalonFX', 'TalonSRX', 'SparkMax', 'SparkFlex', 'Other']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (val) => setState(() => widget.motor.motorType = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    _buildTodoFlag(
                      isTodo: widget.motor.todoCanBus,
                      onChanged: (val) => setState(() => widget.motor.todoCanBus = val),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.motor.canBus,
                        decoration: const InputDecoration(labelText: 'CAN Bus', border: OutlineInputBorder()),
                        items: ['Rio', 'CANIvore']
                            .map((bus) => DropdownMenuItem(value: bus, child: Text(bus)))
                            .toList(),
                        onChanged: (val) => setState(() => widget.motor.canBus = val!),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            secondary: _buildTodoFlag(
              isTodo: widget.motor.todoInverted,
              onChanged: (val) => setState(() => widget.motor.todoInverted = val),
            ),
            title: const Text('Inverted'),
            value: widget.motor.inverted,
            onChanged: (val) => setState(() => widget.motor.inverted = val),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            secondary: _buildTodoFlag(
              isTodo: widget.motor.todoBrakeMode,
              onChanged: (val) => setState(() => widget.motor.todoBrakeMode = val),
            ),
            title: const Text('Brake Mode'),
            value: widget.motor.brakeMode,
            onChanged: (val) => setState(() => widget.motor.brakeMode = val),
            contentPadding: EdgeInsets.zero,
          ),

          const Divider(height: 32),

          AutoCheckField(
            label: 'Max Voltage',
            initialValue: widget.motor.maxVolt.toString(),
            defaultValue: '12.0',
            initialUse: widget.motor.useMaxVolt,
            initialTodo: widget.motor.todoMaxVolt,
            onChanged: (val) => widget.motor.maxVolt = double.tryParse(val) ?? 12.0,
            onUseChanged: (checked) => widget.motor.useMaxVolt = checked,
            onTodoChanged: (todo) => widget.motor.todoMaxVolt = todo,
          ),
          AutoCheckField(
            label: 'Max Current',
            initialValue: widget.motor.maxCurrent.toString(),
            defaultValue: '40.0',
            initialUse: widget.motor.useMaxCurrent,
            initialTodo: widget.motor.todoMaxCurrent,
            onChanged: (val) => widget.motor.maxCurrent = double.tryParse(val) ?? 40.0,
            onUseChanged: (checked) => widget.motor.useMaxCurrent = checked,
            onTodoChanged: (todo) => widget.motor.todoMaxCurrent = todo,
          ),
          AutoCheckField(
            label: 'Ramp Up Time',
            initialValue: widget.motor.rampUpTime.toString(),
            defaultValue: '0.3',
            initialUse: widget.motor.useRampUpTime,
            initialTodo: widget.motor.todoRampUpTime,
            onChanged: (val) => widget.motor.rampUpTime = double.tryParse(val) ?? 0.3,
            onUseChanged: (checked) => widget.motor.useRampUpTime = checked,
            onTodoChanged: (todo) => widget.motor.todoRampUpTime = todo,
          ),

          const Divider(height: 32),
          
          const Text('Mechanism Units', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          
          CheckboxListTile(
            title: const Text('Use Radians Motor'),
            value: widget.motor.useRadiansMotor,
            onChanged: (val) {
              setState(() {
                widget.motor.useRadiansMotor = val ?? false;
                if (widget.motor.useRadiansMotor) widget.motor.useMeterMotor = false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          if (widget.motor.useRadiansMotor)
            Padding(
              padding: const EdgeInsets.only(left: 32.0, bottom: 16.0),
              child: Row(
                children: [
                  _buildTodoFlag(
                    isTodo: widget.motor.todoGearRatio,
                    onChanged: (val) => setState(() => widget.motor.todoGearRatio = val),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: widget.motor.gearRatio.toString(),
                      decoration: const InputDecoration(labelText: 'Gear Ratio', border: OutlineInputBorder(), isDense: true),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      onChanged: (val) => widget.motor.gearRatio = double.tryParse(val) ?? 1.0,
                    ),
                  ),
                ],
              ),
            ),

          CheckboxListTile(
            title: const Text('Use Meter Motor'),
            value: widget.motor.useMeterMotor,
            onChanged: (val) {
              setState(() {
                widget.motor.useMeterMotor = val ?? false;
                if (widget.motor.useMeterMotor) widget.motor.useRadiansMotor = false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          if (widget.motor.useMeterMotor)
            Padding(
              padding: const EdgeInsets.only(left: 32.0, bottom: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildTodoFlag(
                        isTodo: widget.motor.todoGearRatio,
                        onChanged: (val) => setState(() => widget.motor.todoGearRatio = val),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: widget.motor.gearRatio.toString(),
                          decoration: const InputDecoration(labelText: 'Gear Ratio', border: OutlineInputBorder(), isDense: true),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          onChanged: (val) => widget.motor.gearRatio = double.tryParse(val) ?? 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildTodoFlag(
                        isTodo: widget.motor.todoDiameter,
                        onChanged: (val) => setState(() => widget.motor.todoDiameter = val),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: widget.motor.diameter.toString(),
                          decoration: const InputDecoration(labelText: 'Diameter (Meters)', border: OutlineInputBorder(), isDense: true),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          onChanged: (val) => widget.motor.diameter = double.tryParse(val) ?? 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          const Divider(height: 32),

          _buildGroupHeader(
            title: 'PID Constants',
            isUsed: widget.motor.usePIDFF,
            isTodo: widget.motor.todoPIDFF,
            onUseChanged: (val) => setState(() => widget.motor.usePIDFF = val),
            onTodoChanged: (val) => setState(() => widget.motor.todoPIDFF = val),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16, runSpacing: 16,
            children: [
              _buildGroupedTextField(
                label: 'kP', initialValue: widget.motor.kP, defaultValue: 0.0,
                onChanged: (v) => widget.motor.kP = v,
                markAsUsed: () => setState(() => widget.motor.usePIDFF = true),
              ),
              _buildGroupedTextField(
                label: 'kI', initialValue: widget.motor.kI, defaultValue: 0.0,
                onChanged: (v) => widget.motor.kI = v,
                markAsUsed: () => setState(() => widget.motor.usePIDFF = true),
              ),
              _buildGroupedTextField(
                label: 'kD', initialValue: widget.motor.kD, defaultValue: 0.0,
                onChanged: (v) => widget.motor.kD = v,
                markAsUsed: () => setState(() => widget.motor.usePIDFF = true),
              ),
              _buildGroupedTextField(
                label: 'kS', initialValue: widget.motor.kS, defaultValue: 0.0,
                onChanged: (v) => widget.motor.kS = v,
                markAsUsed: () => setState(() => widget.motor.usePIDFF = true),
              ),
              _buildGroupedTextField(
                label: 'kV', initialValue: widget.motor.kV, defaultValue: 0.0,
                onChanged: (v) => widget.motor.kV = v,
                markAsUsed: () => setState(() => widget.motor.usePIDFF = true),
              ),
              _buildGroupedTextField(
                label: 'kA', initialValue: widget.motor.kA, defaultValue: 0.0,
                onChanged: (v) => widget.motor.kA = v,
                markAsUsed: () => setState(() => widget.motor.usePIDFF = true),
              ),
              _buildGroupedTextField(
                label: 'kG', initialValue: widget.motor.kG, defaultValue: 0.0,
                onChanged: (v) => widget.motor.kG = v,
                markAsUsed: () => setState(() => widget.motor.usePIDFF = true),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildGroupHeader(
            title: 'Advanced Feed Forward',
            isUsed: widget.motor.useAdvancedFF,
            isTodo: widget.motor.todoAdvancedFF,
            onUseChanged: (val) => setState(() => widget.motor.useAdvancedFF = val),
            onTodoChanged: (val) => setState(() => widget.motor.todoAdvancedFF = val),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16, runSpacing: 16,
            children: [
              _buildGroupedTextField(
                label: 'kV2', initialValue: widget.motor.kV2, defaultValue: 0.0,
                onChanged: (v) => widget.motor.kV2 = v,
                markAsUsed: () => setState(() => widget.motor.useAdvancedFF = true),
              ),
              _buildGroupedTextField(
                label: 'kSin', initialValue: widget.motor.kSin, defaultValue: 0.0,
                onChanged: (v) => widget.motor.kSin = v,
                markAsUsed: () => setState(() => widget.motor.useAdvancedFF = true),
              ),
            ],
          ),

          const Divider(height: 32),

          _buildGroupHeader(
            title: 'Motion Magic Parameters',
            isUsed: widget.motor.useMotionMagic,
            isTodo: widget.motor.todoMotionMagic,
            onUseChanged: (val) => setState(() => widget.motor.useMotionMagic = val),
            onTodoChanged: (val) => setState(() => widget.motor.todoMotionMagic = val),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16, runSpacing: 16,
            children: [
              _buildGroupedTextField(
                label: 'Max Velocity', initialValue: widget.motor.maxVelocity, defaultValue: 0.0,
                onChanged: (v) => widget.motor.maxVelocity = v,
                markAsUsed: () => setState(() => widget.motor.useMotionMagic = true),
              ),
              _buildGroupedTextField(
                label: 'Max Acceleration', initialValue: widget.motor.maxAcceleration, defaultValue: 0.0,
                onChanged: (v) => widget.motor.maxAcceleration = v,
                markAsUsed: () => setState(() => widget.motor.useMotionMagic = true),
              ),
              _buildGroupedTextField(
                label: 'Max Jerk', initialValue: widget.motor.maxJerk, defaultValue: 0.0,
                onChanged: (v) => widget.motor.maxJerk = v,
                markAsUsed: () => setState(() => widget.motor.useMotionMagic = true),
              ),
              _buildGroupedTextField(
                label: 'Max Position Error', initialValue: widget.motor.maxPositionError, defaultValue: 0.5,
                onChanged: (v) => widget.motor.maxPositionError = v,
                markAsUsed: () => setState(() => widget.motor.useMotionMagic = true),
              ),
            ],
          ),

          const Divider(height: 32),

          _buildGroupHeader(
            title: 'Stall Detection',
            isUsed: widget.motor.useStallDetection,
            isTodo: widget.motor.todoStallDetection,
            onUseChanged: (val) => setState(() => widget.motor.useStallDetection = val),
            onTodoChanged: (val) => setState(() => widget.motor.todoStallDetection = val),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16, runSpacing: 16,
            children: [
              _buildGroupedTextField(
                label: 'High Current Threshold', initialValue: widget.motor.highCurrentThreshold, defaultValue: 0.0,
                onChanged: (v) => widget.motor.highCurrentThreshold = v,
                markAsUsed: () => setState(() => widget.motor.useStallDetection = true),
              ),
              _buildGroupedTextField(
                label: 'Low Velocity Threshold', initialValue: widget.motor.lowVelocityThreshold, defaultValue: 0.0,
                onChanged: (v) => widget.motor.lowVelocityThreshold = v,
                markAsUsed: () => setState(() => widget.motor.useStallDetection = true),
              ),
              _buildGroupedTextField(
                label: 'Seconds Threshold', initialValue: widget.motor.secondsThreshold, defaultValue: 0.0,
                onChanged: (v) => widget.motor.secondsThreshold = v,
                markAsUsed: () => setState(() => widget.motor.useStallDetection = true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodoFlag({required bool isTodo, required Function(bool) onChanged}) {
    return IconButton(
      icon: Icon(
        isTodo ? Icons.flag : Icons.outlined_flag,
        color: isTodo ? Colors.orange : Colors.grey,
      ),
      tooltip: 'Mark as TODO',
      onPressed: () => onChanged(!isTodo),
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.only(right: 8.0),
    );
  }

  Widget _buildGroupHeader({
    required String title,
    required bool isUsed,
    required bool isTodo,
    required Function(bool) onUseChanged,
    required Function(bool) onTodoChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: isUsed,
          onChanged: (val) => onUseChanged(val ?? false),
        ),
        _buildTodoFlag(
          isTodo: isTodo,
          onChanged: onTodoChanged,
        ),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGroupedTextField({
    required String label,
    required double? initialValue,
    required double defaultValue,
    required Function(double) onChanged,
    required Function() markAsUsed,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 32,
      child: TextFormField(
        initialValue: initialValue?.toString() ?? defaultValue.toString(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        onChanged: (val) {
          double parsed = double.tryParse(val) ?? defaultValue;
          onChanged(parsed);
          if (parsed != defaultValue) {
            markAsUsed();
          }
        },
      ),
    );
  }
}

// ==========================================
// PAGE 4: SENSOR EDITOR
// ==========================================

class SensorEditorPage extends StatefulWidget {
  final SensorModel sensor;
  const SensorEditorPage({super.key, required this.sensor});

  @override
  State<SensorEditorPage> createState() => _SensorEditorPageState();
}

class _SensorEditorPageState extends State<SensorEditorPage> {
  
  final List<String> _sensorTypes = [
    'Cancoder', 'Pigeon', 'DigitalEncoder', 'AnalogEncoder', 
    'LimitSwitch', 'ColorSensor', 'OpticalSensor', 'LidarSensor', 'UltraSonicSensor'
  ];

  @override
  Widget build(BuildContext context) {
    bool isCanSensor = widget.sensor.sensorType == 'Cancoder' || widget.sensor.sensorType == 'Pigeon';
    bool isEncoder = widget.sensor.sensorType == 'Cancoder' || widget.sensor.sensorType == 'DigitalEncoder' || widget.sensor.sensorType == 'AnalogEncoder';
    bool isGyro = widget.sensor.sensorType == 'Pigeon';
    bool hasOffset = isEncoder || isGyro || widget.sensor.sensorType == 'UltraSonicSensor'; 
    bool isSimpleDigitalAnalog = widget.sensor.sensorType == 'ColorSensor' || widget.sensor.sensorType == 'OpticalSensor' || widget.sensor.sensorType == 'LidarSensor';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Configuration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: widget.sensor.name,
                  decoration: const InputDecoration(labelText: 'Sensor Name', border: OutlineInputBorder()),
                  onChanged: (val) => widget.sensor.name = val,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    _buildTodoFlag(
                      isTodo: widget.sensor.todoId,
                      onChanged: (val) => setState(() => widget.sensor.todoId = val),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.sensor.idOrPort,
                        decoration: InputDecoration(
                          labelText: isCanSensor ? 'CAN ID' : 'Port / Channel', 
                          border: const OutlineInputBorder()
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => widget.sensor.idOrPort = val,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: widget.sensor.sensorType,
                  decoration: const InputDecoration(labelText: 'Sensor Type', border: OutlineInputBorder()),
                  items: _sensorTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) => setState(() => widget.sensor.sensorType = val!),
                ),
              ),
              const SizedBox(width: 16),
              if (isCanSensor) Expanded(
                child: Row(
                  children: [
                    _buildTodoFlag(
                      isTodo: widget.sensor.todoCanBus,
                      onChanged: (val) => setState(() => widget.sensor.todoCanBus = val),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.sensor.canBus,
                        decoration: const InputDecoration(labelText: 'CAN Bus', border: OutlineInputBorder()),
                        items: ['Rio', 'CANivore'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                        onChanged: (val) => setState(() => widget.sensor.canBus = val!),
                      ),
                    ),
                  ],
                ),
              ) else const Spacer(),
            ],
          ),

          const Divider(height: 32),

          if (!isSimpleDigitalAnalog && widget.sensor.sensorType != 'UltraSonicSensor')
            SwitchListTile(
              secondary: _buildTodoFlag(
                isTodo: widget.sensor.todoInverted,
                onChanged: (val) => setState(() => widget.sensor.todoInverted = val),
              ),
              title: const Text('Inverted'),
              value: widget.sensor.inverted,
              onChanged: (val) => setState(() => widget.sensor.inverted = val),
              contentPadding: EdgeInsets.zero,
            ),
          
          if (isGyro) ...[
            SwitchListTile(
              secondary: _buildTodoFlag(isTodo: widget.sensor.todoCompass, onChanged: (val) => setState(() => widget.sensor.todoCompass = val)),
              title: const Text('Enable Compass'),
              value: widget.sensor.compass,
              onChanged: (val) => setState(() => widget.sensor.compass = val),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              secondary: _buildTodoFlag(isTodo: widget.sensor.todoTempComp, onChanged: (val) => setState(() => widget.sensor.todoTempComp = val)),
              title: const Text('Temperature Compensation'),
              value: widget.sensor.tempCompensation,
              onChanged: (val) => setState(() => widget.sensor.tempCompensation = val),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              secondary: _buildTodoFlag(isTodo: widget.sensor.todoNoMotion, onChanged: (val) => setState(() => widget.sensor.todoNoMotion = val)),
              title: const Text('No Motion Calibration'),
              value: widget.sensor.noMotionCalibration,
              onChanged: (val) => setState(() => widget.sensor.noMotionCalibration = val),
              contentPadding: EdgeInsets.zero,
            ),
          ],

          if (hasOffset && widget.sensor.sensorType != 'Pigeon') ...[
            const Divider(height: 16),
            AutoCheckField(
              label: 'Offset',
              initialValue: widget.sensor.offset.toString(), defaultValue: '0.0',
              initialUse: widget.sensor.useOffset, initialTodo: widget.sensor.todoOffset,
              onChanged: (val) => widget.sensor.offset = double.tryParse(val) ?? 0.0,
              onUseChanged: (c) => widget.sensor.useOffset = c, onTodoChanged: (t) => widget.sensor.todoOffset = t,
            ),
          ],

          if (widget.sensor.sensorType == 'AnalogEncoder' || widget.sensor.sensorType == 'DigitalEncoder') ...[
            AutoCheckField(
              label: 'Full Range (Radians)',
              initialValue: widget.sensor.fullRange.toString(), defaultValue: '6.28318',
              initialUse: widget.sensor.useFullRange, initialTodo: widget.sensor.todoFullRange,
              onChanged: (val) => widget.sensor.fullRange = double.tryParse(val) ?? 6.28318,
              onUseChanged: (c) => widget.sensor.useFullRange = c, onTodoChanged: (t) => widget.sensor.todoFullRange = t,
            ),
            Row(
              children: [
                Expanded(
                  child: AutoCheckField(
                    label: 'Min Range',
                    initialValue: widget.sensor.minRange.toString(), defaultValue: '0.0',
                    initialUse: widget.sensor.useMinRange, initialTodo: widget.sensor.todoMinRange,
                    onChanged: (val) => widget.sensor.minRange = double.tryParse(val) ?? 0.0,
                    onUseChanged: (c) => widget.sensor.useMinRange = c, onTodoChanged: (t) => widget.sensor.todoMinRange = t,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AutoCheckField(
                    label: 'Max Range',
                    initialValue: widget.sensor.maxRange.toString(), defaultValue: '1.0',
                    initialUse: widget.sensor.useMaxRange, initialTodo: widget.sensor.todoMaxRange,
                    onChanged: (val) => widget.sensor.maxRange = double.tryParse(val) ?? 1.0,
                    onUseChanged: (c) => widget.sensor.useMaxRange = c, onTodoChanged: (t) => widget.sensor.todoMaxRange = t,
                  ),
                ),
              ],
            ),
          ],

          if (widget.sensor.sensorType == 'DigitalEncoder') ...[
            AutoCheckField(
              label: 'Frequency (Hz)',
              initialValue: widget.sensor.frequency.toString(), defaultValue: '1000.0',
              initialUse: widget.sensor.useFrequency, initialTodo: widget.sensor.todoFrequency,
              onChanged: (val) => widget.sensor.frequency = double.tryParse(val) ?? 1000.0,
              onUseChanged: (c) => widget.sensor.useFrequency = c, onTodoChanged: (t) => widget.sensor.todoFrequency = t,
            ),
          ],

          if (widget.sensor.sensorType == 'UltraSonicSensor') ...[
            const Divider(height: 16),
            Row(
              children: [
                _buildTodoFlag(
                  isTodo: widget.sensor.todoPingChannel,
                  onChanged: (val) => setState(() => widget.sensor.todoPingChannel = val),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: widget.sensor.pingChannel,
                    decoration: const InputDecoration(labelText: 'Ping Channel', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => widget.sensor.pingChannel = val,
                  ),
                ),
              ],
            ),
          ],

          if (isGyro) ...[
            const Divider(height: 32),
            _buildGroupHeader(
              title: 'Mounting Offsets (Degrees)',
              isUsed: widget.sensor.useOffsets,
              isTodo: widget.sensor.todoOffsets,
              onUseChanged: (val) => setState(() => widget.sensor.useOffsets = val),
              onTodoChanged: (val) => setState(() => widget.sensor.todoOffsets = val),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16, runSpacing: 16,
              children: [
                _buildGroupedTextField(
                  label: 'Pitch Offset', initialValue: widget.sensor.pitchOffset, defaultValue: 0.0,
                  onChanged: (v) => widget.sensor.pitchOffset = v,
                  markAsUsed: () => setState(() => widget.sensor.useOffsets = true),
                ),
                _buildGroupedTextField(
                  label: 'Roll Offset', initialValue: widget.sensor.rollOffset, defaultValue: 0.0,
                  onChanged: (v) => widget.sensor.rollOffset = v,
                  markAsUsed: () => setState(() => widget.sensor.useOffsets = true),
                ),
                _buildGroupedTextField(
                  label: 'Yaw Offset', initialValue: widget.sensor.yawOffset, defaultValue: 0.0,
                  onChanged: (v) => widget.sensor.yawOffset = v,
                  markAsUsed: () => setState(() => widget.sensor.useOffsets = true),
                ),
              ],
            ),

            const Divider(height: 32),
            _buildGroupHeader(
              title: 'Scalars',
              isUsed: widget.sensor.useScalars,
              isTodo: widget.sensor.todoScalars,
              onUseChanged: (val) => setState(() => widget.sensor.useScalars = val),
              onTodoChanged: (val) => setState(() => widget.sensor.todoScalars = val),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16, runSpacing: 16,
              children: [
                _buildGroupedTextField(
                  label: 'X Scalar', initialValue: widget.sensor.xScalar, defaultValue: 1.0,
                  onChanged: (v) => widget.sensor.xScalar = v,
                  markAsUsed: () => setState(() => widget.sensor.useScalars = true),
                ),
                _buildGroupedTextField(
                  label: 'Y Scalar', initialValue: widget.sensor.yScalar, defaultValue: 1.0,
                  onChanged: (v) => widget.sensor.yScalar = v,
                  markAsUsed: () => setState(() => widget.sensor.useScalars = true),
                ),
                _buildGroupedTextField(
                  label: 'Z Scalar', initialValue: widget.sensor.zScalar, defaultValue: 1.0,
                  onChanged: (v) => widget.sensor.zScalar = v,
                  markAsUsed: () => setState(() => widget.sensor.useScalars = true),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildTodoFlag({required bool isTodo, required Function(bool) onChanged}) {
    return IconButton(
      icon: Icon(
        isTodo ? Icons.flag : Icons.outlined_flag,
        color: isTodo ? Colors.orange : Colors.grey,
      ),
      tooltip: 'Mark as TODO',
      onPressed: () => onChanged(!isTodo),
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.only(right: 8.0),
    );
  }

  Widget _buildGroupHeader({
    required String title,
    required bool isUsed,
    required bool isTodo,
    required Function(bool) onUseChanged,
    required Function(bool) onTodoChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: isUsed,
          onChanged: (val) => onUseChanged(val ?? false),
        ),
        _buildTodoFlag(
          isTodo: isTodo,
          onChanged: onTodoChanged,
        ),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGroupedTextField({
    required String label,
    required double? initialValue,
    required double defaultValue,
    required Function(double) onChanged,
    required Function() markAsUsed,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 32,
      child: TextFormField(
        initialValue: initialValue?.toString() ?? defaultValue.toString(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        onChanged: (val) {
          double parsed = double.tryParse(val) ?? defaultValue;
          onChanged(parsed);
          if (parsed != defaultValue) {
            markAsUsed();
          }
        },
      ),
    );
  }
}

// ==========================================
// CUSTOM WIDGETS
// ==========================================

class AutoCheckField extends StatefulWidget {
  final String label;
  final String initialValue;
  final String defaultValue;
  final bool initialUse;
  final bool initialTodo;
  final Function(String) onChanged;
  final Function(bool) onUseChanged;
  final Function(bool) onTodoChanged;

  const AutoCheckField({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.defaultValue,
    required this.initialUse,
    required this.initialTodo,
    required this.onChanged,
    required this.onUseChanged,
    required this.onTodoChanged,
  }) : super(key: key);

  @override
  State<AutoCheckField> createState() => _AutoCheckFieldState();
}

class _AutoCheckFieldState extends State<AutoCheckField> {
  late bool isChecked;
  late bool isTodo;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    isChecked = widget.initialUse;
    isTodo = widget.initialTodo;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (val) {
              setState(() => isChecked = val ?? false);
              widget.onUseChanged(isChecked);
            },
          ),
          IconButton(
            icon: Icon(
              isTodo ? Icons.flag : Icons.outlined_flag,
              color: isTodo ? Colors.orange : Colors.grey,
            ),
            tooltip: 'Mark as TODO',
            onPressed: () {
              setState(() => isTodo = !isTodo);
              widget.onTodoChanged(isTodo);
            },
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(right: 8.0),
          ),
          Expanded(
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: widget.label,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              onChanged: (val) {
                widget.onChanged(val);
                
                bool changedFromDefault = double.tryParse(val) != double.tryParse(widget.defaultValue);
                if (changedFromDefault && !isChecked) {
                  setState(() => isChecked = true);
                  widget.onUseChanged(true);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// CODE GENERATOR
// ==========================================

class JavaCodeGenerator {
  static String _capitalize(String s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
  
  static String _constantize(String s) {
    String replaced = s.replaceAll(' ', '_');
    // Convert camelCase to CONSTANT_CASE
    replaced = replaced.replaceAllMapped(RegExp(r'(?<=[a-z])([A-Z])'), (Match m) => '_${m.group(1)}');
    return replaced.toUpperCase();
  }

  static String _todo(bool isTodo) => isTodo ? ' // TODO' : '';

  static Map<String, String> generateMechanismFiles(MechanismModel mech) {
    Map<String, String> files = {};
    
    if (mech.name.isEmpty) return files;

    String mechNameLower = mech.name.replaceAll(' ', '').toLowerCase();
    String mechNameCap = _capitalize(mech.name.replaceAll(' ', ''));
    
    files['$mechNameLower/${mechNameCap}Constants.java'] = _generateConstants(mech, mechNameCap, mechNameLower);
    
    files['$mechNameLower/subsystems/$mechNameCap.java'] = _generateSubsystem(mech, mechNameCap, mechNameLower);
    
    if (mech.useDefaultCommand) {
      files['$mechNameLower/commands/${mechNameCap}Command.java'] = _generateDefaultCommand(mech, mechNameCap, mechNameLower);
    }

    for (var calib in mech.calibrationCommands) {
      String motorNameCap = _capitalize(calib.motorName.replaceAll(' ', ''));
      String cmdName = '${motorNameCap}CalibrationCommand';
      files['$mechNameLower/commands/$cmdName.java'] = _generateCalibrationCommand(mech, calib, mechNameCap, mechNameLower, cmdName);
    }

    return files;
  }

  static String _generateConstants(MechanismModel mech, String mechNameCap, String mechNameLower) {
    StringBuffer sb = StringBuffer();
    String mechConstName = '${_constantize(mech.name)}_NAME';

    sb.writeln('package frc.robot.$mechNameLower;');
    sb.writeln('');
    
    if (mech.useStates) {
      sb.writeln('import frc.demacia.utils.mechanisms.StateBaseMechanism.MechanismState;');
      if (mech.statesType == 'dynamic states') {
        sb.writeln('import frc.robot.$mechNameLower.subsystems.$mechNameCap;');
      }
    }

    bool hasCanBus = mech.motors.any((m) => m.motorType == 'TalonFX' || m.motorType == 'TalonSRX') ||
                     mech.sensors.any((s) => s.sensorType == 'Cancoder' || s.sensorType == 'Pigeon');
    
    if (hasCanBus) {
      sb.writeln('import frc.demacia.utils.motors.BaseMotorConfig.Canbus;');
    }

    Set<String> motorTypes = mech.motors.map((m) => m.motorType).toSet();
    for (String mt in motorTypes) {
      sb.writeln('import frc.demacia.utils.motors.${mt}Config;');
    }

    Set<String> sensorTypes = mech.sensors.map((s) => s.sensorType).toSet();
    for (String st in sensorTypes) {
      sb.writeln('import frc.demacia.utils.sensors.${st}Config;');
    }

    sb.writeln('');
    sb.writeln('public class ${mechNameCap}Constants {');
    sb.writeln('    public static final String $mechConstName = "${mech.name.toLowerCase()}";');
    sb.writeln('');

    // Motors Constants
    for (var motor in mech.motors) {
      if (motor.name.isEmpty) continue;
      String mBaseName = motor.name.replaceAll(' ', '');
      String mConst = _constantize(mBaseName);
      String mClass = '${_capitalize(mBaseName)}Constants';
      
      sb.writeln('    public static final class $mClass {');
      sb.writeln('        public static final String ${mConst}_NAME = "${motor.name}";');
      sb.writeln('        public static final int ${mConst}_ID = ${motor.id.isEmpty ? '0' : motor.id};${_todo(motor.todoId)}');
      
      bool isCanMotor = motor.motorType == 'TalonFX' || motor.motorType == 'TalonSRX';
      if (isCanMotor) {
        sb.writeln('        public static final Canbus ${mConst}_CANBUS = Canbus.${motor.canBus};${_todo(motor.todoCanBus)}');
      }
      
      sb.writeln('        public static final boolean ${mConst}_BRAKE = ${motor.brakeMode};${_todo(motor.todoBrakeMode)}');
      sb.writeln('        public static final boolean ${mConst}_INVERT = ${motor.inverted};${_todo(motor.todoInverted)}');
      
      if (motor.useMaxVolt) {
        sb.writeln('        public static final boolean ${mConst}_MAX_VOLTAGE = ${motor.maxVolt};${_todo(motor.todoMaxVolt)}');
      }
      if (motor.useMaxCurrent) {
        sb.writeln('        public static final boolean ${mConst}_MAX_CURRENT = ${motor.maxCurrent};${_todo(motor.todoMaxCurrent)}');
      }
      if (motor.useRampUpTime) {
        sb.writeln('        public static final double ${mConst}_RAMP_UP_TIME = ${motor.rampUpTime};${_todo(motor.todoRampUpTime)}');
      }

      if (motor.useRadiansMotor) {
        sb.writeln('        public static final double ${mConst}_GEAR_RATIO = ${motor.gearRatio};${_todo(motor.todoGearRatio)}');
      }
      if (motor.useMeterMotor) {
        sb.writeln('        public static final double ${mConst}_GEAR_RATIO = ${motor.gearRatio};${_todo(motor.todoGearRatio)}');
        sb.writeln('        public static final double ${mConst}_DIAMETER = ${motor.diameter};${_todo(motor.todoDiameter)}');
      }

      // PID & Advanced Control Constants
      if (motor.usePIDFF) {
        String t = _todo(motor.todoPIDFF);
        sb.writeln('        public static final double ${mConst}_KP = ${motor.kP};$t');
        sb.writeln('        public static final double ${mConst}_KI = ${motor.kI};$t');
        sb.writeln('        public static final double ${mConst}_KD = ${motor.kD};$t');
        sb.writeln('        public static final double ${mConst}_KS = ${motor.kS};$t');
        sb.writeln('        public static final double ${mConst}_KV = ${motor.kV};$t');
        sb.writeln('        public static final double ${mConst}_KA = ${motor.kA};$t');
        sb.writeln('        public static final double ${mConst}_KG = ${motor.kG};$t');
      }
      if (motor.useAdvancedFF) {
        String t = _todo(motor.todoAdvancedFF);
        sb.writeln('        public static final double ${mConst}_KV2 = ${motor.kV2};$t');
        sb.writeln('        public static final double ${mConst}_KSIN = ${motor.kSin};$t');
      }
      if (motor.useMotionMagic) {
        String t = _todo(motor.todoMotionMagic);
        sb.writeln('        public static final double ${mConst}_MAX_VELOCITY = ${motor.maxVelocity};$t');
        sb.writeln('        public static final double ${mConst}_MAX_ACCELERATION = ${motor.maxAcceleration};$t');
        sb.writeln('        public static final double ${mConst}_MAX_JERK = ${motor.maxJerk};$t');
        sb.writeln('        public static final double ${mConst}_MAX_POSITION_ERROR = ${motor.maxPositionError};$t');
      }
      if (motor.useStallDetection) {
        String t = _todo(motor.todoStallDetection);
        sb.writeln('        public static final double ${mConst}_HIGH_CURRENT_THRESHOLD = ${motor.highCurrentThreshold};$t');
        sb.writeln('        public static final double ${mConst}_LOW_VELOCITY_THRESHOLD = ${motor.lowVelocityThreshold};$t');
        sb.writeln('        public static final double ${mConst}_SECONDS_THRESHOLD = ${motor.secondsThreshold};$t');
      }

      sb.writeln('');
      
      String configArgs = isCanMotor ? '${mConst}_ID, ${mConst}_CANBUS, ${mConst}_NAME' : '${mConst}_ID, ${mConst}_NAME';
      sb.writeln('        public static final ${motor.motorType}Config ${mConst}_MOTOR_CONFIG = new ${motor.motorType}Config($configArgs)');
      sb.writeln('            .withBrake(${mConst}_BRAKE)');
      sb.write('            .withInvert(${mConst}_INVERT)');

      if (motor.useMaxVolt) {
        sb.writeln('');
        sb.writeln('            .withVolts(${mConst}_MAX_VOLTAGE)');
      }
      if (motor.useMaxCurrent) {
        sb.writeln('            .withCurrent(${mConst}_MAX_CURRENT)');
      }
      if (motor.useRampUpTime) {
        sb.writeln('            .withRampTime(${mConst}_RAMP_UP_TIME)');
      }

      if (motor.useRadiansMotor) {
        sb.writeln('            .withRadiansMotor(${mConst}_GEAR_RATIO)');
      }
      if (motor.useMeterMotor) {
        sb.writeln('            .withMeterMotor(${mConst}_GEAR_RATIO), ${mConst}_DIAMETER)');
      }
      
      if (motor.usePIDFF) {
         sb.write('            .withPID(${mConst}_KP, ${mConst}_KI, ${mConst}_KD),${mConst}_KS, ${mConst}_KV, ${mConst}_KA, ${mConst}_KG)');
         }
      if (motor.useAdvancedFF) {
         sb.writeln('');
         sb.write('            .withAdvancedFF(${mConst}_KV2, ${mConst}_KSIN)');
      }
      if (motor.useMotionMagic) {
         sb.writeln('');
         sb.write('            .withMotionMagic(${mConst}_MAX_VELOCITY, ${mConst}_MAX_ACCELERATION, ${mConst}_MAX_JERK, ${mConst}_MAX_POSITION_ERROR)');
      }
      if (motor.useStallDetection) {
         sb.writeln('');
         sb.write('            .withStallDetection(${mConst}_HIGH_CURRENT_THRESHOLD, ${mConst}_LOW_VELOCITY_THRESHOLD, ${mConst}_SECONDS_THRESHOLD)');
      }
      sb.writeln(';');

      // Limits Constants
      var limit = mech.limits.where((l) => l.motorName == motor.name).firstOrNull;
      if (limit != null) {
        sb.writeln('        public static final double ${mConst}_MIN_LIMIT = ${limit.minLimit};${_todo(limit.todoMinLimit)}');
        sb.writeln('        public static final double ${mConst}_MAX_LIMIT = ${limit.maxLimit};${_todo(limit.todoMaxLimit)}');
      }

      // Calibration Constants
      var calibCmd = mech.calibrationCommands.where((c) => c.motorName == motor.name).firstOrNull;
      var autoCalib = mech.autoCalibrations.where((c) => c.motorName == motor.name).firstOrNull;
      if (calibCmd != null) {
        sb.writeln('        public static final double ${mConst}_CALIBRATION_POWER = ${calibCmd.power};${_todo(calibCmd.todoPower)}');
        sb.writeln('        public static final double ${mConst}_CALIBRATION_RESET_POS = ${calibCmd.resetPos};${_todo(calibCmd.todoResetPos)}');
      } else if (autoCalib != null) {
        sb.writeln('        public static final double ${mConst}_CALIBRATION_RESET_POS = ${autoCalib.resetPos};${_todo(autoCalib.todoResetPos)}');
      }
      sb.writeln('    }');
      sb.writeln('');
    }

    // Sensors Constants
    for (var sensor in mech.sensors) {
      if (sensor.name.isEmpty) continue;
      String sBaseName = '${sensor.name.replaceAll(' ', '')}${sensor.sensorType}';
      String sConst = _constantize(sBaseName);
      String sClass = '${_capitalize(sBaseName)}Constants';
      
      sb.writeln('    public static final class $sClass {');
      sb.writeln('        public static final String ${sConst}_NAME = "$sBaseName";');
      
      bool isCanSensor = sensor.sensorType == 'Cancoder' || sensor.sensorType == 'Pigeon';
      bool isColorSensor = sensor.sensorType == 'ColorSensor';
      
      if (!isColorSensor) {
        sb.writeln('        public static final int ${sConst}_ID = ${sensor.idOrPort.isEmpty ? '0' : sensor.idOrPort};${_todo(sensor.todoId)}');
      }
      
      if (isCanSensor) {
        sb.writeln('        public static final Canbus ${sConst}_CANBUS = Canbus.${sensor.canBus};${_todo(sensor.todoCanBus)}');
      }
      
      if (sensor.sensorType == 'UltraSonicSensor') {
        sb.writeln('        public static final int ${sConst}_PING_CHANNEL = ${sensor.pingChannel.isEmpty ? '0' : sensor.pingChannel};${_todo(sensor.todoPingChannel)}');
      }
      
      bool hasInvert = sensor.sensorType != 'ColorSensor' && sensor.sensorType != 'OpticalSensor' && sensor.sensorType != 'LidarSensor' && sensor.sensorType != 'UltraSonicSensor';
      if (hasInvert) {
        sb.writeln('        public static final boolean ${sConst}_INVERT = ${sensor.inverted};${_todo(sensor.todoInverted)}');
      }
      
      bool hasOffset = sensor.sensorType == 'Cancoder' || sensor.sensorType == 'AnalogEncoder' || sensor.sensorType == 'DigitalEncoder';
      if (hasOffset && sensor.useOffset) {
        sb.writeln('        public static final double ${sConst}_OFFSET = ${sensor.offset};${_todo(sensor.todoOffset)}');
      }
      
      bool hasRange = sensor.sensorType == 'AnalogEncoder' || sensor.sensorType == 'DigitalEncoder';
      if (hasRange) {
        if (sensor.useFullRange) sb.writeln('        public static final double ${sConst}_FULL_RANGE = ${sensor.fullRange};${_todo(sensor.todoFullRange)}');
        if (sensor.useMinRange) sb.writeln('        public static final double ${sConst}_MIN_RANGE = ${sensor.minRange};${_todo(sensor.todoMinRange)}');
        if (sensor.useMaxRange) sb.writeln('        public static final double ${sConst}_MAX_RANGE = ${sensor.maxRange};${_todo(sensor.todoMaxRange)}');
      }
      
      if (sensor.sensorType == 'DigitalEncoder' && sensor.useFrequency) {
        sb.writeln('        public static final double ${sConst}_FREQUENCY = ${sensor.frequency};${_todo(sensor.todoFrequency)}');
      }
      
      if (sensor.sensorType == 'Pigeon') {
        if (sensor.useOffsets) {
          sb.writeln('        public static final double ${sConst}_PITCH_OFFSET = ${sensor.pitchOffset};${_todo(sensor.todoOffsets)}');
          sb.writeln('        public static final double ${sConst}_ROLL_OFFSET = ${sensor.rollOffset};${_todo(sensor.todoOffsets)}');
          sb.writeln('        public static final double ${sConst}_YAW_OFFSET = ${sensor.yawOffset};${_todo(sensor.todoOffsets)}');
        }
        if (sensor.useScalars) {
          sb.writeln('        public static final double ${sConst}_X_SCALAR = ${sensor.xScalar};${_todo(sensor.todoScalars)}');
          sb.writeln('        public static final double ${sConst}_Y_SCALAR = ${sensor.yScalar};${_todo(sensor.todoScalars)}');
          sb.writeln('        public static final double ${sConst}_Z_SCALAR = ${sensor.zScalar};${_todo(sensor.todoScalars)}');
        }
        sb.writeln('        public static final boolean ${sConst}_COMPASS = ${sensor.compass};${_todo(sensor.todoCompass)}');
        sb.writeln('        public static final boolean ${sConst}_TEMP_COMP = ${sensor.tempCompensation};${_todo(sensor.todoTempComp)}');
        sb.writeln('        public static final boolean ${sConst}_NO_MOTION_CALIB = ${sensor.noMotionCalibration};${_todo(sensor.todoNoMotion)}');
      }
      
      // Construct configArgs correctly based on constructor definitions
      String configArgs;
      if (isCanSensor) {
        configArgs = '${sConst}_ID, ${sConst}_CANBUS, ${sConst}_NAME';
      } else if (sensor.sensorType == 'ColorSensor') {
        configArgs = '${sConst}_NAME';
      } else if (sensor.sensorType == 'OpticalSensor' || sensor.sensorType == 'LidarSensor') {
        configArgs = '${sConst}_NAME, ${sConst}_ID';
      } else if (sensor.sensorType == 'UltraSonicSensor') {
        configArgs = '${sConst}_ID, ${sConst}_PING_CHANNEL, ${sConst}_NAME';
      } else {
        configArgs = '${sConst}_ID, ${sConst}_NAME';
      }
      
      sb.write('        public static final ${sensor.sensorType}Config ${sConst}_CONFIG = new ${sensor.sensorType}Config($configArgs)');
      
      if (hasInvert) {
        sb.write('\n            .withInvert(${sConst}_INVERT)');
      }
      
      if (hasOffset && sensor.useOffset) {
        sb.write('\n            .withOffset(${sConst}_OFFSET)');
      }
      
      if (hasRange) {
        if (sensor.useFullRange) {
          if (sensor.sensorType == 'AnalogEncoder') sb.write('\n            .withFullRange(${sConst}_FULL_RANGE)');
          if (sensor.sensorType == 'DigitalEncoder') sb.write('\n            .withScalar(${sConst}_FULL_RANGE)');
        }
        if (sensor.useMinRange && sensor.useMaxRange) {
          sb.write('\n            .withRange(${sConst}_MIN_RANGE, ${sConst}_MAX_RANGE)');
        } else if (sensor.useMinRange) {
          sb.write('\n            .withMinRange(${sConst}_MIN_RANGE)');
        } else if (sensor.useMaxRange) {
          sb.write('\n            .withMaxRange(${sConst}_MAX_RANGE)');
        }
      }
      
      if (sensor.sensorType == 'DigitalEncoder' && sensor.useFrequency) {
        sb.write('\n            .withFrequency(${sConst}_FREQUENCY)');
      }
      
      if (sensor.sensorType == 'Pigeon') {
        if (sensor.useOffsets) {
          sb.write('\n            .withPitchOffset(${sConst}_PITCH_OFFSET)');
          sb.write('\n            .withRollOffset(${sConst}_ROLL_OFFSET)');
          sb.write('\n            .withYawOffset(${sConst}_YAW_OFFSET)');
        }
        if (sensor.useScalars) {
          sb.write('\n            .withXScalar(${sConst}_X_SCALAR)');
          sb.write('\n            .withYScalar(${sConst}_Y_SCALAR)');
          sb.write('\n            .withZScalar(${sConst}_Z_SCALAR)');
        }
        sb.write('\n            .withCompass(${sConst}_COMPASS)');
        sb.write('\n            .withTemperatureCompensation(${sConst}_TEMP_COMP)');
        sb.write('\n            .withNoMotionCalibration(${sConst}_NO_MOTION_CALIB)');
      }
      
      sb.writeln(';');
      sb.writeln('    }');
      sb.writeln('');
    }

    // States Enum
    if (mech.useStates) {
      sb.writeln('    public static enum ${mechNameCap}States implements MechanismState {');
      
      for (int i = 0; i < mech.states.length; i++) {
        var state = mech.states[i];
        String stateName = _constantize(state.name.isEmpty ? 'STATE_$i' : state.name);
        
        if (mech.statesType == 'fixed states') {
          List<String> values = [];
          for (var motor in mech.motors) {
            values.add(state.motorValues[motor.name]?.toString() ?? '0.0');
          }
          sb.write('        $stateName(${values.join(', ')})');
        } else {
          sb.write('        $stateName');
        }
        sb.writeln(i == mech.states.length - 1 ? ';' : ',');
      }

      sb.writeln('');
      if (mech.statesType == 'fixed states') {
        sb.writeln('        private final double[] values;');
        sb.writeln('        private ${mechNameCap}States(double... vals) { this.values = vals; }');
        sb.writeln('        @Override public double[] getValues() { return values; }');
      } else {
        sb.writeln('        @Override public double[] getValues() {');
        sb.writeln('            return ${mechNameCap}.getInstance().get${mechNameCap}Values();');
        sb.writeln('        }');
      }
      sb.writeln('    }');
    }
    
    sb.writeln('}');
    return sb.toString();
  }

  static String _generateSubsystem(MechanismModel mech, String mechNameCap, String mechNameLower) {
    StringBuffer sb = StringBuffer();
    String mechConstName = '${mechNameCap}Constants.${_constantize(mech.name)}_NAME';

    sb.writeln('package frc.robot.$mechNameLower.subsystems;');
    sb.writeln('');
    
    if (mech.useStates) {
      sb.writeln('import frc.demacia.utils.mechanisms.StateBaseMechanism;');
    } else {
      sb.writeln('import frc.demacia.utils.mechanisms.BaseMechanism;');
    }
    
    sb.writeln('import frc.demacia.utils.motors.MotorInterface;');
    sb.writeln('import frc.demacia.utils.sensors.SensorInterface;');
    
    Set<String> motorTypes = mech.motors.map((m) => m.motorType).toSet();
    for (String mt in motorTypes) {
      sb.writeln('import frc.demacia.utils.motors.${mt}Motor;');
    }
    
    Set<String> sensorTypes = mech.sensors.map((s) => s.sensorType).toSet();
    for (String st in sensorTypes) {
      sb.writeln('import frc.demacia.utils.sensors.$st;');
    }
    
    if (mech.powerCommands.isNotEmpty) {
      sb.writeln('import frc.robot.RobotContainer;');
    }

    sb.writeln('import frc.robot.$mechNameLower.${mechNameCap}Constants;');
    sb.writeln('import frc.robot.$mechNameLower.${mechNameCap}Constants.*;');
    
    // Static imports for Constants
    for (var motor in mech.motors) {
      String mClass = '${_capitalize(motor.name.replaceAll(' ', ''))}Constants';
      sb.writeln('import static frc.robot.$mechNameLower.${mechNameCap}Constants.$mClass.*;');
    }
    for (var sensor in mech.sensors) {
      String sBaseName = '${sensor.name.replaceAll(' ', '')}${sensor.sensorType}';
      String sClass = '${_capitalize(sBaseName)}Constants';
      sb.writeln('import static frc.robot.$mechNameLower.${mechNameCap}Constants.$sClass.*;');
    }
    
    sb.writeln('');
    
    String parentClass = mech.useStates ? 'StateBaseMechanism' : 'BaseMechanism';
    
    sb.writeln('public class $mechNameCap extends $parentClass {');
    sb.writeln('    private static $mechNameCap instance;');
    sb.writeln('');
    sb.writeln('    public $mechNameCap() {');
    sb.writeln('        super($mechConstName, ');
    
    // Motors array
    sb.writeln('        new MotorInterface[] {');
    for (var motor in mech.motors) {
      if (motor.name.isEmpty) continue;
      String mConst = _constantize(motor.name.replaceAll(' ', ''));
      sb.writeln('            new ${motor.motorType}Motor(${mConst}_MOTOR_CONFIG),');
    }
    sb.writeln('        }, ');

    // Sensors array
    sb.writeln('        new SensorInterface[] {');
    if (mech.sensors.isEmpty) {
      sb.writeln('            // No sensors configured');
    } else {
      for (var sensor in mech.sensors) {
        String sBaseName = '${sensor.name.replaceAll(' ', '')}${sensor.sensorType}';
        String sConst = _constantize(sBaseName);
        sb.writeln('            new ${sensor.sensorType}(${sConst}_CONFIG),');
      }
    }
    sb.writeln('        }' + (mech.useStates ? ', ' : ');'));

    if (mech.useStates) {
      sb.writeln('        ${mechNameCap}States.class);');
    }
    sb.writeln('');
    
    // Limits
    for (var limit in mech.limits) {
      String mConst = _constantize(limit.motorName.replaceAll(' ', ''));
      sb.writeln('        addLimit(${mConst}_NAME, ${mConst}_MIN_LIMIT, ${mConst}_MAX_LIMIT);');
    }

    // Power Commands
    for (var pc in mech.powerCommands) {
      String mConst = _constantize(pc.motorName.replaceAll(' ', ''));
      String supplierLogic = '0.0';
      switch (pc.supplier) {
        case 'Controller rightX': supplierLogic = 'RobotContainer.controller.getRightX()'; break;
        case 'Controller rightY': supplierLogic = 'RobotContainer.controller.getRightY()'; break;
        case 'Controller leftX': supplierLogic = 'RobotContainer.controller.getLeftX()'; break;
        case 'Controller leftY': supplierLogic = 'RobotContainer.controller.getLeftY()'; break;
      }
      sb.writeln('        withPowerCommand(${mConst}_NAME, () -> $supplierLogic);');
    }

    sb.writeln('    }');
    sb.writeln('');

    // getInstance() immediately after constructor
    sb.writeln('    public static $mechNameCap getInstance() {');
    sb.writeln('        if (instance == null) {');
    sb.writeln('            instance = new $mechNameCap();');
    sb.writeln('        }');
    sb.writeln('        return instance;');
    sb.writeln('    }');
    sb.writeln('');
    
    // Dynamic States Method
    if (mech.useStates && mech.statesType == 'dynamic states') {
      sb.writeln('    public double[] get${mechNameCap}Values() {');
      sb.writeln('        switch ((${mechNameCap}States) state) {');
      for (var state in mech.states) {
        String sName = _constantize(state.name.isEmpty ? 'STATE' : state.name);
        sb.writeln('            case $sName:');
        sb.writeln('                break;');
      }
      sb.writeln('            default:');
      sb.writeln('                break;');
      sb.writeln('        }');
      sb.writeln('        ');
      sb.writeln('        // TODO Auto-generated method stub');
      sb.writeln('        throw new UnsupportedOperationException("Unimplemented method \'get${mechNameCap}Values\'");');
      sb.writeln('    }');
      sb.writeln('');
    }

    // Calibration condition methods
    Set<String> calibMotors = {};
    for (var calib in mech.autoCalibrations) calibMotors.add(calib.motorName);
    for (var calib in mech.calibrationCommands) calibMotors.add(calib.motorName);

    for (String motorName in calibMotors) {
      dynamic calib;
      for (var c in mech.autoCalibrations) {
        if (c.motorName == motorName) calib = c;
      }
      if (calib == null) {
        for (var c in mech.calibrationCommands) {
          if (c.motorName == motorName) calib = c;
        }
      }

      if (calib != null) {
        String motorNameCap = _capitalize(motorName.replaceAll(' ', ''));
        sb.writeln('    public boolean at${motorNameCap}ResetPos() {');
        if (calib.atResetPosMethod == 'when sensor true') {
          dynamic sensor;
          for (var s in mech.sensors) {
            if (s.name == calib.sensorName) sensor = s;
          }
          
          if (sensor != null) {
            String sBaseName = '${sensor.name.replaceAll(' ', '')}${sensor.sensorType}';
            String sConst = _constantize(sBaseName);
            
            if (sensor.sensorType == 'LimitSwitch') {
              sb.writeln('        return ((LimitSwitch) getSensor(${sConst}_NAME)).get();');
            } else {
              sb.writeln('        return ((${sensor.sensorType}) getSensor(${sConst}_NAME)).getBoolean(); // TODO check method name for this sensor');
            }
          } else {
            sb.writeln('        return false; // TODO Sensor not found');
          }
        } else {
          sb.writeln('        // TODO Auto-generated method stub');
          sb.writeln('        return false;');
        }
        sb.writeln('    }');
        sb.writeln('');
      }
    }

    sb.writeln('}');
    return sb.toString();
  }

  static String _generateDefaultCommand(MechanismModel mech, String mechNameCap, String mechNameLower) {
    StringBuffer sb = StringBuffer();
    sb.writeln('package frc.robot.$mechNameLower.commands;');
    sb.writeln('');
    sb.writeln('import frc.demacia.utils.mechanisms.DefaultCommand;');
    sb.writeln('import frc.demacia.utils.motors.MotorInterface.ControlMode;');
    sb.writeln('import frc.robot.$mechNameLower.subsystems.$mechNameCap;');
    sb.writeln('');
    sb.writeln('public class ${mechNameCap}Command extends DefaultCommand {');
    sb.writeln('    ');
    sb.writeln('    public ${mechNameCap}Command() {');
    sb.writeln('        super($mechNameCap.getInstance(), new ControlMode[] {');
    
    for (int i = 0; i < mech.motors.length; i++) {
      var motor = mech.motors[i];
      String mode = mech.defaultControlModes[motor.name] ?? 'DUTYCYCLE';
      sb.write('            ControlMode.$mode');
      if (i < mech.motors.length - 1) sb.write(',');
      sb.writeln('');
    }
    
    sb.writeln('        });');
    sb.writeln('    }');
    sb.writeln('}');
    return sb.toString();
  }

  static String _generateCalibrationCommand(MechanismModel mech, CalibCmdConfig calib, String mechNameCap, String mechNameLower, String cmdName) {
    StringBuffer sb = StringBuffer();
    String motorNameCap = _capitalize(calib.motorName.replaceAll(' ', ''));
    String mClass = '${motorNameCap}Constants';
    String mConst = _constantize(calib.motorName.replaceAll(' ', ''));
    
    sb.writeln('package frc.robot.$mechNameLower.commands;');
    sb.writeln('');
    sb.writeln('import frc.demacia.utils.mechanisms.CalibrationCommand;');
    sb.writeln('import frc.robot.$mechNameLower.subsystems.$mechNameCap;');
    sb.writeln('import static frc.robot.$mechNameLower.${mechNameCap}Constants.$mClass.*;');
    sb.writeln('');
    sb.writeln('public class $cmdName extends CalibrationCommand {');
    sb.writeln('');
    sb.writeln('    public $cmdName($mechNameCap mechanism) {');
    sb.writeln('        super(');
    sb.writeln('            mechanism, ');
    sb.writeln('            ${mConst}_NAME, ');
    sb.writeln('            ${mConst}_CALIBRATION_POWER,');
    sb.writeln('            mechanism::at${motorNameCap}ResetPos, ');
    sb.writeln('            ${mConst}_CALIBRATION_RESET_POS');
    sb.writeln('        );');
    sb.writeln('    }');
    sb.writeln('}');
    return sb.toString();
  }

  static String generateChassisConstants(ChassisModel chassis) {
    StringBuffer sb = StringBuffer();
    
    String className = _capitalize(chassis.name.replaceAll(' ', '')) + 'ChassisConstants';
    String constName = chassis.name + " Chassis";

    sb.writeln('package frc.robot.chassis;');
    sb.writeln('');
    sb.writeln('import edu.wpi.first.math.geometry.Translation2d;');
    sb.writeln('import frc.demacia.utils.motors.TalonFXConfig;');
    sb.writeln('import frc.demacia.utils.chassis.ChassisConfig;');
    sb.writeln('import frc.demacia.utils.chassis.SwerveModuleConfig;');
    sb.writeln('import frc.demacia.utils.motors.BaseMotorConfig.Canbus;');
    sb.writeln('import frc.demacia.utils.sensors.CancoderConfig;');
    sb.writeln('import frc.demacia.utils.sensors.PigeonConfig;');
    sb.writeln('');
    sb.writeln('public class $className {');
    sb.writeln('');
    sb.writeln('  public static final String NAME = "$constName";');
    sb.writeln('');
    sb.writeln('  public static final int PIGEON_ID = ${chassis.pigeonId.isEmpty ? '0' : chassis.pigeonId};${_todo(chassis.todoPigeonId)}');
    sb.writeln('  public static final Canbus CAN_BUS = Canbus.${chassis.canBus};${_todo(chassis.todoCanBus)}');
    sb.writeln('  public static final Canbus PIGEON_CAN_BUS = Canbus.${chassis.pigeonCanBus};${_todo(chassis.todoPigeonCanBus)}');
    sb.writeln('  public static final double STEER_GEAR_RATIO = ${chassis.steerGearRatio};${_todo(chassis.todoSteerGearRatio)}');
    sb.writeln('  public static final double DRIVE_GEAR_RATIO = ${chassis.driveGearRatio};${_todo(chassis.todoDriveGearRatio)}');
    sb.writeln('  public static final double WHEEL_DIAMETER = ${chassis.wheelDiameter};${_todo(chassis.todoWheelDiameter)}');
    sb.writeln('');
    sb.writeln('  public static final double STEER_KP = ${chassis.steerKP};${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('  public static final double STEER_KI = ${chassis.steerKI};${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('  public static final double STEER_KD = ${chassis.steerKD};${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('  public static final double STEER_KS = ${chassis.steerKS};${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('  public static final double STEER_KV = ${chassis.steerKV};${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('  public static final double STEER_KA = ${chassis.steerKA};${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('');
    sb.writeln('  public static final double DRIVE_KP = ${chassis.driveKP};${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('  public static final double DRIVE_KI = ${chassis.driveKI};${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('  public static final double DRIVE_KD = ${chassis.driveKD};${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('  public static final double DRIVE_KS = ${chassis.driveKS};${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('  public static final double DRIVE_KV = ${chassis.driveKV};${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('  public static final double DRIVE_KA = ${chassis.driveKA};${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('');
    sb.writeln('  public static final double MOTION_MAGIC_VEL = ${chassis.motionMagicVel};${_todo(chassis.todoMotionMagic)}');
    sb.writeln('  public static final double MOTION_MAGIC_ACCEL = ${chassis.motionMagicAccel};${_todo(chassis.todoMotionMagic)}');
    sb.writeln('  public static final double MOTION_MAGIC_JERK = ${chassis.motionMagicJerk};${_todo(chassis.todoMotionMagic)}');
    sb.writeln('');
    sb.writeln('  public static final double MAX_DRIVE_VELOCITY = ${chassis.maxDriveVelocity};${_todo(chassis.todoMaxDriveVelocity)}');
    sb.writeln('  public static final double RAMP_TIME_STEER = ${chassis.rampTimeSteer};${_todo(chassis.todoRampTimeSteer)}');
    sb.writeln('');
    sb.writeln('  public static final Translation2d[] MODULE_LOCATIONS = {');
    sb.writeln('    /* Front Left Position: */  new Translation2d(${chassis.flX}${_todo(chassis.todoFlX)}, ${chassis.flY}${_todo(chassis.todoFlY)}),');
    sb.writeln('    /* Front Right Position: */ new Translation2d(${chassis.frX}${_todo(chassis.todoFrX)}, ${chassis.frY}${_todo(chassis.todoFrY)}),');
    sb.writeln('    /* Back Left Position: */   new Translation2d(${chassis.blX}${_todo(chassis.todoBlX)}, ${chassis.blY}${_todo(chassis.todoBlY)}),');
    sb.writeln('    /* Back Right Position: */  new Translation2d(${chassis.brX}${_todo(chassis.todoBrX)}, ${chassis.brY}${_todo(chassis.todoBrY)})');
    sb.writeln('  };');
    sb.writeln('');
    sb.writeln('  public static final SwerveModuleConfig[] swerveModules(double[] offsets) {');
    sb.writeln('    SwerveModuleConfig[] ans = new SwerveModuleConfig[4];');
    sb.writeln('    for (int i = 0; i < 4; i++) {');
    sb.writeln('      String name = "Error";');
    sb.writeln('      switch (i) {');
    sb.writeln('        case 0: name = "Front Left"; break;');
    sb.writeln('        case 1: name = "Front Right"; break;');
    sb.writeln('        case 2: name = "Back Left"; break;');
    sb.writeln('        case 3: name = "Back Right"; break;');
    sb.writeln('      }');
    sb.writeln('');
    sb.writeln('      ans[i] = new SwerveModuleConfig(');
    sb.writeln('          name,');
    sb.writeln('          new TalonFXConfig(i * 3 + 2, CAN_BUS, name + " Steer")');
    sb.writeln('              .withPID(STEER_KP, STEER_KI, STEER_KD, STEER_KS, STEER_KV, STEER_KA, 0)');
    sb.writeln('              .withMotionParam(MOTION_MAGIC_VEL, MOTION_MAGIC_ACCEL, MOTION_MAGIC_JERK)');
    sb.writeln('              .withBrake(true)');
    sb.writeln('              .withInvert(true)');
    sb.writeln('              .withRadiansMotor(STEER_GEAR_RATIO)');
    sb.writeln('              .withRampTime(RAMP_TIME_STEER),');
    sb.writeln('          new TalonFXConfig(i * 3 + 1, CAN_BUS, name + " Drive")');
    sb.writeln('              .withPID(DRIVE_KP, DRIVE_KI, DRIVE_KD, DRIVE_KS, DRIVE_KV, DRIVE_KA, 0)');
    sb.writeln('              .withBrake(true)');
    sb.writeln('              .withMeterMotor(DRIVE_GEAR_RATIO, WHEEL_DIAMETER),');
    sb.writeln('          new CancoderConfig(i * 3 + 3, CAN_BUS, name + " Cancoder"))');
    sb.writeln('          .withPosion(MODULE_LOCATIONS[i])');
    sb.writeln('          .withSteerOffset(offsets[i]);');
    sb.writeln('    }');
    sb.writeln('    return ans;');
    sb.writeln('  }');
    sb.writeln('');
    sb.writeln('  public static final SwerveModuleConfig[] modules = swerveModules(');
    sb.writeln('      new double[] {');
    sb.writeln('        /* Front Left Offset: */  ${chassis.flOffset},${_todo(chassis.todoFlOffset)}');
    sb.writeln('        /* Front Right Offset: */ ${chassis.frOffset},${_todo(chassis.todoFrOffset)}');
    sb.writeln('        /* Back Left Offset: */   ${chassis.blOffset},${_todo(chassis.todoBlOffset)}');
    sb.writeln('        /* Back Right Offset: */  ${chassis.brOffset}${_todo(chassis.todoBrOffset)}');
    sb.writeln('      });');
    sb.writeln('');
    sb.writeln('  public static final PigeonConfig PIGEON_CONFIG = new PigeonConfig(PIGEON_ID, PIGEON_CAN_BUS, NAME + " pigeon");');
    sb.writeln('');
    sb.writeln('  public static final ChassisConfig CHASSIS_CONFIG = new ChassisConfig(');
    sb.writeln('      NAME,');
    sb.writeln('      modules,');
    sb.writeln('      PIGEON_CONFIG);');
    sb.writeln('}');

    return sb.toString();
  }
}