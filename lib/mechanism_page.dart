import 'package:flutter/material.dart';

import 'main.dart';
import 'motor_page.dart';
import 'sensor_page.dart';

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
    List<String> limitSwitchNames = widget.mechanism.getLimitSwitchNames();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit: ${widget.mechanism.name}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          AppTextFormField(
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
                  title: const Text('Use States Mechanism', style: TextStyle(fontWeight: FontWeight.bold)),
                  value: widget.mechanism.useStates,
                  onChanged: (val) => setState(() => widget.mechanism.useStates = val),
                ),
                if (widget.mechanism.useStates)
                  ExpansionTile(
                    title: const Text('States Configuration'),
                    initiallyExpanded: true,
                    maintainState: true,
                    children: [
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
                                    child: AppTextFormField(
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
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
                                    child: Row(
                                      children: [
                                        Expanded(flex: 2, child: Text(mName)),
                                        _buildTodoFlag(
                                          isTodo: stateCfg.todoMotorValues,
                                          onChanged: (val) => setState(() => stateCfg.todoMotorValues = val),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: DoubleTextFormField(
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextButton.icon(
                          onPressed: () => setState(() => widget.mechanism.states.add(StateConfig())), 
                          icon: const Icon(Icons.add), label: const Text('Add State')
                        ),
                      ),
                    ],
                  ),
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
              maintainState: true,
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
                        child: DoubleTextFormField(
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
                        child: DoubleTextFormField(
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
              maintainState: true,
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
              maintainState: true,
              children: [
                ...widget.mechanism.autoCalibrations.map((autoCalibration) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: motorNames.contains(autoCalibration.motorName) ? autoCalibration.motorName : motorNames.first,
                          decoration: const InputDecoration(labelText: 'Motor', border: OutlineInputBorder(), isDense: true),
                          items: motorNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                          onChanged: (val) => setState(() => autoCalibration.motorName = val!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: autoCalibration.atResetPosMethod,
                          decoration: const InputDecoration(
                            labelText: 'at ResetPos Method',
                            border: OutlineInputBorder(),
                          ),
                          items: ['when sensor true', 'other']
                              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                              .toList(),
                          onChanged: (val) => setState(() => autoCalibration.atResetPosMethod = val!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (autoCalibration.atResetPosMethod == "when sensor true")
                          Expanded(
                          child: DropdownButtonFormField<String>(
                            value: limitSwitchNames.contains(autoCalibration.sensorName) ? autoCalibration.sensorName : limitSwitchNames.first,
                            decoration: const InputDecoration(labelText: 'Sensor', border: OutlineInputBorder(), isDense: true),
                            items: limitSwitchNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                            onChanged: (val) => setState(() => autoCalibration.sensorName = val!),
                          ),
                        ),
                      const SizedBox(width: 8),
                      _buildTodoFlag(
                        isTodo: autoCalibration.todoResetPos,
                        onChanged: (val) => setState(() => autoCalibration.todoResetPos = val),
                      ),
                      Expanded(
                        child: DoubleTextFormField(
                          initialValue: autoCalibration.autoResetPos.toString(),
                          decoration: const InputDecoration(labelText: 'Auto Reset Pos', border: OutlineInputBorder(), isDense: true),
                          keyboardType: TextInputType.number,
                          onChanged: (val) => autoCalibration.autoResetPos = double.tryParse(val) ?? 0.0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => setState(() => widget.mechanism.autoCalibrations.remove(autoCalibration)),
                      ),
                    ],
                  ),
                )),
                TextButton.icon(
                  onPressed: () => setState(() => widget.mechanism.autoCalibrations.add(AutoCalibrationConfig()..motorName = motorNames.first..sensorName = limitSwitchNames.first)), 
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
              maintainState: true,
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
                                value: limitSwitchNames.contains(cmd.sensorName) ? cmd.sensorName : limitSwitchNames.first,
                                decoration: const InputDecoration(labelText: 'Sensor', border: OutlineInputBorder(), isDense: true),
                                items: limitSwitchNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
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
                            child: DoubleTextFormField(
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
                            child: DoubleTextFormField(
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
                              child: DoubleTextFormField(
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
                              child: DoubleTextFormField(
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
                  onPressed: () => setState(() => widget.mechanism.calibrationCommands.add(CalibrationCmdConfig()..motorName = motorNames.first..sensorName = limitSwitchNames.first)), 
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
                if (widget.mechanism.useStates) ... {
                  SwitchListTile(
                    title: const Text('Generate Default Command', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: widget.mechanism.useDefaultCommand,
                    onChanged: (val) => setState(() => widget.mechanism.useDefaultCommand = val),
                  ),
                  if (widget.mechanism.useDefaultCommand)
                    ExpansionTile(
                      title: const Text('Default Command Configuration'),
                      initiallyExpanded: true,
                      maintainState: true,
                      children: [
                        if (motorNames.isNotEmpty && motorNames.first != 'No Motors Available')
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
                        if (motorNames.isEmpty || motorNames.first == 'No Motors Available')
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Add motors to assign control modes.', style: TextStyle(color: Colors.grey)),
                          )
                      ],
                    ),
                }
              ],
            ),
          ),

          const SizedBox(height: 400)
        ],
      ),
    );
  }
}