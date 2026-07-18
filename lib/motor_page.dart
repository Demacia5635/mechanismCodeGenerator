import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

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
                child: AppTextFormField(
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                  items: ['TalonFX', 'TalonSRX', 'SparkMax', 'SparkFlex']
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
                    child: DoubleTextFormField(
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
                        child: DoubleTextFormField(
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
                        child: DoubleTextFormField(
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

          const SizedBox(height: 400)
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
          if (parsed != defaultValue) {
            markAsUsed();
          }
        },
      ),
    );
  }
}