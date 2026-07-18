import 'package:flutter/material.dart';

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'mechanism_page.dart';

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
  final RobotContainerModel _robotContainer = RobotContainerModel();

  void _addNewMechanismDialog() {
    String tempName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Mechanism'),
          content: AppTextField(
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
      String className = _chassis.name;
      if (className.isNotEmpty) {
        className = className[0].toUpperCase() + className.substring(1);
      } else {
        className = "Robot";
      }
      allFiles['chassis/${className}ChassisConstants.java'] = JavaCodeGenerator.generateChassisConstants(_chassis);
    }

    if (_robotContainer.makeRobotContainer) {
      String className = "RobotContainer";
      allFiles['$className.java'] = JavaCodeGenerator.generateRobotContainer(_robotContainer, _chassis, _mechanisms);
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

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved ${allFiles.length} files successfully to:\n$selectedDirectory'),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!mounted) return;
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
                      maintainState: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextFormField(
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
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
                                      items: ['CANIvore', 'Rio'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
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
                                      items: ['CANIvore', 'Rio'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
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
                                    child: DoubleTextFormField(
                                      initialValue: _chassis.steerGearRatio.toString(),
                                      decoration: const InputDecoration(labelText: 'Steer Gear Ratio', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        _chassis.steerGearRatio = double.tryParse(val) ?? 0;
                                      },
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
                                    child: DoubleTextFormField(
                                      initialValue: _chassis.driveGearRatio.toString(),
                                      decoration: const InputDecoration(labelText: 'Drive Gear Ratio', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        _chassis.driveGearRatio = double.tryParse(val) ?? 0;
                                      },
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
                                    child: DoubleTextFormField(
                                      initialValue: _chassis.wheelDiameter.toString(),
                                      decoration: const InputDecoration(labelText: 'Wheel Diameter', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        if (val.isNotEmpty) {
                                          _chassis.wheelDiameter = double.tryParse(val) ?? 0;
                                        }
                                      },
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
                                    onChanged: (val) => _chassis.steerKP = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'steer kI', initialValue: _chassis.steerKI, defaultValue: 0.0,
                                    onChanged: (val) => _chassis.steerKI = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'steer kD', initialValue: _chassis.steerKD, defaultValue: 0.0,
                                    onChanged: (val) => _chassis.steerKD = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'steer kS', initialValue: _chassis.steerKS, defaultValue: 0.0,
                                    onChanged: (val) => _chassis.steerKS = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'steer kV', initialValue: _chassis.steerKV, defaultValue: 0.0,
                                    onChanged: (val) => _chassis.steerKV = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'steer kA', initialValue: _chassis.steerKA, defaultValue: 0.0,
                                    onChanged: (val) => _chassis.steerKA = val,
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
                                    onChanged: (val) => _chassis.driveKP = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'drive kI', initialValue: _chassis.driveKI, defaultValue: 0.0,
                                    onChanged: (val) => _chassis.driveKI = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'drive kD', initialValue: _chassis.driveKD, defaultValue: 0.0,
                                    onChanged: (val) => _chassis.driveKD = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'drive kS', initialValue: _chassis.driveKS, defaultValue: 0.0,
                                    onChanged: (val) => _chassis.driveKS = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'drive kV', initialValue: _chassis.driveKV, defaultValue: 0.0,
                                    onChanged: (val) => _chassis.driveKV = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'drive kA', initialValue: _chassis.driveKA, defaultValue: 0.0,
                                    onChanged: (val) => _chassis.driveKA = val,
                                  ),
                                ],
                              ),

                              const Divider(height: 32),

                              _buildGroupHeader(
                                title: 'Steer Motion Magic Parameters',
                                isTodo: _chassis.todoMotionMagic,
                                onTodoChanged: (val) => setState(() => _chassis.todoMotionMagic = val),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 16, runSpacing: 16,
                                children: [
                                  _buildGroupedTextField(
                                    label: 'Max Velocity', initialValue: _chassis.motionMagicVel, defaultValue: 100,
                                    onChanged: (val) => _chassis.motionMagicVel = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'Max Acceleration', initialValue: _chassis.motionMagicAccel, defaultValue: 50,
                                    onChanged: (val) => _chassis.motionMagicAccel = val,
                                  ),
                                  _buildGroupedTextField(
                                    label: 'Max Jerk', initialValue: _chassis.motionMagicJerk, defaultValue: 1000,
                                    onChanged: (val) => _chassis.motionMagicJerk = val,
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
                                    child: DoubleTextFormField(
                                      initialValue: _chassis.maxDriveVelocity.toString(),
                                      decoration: const InputDecoration(labelText: 'Max Drive Velocity', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        if (val.isNotEmpty) {
                                          _chassis.maxDriveVelocity = double.tryParse(val) ?? 0;
                                        }
                                      },
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
                                    child: DoubleTextFormField(
                                      initialValue: _chassis.rampTimeSteer.toString(),
                                      decoration: const InputDecoration(labelText: 'Ramp Time (Steer)', border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        _chassis.rampTimeSteer = double.tryParse(val) ?? 0;
                                      },
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
                                  _buildTodoFlag(isTodo: _chassis.todoLocations, onChanged: (val) => setState(() => _chassis.todoLocations = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.flX.toString(), decoration: const InputDecoration(labelText: 'X Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.flX = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoLocations, onChanged: (val) => setState(() => _chassis.todoLocations = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.flY.toString(), decoration: const InputDecoration(labelText: 'Y Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.flY = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoOffsets, onChanged: (val) => setState(() => _chassis.todoOffsets = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.flOffset.toString(), decoration: const InputDecoration(labelText: 'Offset', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.flOffset = double.tryParse(val) ?? 0.0)),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // --- Front Right ---
                              const Text('Front Right', style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildTodoFlag(isTodo: _chassis.todoLocations, onChanged: (val) => setState(() => _chassis.todoLocations = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.frX.toString(), decoration: const InputDecoration(labelText: 'X Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.frX = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoLocations, onChanged: (val) => setState(() => _chassis.todoLocations = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.frY.toString(), decoration: const InputDecoration(labelText: 'Y Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.frY = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoOffsets, onChanged: (val) => setState(() => _chassis.todoOffsets = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.frOffset.toString(), decoration: const InputDecoration(labelText: 'Offset', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.frOffset = double.tryParse(val) ?? 0.0)),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // --- Back Left ---
                              const Text('Back Left', style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildTodoFlag(isTodo: _chassis.todoLocations, onChanged: (val) => setState(() => _chassis.todoLocations = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.blX.toString(), decoration: const InputDecoration(labelText: 'X Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.blX = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoLocations, onChanged: (val) => setState(() => _chassis.todoLocations = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.blY.toString(), decoration: const InputDecoration(labelText: 'Y Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.blY = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoOffsets, onChanged: (val) => setState(() => _chassis.todoOffsets = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.blOffset.toString(), decoration: const InputDecoration(labelText: 'Offset', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.blOffset = double.tryParse(val) ?? 0.0)),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // --- Back Right ---
                              const Text('Back Right', style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildTodoFlag(isTodo: _chassis.todoLocations, onChanged: (val) => setState(() => _chassis.todoLocations = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.brX.toString(), decoration: const InputDecoration(labelText: 'X Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.brX = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoLocations, onChanged: (val) => setState(() => _chassis.todoLocations = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.brY.toString(), decoration: const InputDecoration(labelText: 'Y Location', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.brY = double.tryParse(val) ?? 0.0)),
                                  const SizedBox(width: 8),
                                  _buildTodoFlag(isTodo: _chassis.todoOffsets, onChanged: (val) => setState(() => _chassis.todoOffsets = val)),
                                  Expanded(child: DoubleTextFormField(initialValue: _chassis.brOffset.toString(), decoration: const InputDecoration(labelText: 'Offset', border: OutlineInputBorder(), isDense: true), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), onChanged: (val) => _chassis.brOffset = double.tryParse(val) ?? 0.0)),
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            _mechanisms.remove(mech);
                          });
                        },
                      ),
                      onTap: () => _openMechanismEditor(mech),
                    ),
                  );
                },
              ),
              Card(
                margin: const EdgeInsets.all(16),
                color: Colors.grey[900],
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Generate Built-in RobotContainer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),),
                      value: _robotContainer.makeRobotContainer,
                      onChanged: (val) {setState(() {_robotContainer.makeRobotContainer = val;});},
                    ),
                    if (_robotContainer.makeRobotContainer)
                      ExpansionTile(
                        title: const Text('RobotContainer Configuration'),
                        initiallyExpanded: true,
                        maintainState: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DropdownButtonFormField<String>(
                                  value: _robotContainer.controllerType,
                                  decoration: const InputDecoration(labelText: 'Controller Type', border: OutlineInputBorder(),),
                                  items: const [
                                    DropdownMenuItem(value: 'PS5', child: Text('PS5'),),
                                    DropdownMenuItem(value: 'Xbox', child: Text('Xbox'),),
                                  ],
                                  onChanged: (val) {
                                    setState(() {_robotContainer.controllerType = val!;});
                                  },
                                ),
                                const SizedBox(height: 16),
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Use another chassis', style: TextStyle(fontWeight: FontWeight.bold),),
                                  value: _robotContainer.useAnotherChassis,
                                  onChanged: (val) {setState(() {_robotContainer.useAnotherChassis = val;});},
                                ),
                                if (_robotContainer.useAnotherChassis) ...[
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    initialValue:_robotContainer.anotherChassisClassName,
                                    decoration: const InputDecoration(labelText: 'Chassis Class Name', border: OutlineInputBorder(),),
                                    onChanged: (val) {_robotContainer.anotherChassisClassName = val;},
                                    inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[A-Za-z0-9_]'),
                                    ),
                                    FirstCharNotDigitFormatter(),
                                  ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 400)
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
    required Function(double) onChanged,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 32,
      child: DoubleTextFormField(
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
        },
      ),
    );
  }
}