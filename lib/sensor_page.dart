import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

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
    'Cancoder', 'Pigeon', 'Digital Encoder', 'Analog Encoder', 
    'Limit Switch', 'Color Sensor', 'Optical Sensor', 'Ultra Sonic Sensor'
  ];

  @override
  Widget build(BuildContext context) {
    bool isCanSensor = widget.sensor.sensorType == 'Cancoder' || widget.sensor.sensorType == 'Pigeon';
    bool isEncoder = widget.sensor.sensorType == 'Cancoder' || widget.sensor.sensorType == 'Digital Encoder' || widget.sensor.sensorType == 'Analog Encoder';
    bool isGyro = widget.sensor.sensorType == 'Pigeon';
    bool hasOffset = isEncoder || isGyro || widget.sensor.sensorType == 'Ultra Sonic Sensor'; 
    bool isSimpleDigitalAnalog = widget.sensor.sensorType == 'Color Sensor' || widget.sensor.sensorType == 'Optical Sensor';

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
                child: AppTextFormField(
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                        items: ['Rio', 'CANIvore'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                        onChanged: (val) => setState(() => widget.sensor.canBus = val!),
                      ),
                    ),
                  ],
                ),
              ) else const Spacer(),
            ],
          ),

          const Divider(height: 32),

          if (!isSimpleDigitalAnalog && widget.sensor.sensorType != 'Ultra Sonic Sensor')
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
              secondary: _buildTodoFlag(isTodo: widget.sensor.todoNoMotionCal, onChanged: (val) => setState(() => widget.sensor.todoNoMotionCal = val)),
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

          if (widget.sensor.sensorType == 'Analog Encoder' || widget.sensor.sensorType == 'Digital Encoder') ...[
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

          if (widget.sensor.sensorType == 'Digital Encoder') ...[
            AutoCheckField(
              label: 'Frequency (Hz)',
              initialValue: widget.sensor.frequency.toString(), defaultValue: '1000.0',
              initialUse: widget.sensor.useFrequency, initialTodo: widget.sensor.todoFrequency,
              onChanged: (val) => widget.sensor.frequency = double.tryParse(val) ?? 1000.0,
              onUseChanged: (c) => widget.sensor.useFrequency = c, onTodoChanged: (t) => widget.sensor.todoFrequency = t,
            ),
          ],

          if (widget.sensor.sensorType == 'Ultra Sonic Sensor') ...[
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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

            const SizedBox(height: 400)
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