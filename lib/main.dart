import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'home_page.dart';

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
  bool noMotionCalibration = false; bool todoNoMotionCal = false;
  
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

class AutoCalibrationConfig {
  String motorName = '';
  String atResetPosMethod = 'other';
  String sensorName = '';
  double autoResetPos = 0.0;
  bool todoResetPos = false;
}

class CalibrationCmdConfig {
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
  bool todoMotorValues = false;
}

class MechanismModel {
  String name = '';
  List<MotorModel> motors = [];
  List<SensorModel> sensors = [];
  
  List<PowerCommandConfig> powerCommands = [];
  List<LimitConfig> limits = [];
  List<AutoCalibrationConfig> autoCalibrations = [];
  List<CalibrationCmdConfig> calibrationCommands = [];

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
      String name = motors[i].name.trim();
      names.add(name.isEmpty ? 'Unnamed Motor ${i + 1}' : name);
    }
    return names.isEmpty ? ['No Motors Available'] : names;
  }

  List<String> getLimitSwitchNames() {
    List<String> names = [];
    for (int i = 0; i < sensors.length; i++) {
      if (sensors[i].sensorType == 'Limit Switch') {
        String n = sensors[i].name.trim();
        names.add(n.isEmpty ? 'Unnamed Sensor ${i + 1}' : n);
      }
    }
    return names.isEmpty ? ['No Limit Switch Available'] : names;
  }
}

class ChassisModel {
  bool makeChassis = false;

  String name = 'robot';
  
  String pigeonId = ''; bool todoPigeonId = false;
  String canBus = 'CANIvore'; bool todoCanBus = false;
  String pigeonCanBus = 'CANIvore'; bool todoPigeonCanBus = false;
  
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
  double flX = 0;
  double flY = 0;
  double frX = 0;
  double frY = 0;
  double blX = 0;
  double blY = 0;
  double brX = 0;
  double brY = 0;
  bool todoLocations = true;

  // Offsets
  double flOffset = 0;
  double frOffset = 0;
  double blOffset = 0;
  double brOffset = 0;
  bool todoOffsets = true;
}

class RobotContainerModel {
  bool makeRobotContainer = false;
  String controllerType = 'PS5';
  bool useAnotherChassis = false;
  String anotherChassisClassName = '';
}

class FirstCharNotDigitFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isNotEmpty &&
        RegExp(r'^\d').hasMatch(newValue.text)) {
      return oldValue;
    }

    return newValue;
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.onChanged,
    this.decoration,
    this.autofocus = false,
  });

  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      decoration: decoration,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[A-Za-z0-9_ ]'),
        ),
        FirstCharNotDigitFormatter(),
      ],
    );
  }
}

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.decoration,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[A-Za-z0-9_ ]'),
        ),
        FirstCharNotDigitFormatter(),
      ],
    );
  }
}

class DoubleTextFormField extends StatelessWidget {
  const DoubleTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.decoration,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text;

          if (text.isEmpty ||
              RegExp(r'^-?\d*\.?\d*$').hasMatch(text)) {
            return newValue;
          }

          return oldValue;
        }),
      ],
    );
  }
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
            child: DoubleTextFormField(
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
  static String _capitalize(String s) {
    if (s.isEmpty) return '';
    List<String> words = s.split(RegExp(r'[\s_\-]+'));
    String cap = words.map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join('');
    
    if (RegExp(r'^[0-9]').hasMatch(cap)) {
      cap = 'M$cap'; 
    }
    return cap;
  }
  
  static String _constantize(String s) {
    if (s.isEmpty) return '';
    String replaced = s.replaceAll(RegExp(r'[\s\-]+'), '_');
    replaced = replaced.replaceAllMapped(
      RegExp(r'(?<=[a-z])([A-Z])(?=[a-zA-Z])'), 
      (Match m) => '_${m.group(1)}'
    );
    return replaced.toUpperCase();
  }
  
  static String _todo(bool isTodo) => isTodo ? ' // TODO' : '';

  static Map<String, String> generateMechanismFiles(MechanismModel mech) {
    Map<String, String> files = {};
    
    if (mech.name.trim().isEmpty) return files;

    String mechNameLower = _capitalize(mech.name)[0].toLowerCase() + _capitalize(mech.name).substring(1);
    String mechNameCap = _capitalize(mech.name);
    
    for (int i = 0; i < mech.motors.length; i++) {
      String name = mech.motors[i].name;
      if (name.isEmpty) {
        mech.motors[i].name = 'Unnamed Motor ${i + 1}';
      }
      if (name == mech.name) {
        mech.motors[i].name += ' motor';
        var limit = mech.limits.where((l) => l.motorName == name).firstOrNull;
        if (limit != null) {
          limit.motorName += ' motor';
        }
        var powerCommand = mech.powerCommands.where((p) => p.motorName == name).firstOrNull;
        if (powerCommand != null) {
          powerCommand.motorName += ' motor';
        }
        var cmdCal = mech.calibrationCommands.where((c) => c.motorName == name).firstOrNull;
        if (cmdCal != null) {
          cmdCal.motorName += ' motor';
        }
        var autoCal = mech.autoCalibrations.where((c) => c.motorName == name).firstOrNull;
        if (autoCal != null) {
          autoCal.motorName += ' motor';
        }
      }
    }

    for (int i = 0; i < mech.sensors.length; i++) {
      if (mech.sensors[i].name.isEmpty) {
        mech.sensors[i].name = 'Unnamed Sensor ${i + 1}';
      }
    }

    files['$mechNameLower/${mechNameCap}Constants.java'] = _generateConstants(mech, mechNameCap, mechNameLower);
    
    files['$mechNameLower/subsystems/$mechNameCap.java'] = _generateSubsystem(mech, mechNameCap, mechNameLower);
    
    if (mech.useStates && mech.useDefaultCommand) {
      files['$mechNameLower/commands/${mechNameCap}Command.java'] = _generateDefaultCommand(mech, mechNameCap, mechNameLower);
    }

    for (var calibration in mech.calibrationCommands) {
      if (calibration.motorName == 'No Motors Available') continue;
      String motorNameCap = _capitalize(calibration.motorName);
      String cmdName = '${motorNameCap}CalibrationCommand';
      files['$mechNameLower/commands/$cmdName.java'] = _generateCalibrationCommand(mech, calibration, mechNameCap, mechNameLower, cmdName);
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
      sb.writeln('import frc.demacia.utils.sensors.${st.replaceAll(' ', '')}Config;');
    }

    sb.writeln('');
    sb.writeln('public class ${mechNameCap}Constants {');
    sb.writeln('    public static final String $mechConstName = "${mech.name.toLowerCase()}";');
    sb.writeln('');

    // Motors Constants
    for (var motor in mech.motors) {
      String mConst = _constantize(motor.name);
      String mClass = '${_capitalize(motor.name)}Constants';
      
      sb.writeln('    public static final class $mClass {');
      sb.writeln('        public static final String ${mConst}_NAME = "${motor.name}";');
      sb.writeln('        public static final int ${mConst}_ID = ${motor.id.isEmpty ? '0' : motor.id};${_todo(motor.todoId)}');
      
      bool isCanMotor = motor.motorType == 'TalonFX';
      if (isCanMotor) {
        sb.writeln('        public static final Canbus ${mConst}_CANBUS = Canbus.${motor.canBus};${_todo(motor.todoCanBus)}');
      }
      
      sb.writeln('        public static final boolean ${mConst}_BRAKE = ${motor.brakeMode};${_todo(motor.todoBrakeMode)}');
      sb.writeln('        public static final boolean ${mConst}_INVERT = ${motor.inverted};${_todo(motor.todoInverted)}');
      
      if (motor.useMaxVolt) {
        sb.writeln('        public static final double ${mConst}_MAX_VOLTAGE = ${motor.maxVolt};${_todo(motor.todoMaxVolt)}');
      }
      if (motor.useMaxCurrent) {
        sb.writeln('        public static final double ${mConst}_MAX_CURRENT = ${motor.maxCurrent};${_todo(motor.todoMaxCurrent)}');
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
        sb.writeln('        public static final double ${mConst}_KP = ${motor.kP};${_todo(motor.todoPIDFF)}');
        sb.writeln('        public static final double ${mConst}_KI = ${motor.kI};${_todo(motor.todoPIDFF)}');
        sb.writeln('        public static final double ${mConst}_KD = ${motor.kD};${_todo(motor.todoPIDFF)}');
        sb.writeln('        public static final double ${mConst}_KS = ${motor.kS};${_todo(motor.todoPIDFF)}');
        sb.writeln('        public static final double ${mConst}_KV = ${motor.kV};${_todo(motor.todoPIDFF)}');
        sb.writeln('        public static final double ${mConst}_KA = ${motor.kA};${_todo(motor.todoPIDFF)}');
        sb.writeln('        public static final double ${mConst}_KG = ${motor.kG};${_todo(motor.todoPIDFF)}');
      }
      if (motor.useAdvancedFF) {
        sb.writeln('        public static final double ${mConst}_KV2 = ${motor.kV2};${_todo(motor.todoAdvancedFF)}');
        sb.writeln('        public static final double ${mConst}_KSIN = ${motor.kSin};${_todo(motor.todoAdvancedFF)}');
      }
      if (motor.useMotionMagic) {
        sb.writeln('        public static final double ${mConst}_MAX_VELOCITY = ${motor.maxVelocity};${_todo(motor.todoMotionMagic)}');
        sb.writeln('        public static final double ${mConst}_MAX_ACCELERATION = ${motor.maxAcceleration};${_todo(motor.todoMotionMagic)}');
        sb.writeln('        public static final double ${mConst}_MAX_JERK = ${motor.maxJerk};${_todo(motor.todoMotionMagic)}');
      }
      if (motor.useStallDetection) {
        sb.writeln('        public static final double ${mConst}_HIGH_CURRENT_THRESHOLD = ${motor.highCurrentThreshold};${_todo(motor.todoStallDetection)}');
        sb.writeln('        public static final double ${mConst}_LOW_VELOCITY_THRESHOLD = ${motor.lowVelocityThreshold};${_todo(motor.todoStallDetection)}');
        sb.writeln('        public static final double ${mConst}_SECONDS_THRESHOLD = ${motor.secondsThreshold};${_todo(motor.todoStallDetection)}');
      }

      sb.writeln('');
      
      String configArgs = isCanMotor ? '${mConst}_ID, ${mConst}_CANBUS, ${mConst}_NAME' : '${mConst}_ID, ${mConst}_NAME';
      sb.writeln('        public static final ${motor.motorType}Config ${mConst}_CONFIG = new ${motor.motorType}Config($configArgs)');
      sb.writeln('            .withBrake(${mConst}_BRAKE)');
      sb.write('            .withInvert(${mConst}_INVERT)');

      if (motor.useMaxVolt) {
        sb.write('\n            .withVolts(${mConst}_MAX_VOLTAGE)');
      }
      if (motor.useMaxCurrent) {
        sb.write('\n            .withCurrent(${mConst}_MAX_CURRENT)');
      }
      if (motor.useRampUpTime) {
        sb.write('\n            .withRampTime(${mConst}_RAMP_UP_TIME)');
      }

      if (motor.useRadiansMotor) {
        sb.write('\n            .withRadiansMotor(${mConst}_GEAR_RATIO)');
      }
      if (motor.useMeterMotor) {
        sb.write('\n            .withMeterMotor(${mConst}_GEAR_RATIO, ${mConst}_DIAMETER)');
      }
      
      if (motor.usePIDFF) {
        sb.write('\n            .withPID(${mConst}_KP, ${mConst}_KI, ${mConst}_KD, ${mConst}_KS, ${mConst}_KV, ${mConst}_KA, ${mConst}_KG)');
      }
      if (motor.useAdvancedFF) {
         sb.write('\n            .withFeedForward(${mConst}_KV2, ${mConst}_KSIN)');
      }
      if (motor.useMotionMagic) {
         sb.write('\n            .withMotionParam(${mConst}_MAX_VELOCITY, ${mConst}_MAX_ACCELERATION, ${mConst}_MAX_JERK)');
      }
      if (motor.useStallDetection) {
         sb.write('\n            //does not exist yet\n            ');
      }
      sb.writeln(';');
      sb.writeln('');

      // Limits Constants
      var limit = mech.limits.where((l) => l.motorName == motor.name).firstOrNull;
      if (limit != null) {
        sb.writeln('        public static final double ${mConst}_MIN_LIMIT = ${limit.minLimit};${_todo(limit.todoMinLimit)}');
        sb.writeln('        public static final double ${mConst}_MAX_LIMIT = ${limit.maxLimit};${_todo(limit.todoMaxLimit)}');
      }

      var cmdCal = mech.calibrationCommands.where((c) => c.motorName == motor.name).firstOrNull;
      var autoCal = mech.autoCalibrations.where((c) => c.motorName == motor.name).firstOrNull;
      
      if (cmdCal != null) {
        sb.writeln('        public static final double ${mConst}_CALIBRATION_POWER = ${cmdCal.power};${_todo(cmdCal.todoPower)}');
        sb.writeln('        public static final double ${mConst}_CMD_CALIBRATION_RESET_POS = ${cmdCal.resetPos};${_todo(cmdCal.todoResetPos)}');
        if (cmdCal.useStartDelay) {
            sb.writeln('        public static final double ${mConst}_START_POWER = ${cmdCal.startPower};${_todo(cmdCal.todoStartPower)}');
            sb.writeln('        public static final double ${mConst}_START_DELAY_SEC = ${cmdCal.startDelaySec};${_todo(cmdCal.todoStartDelay)}');
        }
      }
      if (autoCal != null) {
        sb.writeln('        public static final double ${mConst}_AUTO_CALIBRATION_RESET_POS = ${autoCal.autoResetPos};${_todo(autoCal.todoResetPos)}');
      }
      
      sb.writeln('    }');
      sb.writeln('');
    }

    // Sensors Constants
    for (var sensor in mech.sensors) {
      String sBaseName = '${sensor.name} ${sensor.sensorType}';
      String sConst = _constantize(sBaseName);
      String sClass = '${_capitalize(sBaseName)}Constants';
      
      sb.writeln('    public static final class $sClass {');
      sb.writeln('        public static final String ${sConst}_NAME = "$sBaseName";');
      
      bool isCanSensor = sensor.sensorType == 'Cancoder' || sensor.sensorType == 'Pigeon';
      bool isColorSensor = sensor.sensorType == 'Color Sensor';
      
      if (!isColorSensor) {
        sb.writeln('        public static final int ${sConst}_ID = ${sensor.idOrPort.isEmpty ? '0' : sensor.idOrPort};${_todo(sensor.todoId)}');
      }
      
      if (isCanSensor) {
        sb.writeln('        public static final Canbus ${sConst}_CANBUS = Canbus.${sensor.canBus};${_todo(sensor.todoCanBus)}');
      }
      
      if (sensor.sensorType == 'Ultra Sonic Sensor') {
        sb.writeln('        public static final int ${sConst}_PING_CHANNEL = ${sensor.pingChannel.isEmpty ? '0' : sensor.pingChannel};${_todo(sensor.todoPingChannel)}');
      }
      
      bool hasInvert = sensor.sensorType != 'Color Sensor' && sensor.sensorType != 'Optical Sensor'&& sensor.sensorType != 'Ultra Sonic Sensor';
      if (hasInvert) {
        sb.writeln('        public static final boolean ${sConst}_INVERT = ${sensor.inverted};${_todo(sensor.todoInverted)}');
      }
      
      bool hasOffset = sensor.sensorType == 'Cancoder' || sensor.sensorType == 'Analog Encoder' || sensor.sensorType == 'Digital Encoder';
      if (hasOffset && sensor.useOffset) {
        sb.writeln('        public static final double ${sConst}_OFFSET = ${sensor.offset};${_todo(sensor.todoOffset)}');
      }
      
      bool hasRange = sensor.sensorType == 'Analog Encoder' || sensor.sensorType == 'Digital Encoder';
      if (hasRange) {
        if (sensor.useFullRange) sb.writeln('        public static final double ${sConst}_FULL_RANGE = ${sensor.fullRange};${_todo(sensor.todoFullRange)}');
        if (sensor.useMinRange) sb.writeln('        public static final double ${sConst}_MIN_RANGE = ${sensor.minRange};${_todo(sensor.todoMinRange)}');
        if (sensor.useMaxRange) sb.writeln('        public static final double ${sConst}_MAX_RANGE = ${sensor.maxRange};${_todo(sensor.todoMaxRange)}');
      }
      
      if (sensor.sensorType == 'Digital Encoder' && sensor.useFrequency) {
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
        sb.writeln('        public static final boolean ${sConst}_NO_MOTION_CALIBRATION = ${sensor.noMotionCalibration};${_todo(sensor.todoNoMotionCal)}');
      }
      
      // Construct configArgs correctly based on constructor definitions
      String configArgs;
      if (isCanSensor) {
        configArgs = '${sConst}_ID, ${sConst}_CANBUS, ${sConst}_NAME';
      } else if (sensor.sensorType == 'Color Sensor') {
        configArgs = '${sConst}_NAME';
      } else if (sensor.sensorType == 'Optical Sensor') {
        configArgs = '${sConst}_NAME, ${sConst}_ID';
      } else if (sensor.sensorType == 'Ultra Sonic Sensor') {
        configArgs = '${sConst}_ID, ${sConst}_PING_CHANNEL, ${sConst}_NAME';
      } else {
        configArgs = '${sConst}_ID, ${sConst}_NAME';
      }
      
      sb.write('        public static final ${sensor.sensorType.replaceAll(' ', '')}Config ${sConst}_CONFIG = new ${sensor.sensorType.replaceAll(' ', '')}Config($configArgs)');
      
      if (hasInvert) {
        sb.write('\n            .withInvert(${sConst}_INVERT)');
      }
      
      if (hasOffset && sensor.useOffset) {
        sb.write('\n            .withOffset(${sConst}_OFFSET)');
      }
      
      if (hasRange) {
        if (sensor.useFullRange) {
          if (sensor.sensorType == 'Analog Encoder') sb.write('\n            .withFullRange(${sConst}_FULL_RANGE)');
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
      
      if (sensor.sensorType == 'Digital Encoder' && sensor.useFrequency) {
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
        sb.write('\n            .withNoMotionCalibration(${sConst}_NO_MOTION_CALIBRATION)');
      }
      
      sb.writeln(';');
      sb.writeln('    }');
      sb.writeln('');
    }

    // States Enum
    if (mech.useStates) {
      sb.writeln('    public static enum ${mechNameCap}States implements MechanismState {');
      
      if (mech.states.isEmpty) {
        sb.writeln('        ;');
      }
      for (int i = 0; i < mech.states.length; i++) {
        var state = mech.states[i];
        String stateName = _constantize(state.name.isEmpty ? 'STATE_${i + 1}' : state.name);
        
        if (mech.statesType == 'fixed states') {
          List<String> values = [];
          for (var motor in mech.motors) {
            values.add(state.motorValues[motor.name]?.toString() ?? '0.0');
          }
          sb.write('        $stateName(${values.join(', ')})');
        } else {
          sb.write('        $stateName');
        }
        sb.writeln(i == mech.states.length - 1 ? ';${_todo(state.todoMotorValues)}' : ',${_todo(state.todoMotorValues)}');
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
    String mechConstName = '${_constantize(mech.name)}_NAME';

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
      sb.writeln('import frc.demacia.utils.sensors.${st.replaceAll(' ', '')};');
    }
    
    if (mech.powerCommands.isNotEmpty) {
      sb.writeln('import frc.robot.RobotContainer;');
    }

    sb.writeln('import static frc.robot.$mechNameLower.${mechNameCap}Constants.*;');

    if (mech.calibrationCommands.isNotEmpty) {
      sb.writeln('import edu.wpi.first.wpilibj.smartdashboard.SmartDashboard;');
      for (var cal in mech.calibrationCommands) {
        if (cal.motorName == 'No Motors Available') continue;
        sb.writeln('import frc.robot.$mechNameLower.commands.${_capitalize(cal.motorName)}CalibrationCommand;');
      }
    }
    
    for (var motor in mech.motors) {
      String mClass = '${_capitalize(motor.name)}Constants';
      sb.writeln('import static frc.robot.$mechNameLower.${mechNameCap}Constants.$mClass.*;');
    }
    for (var sensor in mech.sensors) {
      String sBaseName = '${sensor.name} ${sensor.sensorType}';
      String sClass = '${_capitalize(sBaseName)}Constants';
      sb.writeln('import static frc.robot.$mechNameLower.${mechNameCap}Constants.$sClass.*;');
    }
    
    sb.writeln('');
    
    String parentClass = mech.useStates ? 'StateBaseMechanism' : 'BaseMechanism';
    
    sb.writeln('public class $mechNameCap extends $parentClass {');
    sb.writeln('    private static $mechNameCap instance;');
    sb.writeln('');
    sb.writeln('    private $mechNameCap() {');
    sb.writeln('        super($mechConstName, ');
    
    sb.writeln('        new MotorInterface[] {');
    for (var motor in mech.motors) {
      String mConst = _constantize(motor.name);
      sb.writeln('            new ${motor.motorType}Motor(${mConst}_CONFIG),');
    }
    sb.writeln('        }, ');

    sb.writeln('        new SensorInterface[] {');
    if (mech.sensors.isNotEmpty) {
      for (var sensor in mech.sensors) {
        String sBaseName = '${sensor.name} ${sensor.sensorType}';
        String sConst = _constantize(sBaseName);
        sb.writeln('            new ${sensor.sensorType.replaceAll(' ', '')}(${sConst}_CONFIG),');
      }
    }
    sb.writeln('        }' + (mech.useStates ? ', ' : ');'));

    if (mech.useStates) {
      sb.writeln('        ${mechNameCap}States.class);');
    }
    sb.writeln('');
    
    for (var limit in mech.limits) {
      if (limit.motorName == 'No Motors Available') continue;
      String mConst = _constantize(limit.motorName);
      sb.writeln('        addLimit(${mConst}_NAME, ${mConst}_MIN_LIMIT, ${mConst}_MAX_LIMIT);');
    }

    for (var pc in mech.powerCommands) {
      if (pc.motorName == 'No Motors Available') continue;
      String mConst = _constantize(pc.motorName);
      String supplierLogic = '0.0';
      switch (pc.supplier) {
        case 'Controller rightX': supplierLogic = 'RobotContainer.controller.getRightX()'; break;
        case 'Controller rightY': supplierLogic = 'RobotContainer.controller.getRightY()'; break;
        case 'Controller leftX': supplierLogic = 'RobotContainer.controller.getLeftX()'; break;
        case 'Controller leftY': supplierLogic = 'RobotContainer.controller.getLeftY()'; break;
      }
      sb.writeln('        withPowerCommand(${mConst}_NAME, () -> $supplierLogic);');
    }

    for (var autoCal in mech.autoCalibrations) {
      if (autoCal.motorName == 'No Motors Available') continue;
      String mConst = _constantize(autoCal.motorName);
      String motorNameCap = _capitalize(autoCal.motorName);

      bool reuseCmdMethod = false;
      var cmdCal = mech.calibrationCommands.where((c) => c.motorName == autoCal.motorName).firstOrNull;
      if (cmdCal != null && cmdCal.atResetPosMethod == autoCal.atResetPosMethod && cmdCal.sensorName == autoCal.sensorName) {
        reuseCmdMethod = true;
      }

      String methodName = reuseCmdMethod ? 'at${motorNameCap}ResetPos' : 'at${motorNameCap}AutoResetPos';

      sb.writeln('        withAutoCalibration(${mConst}_NAME, this::$methodName, ${mConst}_AUTO_CALIBRATION_RESET_POS);');
    }

    for (var cal in mech.calibrationCommands) {
      if (cal.motorName == 'No Motors Available') continue;
      String mConst = _constantize(cal.motorName);
      String mechNameConst = _constantize(mech.name);
      sb.writeln('        SmartDashboard.putData(${mechNameConst}_NAME + "/" + ${mConst}_NAME + " Calibration Command", new ${_capitalize(cal.motorName)}CalibrationCommand(this));');
    }

    sb.writeln('    }');
    sb.writeln('');

    sb.writeln('    public static $mechNameCap getInstance() {');
    sb.writeln('        if (instance == null) {');
    sb.writeln('            instance = new $mechNameCap();');
    sb.writeln('        }');
    sb.writeln('        return instance;');
    sb.writeln('    }');
    sb.writeln('');
    
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
      sb.writeln('        throw new UnsupportedOperationException("Unimplemented method \'get${mechNameCap}Values\'");');
      sb.writeln('    }');
      sb.writeln('');
    }

    void writeConditionMethod(String methodName, String methodType, String sensorName) {
      sb.writeln('    public boolean $methodName() {');
      if (methodType == 'when sensor true') {
        var sensor = mech.sensors.where((s) => s.name == sensorName).firstOrNull;
        if (sensor != null) {
          String sBaseName = '${sensor.name} ${sensor.sensorType}';
          String sConst = _constantize(sBaseName);
          sb.writeln('        return ((${sensor.sensorType.replaceAll(' ', '')}) getSensor(${sConst}_NAME)).get();');
        } else {
          sb.writeln('        throw new UnsupportedOperationException("Sensor not found");');
        }
      } else {
        sb.writeln('        // TODO Auto-generated method stub');
        sb.writeln('        throw new UnsupportedOperationException("Unimplemented method \'$methodName()\'");');
      }
      sb.writeln('    }');
      sb.writeln('');
    }

    for (var cmdCal in mech.calibrationCommands) {
      if (cmdCal.motorName == 'No Motors Available') continue;
      String motorNameCap = _capitalize(cmdCal.motorName);
      writeConditionMethod('at${motorNameCap}ResetPos', cmdCal.atResetPosMethod, cmdCal.sensorName);
    }

    for (var autoCal in mech.autoCalibrations) {
      if (autoCal.motorName == 'No Motors Available') continue;
      String motorNameCap = _capitalize(autoCal.motorName);
      
      var cmdCal = mech.calibrationCommands.where((cmd) => cmd.motorName == autoCal.motorName).firstOrNull;
      bool isDifferent = true;
      
      if (cmdCal != null && cmdCal.atResetPosMethod == autoCal.atResetPosMethod && cmdCal.sensorName == autoCal.sensorName) {
        isDifferent = false;
      }

      if (isDifferent) {
        writeConditionMethod('at${motorNameCap}AutoResetPos', autoCal.atResetPosMethod, autoCal.sensorName);
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

  static String _generateCalibrationCommand(MechanismModel mech, CalibrationCmdConfig calib, String mechNameCap, String mechNameLower, String cmdName) {
    StringBuffer sb = StringBuffer();
    String motorNameCap = _capitalize(calib.motorName);
    String mClass = '${motorNameCap}Constants';
    String mConst = _constantize(calib.motorName);
    
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
    sb.writeln('            ${mConst}_CMD_CALIBRATION_RESET_POS ${calib.useStartDelay ? ',' : ''}');
    if (calib.useStartDelay) {
        sb.writeln('            ${mConst}_START_POWER,');
        sb.writeln('            ${mConst}_START_DELAY_SEC');
    }
    sb.writeln('        );');
    sb.writeln('    }');
    sb.writeln('}');
    return sb.toString();
  }

  static String generateChassisConstants(ChassisModel chassis) {
    StringBuffer sb = StringBuffer();
    
    String className = '${_capitalize(chassis.name)}ChassisConstants';
    String constName = '${chassis.name} Chassis';

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
    sb.writeln('  public static final int PIGEON_ID = ${int.tryParse(chassis.pigeonId) ?? 0}; ${_todo(chassis.todoPigeonId)}');
    sb.writeln('  public static final Canbus CAN_BUS = Canbus.${chassis.canBus}; ${_todo(chassis.todoCanBus)}');
    sb.writeln('  public static final Canbus PIGEON_CAN_BUS = Canbus.${chassis.pigeonCanBus}; ${_todo(chassis.todoPigeonCanBus)}');
    sb.writeln('  public static final double STEER_GEAR_RATIO = ${chassis.steerGearRatio}; ${_todo(chassis.todoSteerGearRatio)}');
    sb.writeln('  public static final double DRIVE_GEAR_RATIO = ${chassis.driveGearRatio}; ${_todo(chassis.todoDriveGearRatio)}');
    sb.writeln('  public static final double WHEEL_DIAMETER = ${chassis.wheelDiameter}; ${_todo(chassis.todoWheelDiameter)}');
    sb.writeln('');
    sb.writeln('  public static final double STEER_KP = ${chassis.steerKP}; ${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('  public static final double STEER_KI = ${chassis.steerKI}; ${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('  public static final double STEER_KD = ${chassis.steerKD}; ${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('  public static final double STEER_KS = ${chassis.steerKS}; ${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('  public static final double STEER_KV = ${chassis.steerKV}; ${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('  public static final double STEER_KA = ${chassis.steerKA}; ${_todo(chassis.todoSteerPIDFF)}');
    sb.writeln('');
    sb.writeln('  public static final double DRIVE_KP = ${chassis.driveKP}; ${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('  public static final double DRIVE_KI = ${chassis.driveKI}; ${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('  public static final double DRIVE_KD = ${chassis.driveKD}; ${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('  public static final double DRIVE_KS = ${chassis.driveKS}; ${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('  public static final double DRIVE_KV = ${chassis.driveKV}; ${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('  public static final double DRIVE_KA = ${chassis.driveKA}; ${_todo(chassis.todoDrivePIDFF)}');
    sb.writeln('');
    sb.writeln('  public static final double STEER_MOTION_MAGIC_VEL = ${chassis.motionMagicVel}; ${_todo(chassis.todoMotionMagic)}');
    sb.writeln('  public static final double STEER_MOTION_MAGIC_ACCEL = ${chassis.motionMagicAccel}; ${_todo(chassis.todoMotionMagic)}');
    sb.writeln('  public static final double STEER_MOTION_MAGIC_JERK = ${chassis.motionMagicJerk}; ${_todo(chassis.todoMotionMagic)}');
    sb.writeln('');
    sb.writeln('  public static final double MAX_DRIVE_VELOCITY = ${chassis.maxDriveVelocity}; ${_todo(chassis.todoMaxDriveVelocity)}');
    sb.writeln('  public static final double RAMP_TIME_STEER = ${chassis.rampTimeSteer}; ${_todo(chassis.todoRampTimeSteer)}');
    sb.writeln('');
    sb.writeln('  public static final Translation2d[] MODULE_LOCATIONS = {');
    sb.writeln('    new Translation2d(${chassis.flX}, ${chassis.flY}), //FRONT LEFT ${_todo(chassis.todoLocations)}');
    sb.writeln('    new Translation2d(${chassis.frX}, ${chassis.frY}), //FRONT RIGHT ${_todo(chassis.todoLocations)}');
    sb.writeln('    new Translation2d(${chassis.blX}, ${chassis.blY}), //BACK LEFT ${_todo(chassis.todoLocations)}');
    sb.writeln('    new Translation2d(${chassis.brX}, ${chassis.brY}), //BACK RIGHT ${_todo(chassis.todoLocations)}');
    sb.writeln('  };');
    sb.writeln('');
    sb.writeln('  public static final SwerveModuleConfig[] modules = swerveModules(');
    sb.writeln('      new double[] {');
    sb.writeln('        ${chassis.flOffset}, //FRONT LEFT ${_todo(chassis.todoOffsets)}');
    sb.writeln('        ${chassis.frOffset}, //FRONT RIGHT ${_todo(chassis.todoOffsets)}');
    sb.writeln('        ${chassis.blOffset}, //BACK LEFT ${_todo(chassis.todoOffsets)}');
    sb.writeln('        ${chassis.brOffset} //BACK RIGHT ${_todo(chassis.todoOffsets)}');
    sb.writeln('      });');
    sb.writeln('');
    sb.writeln('  public static final PigeonConfig PIGEON_CONFIG = new PigeonConfig(PIGEON_ID, PIGEON_CAN_BUS, NAME + " pigeon");');
    sb.writeln('');
    sb.writeln('  public static final ChassisConfig CHASSIS_CONFIG = new ChassisConfig(');
    sb.writeln('      NAME,');
    sb.writeln('      modules,');
    sb.writeln('      PIGEON_CONFIG);');
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
    sb.writeln('              .withMotionParam(STEER_MOTION_MAGIC_VEL, STEER_MOTION_MAGIC_ACCEL, STEER_MOTION_MAGIC_JERK)');
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
    sb.writeln('}');

    return sb.toString();
  }

  static String generateRobotContainer(RobotContainerModel robotContainer, ChassisModel chassis, List<MechanismModel> mechanisms) {
    StringBuffer sb = StringBuffer();

    sb.writeln('package frc.robot;');
    sb.writeln('import edu.wpi.first.util.sendable.Sendable;');
    sb.writeln('import edu.wpi.first.util.sendable.SendableBuilder;');
    sb.writeln('import edu.wpi.first.wpilibj.smartdashboard.SmartDashboard;');
    sb.writeln('import frc.demacia.utils.controller.CommandController;');
    sb.writeln('import frc.demacia.utils.controller.CommandController.ControllerType;');
    sb.writeln('import edu.wpi.first.wpilibj2.command.Command;');
    if (chassis.makeChassis || robotContainer.useAnotherChassis) {
      sb.writeln('import frc.demacia.utils.chassis.Chassis;');
      sb.writeln('import frc.demacia.utils.chassis.DriveCommand;');
      sb.writeln('import frc.robot.chassis.${robotContainer.useAnotherChassis ? robotContainer.anotherChassisClassName : '${_capitalize(chassis.name)}ChassisConstants'};');
    }
    for (var mech in mechanisms) {
      sb.writeln('import frc.robot.${_capitalize(mech.name)[0].toLowerCase() + _capitalize(mech.name).substring(1)}.subsystems.${_capitalize(mech.name)};');
      if (mech.useStates && mech.useDefaultCommand) {
        sb.writeln('import frc.robot.${_capitalize(mech.name)[0].toLowerCase() + _capitalize(mech.name).substring(1)}.commands.${_capitalize(mech.name)}Command;');
      }
    }
    sb.writeln('');
    sb.writeln('/**');
    sb.writeln(' * This class is where the bulk of the robot should be declared. Since');
    sb.writeln(' * Command-based is a');
    sb.writeln(' * "declarative" paradigm, very little robot logic should actually be handled in');
    sb.writeln(' * the {@link Robot}');
    sb.writeln(' * periodic methods (other than the scheduler calls). Instead, the structure of');
    sb.writeln('* the robot (including');
    sb.writeln(' * subsystems, commands, and trigger mappings) should be declared here.');
    sb.writeln(' */');
    sb.writeln('public class RobotContainer implements Sendable {');
    sb.writeln('');
    sb.writeln('  public static CommandController controller = new CommandController(0, ControllerType.k${robotContainer.controllerType});');
    sb.writeln('');
    for (var mech in mechanisms) {
      sb.writeln('  private ${_capitalize(mech.name)} ${_capitalize(mech.name)[0].toLowerCase() + _capitalize(mech.name).substring(1)};');
    }
    if (chassis.makeChassis || robotContainer.useAnotherChassis) {
      sb.writeln('  public static DriveCommand driveCommand;');
    }
    sb.writeln('');
    sb.writeln('  /**');
    sb.writeln('   * The container for the robot. Contains subsystems, OI devices, and commands.');
    sb.writeln('   */');
    sb.writeln('  public RobotContainer() {');
    sb.writeln('    SmartDashboard.putData("RC", this);');
    if (chassis.makeChassis || robotContainer.useAnotherChassis) {
      sb.writeln('    Chassis.initialize(${robotContainer.useAnotherChassis ? robotContainer.anotherChassisClassName : '${_capitalize(chassis.name)}ChassisConstants'}.CHASSIS_CONFIG);');
      sb.writeln('    driveCommand = new DriveCommand(Chassis.getInstance(), controller);');
    }
    for (var mech in mechanisms) {
      sb.writeln('    ${_capitalize(mech.name)[0].toLowerCase() + _capitalize(mech.name).substring(1)} = ${_capitalize(mech.name)}.getInstance();');
    }
    sb.writeln('');
    sb.writeln('    configureBindings();');
    sb.writeln('    setDefaultCommands();');
    sb.writeln('    setController();');
    sb.writeln('  }');
    sb.writeln('');
    sb.writeln('  private void configureBindings() {');
    sb.writeln('');
    sb.writeln('  }');
    sb.writeln('');
    sb.writeln('  private void setDefaultCommands() {');
    if (chassis.makeChassis || robotContainer.useAnotherChassis) {
      sb.writeln('    Chassis.getInstance().setDefaultCommand(driveCommand);');
    }
    for (var mech in mechanisms) {
      if (mech.useStates && mech.useDefaultCommand) {
        sb.writeln('    ${_capitalize(mech.name)[0].toLowerCase() + _capitalize(mech.name).substring(1)}.setDefaultCommand(new ${_capitalize(mech.name)}Command());');
      }
    }
    sb.writeln('  }');
    sb.writeln('');
    sb.writeln('  private void setController() {');
    sb.writeln('');
    sb.writeln('  }');
    sb.writeln('');
    sb.writeln('  @Override');
    sb.writeln('  public void initSendable(SendableBuilder builder) {');
    sb.writeln('');
    sb.writeln('  }');
    sb.writeln('');
    sb.writeln('  /**');
    sb.writeln('   * Use this to pass the autonomous command to the main {@link Robot} class.');
    sb.writeln('   *');
    sb.writeln('   * @return the command to run in autonomous');
    sb.writeln('   */');
    sb.writeln('  public Command getAutonomousCommand() {');
    sb.writeln('    return null;');
    sb.writeln('  }');
    sb.write('}');

    return sb.toString();
  }
}